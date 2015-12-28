# pin packages so they have precedence over those from the leap repo
class pixelated::apt::preferences {

  apt::preferences_snippet { ['python-urllib3', 'python-requests','python-six']:
    release  => "${::lsbdistcodename}-backports",
    priority => 999
  }

  case $::lsbdistcodename {
    'wheezy': {
      # docker needs a newer kernel on wheezy
      apt::preferences_snippet { ['linux-image-amd64']:
        release  => "${::lsbdistcodename}-backports",
        priority => 999
      }
    }

    'jessie': {
      # install python-docker from backports on jessie
      apt::preferences_snippet { ['python-docker']:
        release  => "${::lsbdistcodename}-backports",
        priority => 999
      }
    }

    default:  { }
  }

  apt::preferences_snippet { ['python-tornado',
    'soledad-server',
    'soledad-common',
    'soledad-client',
    'leap-keymanager',
    'leap-auth']:
      pin      => 'release o=pixelated',
      priority => 999,
  }

}
