# add the pixelated sources and the signing key
class pixelated::apt {

  include apt

  $version = $::domain ? {
    /^(staging|dev|unstable)\.pixelated-project\.org$/ => '-snapshots',
    default                         => '',
  }

  apt::sources_list { 'pixelated.list':
    content => "deb [arch=amd64] http://packages.pixelated-project.org/debian ${::lsbdistcodename}${version} main\n",
    require => Exec[add_pixelated_key],
    notify  => Exec[refresh_apt],
  }

  file { '/srv/leap/restart-pixelated-server':
    source => 'puppet:///modules/pixelated/restart-pixelated-server'',
  }

  apt::apt_conf {'restart-service':
    content => 'DPkg::Post-Install-Pkgs { "/srv/leap/restart-pixelated-server"; }'
    require => File['/srv/leap/restart-pixelated-server']
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
