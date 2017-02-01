require 'spec_helper'

describe 'pixelated' do
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
      "class apt {}",
      "define rsyslog::snippet($content) {}",
      "define shorewall::rule($source,$destination,$action,$order) {}",
      "define apache::vhost::file($content,$mod_security) {}",
      "define apt::sources_list($content='deb url') {}",
      "define apt::apt_conf($source='file url',$refresh_apt='true') {}",
      "define apt::preferences_snippet($release='stable',$priority='999',$pin='release o=Debian',$package='*',$ensure='present') {}",
    ] }

    it { should contain_class('pixelated::agent') }
  end
end

