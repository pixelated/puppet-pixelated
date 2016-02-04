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
          :lsbdistcodename  => 'wheezy',
          :testscenario     => 'single_node',
        }
    end
    it { should contain_class('pixelated::syslog') }
    it { should contain_class('pixelated::tests') }

    it { should contain_service('pixelated-server')}

    # testing if shorewall::masq generates the files
    it { should contain_concat__fragment('rules-200-net2fw-pixelated-user-agent').with_content(/pixelated_user_agent\(ACCEPT\) net \$FW/)}
    it { should contain_apache__vhost__file('pixelated').with_content(/mail.example.com/)}

    it "should configure leap webapp" do
      should contain_file('/srv/leap/webapp/config/customization/locales/en.yml').with( 'require' => 'File[/srv/leap/webapp/config/customization/views/common]',)
      should contain_file('/srv/leap/webapp/config/customization/views/common/_download_button.html.haml')
      should contain_file('/srv/leap/webapp/config/customization/views/users/show.html.haml').with_content(/mail.example.com/)
    end
  end

end
