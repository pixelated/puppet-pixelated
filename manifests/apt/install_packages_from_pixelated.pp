# Prefer all installed packages from the pixelayed repo
class pixelated::apt::install_packages_from_pixelated {

  file { '/usr/local/bin/prefer_package_repo.sh':
    source => 'puppet:///modules/pixelated/prefer_package_repo.sh',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  exec { 'prefer_pixelated_packages':
    command => '/usr/local/bin/prefer_package_repo.sh',
    unless  => '/usr/local/bin/prefer_package_repo.sh check',
    require => [
      Package[ 'leap-keymanager', 'leap-mx', 'soledad-client', 'soledad-server' ],
      File['/usr/local/bin/prefer_package_repo.sh']
    ]
  }

}
