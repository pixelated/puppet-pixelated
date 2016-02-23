require 'spec_helper'

describe 'pixelated::tests' do
  it do
    should contain_file('/srv/leap/tests_custom').with(
      'ensure' => 'directory',
      'mode'   => '0755',
    )
  end
  it do
    should contain_file('/srv/leap/tests_custom/functional-tests').with(
      'ensure'   => 'directory',
      'recurse' => 'true',
    )
  end



  it { should contain_file('/srv/leap/tests_custom/pixelated.rb')}
  it { should contain_file('/var/local/phantomjs.sha256sum')}
  it { should contain_package('python-pip')}
  it { should contain_package('curl')}
  it { should contain_package('behave')}
  it { should contain_package('selenium')}

  it do 
    should contain_exec('install_phantomjs').with(
      'creates' => '/usr/local/bin/phantomjs',
      'require' => 'Package[curl]'
    )
  end
  it do
    should contain_exec('dummy_register_job').with(
      "require" => "Class[::Check_mk::Agent::Install]"
    )
  end
end
