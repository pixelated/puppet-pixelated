require 'spec_helper'

describe 'pixelated::docker' do
  let(:facts) do
      {
        :operatingsystem  => 'Debian',
        :osfamily         => 'Debian',
        :lsbdistid        => 'Debian',
        :lsbdistcodename  => 'wheezy',
        :testscenario     => 'single_node',
      }
  end
  it { should contain_service('docker').that_requires('Package[docker-engine]')}
  it { should contain_file('/etc/init.d/docker').that_comes_before('Package[docker-engine]')}
  it { should contain_exec('insserv_docker')}
  it { should contain_exec('configure_docker').with_refreshonly('true')}
  it { should contain_exec('configure_docker')}
  it { should contain_file('/usr/local/bin/renew-docker-images.sh')}
  it { should contain_package('docker-engine')}
  it { should contain_cron('renew-docker').with_command("/usr/local/bin/renew-docker-images.sh 1>&2 >> /var/log/pixelated/docker-renew.log")}
  it { should contain_concat__fragment('zones-100-dkr').with_content(/dkr ipv4/)}
  it { should contain_concat__fragment('policy-1-dkr-to-all').with_content(/dkr all ACCEPT/)}
  it { should contain_concat__fragment('rules-201-dkr2fw-https').with_content(/HTTPS\(ACCEPT\) dkr \$FW/)}
  it { should contain_concat__fragment('rules-202-dkr2fw-leap-api').with_content(/leap_webapp_api\(ACCEPT\) dkr \$FW/)}
  it { should contain_concat__fragment('rules-203-dkr2fw-leap-mx').with_content(/leap_mx\(ACCEPT\) dkr \$FW/)}
end
