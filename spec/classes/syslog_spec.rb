require 'spec_helper'

describe 'pixelated::syslog' do
  let(:facts) do
      {
        :operatingsystem  => 'Debian',
        :osfamily         => 'Debian',
        :lsbdistcodename  => 'jessie',
      }
  end
  let(:pre_condition) { [
      "define shorewall::rule($source,$destination,$action,$order) {}",
      "define apache::vhost::file($content,$mod_security) {}",
      "define apt::sources_list($content='deb url') {}",
      "define apt::apt_conf($source='file url') {}",
      "define apt::preferences_snippet($release='stable',$priority='999',$pin='release o=Debian') {}",
    ] }

 
  it { should contain_rsyslog__snippet('05-pixelated')}
  it { should contain_file('/etc/logrotate.d/pixelated')}
end
