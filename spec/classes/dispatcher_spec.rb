require 'spec_helper'
  describe 'pixelated::dispatcher' do
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
    it { should contain_class('pixelated::docker') }
    it { should contain_class('pixelated::tests') }
    it { should_not contain_class('pixelated::check_mk') }
    # testing if shorewall::masq generates the files
    it { should contain_concat__fragment('masq-100-docker_masq').with_content(/eth0 172\.17\.0\.0\/16/)}
    it { should contain_concat__fragment('rules-200-net2fw-pixelated-dispatcher').with_content(/pixelated_dispatcher\(ACCEPT\) net \$FW/)}
    it { should contain_apache__vhost__file('dispatcher').with_content(/mail.example.com/)}

    it "should configure leap webapp" do
      should contain_file('/srv/leap/webapp/config/customization/locales/en.yml').with( 'require' => 'File[/srv/leap/webapp/config/customization/views/common]',)
      should contain_file('/srv/leap/webapp/config/customization/views/common/_download_button.html.haml')
      should contain_file('/srv/leap/webapp/config/customization/views/users/show.html.haml').with_content(/mail.example.com/)
    end
  end

  context 'multi node' do
    let(:facts) do
      {
        :operatingsystem  => 'Debian',
        :osfamily         => 'Debian',
        :lsbdistid        => 'Debian',
        :lsbdistcodename  => 'wheezy',
        :testscenario     => 'multi_node',
      }
    end
    it { should_not contain_concat__fragment('rules-203-dkr2fw-leap-mx')}
  end

  context 'with nagios' do
    let(:facts) do
        {
          :operatingsystem  => 'Debian',
          :osfamily         => 'Debian',
          :lsbdistid        => 'Debian',
          :lsbdistcodename  => 'wheezy',
          :testscenario     => 'with_nagios',
        }
    end
    it { should contain_class('pixelated::check_mk') }
  end
 
end
