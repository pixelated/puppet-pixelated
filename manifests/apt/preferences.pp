# pin packages
class pixelated::apt::preferences {

  apt::preferences_snippet { ['python-urllib3', 'python-requests','python-six']:
    release  => "${::lsbdistcodename}-backports",
    priority => 999
  }

  file { [
    '/etc/apt/preferences.d/soledad-client',
    '/etc/apt/preferences.d/soledad-server',
    '/etc/apt/preferences.d/soledad-common',
    '/etc/apt/preferences.d/leap-keymanager',
    '/etc/apt/preferences.d/leap-auth']:
      ensure => absent
  }


  # Remove legacy apt repo resources
  file { '/etc/apt/sources.list.d/pixelated.list':
    ensure =>  absent,
    notify => Exec[refresh_apt],
  }
  apt::preferences_snippet { 'pixelated':
    ensure =>  absent,
  }

}
