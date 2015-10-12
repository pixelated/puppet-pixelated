# todo: opening ports <1024 doesn't work on mac
Vagrant.configure("2") do |config|
  config.vm.define :pixelated_platform do |config|
    config.vm.box = "LEAP/wheezy"
    config.vm.network "forwarded_port", guest: 8080, host:8080
    config.vm.network "forwarded_port", guest: 443, host:4443
  end
end
