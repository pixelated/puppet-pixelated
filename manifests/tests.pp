#
class pixelated::tests {
  File {
    owner => root,
    group => root,
    mode  => '0644',
  }

  file { '/srv/leap/tests_custom':
    ensure => directory,
    mode   => '0755',
  }
  file { '/srv/leap/tests_custom/pixelated.rb':
    source => 'puppet:///modules/pixelated/leap_test.rb',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  package{'python-pip':
    ensure => installed,
  }
  package{['behave','selenium']:
    ensure   => installed,
    provider => 'pip',
    require  => Package['python-pip'],
  }

  exec{'install_phantomjs':
    command => '/usr/bin/curl -L https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 | tar xvj --strip-components=2 -C /usr/local/bin/ phantomjs-2.1.1-linux-x86_64/bin/phantomjs',
    creates => '/usr/local/bin/phantomjs',
    notify  => Exec['check_phantomjs_sha'],
  }
  exec{'check_phantomjs_sha':
    command => '/usr/bin/sha256sum -c /var/local/phantomjs.sha256sum',
    require => File['/var/local/phantomjs.sha256sum'],
  }
  file{'/var/local/phantomjs.sha256sum':
    source => 'puppet:///modules/pixelated/phantomjs.sha256',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
}
