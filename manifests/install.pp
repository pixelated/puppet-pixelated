# Installs pixelated-server and pixelated-user-agent
class pixelated::install (
  $release                  = '1.0_beta1',
  $pixelated_server_deb     = 'pixelated-server_0.2.162.gbpba0081_all.deb',
  $pixelated_user_agent_deb = 'pixelated-user-agent_0.6.699.gbpc8f588_all.deb'
) {



  exec { 'fetch_pixelated_user_agent':
    command => "/usr/bin/wget https://github.com/pixelated/pixelated-user-agent/releases/download/${release}/${pixelated_user_agent_deb}",
    cwd     => '/var/tmp',
    creates => "/var/tmp/${pixelated_user_agent_deb}"
  }

  exec { 'fetch_pixelated_server':
    command => "/usr/bin/wget https://github.com/pixelated/pixelated-user-agent/releases/download/${release}/${pixelated_server_deb}",
    cwd     => '/var/tmp',
    creates => "/var/tmp/${pixelated_server_deb}"
  }

  package {
    # Dependencies of pixelated-user-agent
    [ 'libffi6', 'libsqlcipher0', 'python' ]:
      ensure   => installed;
    'pixelated-user-agent':
      ensure   => latest,
      provider => 'dpkg',
      source   => "/var/tmp/${pixelated_user_agent_deb}",
      require  => [
        Exec['fetch_pixelated_user_agent'],
        Package['libffi6'],
        Package['libsqlcipher0'],
        Package['libssl-dev'],
        Package['python'],
      ];
    # Dependencies of pixelated-server
    [ 'python-sqlcipher', 'systemd' ]:
      ensure  => installed;
    'pixelated-server':
      ensure   => latest,
      provider => 'dpkg',
      source   => "/var/tmp/${pixelated_server_deb}",
      require  => [
        Exec['fetch_pixelated_server'],
        Package['pixelated-user-agent'],
        Package['ssl-cert'] ]
  }
}
