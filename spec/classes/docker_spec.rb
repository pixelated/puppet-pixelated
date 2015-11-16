require 'spec_helper'

describe 'pixelated::docker' do
  let(:facts) do
      {
        :operatingsystem  => 'Debian',
        :osfamily         => 'Debian',
        :lsbdistid        => 'Debian',
        :lsbdistcodename  => 'wheezy',
      }
  end
  it { should contain_service('docker')}
  it { should contain_file('/etc/init.d/docker')}
  it { should contain_exec('configure_docker').with_refreshonly('true')}
  it { should contain_file('/usr/local/bin/renew-docker-images.sh')}
  it { should contain_cron('renew-docker').with_command("/usr/local/bin/renew-docker-images.sh 1>&2 >> /var/log/pixelated/docker-renew.log")}
end
