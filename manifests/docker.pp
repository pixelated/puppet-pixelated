# configuring docker to host our user-agents
class pixelated::docker {
  $services    = hiera('services')

  # on wheezy, docker needs a newer kernel from backports
  if $::lsbdistcodename == 'wheezy' {
    package{ [
      'linux-image-amd64/wheezy-backports',
      'initramfs-tools/wheezy-backports' ]:
        ensure => installed,
    }
    file{'/etc/init.d/docker':
      source => 'puppet:///modules/pixelated/docker.init',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
      before => Package['docker'],
      notify => Exec['insserv_docker'],
    }

    exec{'insserv_docker':
      command     => '/sbin/insserv docker',
      refreshonly => true,
    }
  
    $docker_packagename = 'docker-engine'

  } else {
    $docker_packagename = 'docker.io'
  }


  service{'docker':
    ensure    => running,
    hasstatus => true,
    require   => Package['docker'],
  }

  package{ 'docker':
    ensure => latest,
    name   => $docker_packagename,
  }

  package{ 'python-docker':
    ensure  => latest,
  }

  exec{'configure_docker':
    command     => "/bin/sed -E  's/^.*DOCKER_OPTS=.*/DOCKER_OPTS=--iptables=false/' /etc/default/docker",
    unless      => '/bin/grep -q iptables /etc/default/docker',
    notify      => Service['docker'],
    require     => Package['docker','pixelated-dispatcher'],
  }

  file{'/usr/local/bin/renew-docker-images.sh':
    source => 'puppet:///modules/pixelated/renew-docker-images.sh',
    owner  => root,
    group  => root,
    mode   => '0755',
  }
  cron {'renew-docker':
    command => '/usr/local/bin/renew-docker-images.sh 1>&2 >> /var/log/pixelated/docker-renew.log',
    user    => root,
    hour    => 6,
    minute  => 0
  }

  shorewall::masq{'docker_masq':
        interface => 'eth0',
        source    => '172.17.0.0/16',
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

  if member ( $services, 'mx') {
    shorewall::rule {
        'dkr2fw-leap-mx':
          source      => 'dkr',
          destination => '$FW',
          action      => 'leap_mx(ACCEPT)',
          order       => 203;
    }
  }

}

