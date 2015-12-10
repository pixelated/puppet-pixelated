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

}
