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
end
