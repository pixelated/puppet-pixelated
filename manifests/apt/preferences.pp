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

}
