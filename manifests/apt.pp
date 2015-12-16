# add the pixelated sources and the signing key
class pixelated::apt {

  include apt

  apt::sources_list { 'pixelated.list':
    content => "deb http://packages.pixelated-project.org/debian ${::lsbdistcodename}-snapshots main\ndeb http://packages.pixelated-project.org/debian ${::lsbdistcodename} main\n",
    require => Exec[add_pixelated_key],
    notify  => Exec[refresh_apt],
  }
  apt::sources_list { 'docker.list':
    content => "deb deb http://apt.dockerproject.org/repo debian-${::lsbdistcodename} main\n",
    require => Exec[add_docker_key],
    notify  => Exec[refresh_apt],
  }

  file { '/srv/leap/0x58118E89F3A9128_docker_release.asc':
    source => 'puppet:///modules/pixelated/0x287A1542472DC0E3_packages@pixelated-project.org.asc',
    notify => Exec['add_docker_key']
  }
  file { '/srv/leap/0x287A1542472DC0E3_packages@pixelated-project.org.asc':
    source => 'puppet:///modules/pixelated/0x287A1542472DC0E3_packages@pixelated-project.org.asc',
    notify => Exec['add_pixelated_key']
  }
  exec{'add_pixelated_key':
    command     => '/usr/bin/apt-key add /srv/leap/0x287A1542472DC0E3_packages@pixelated-project.org.asc',
    refreshonly => true,
    require     => File['/srv/leap/0x287A1542472DC0E3_packages@pixelated-project.org.asc'],
  }
  exec{'add_docker_key':
    command     => '/usr/bin/apt-key add /srv/leap/0x58118E89F3A9128_docker_release.asc',
    refreshonly => true,
    require     => File['/srv/leap/0x58118E89F3A9128_docker_release.asc'],
  }

}
