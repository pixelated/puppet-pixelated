# add the pixelated sources needed to install everything

class pixelated::apt {

  include apt
  include lsb
  apt::preferences_snippet { ['python-urllib3', 'python-requests','python-six','linux-image-amd64']:
    release  => "${::lsbdistcodename}-backports",
    priority => 999
  }
  apt::preferences_snippet { ['python-tornado',
    'soledad-server',
    'soledad-common',
    'soledad-client',
    'leap-keymanager',
    'python-leap-common',
    'leap-mx',
    'leap-auth']:
      pin      => 'release o=pixelated',
      priority => 999,
  }

  apt::sources_list { 'pixelated.list':
    content => "deb http://packages.pixelated-project.org/debian wheezy-snapshots main\ndeb http://packages.pixelated-project.org/debian wheezy main\n",
    require => Exec[add_pixelated_key],
    notify  => Exec[refresh_apt],
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
}

