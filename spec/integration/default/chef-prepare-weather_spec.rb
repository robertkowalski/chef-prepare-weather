require File.expand_path('../../spec_helper', __FILE__)

describe 'raspberry pi' do
  describe file('/data') do
    it { should be_directory }
  end

  describe cron do
    it { should have_entry('0 * * * * /opt/node/bin/node /home/pi/node_modules/raspi-temp-logger/index.js >> /tmp/node_debug.log 2>&1').with_user('node') }
  end

end
