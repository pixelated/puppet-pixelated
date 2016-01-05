# remove obsolent stuff we deployed by earlier versions of
# this module

#
class pixelated::remove {
  tidy {
    '/etc/apt/preferences.d/leap-mx':;
  }
}
