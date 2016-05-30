require 'spec_helper'
  describe 'pixelated::agent' do
    after :each do
      Facter.clear
      Facter.clear_messages
    end



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
      "define rsyslog::snippet($content) {}",
      "define shorewall::rule($source,$destination,$action,$order) {}",
      "define apache::vhost::file($content,$mod_security) {}",
      "define apt::sources_list($content='deb url') {}",
      "define apt::apt_conf($source='file url',$refresh_apt='true') {}",
      "define apt::preferences_snippet($release='stable',$priority='999',$pin='release o=Debian') {}",
    ] }

    it { should contain_class('pixelated::syslog') }
    it { should contain_class('pixelated::tests') }

    it { should contain_service('pixelated-server')}

    # testing if shorewall::masq generates the files
    it { should contain_shorewall__rule('net2fw-pixelated-user-agent').with_source('net') }

    it { should contain_apache__vhost__file('pixelated').with_content(/mail.example.com/)}

    it "should configure leap webapp" do
      should contain_file('/srv/leap/webapp/config/customization/locales/en.yml').with( 'require' => 'File[/srv/leap/webapp/config/customization/views/common]',)
      should contain_file('/srv/leap/webapp/config/customization/views/common/_download_button.html.haml')
      should contain_file('/srv/leap/webapp/config/customization/views/users/show.html.haml').with_content(/mail.example.com/)
    end
  end

end
