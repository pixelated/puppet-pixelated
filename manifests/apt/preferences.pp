# pin packages so they have precedence over those from the leap repo
class pixelated::apt::preferences {

  apt::preferences_snippet { ['python-urllib3', 'python-requests','python-six','linux-image-amd64']:
    release  => "${::lsbdistcodename}-backports",
    priority => 999
  }
  apt::preferences_snippet { ['python-tornado',
    'soledad-server',
    'soledad-common',
    'soledad-client',
    'leap-keymanager',
    'python-leap-common',
    'leap-mx',
    'leap-auth']:
      pin      => 'release o=pixelated',
      priority => 999,
  }

}
