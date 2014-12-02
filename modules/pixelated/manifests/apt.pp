# add the pixelated sources needed to install everything

class pixelated::apt {

  apt::sources_list { 'pixelated.list':
    content => "deb http://packages.pixelated-project.org/debian wheezy-snapshots main\ndeb http://packages.pixelated-project.org/debian wheezy main\n",
    require => Exec[add_pixelated_key],
    notify  => Exec[refresh_apt],
  }

  file { '/home/leap/0x287A1542472DC0E3_packages@pixelated-project.org.asc':
    source => 'puppet:///modules/pixelated/0x287A1542472DC0E3_packages@pixelated-project.org.asc',
    notify => Exec['add_pixelated_key']
  }
  exec{'add_pixelated_key':
    command     => '/usr/bin/apt-key add /home/leap/0x287A1542472DC0E3_packages@pixelated-project.org.asc',
    refreshonly => true,
    require     => File['/home/leap/0x287A1542472DC0E3_packages@pixelated-project.org.asc'],
  }
}

