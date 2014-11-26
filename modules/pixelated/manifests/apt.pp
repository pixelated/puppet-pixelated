# add the pixelated sources needed to install everything

class pixelated::apt {

  apt::sources_list { 'pixelated.list':
    content => "deb http://packages.pixelated-project.org/debian wheezy-snapshots main\ndeb http://packages.pixelated-project.org/debian wheezy main\n",
    require => Exec[add_pixelated_key],
    notify  =>  Exec[refresh_apt],
  }
  exec{'add_pixelated_key':
    command     => '/usr/bin/apt-key adv --keyserver pool.sks-keyservers.net --recv-key 287A1542472DC0E3',
    refreshonly => true,
  }
}

