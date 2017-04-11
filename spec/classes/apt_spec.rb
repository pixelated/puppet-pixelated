require 'spec_helper'

describe 'pixelated::apt' do
  let(:facts) do
      {
        :operatingsystem => 'Debian',
        :lsbdistid       => 'Debian',
        :domain          => 'default',
        :lsbdistcodename => 'jessie',
      }
  end

  let(:pre_condition) { [
    "class apt {}",
    "define apt::sources_list($content='deb url') {}",
  ] }

  it { should contain_apt__sources_list('pixelated.list').
    with_content("deb [arch=amd64] http://packages.pixelated-project.org/debian jessie main\n") }
  it { should contain_file('/srv/leap/0x287A1542472DC0E3_packages@pixelated-project.org.asc') }
  it { should contain_exec('add_pixelated_key') }

  context 'staging' do
    let(:facts) do
        {
          :domain          => 'staging.pixelated-project.org',
          :lsbdistcodename => 'jessie',
        }
    end

    it { should contain_apt__sources_list('pixelated.list').
      with_content("deb [arch=amd64] http://packages.pixelated-project.org/debian jessie-snapshots main\n") }
  end

  context 'unstable' do
    let(:facts) do
        {
          :domain          => 'unstable.pixelated-project.org',
          :lsbdistcodename => 'jessie',
        }
    end

    it { should contain_apt__sources_list('pixelated.list').
      with_content("deb [arch=amd64] http://packages.pixelated-project.org/debian jessie-snapshots main\n") }
  end

  context 'vagrant' do
    let(:facts) do
        {
          :domain          => 'pixelated-project.local',
          :lsbdistcodename => 'jessie',
        }
    end

    it { should contain_apt__sources_list('pixelated.list').
      with_content("deb [arch=amd64] http://packages.pixelated-project.org/debian jessie-snapshots main\n") }
  end
end
