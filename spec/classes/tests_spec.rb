require 'spec_helper'

describe 'pixelated::tests' do
  context 'single node' do
      let(:facts) do
          {
            :operatingsystem  => 'Debian',
            :osfamily         => 'Debian',
            :lsbdistid        => 'Debian',
            :lsbdistcodename  => 'jessie',
            :testscenario     => 'single_node',
          }
      end
 
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
    it { should contain_package('python-enum')}

    it do 
      should contain_exec('install_phantomjs').with(
        'creates' => '/usr/local/bin/phantomjs',
        'require' => '[Package[curl]{:name=>"curl"}, Package[bzip2]{:name=>"bzip2"}]'
      )
    end
    it do
      should contain_exec('dummy_register_job').with(
        "require" => "Class[::Check_mk::Agent::Install]"
      )
    end
    it do
      should contain_cron('run_functional_tests').with(
        "command" => """(date; INVITE_CODE_ENABLED=true /usr/bin/mk-job pixelated-functional-tests /usr/local/bin/behave --tags @staging --tags ~@wip --no-capture -k /srv/leap/tests_custom/functional-tests/) >> /var/log/check_mk_jobs.log 2>&1"
      )
    end
  end
end
