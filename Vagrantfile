Vagrant.configure(2) do |config|
  config.vm.box = "boxcutter/debian77"
  config.vm.network "forwarded_port", guest: 8080, host:8080
  config.vm.network "forwarded_port", guest: 443, host:4443
end
