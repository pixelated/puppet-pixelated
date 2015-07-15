require 'spec_helper'

describe 'pixelated::apt' do
  let(:facts) do
      {
        :operatingsystem => 'Debian',
        :lsbdistid       => 'Debian',
        :lsbdistcodename => 'wheezy',
      }
  end
  it { should contain_file('/etc/apt/preferences.d/python-tornado').with_content(/Pin: release o=pixelated/) }
  it { should contain_file('/etc/apt/preferences.d/python-tornado').with_content(/Package: python-tornado/) }
  it { should contain_file('/etc/apt/preferences.d/python-tornado').with_content(/Pin-Priority: 999/) }
  it { should contain_file('/etc/apt/sources.list.d/pixelated.list') }

  %w( python-urllib3 python-requests python-six linux-image-amd64).each do | package |
    it { should contain_file("/etc/apt/preferences.d/#{package}").with_content(/wheezy/) }
  end


end
