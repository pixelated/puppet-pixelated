# configure the pixelated dispatcher
class pixelated::dispatcher{
  include pixelated::apt
  # Allow traffic from outside to dispatcher
  file { '/etc/shorewall/macro.pixelated_dispatcher':
    content => 'PARAM   -       -       tcp    8080',
    notify  => Service['shorewall'],
    require => Package['shorewall']
  }
  shorewall::rule {
      'net2fw-pixelated-dispatcher':
        source      => 'net',
        destination => '$FW',
        action      => 'pixelated_dispatcher(ACCEPT)',
        order       => 200;
  }
  # allow docker traffic
  shorewall::zone {'dkr': type => 'ipv4'; }
  shorewall::interface { 'docker0':
    zone      => 'dkr',
    options   => 'tcpflags,blacklist,nosmurfs';
  }
  shorewall::policy {
    'dkr-to-all':
      sourcezone      => 'dkr',
      destinationzone => 'all',
      policy          => 'ACCEPT',
      order           => 200;
  }
  shorewall::rule {
      'dkr2fw-https':
        source      => 'dkr',
        destination => '$FW',
        action      => 'HTTPS(ACCEPT)',
        order       => 201;
  }
  shorewall::rule {
      'dkr2fw-leap-api':
        source      => 'dkr',
        destination => '$FW',
        action      => 'leap_webapp_api(ACCEPT)',
        order       => 202;
  }
  shorewall::rule {
      'dkr2fw-leap-mx':
        source      => 'dkr',
        destination => '$FW',
        action      => 'leap_mx(ACCEPT)',
        order       => 203;
  }
}

