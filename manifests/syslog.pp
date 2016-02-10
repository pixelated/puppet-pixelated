#
class pixelated::syslog {
  File {
    owner => root,
    group => root,
    mode  => '0644',
  }

  rsyslog::snippet { '05-pixelated':
    content => template('pixelated/05-pixelated.conf.erb'),
  }

  file { '/etc/logrotate.d/pixelated':
    owner  => root,
    group  => root,
    mode   => '0644',
    source => 'puppet:///modules/pixelated/syslog/pixelated',
  }

}
