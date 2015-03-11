class custom {
  File['/etc/resolv.conf'] -> Service['couchdb']
  include pixelated::dispatcher
}
