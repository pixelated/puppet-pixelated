require 'spec_helper'

describe 'pixelated::apt::preferences' do
  let(:facts) do
      {
        :operatingsystem => 'Debian',
        :lsbdistid       => 'Debian',
        :lsbdistcodename => 'jessie',
      }
  end

    let(:pre_condition) { [
    "class apt {}",
    "define apt::sources_list($content='deb url') {}",
    "define apt::preferences_snippet($release='stable',$priority='999',$pin='release o=Debian') {}",
    ] }

#  %w( soledad-server soledad-client soledad-common leap-keymanager leap-auth).each do | package |
    #it { should contain_apt__preferences_snippet("#{package}").with_pin('release o=pixelated')}
  #end

 # %w( python-urllib3 python-requests python-six).each do | package |
    #it { should contain_apt__preferences_snippet("#{package}").with_release(/jessie/) }
  #end

end
