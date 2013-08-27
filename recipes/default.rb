#
# Cookbook Name:: chef-prepare-weather
# Recipe:: default
#
# Copyright (C) 2013 Robert Kowalski <rok@kowalski.gd>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

DIRECTORY = 'downloads' #d irectory for the ecstatic server

def deploy_service(path, git_url, service_name=nil)
  deploy path do
    repo git_url
    revision 'HEAD'
    enable_submodules true
    shallow_clone true
    keep_releases 10
    action :deploy
    migrate false
    restart_command do
      service service_name do
        supports :start => true, :stop => true, :restart => true, :status => true
        action [ :enable, :restart ]
        not_if { service_name == nil }
      end
    end
    scm_provider Chef::Provider::Git
    symlink_before_migrate.clear
    create_dirs_before_symlink.clear
    purge_before_symlink.clear
    symlinks.clear
  end
end

# testability on vagrant-debian
if node['kernel']['machine'] =~ /armv6l/
  execute 'load modules' do
    command 'modprobe w1-gpio'
  end

  execute 'load modules' do
    command 'modprobe w1-therm'
  end
end

user 'node' do
  action :create
  home '/home/node'
  supports :manage_home => true
end

package 'nginx' do
  action :install
end

package 'git' do
  action :install
end

include_recipe 'nodejs::install_from_binary'

include_recipe 'ssh_known_hosts'
ssh_known_hosts_entry 'github.com'

execute 'install NPM package forever' do
  command 'npm install -g forever'
end

file '/etc/nginx/sites-enabled/default' do
  action :delete
end

directory '/data' do
  owner 'node'
  group 'www-data'
  action :create
end

directory '/var/www' do
  owner 'node'
  group 'www-data'
  action :create
end

%w{/var/log/raspi-weather-webservice-api.log /var/log/raspi-weather-webservice-static.log}.each do |log|
  file log do
    owner 'node'
    group 'root'
    action :create
  end
end

file '/var/log/templogger.log' do
  owner 'node'
  group 'root'
  action :create
end

template 'raspi-weather-webservice-api-service' do
  path '/etc/init.d/raspi-weather-webservice-api'
  source 'service.erb'
  owner 'root'
  group 'root'
  mode  '0755'
  variables({
    :app => 'raspi-weather-webservice-api',
    :serverfile => 'app.js',
    :env => ''
  })
end

template 'raspi-weather-webservice-static-service' do
  path '/etc/init.d/raspi-weather-webservice-static'
  source 'service.erb'
  owner 'root'
  group 'root'
  mode  '0755'
  variables({
    :app => 'raspi-weather-webservice-static',
    :serverfile => 'app.js',
    :env => 'BASEDIR=' + DIRECTORY
  })
end

template 'raspi-weather-nginx' do
  path '/etc/nginx/sites-available/weather'
  source 'site.erb'
  owner 'root'
  group 'root'
  variables({
    :basedir => DIRECTORY
  })
end


link '/etc/nginx/sites-enabled/weather' do
  to '/etc/nginx/sites-available/weather'
end

deploy_service('/var/www/raspi-weather-webservice-api',
               'https://github.com/robertkowalski/raspi-weather-webservice-api.git',
               'raspi-weather-webservice-api')

deploy_service('/var/www/raspi-weather-webservice-static',
               'https://github.com/robertkowalski/raspi-weather-webservice-static.git',
               'raspi-weather-webservice-static')

service 'nginx' do
  supports :status => true, :restart => true
  action [ :restart ]
end

deploy_service('/home/node/raspi-temp-logger/', 'https://github.com/robertkowalski/raspi-temp-logger.git')

cron 'temp_to_csv' do
  minute '0'
  command '/usr/local/bin/node /home/node/raspi-temp-logger/current/index.js >> /var/log/templogger.log 2>&1'
  action :create
  user 'node'
end
