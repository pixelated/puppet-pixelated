# configuring docker to host our user-agents
class pixelated::docker {
  file{'/etc/init.d/docker':
    source => 'puppet:///modules/pixelated/docker.init',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
  service{'docker':
    ensure    => running,
    hasstatus => true,
  }
  exec{'configure_docker':
    command     => "/bin/sed -i 's/^.\\?DOCKER_OPTS.*/DOCKER_OPTS=--iptables=false/' /etc/default/docker",
    refreshonly => true,
    notify      => Service['docker'],
    require     => Package['pixelated-dispatcher'],
  }

  file{'/usr/local/bin/renew-docker-images.sh':
    source => 'puppet:///modules/pixelated/renew-docker-images.sh',
    owner  => root,
    group  => root,
    mode   => '0755',
  }
  cron {'renew-docker':
    command => '/usr/local/bin/renew-docker-images.sh',
    user    => root,
    hour    => 6,
    minute  => 0
  }
}

