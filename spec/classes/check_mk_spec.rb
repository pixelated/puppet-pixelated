require 'spec_helper'

describe 'pixelated::check_mk' do
  let(:facts) do
      {
        :operatingsystem  => 'Debian',
        :lsbdistid  => 'Debian',
        :lsbdistcodename  => 'wheezy',
      }
  end
  it { should contain_file('/etc/check_mk/logwatch.d/user-agent.cfg')}
  it { should contain_file('/etc/check_mk/conf.d/ignore_filesystems.mk')}
  it { should contain_file('/etc/check_mk/conf.d/ignored_checktypes.mk')}
  it { should contain_file('check_docker.sh').with_path('/usr/lib/check_mk_agent/local/check_docker.sh')}
  it { should contain_file('check_dispatcher_manager.sh').with_path('/usr/lib/check_mk_agent/local/check_dispatcher_manager.sh')}
  it { should contain_file('check_dispatcher_proxy.sh').with_path('/usr/lib/check_mk_agent/local/check_dispatcher_proxy.sh')}
end
