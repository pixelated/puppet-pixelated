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
    "define apt::preferences_snippet($release='stable',$priority='999',$pin='release o=Debian',$package='*') {}",
    ] }

  describe 'pixelated packages' do
    it { should contain_apt__preferences_snippet("pixelated").with_pin('origin "packages.pixelated-project.org"')}
    it { should contain_apt__preferences_snippet("pixelated").with_priority('1000')}
  end

  %w( python-urllib3 python-requests python-six).each do | package |
    it { should contain_apt__preferences_snippet("#{package}").with_release(/jessie/) }
  end

end
