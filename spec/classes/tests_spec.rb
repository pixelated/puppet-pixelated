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

    let!(:ensure_packages) { MockFunction.new('ensure_packages',{:type => :statement}) } 
    let(:pre_condition) { [
      "class stdlib {}",
    ] }

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
    it { should contain_file('/usr/local/bin/phantomjs')}

    it do
      should contain_exec('dummy_register_job').with(
        "require" => "Class[::Check_mk::Agent::Install]"
      )
    end

    it do
      should contain_cron('run_smoke_tests').with(
        "command" => """(date; INVITE_CODE_ENABLED=true /usr/bin/mk-job pixelated-smoke-tests /usr/local/bin/behave --tags @staging --tags ~@wip --no-capture -k /srv/leap/tests_custom/functional-tests/) >> /var/log/check_mk_jobs.log 2>&1"
      )
    end

    it do
      should contain_cron('run_functional_tests').with(
        "command" => """: # This cronjob is temporary, it need to be remove after it have been run in all environments"
      )
    end
  end
end
