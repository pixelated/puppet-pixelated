require 'spec_helper'
describe 'pixelated::services' do
  it "should include apache autostart" do
    should contain_file('/etc/systemd/system/apache2.service.d/auto_restart.conf').with_source('puppet:///modules/pixelated/apache_auto_restart.conf')
  end
end
