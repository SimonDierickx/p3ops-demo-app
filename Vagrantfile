
# HOST_ONLY_NETWORK = "vboxnet1" # Typically on Linux/Mac
HOST_ONLY_NETWORK = "VirtualBox Host-Only Ethernet Adapter #2" # Typically on Windows

Vagrant.configure("2") do |config|
    config.vm.define "database.NET" do |host|
        host.vm.box = "generic/alpine318"
        host.vm.hostname = "database.NET"



        host.vm.provider :virtualbox do |v|
            v.name = "database.NET"
            v.cpus = "1"
            v.memory = "2048"
            v.customize ["modifyvm", :id, "--groups", "/test-vm-ops"]
        end
    end
end
