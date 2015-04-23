# configure and install the pixelated dispatcher
class pixelated::dispatcher{
  include ::pixelated::apt
  include ::pixelated::check_mk
  include ::pixelated::unattended_upgrades
  include ::pixelated::syslog

  package{ ['python-tornado','pixelated-dispatcher','pixelated-dispatcher-manager','pixelated-dispatcher-proxy','linux-image-amd64/wheezy-backports','linux-image-3.16.0-0.bpo.4-amd64/wheezy-backports']:
    ensure => installed,
  }

  service{'docker':
    ensure    => running,
    pattern   => '/usr/bin/docker',
    hasstatus => false
  }

  service{'pixelated-dispatcher-manager':
    ensure  => running,
    require => Package['pixelated-dispatcher-manager'],
  }
  service{'pixelated-dispatcher-proxy':
    ensure  => running,
    require => Package['pixelated-dispatcher-proxy'],
  }
  exec{'configure_docker':
    command => "/bin/sed -i 's/^.\\?DOCKER_OPTS.*/DOCKER_OPTS=--iptables=false/' /etc/default/docker",
    notify  => Service['docker'],
    require => Package['pixelated-dispatcher'],
  }

  # logging for user agents
  file { '/etc/rsyslog.d/udp.conf':
    ensure  => file,
    notify  => Service['rsyslog'],
    content => "\$ModLoad imudp\n\$UDPServerRun 514\n"
  }

  $proxy_command ='/bin/echo "PIXELATED_MANAGER_FINGERPRINT=$(openssl x509 -in /etc/ssl/certs/ssl-cert-snakeoil.pem -noout -fingerprint -sha1 | cut -d"=" -f 2)" >> /etc/default/pixelated-dispatcher-proxy'
  $manager_command ='/bin/echo "PIXELATED_PROVIDER_FINGERPRINT=$(openssl x509 -in /usr/local/share/ca-certificates/leap_commercial_ca.crt -noout -fingerprint -sha1 | cut -d"=" -f 2)" >> /etc/default/pixelated-dispatcher-manager'

  exec{'set_fingerprint_for_proxy':
    command     => $proxy_command,
    refreshonly => true,
    subscribe   => Package['pixelated-dispatcher'],
  }
  exec{'set_fingerprint_for_manager':
    command     => $manager_command,
    refreshonly => true,
    subscribe   => Package['pixelated-dispatcher'],
    require     => File['/usr/local/share/ca-certificates/leap_commercial_ca.crt'],
  }

  # Allow traffic from outside to dispatcher
  file { '/etc/shorewall/macro.pixelated_dispatcher':
    content => 'PARAM   -       -       tcp    8080',
    notify  => Service['shorewall'],
    require => Package['shorewall']
  }

  shorewall::masq{'docker_masq':
        interface => 'eth0',
        source    => '172.17.0.0/16',
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
      order           => 1;
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
