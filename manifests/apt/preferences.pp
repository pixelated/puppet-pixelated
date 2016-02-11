# pin packages so they have precedence over those from the leap repo
class pixelated::apt::preferences {

  apt::preferences_snippet { ['python-urllib3', 'python-requests','python-six']:
    release  => "${::lsbdistcodename}-backports",
    priority => 999
  }

  apt::preferences_snippet { ['soledad-server',
    'soledad-common',
    'soledad-client',
    'leap-keymanager',
    'leap-auth']:
      pin      => 'release o=pixelated',
      priority => 999,
  }

}
