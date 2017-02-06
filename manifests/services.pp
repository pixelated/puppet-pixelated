class pixelated::services {
  file { '/etc/systemd/system/apache2.service.d/auto_restart.conf':
    source  => 'puppet:///modules/pixelated/apache_auto_restart.conf',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => [
      Package['pixelated-server'],
      Service['apache']
    ]
  }
}
