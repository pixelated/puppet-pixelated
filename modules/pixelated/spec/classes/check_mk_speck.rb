require 'spec_helper'

describe 'pixelated::unattended_upgrades' do
  let(:facts) do
      {
        :operatingsystem  => 'Debian',
        :lsbdistid  => 'Debian',
        :lsbdistcodename  => 'wheezy',
      }
  end
  it { should contain_apt__apt_conf('51unattended-upgrades_pixelated')}
end
