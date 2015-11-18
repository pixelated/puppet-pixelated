require 'spec_helper'

describe 'pixelated::apt' do
  let(:facts) do
      {
        :operatingsystem => 'Debian',
        :lsbdistid       => 'Debian',
        :lsbdistcodename => 'wheezy',
      }
  end
  it { should contain_file('/etc/apt/sources.list.d/pixelated.list') }

end
