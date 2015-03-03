# enable unattended upgrades for pixelated platform
class pixelated::unattended_upgrades {
  apt::apt_conf { '51unattended-upgrades_pixelated':
    source      => [
      "puppet:///modules/pixelated/${::lsbdistid}/51unattended-upgrades_pixelated.${::lsbdistcodename}",
      "puppet:///modules/pixelated/${::lsbdistid}/51unattended-upgrades_pixelated"],
    require     => Package['unattended-upgrades'],
    refresh_apt => false,
  }
}
