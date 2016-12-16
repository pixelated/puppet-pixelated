# add the pixelated sources and the signing key
class pixelated::apt {

  include apt

  $pixelated_deb = $facts['os']['domain'] ? {
      'staging.pixelated-project.org' => "deb [arch=amd64] http://packages.pixelated-project.org/debian ${::lsbdistcodename}-snapshot main\n",
      default => "deb [arch=amd64] http://packages.pixelated-project.org/debian ${::lsbdistcodename} main\n"
  }

  apt::sources_list { 'pixelated.list':
    content => $pixelated_deb,
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
