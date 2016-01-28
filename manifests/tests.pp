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
    ensure => directory,
    source => 'puppet:///modules/pixelated/leap_test.rb',
  }

  package{'python-pip':
    ensure => installed,
  }
  package{'behave':
    ensure   => installed,
    provider => 'pip',
    require  => Package['python-pip'],
  }

  exec{'install_phantomjs':
    command => '/usr/bin/curl -L https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 | tar xvj --strip-components=2 -C /usr/local/bin/ phantomjs-2.1.1-linux-x86_64/bin/phantomjs',
    creates => '/usr/local/bin/phantomjs'
  }
}
