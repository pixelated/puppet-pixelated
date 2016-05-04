# Install functional test for Pixelated based on bahave and phantomjs
# The tetst are integrated in 'leap test'
class pixelated::tests {
  include stdlib
  $webapp = hiera('webapp')
  $invite = $webapp['invite_required']
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

  ensure_packages(['python-pip', 'curl', 'bzip2', 'python-enum'])

  package{['behave','selenium']:
    ensure   => installed,
    provider => 'pip',
    require  => Package['python-pip'],
  }

  exec{'install_phantomjs':
    command => '/usr/bin/curl -L https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 | tar xvj --strip-components=2 -C /usr/local/bin/ phantomjs-2.1.1-linux-x86_64/bin/phantomjs',
    creates => '/usr/local/bin/phantomjs',
    require => [ Package['curl'], Package['bzip2'] ],
    notify  => Exec['check_phantomjs_sha'],
  }
  exec{'check_phantomjs_sha':
    refreshonly => true,
    command     => '/usr/bin/sha256sum -c /var/local/phantomjs.sha256sum',
    require     => File['/var/local/phantomjs.sha256sum'],
  }

  file{'/var/local/phantomjs.sha256sum':
    source => 'puppet:///modules/pixelated/phantomjs.sha256',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
  file{'/srv/leap/tests_custom/functional-tests':
    ensure  => directory,
    recurse => true,
    purge   => true,
    source  => 'puppet:///modules/pixelated/functional-tests',
  }
  cron {'run_functional_tests':
    command     => "(date; INVITE_CODE_ENABLED=$invite /usr/bin/mk-job pixelated-functional-tests /usr/local/bin/behave --tags @staging --tags ~@wip --no-capture -k /srv/leap/tests_custom/functional-tests/) >> /var/log/check_mk_jobs.log 2>&1",
    environment => 'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    user        => 'root',
    minute      => 27,
    notify      => Exec['dummy_register_job'],
  }
  exec {'dummy_register_job':
    command     => '/usr/bin/mk-job pixelated-functional-tests /bin/true',
    require     => Class['::check_mk::agent::install'],
    refreshonly => true,
  }
}
