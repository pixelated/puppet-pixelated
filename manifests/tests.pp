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

  ensure_packages(['python-pip', 'curl', 'bzip2', 'python-enum','python-pycurl'])

  package{['behave','selenium']:
    ensure   => installed,
    provider => 'pip',
    require  => Package['python-pip'],
  }

  file{'/usr/local/bin/phantomjs':
    source => 'puppet:///modules/pixelated/phantomjs',
    owner  => 'root',
    group  => 'root',
    mode   => '0755'
  }

  file{'/srv/leap/tests_custom/functional-tests':
    ensure  => directory,
    recurse => true,
    purge   => true,
    ignore  => '*.pyc',
    source  => 'puppet:///modules/pixelated/functional-tests',
  }

  cron {'run_functional_tests':
    command     => "(date; INVITE_CODE_ENABLED=${invite} /usr/bin/mk-job pixelated-functional-tests /usr/local/bin/behave --stop --tags @staging --tags ~@wip --no-capture -k /srv/leap/tests_custom/functional-tests/) >> /var/log/check_mk_jobs.log 2>&1",
    environment => 'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    user        => 'root',
    minute      => 27,
    notify      => Exec['dummy_register_job'],
  }

  # You can remove this after january/2017
  cron {'run_smoke_tests':
    ensure  => absent,
  }

  # You can remove this after january/2017
  file {'remove_smoke_tests_on_checkmk_folder':
    ensure => absent,
    path   => '/var/lib/check_mk_agent/job/root/pixelated-smoke-tests'
  }

  exec {'dummy_register_job':
    command     => '/usr/bin/mk-job pixelated-functional-tests /bin/true',
    require     => Class['::check_mk::agent::install'],
    refreshonly => true,
  }
}
