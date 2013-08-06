require File.expand_path('../spec_helper', __FILE__)

describe 'The recipe chef-prepare-weather::default' do
  let (:chef_run) do
    chef_run = ChefSpec::ChefRunner.new(
      :platform      => 'debian',
      :version       => '7.0',
      :log_level     => :error,
      :cookbook_path => COOKBOOK_PATH
    )
    Chef::Config.force_logger true
    chef_run.converge 'chef-prepare-weather::default'
    chef_run
  end

  it 'creates the directory "data"' do
    expect(chef_run).to create_directory '/data'
  end

  it 'the directory is owned by user node and group www-data' do
    directory = chef_run.directory('/data')
    expect(directory).to be_owned_by('node', 'www-data')
  end

  it 'creates the directory "/var/www"' do
    expect(chef_run).to create_directory '/var/www'
  end

  it 'the directory is owned by user node and group www-data' do
    directory = chef_run.directory('/var/www')
    expect(directory).to be_owned_by('node', 'www-data')
  end

  it 'creates a cronjob named "temp_to_csv"' do
    expect(chef_run).to create_cron 'temp_to_csv'
  end

  it 'creates a file: /var/log/templogger.log' do
    expect(chef_run).to create_file '/var/log/templogger.log'
  end

  it '/var/log/templogger.log is owned by the user node' do
    file = chef_run.file('/var/log/templogger.log')
    expect(file).to be_owned_by('node', 'root')
  end
end
