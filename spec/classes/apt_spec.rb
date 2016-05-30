require 'spec_helper'

describe 'pixelated::apt' do
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
  ] }

  it { should contain_apt__sources_list('pixelated.list') }
  it { should contain_file('/srv/leap/0x287A1542472DC0E3_packages@pixelated-project.org.asc') }
  it { should contain_exec('add_pixelated_key') }

end
