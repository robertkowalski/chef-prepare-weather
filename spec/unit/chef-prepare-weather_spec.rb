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

  it 'the directory is owned by user pi and group www-data' do
    directory = chef_run.directory('/data')
    expect(directory).to be_owned_by('pi', 'www-data')
  end

  it 'creates a cronjob named "temp_to_csv"' do
    expect(chef_run).to create_cron 'temp_to_csv'
  end
end
