# enable unattended upgrades for pixelated platform
class pixelated::unattended_upgrades {
  if $::lsbdistid != 'Debian' or $::lsbdistcodename != 'wheezy' {
    fail('Pixelated only runs on Debian-wheezy')
  }

  apt::apt_conf { '51unattended-upgrades_pixelated':
    source      => [
      "puppet:///modules/pixelated/${::lsbdistid}/51unattended-upgrades_pixelated.${::lsbdistcodename}",
      "puppet:///modules/pixelated/${::lsbdistid}/51unattended-upgrades_pixelated"],
    require     => Package['unattended-upgrades'],
    refresh_apt => false,
  }
}
