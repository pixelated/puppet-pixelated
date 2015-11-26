  define pixelated::check_mk_files() {
    file { $name:
      source => "puppet:///modules/pixelated/check_mk/${name}",
      path   => "/usr/lib/check_mk_agent/local/${name}",
      owner  => root,
      group  => root,
      mode   => '0755',
      notify => Exec['check_mk-refresh'],
    }
  }

