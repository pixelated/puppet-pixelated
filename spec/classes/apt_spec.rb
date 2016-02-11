require 'spec_helper'

describe 'pixelated::apt' do
  let(:facts) do
      {
        :operatingsystem => 'Debian',
        :lsbdistid       => 'Debian',
        :lsbdistcodename => 'jessie',
      }
  end
  it { should contain_file('/etc/apt/sources.list.d/pixelated.list') }
  it { should contain_file('/srv/leap/0x287A1542472DC0E3_packages@pixelated-project.org.asc') }
  it { should contain_exec('add_pixelated_key') }

end
