# configure and install the pixelated dispatcher
class pixelated::dispatcher{
  include ::pixelated::apt
  include ::pixelated::apt::preferences
  include ::pixelated::unattended_upgrades
  include ::pixelated::syslog
  include ::pixelated::docker
  include ::pixelated::tests
  # remove leftovers from previous installations
  include ::pixelated::remove

  $domain_hash = hiera('domain')
  $domain      = $domain_hash['full_suffix']
  $services    = hiera('services')

  if member ( $services, 'monitor') {
    include ::pixelated::check_mk
  }
  package{ ['python-tornado','pixelated-dispatcher','pixelated-dispatcher-manager','pixelated-dispatcher-proxy']:
    ensure => installed,
  }
  package{ ['python-urllib3', 'python-requests','python-six']:
    ensure => latest,
    before => [Service['pixelated-dispatcher-manager'], Service['pixelated-dispatcher-proxy']],
  }

  service{'pixelated-dispatcher-manager':
    ensure  => running,
    require => [Package['pixelated-dispatcher-manager'],Service['apache'],Service['docker']],
  }
  service{'pixelated-dispatcher-proxy':
    ensure  => running,
    require => [Package['pixelated-dispatcher-proxy'], Service['pixelated-dispatcher-manager']],
  }
  # logging for user agents
  file { '/etc/rsyslog.d/udp.conf':
    ensure  => file,
    notify  => Service['rsyslog'],
    content => "\$ModLoad imudp\n\$UDPServerRun 514\n"
  }

  file{ ['/srv/leap/webapp/config/customization/locales/','/srv/leap/webapp/config/customization/views','/srv/leap/webapp/config/customization/views/common','/srv/leap/webapp/config/customization/views/users']:
    ensure  => directory,
    owner   => 'leap-webapp',
    group   => 'leap-webapp',
    require => Vcsrepo['/srv/leap/webapp'],
  }
  file{ '/srv/leap/webapp/config/customization/views/common/_download_button.html.haml':
    source  => 'puppet:///modules/pixelated/webapp/views/common/_download_button.html.haml',
    owner   => 'leap-webapp',
    group   => 'leap-webapp',
    require => File['/srv/leap/webapp/config/customization/views/common'],
  }
  file{ '/srv/leap/webapp/config/customization/locales/en.yml':
    source  => 'puppet:///modules/pixelated/webapp/locales/en.yml',
    owner   => 'leap-webapp',
    group   => 'leap-webapp',
    require => File['/srv/leap/webapp/config/customization/views/common'],
  }
  file{ '/srv/leap/webapp/config/customization/views/users/show.html.haml':
    content => template('pixelated/webapp/show.html.haml.erb'),
    owner   => 'leap-webapp',
    group   => 'leap-webapp',
    require => File['/srv/leap/webapp/config/customization/views/common'],
  }

  # make dispatcher accessible at https://mail.domain/
  apache::vhost::file { 'dispatcher':
    content      => template('pixelated/pixelated-apache.conf.erb'),
    mod_security => false,
  }

  $proxy_command ='/bin/echo "PIXELATED_MANAGER_FINGERPRINT=$(openssl x509 -in /etc/ssl/certs/ssl-cert-snakeoil.pem -noout -fingerprint -sha1 | cut -d"=" -f 2)" >> /etc/default/pixelated-dispatcher-proxy'
  $manager_command ='/bin/echo "PIXELATED_PROVIDER_FINGERPRINT=$(openssl x509 -in /etc/x509/certs/leap_commercial.crt -noout -fingerprint -sha1 | cut -d"=" -f 2)" >> /etc/default/pixelated-dispatcher-manager'

  exec{'set_fingerprint_for_proxy':
    command     => $proxy_command,
    refreshonly => true,
    subscribe   => Package['pixelated-dispatcher'],
    notify      => Service['pixelated-dispatcher-proxy'],
  }
  exec{'set_fingerprint_for_manager':
    command     => $manager_command,
    refreshonly => true,
    subscribe   => Package['pixelated-dispatcher'],
    require     => File['/etc/x509/certs/leap_commercial.crt'],
    notify      => Service['pixelated-dispatcher-manager'],
  }

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
}
