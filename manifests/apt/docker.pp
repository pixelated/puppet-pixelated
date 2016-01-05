# add the docker sources and the signing key
class pixelated::apt::docker {

  include apt

  apt::sources_list { 'docker.list':
    content => "deb http://apt.dockerproject.org/repo debian-${::lsbdistcodename} main\n",
    require => Exec[add_docker_key],
    notify  => Exec[refresh_apt],
  }

  file { '/srv/leap/0x58118E89F3A9128_docker_release.asc':
    source => 'puppet:///modules/pixelated/0x58118E89F3A9128_docker_release.asc',
    notify => Exec['add_docker_key']
  }

  exec{'add_docker_key':
    command     => '/usr/bin/apt-key add /srv/leap/0x58118E89F3A9128_docker_release.asc',
    refreshonly => true,
    require     => File['/srv/leap/0x58118E89F3A9128_docker_release.asc'],
  }

}
