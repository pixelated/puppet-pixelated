# configure and install the pixelated user agent
class pixelated::agent {
  include ::pixelated::apt
  include ::pixelated::apt::preferences
  include ::pixelated::unattended_upgrades
  include ::pixelated::syslog
  include ::pixelated::tests

  $domain_hash = hiera('domain')
  $domain      = $domain_hash['full_suffix']
  $services    = hiera('services')
  $default_file = '/etc/default/pixelated-server'

  package { 'pixelated-server':
    ensure => installed,
  }

  service { 'pixelated-server':
    ensure  => running,
    require => Package['pixelated-server'],
  }

  exec{'configure_pixelated_server':
    command => "/bin/sed -i -E 's/^.*LEAP_PROVIDER=.*/LEAP_PROVIDER=${domain}/' ${default_file}",
    unless  => "/bin/grep -q ${domain} ${default_file}",
    notify  => Service['pixelated-server'],
    require => Package['pixelated-server'],
  }

  # make dispatcher accessible at https://mail.domain/
  apache::vhost::file { 'pixelated':
    content      => template('pixelated/pixelated-apache.conf.erb'),
    mod_security => false,
  }

  # Allow traffic from outside to dispatcher
  file { '/etc/shorewall/macro.pixelated_user_agent':
    content => 'PARAM   -       -       tcp    8080',
    notify  => Service['shorewall'],
    require => Package['shorewall']
  }

  shorewall::rule {
      'net2fw-pixelated-user-agent':
        source      => 'net',
        destination => '$FW',
        action      => 'pixelated_user_agent(ACCEPT)',
        order       => 200;
  }


  # webapp customizations
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

}

