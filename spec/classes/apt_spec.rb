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
  it { should contain_file('/etc/apt/sources.list.d/docker.list').with_content("deb http://apt.dockerproject.org/repo debian-wheezy main\n") }
  it { should contain_file('/srv/leap/0x58118E89F3A9128_docker_release.asc') }
  it { should contain_file('/srv/leap/0x287A1542472DC0E3_packages@pixelated-project.org.asc') }
  it { should contain_exec('add_pixelated_key') }
  it { should contain_exec('add_docker_key') }

end
