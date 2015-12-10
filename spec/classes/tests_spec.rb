require 'spec_helper'

describe 'pixelated::tests' do
  it do 
    should contain_file('/srv/leap/tests_custom').with(
      'ensure' => 'directory',
      'mode'   => '0755',
    )
  end 

  it { should contain_file('/srv/leap/tests_custom/pixelated.rb')}
end
