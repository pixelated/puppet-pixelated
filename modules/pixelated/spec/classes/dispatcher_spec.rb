require 'spec_helper'

describe 'pixelated::dispatcher' do
  let(:facts) do
      {
        :operatingsystem  => 'Debian',
        :osfamily         => 'Debian',
        :lsbdistid        => 'Debian',
        :lsbdistcodename  => 'wheezy',
      }
  end

  it { should contain_class('pixelated::syslog') }
  # testing if shorewall::masq generates the files
  it { should contain_concat__fragment('masq-100-docker_masq').with_content(/eth0 172\.17\.0\.0\/16/)}
  it { should contain_concat__fragment('zones-100-dkr').with_content(/dkr ipv4/)}
  it { should contain_concat__fragment('policy-1-dkr-to-all').with_content(/dkr all ACCEPT/)}
  it { should contain_concat__fragment('rules-200-net2fw-pixelated-dispatcher').with_content(/pixelated_dispatcher\(ACCEPT\) net \$FW/)}
  it { should contain_concat__fragment('rules-201-dkr2fw-https').with_content(/HTTPS\(ACCEPT\) dkr \$FW/)}
  it { should contain_concat__fragment('rules-202-dkr2fw-leap-api').with_content(/leap_webapp_api\(ACCEPT\) dkr \$FW/)}
  it { should contain_concat__fragment('rules-203-dkr2fw-leap-mx').with_content(/leap_mx\(ACCEPT\) dkr \$FW/)}
end
