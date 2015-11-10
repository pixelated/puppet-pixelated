require 'spec_helper'

describe 'pixelated::syslog' do
  let(:facts) do
      {
        :operatingsystem  => 'Debian',
        :osfamily         => 'Debian',
        :lsbdistcodename  => 'wheezy',
      }
  end
  it { should contain_rsyslog__snippet('05-pixelated')}
  it { should contain_file('/etc/logrotate.d/pixelated')}
end
