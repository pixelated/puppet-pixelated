# tune check_mk_agent for pixelated specific stuff
# see https://github.com/pixelated-project/pixelated-platform/issues/20
class pixelated::check_mk {

  file { '/etc/check_mk/logwatch.d/user-agent.cfg':
    source  => 'puppet:///modules/pixelated/check_mk/user-agent.cfg',
    notify  => Exec['check_mk-refresh'],
    require => Package['check-mk-server'];
  }

}
