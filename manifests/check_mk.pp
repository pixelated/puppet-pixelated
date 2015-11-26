# tune check_mk_agent for pixelated specific stuff
# see https://github.com/pixelated-project/pixelated-platform/issues/20
class pixelated::check_mk {

  # docker containers are spinned up dynamically and live only short
  # often, the fs check of those mounts throw errors like this:
  # https://github.com/pixelated-project/pixelated-platform/issues/20#issuecomment-66456676
  # so we ignore all aufs mounts
  file { '/etc/check_mk/conf.d/ignore_filesystems.mk':
    source  => 'puppet:///modules/pixelated/check_mk/ignore_filesystems.mk',
    notify  => Exec['check_mk-refresh'],
    require => Package['check-mk-server'];
  }

  file { '/etc/check_mk/logwatch.d/user-agent.cfg':
    source  => 'puppet:///modules/pixelated/check_mk/user-agent.cfg',
    notify  => Exec['check_mk-refresh'],
    require => Package['check-mk-server'];
  }
  file { '/etc/check_mk/conf.d/ignored_checktypes.mk':
    source  => 'puppet:///modules/pixelated/check_mk/ignored_checktypes.mk',
    notify  => Exec['check_mk-refresh'],
    require => Package['check-mk-server'];
  }

  check_mk_files{['check_dispatcher_manager.sh','check_dispatcher_proxy.sh','check_docker.sh']:}
}
