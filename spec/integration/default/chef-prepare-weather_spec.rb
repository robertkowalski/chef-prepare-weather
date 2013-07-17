require File.expand_path('../../spec_helper', __FILE__)

describe 'default node' do
  it 'installs sample package' do
    expect(package 'foo').to be_installed
  end
end
