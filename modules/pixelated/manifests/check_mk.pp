# tune check_mk_agent for pixelated specific stuff
# see https://github.com/pixelated-project/pixelated-platform/issues/20
class pixelated::check_mk {

  # docker containers are spinned up dynamically and live only short
  # often, the fs check of those mounts throw errors like this:
  # https://github.com/pixelated-project/pixelated-platform/issues/20#issuecomment-66456676
  # so we ignore all aufs mounts
  file { '/etc/check_mk/conf.d/ignore_filesystems.mk':
    source  => 'puppet:///modules/site_check_mk/ignore_filesystems.mk',
    notify  => Exec['check_mk-refresh'],
    require => Package['check-mk-server'];
  }

}
