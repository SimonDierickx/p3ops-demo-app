# Uncomment the appropriate network adapter based on your operating system:
# HOST_ONLY_NETWORK = "vboxnet1" # Typically on Linux/Mac
HOST_ONLY_NETWORK = "VirtualBox Host-Only Ethernet Adapter #2" # Typically on Windows

Vagrant.configure("2") do |config|
    config.vm.define "database.NET" do |host|
        host.vm.box = "bento/almalinux-9.4"
        host.vm.hostname = "database.NET"

        # Set up private network with a static IP address
        host.vm.network "private_network", ip: "192.168.62.253", netmask: "255.255.255.0", name: HOST_ONLY_NETWORK

        # Set up port forwarding for HTTP (5000) and HTTPS (5001) if needed
        host.vm.network "forwarded_port", guest: 5000, host: 5000
        host.vm.network "forwarded_port", guest: 5001, host: 5001

        # Configure the VirtualBox provider
        host.vm.provider :virtualbox do |v|
            v.name = "database.NET"
            v.cpus = "1"
            v.memory = "4096"
            v.customize ["modifyvm", :id, "--groups", "/test-vm-ops"]
        end
    end
end
