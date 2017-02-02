# pin packages so they have precedence over those from the leap repo
class pixelated::apt::preferences {

  apt::preferences_snippet { ['python-urllib3', 'python-requests','python-six']:
    release  => "${::lsbdistcodename}-backports",
    priority => 999
  }

  apt::preferences_snippet { 'pixelated':
    priority => 1000,
    package  => '*',
    pin      => 'origin "packages.pixelated-project.org"'
  }

  file { [
    '/etc/apt/preferences.d/soledad-client',
    '/etc/apt/preferences.d/soledad-server',
    '/etc/apt/preferences.d/soledad-common',
    '/etc/apt/preferences.d/leap-keymanager',
    '/etc/apt/preferences.d/leap-auth']:
      ensure => absent
  }

}
