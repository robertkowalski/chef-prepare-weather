require File.expand_path('../../spec_helper', __FILE__)

describe 'raspberry pi' do
  describe file('/data') do
    it { should be_directory }
  end

  describe cron do
    it { should have_entry('0 * * * * /opt/node/bin/node /home/pi/node_modules/raspi-temp-logger/index.js >> /var/log/templogger.log 2>&1').with_user('node') }
  end

  describe file('/var/www') do
    it { should be_directory }
  end

  describe file('/var/log/templogger.log') do
    it { should be_file }
    it { should be_owned_by 'node' }
  end

  describe package('nginx') do
    it { should be_installed }
  end

  describe package('git') do
    it { should be_installed }
  end

  describe file('/usr/local/bin/node') do
    it { should be_file }
  end

  describe file('/etc/ssh/ssh_known_hosts') do
    it { should contain 'github.com' }
  end

  describe file('/var/www/raspi-weather-webservice-api') do
    it { should be_directory }
  end

  describe file('/etc/init.d/raspi_weather_webservice_api') do
    it { should be_file }
    it { should be_owned_by 'root' }
  end

  describe file('/var/log/raspi_weather_webservice_api.log') do
    it { should be_file }
    it { should be_owned_by 'node' }
  end

  describe file('/etc/nginx/sites-available/weather_api') do
    it { should be_file }
  end

  describe file('/etc/nginx/sites-enabled/weather_api') do
    it { should be_file }
  end
end
