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

# create directory /data
directory '/data' do
  owner 'node'
  group 'www-data'
  action :create
end

# create directory /var/www
directory '/var/www' do
  owner 'node'
  group 'www-data'
  action :create
end

# create file /var/log/templogger.log
file '/var/log/templogger.log' do
  owner 'node'
  group 'root'
  action :create
end

# add cronjob
cron 'temp_to_csv' do
  minute '0'
  command '/opt/node/bin/node /home/pi/node_modules/raspi-temp-logger/index.js >> /var/log/templogger.log 2>&1'
  action :create
  user 'node'
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

cmd  = "npm install -g forever"
execute "install NPM package forever" do
  command cmd
end

file '/var/log/raspi_weather_webservice_api.log' do
  owner 'node'
  group 'root'
  action :create
end

template 'service' do
  path '/etc/init.d/raspi_weather_webservice_api'
  source 'service.erb'
  owner 'node'
  group 'root'
  mode  '0755'
  variables({
    :appname => 'raspi_weather_webservice_api',
    :appdir => 'raspi-weather-webservice-api',
    :serverfile => 'app.js'
  })
end

file '/etc/nginx/sites-enabled/default' do
  action :delete
end

template 'raspi-weather-webservice-api' do
  path '/etc/nginx/sites-available/weather_api'
  source 'site.erb'
  owner 'root'
  group 'root'
end

link '/etc/nginx/sites-enabled/weather_api' do
  to '/etc/nginx/sites-available/weather_api'
end

deploy '/var/www/raspi-weather-webservice-api' do
  repo 'https://github.com/robertkowalski/raspi-weather-webservice-api.git'
  revision 'HEAD'
  enable_submodules true
  shallow_clone true
  keep_releases 10
  action :deploy
  migrate false
  restart_command '/etc/init.d/raspi_weather_webservice_api restart'
  scm_provider Chef::Provider::Git
  symlink_before_migrate.clear
  create_dirs_before_symlink.clear
  purge_before_symlink.clear
  symlinks.clear
end