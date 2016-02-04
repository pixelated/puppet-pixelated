require 'spec_helper'

describe 'pixelated' do
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

    it { should contain_class('pixelated::agent') }
  end
end

