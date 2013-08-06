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

user 'node' do
  action :create
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