require File.expand_path('../../spec_helper', __FILE__)

describe 'raspberry pi' do
  describe file('/data') do
    it { should be_directory }
  end

  describe cron do
    it { should have_entry('0 * * * * /usr/local/bin/node /home/node/raspi-temp-logger/current/index.js >> /var/log/templogger.log 2>&1').with_user('node') }
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

  describe file('/etc/init.d/raspi-weather-webservice-api') do
    it { should be_file }
    it { should be_owned_by 'root' }
  end

  describe file('/var/log/raspi-weather-webservice-api.log') do
    it { should be_file }
    it { should be_owned_by 'node' }
  end

  describe file('/etc/nginx/sites-available/weather') do
    it { should be_file }
  end

  describe file('/etc/nginx/sites-enabled/weather') do
    it { should be_file }
  end

  describe file('/var/log/raspi-weather-webservice-static.log') do
    it { should be_file }
    it { should be_owned_by 'node' }
  end

  describe file('/var/www/raspi-weather-webservice-static') do
    it { should be_directory }
  end
end
