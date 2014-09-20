Vagrant.configure('2') do |config|
  # You will want to modify these to reflect your projects needs.
  # This should be the only thing you need to modify
  # These settings also be used in the Puppet manifest.
  settings = {
    box_name:       'My App Box Name',
    app_dir:        '',
    hostname:       'dev.myappdomain.com',
    box_ip:         '192.168.12.120',
    proxy_port:     3000, 
    ruby_version:   '2.0.0-p247',
    gems:           'shotgun,pry,resque'
  }

  config.vbguest.auto_update = true

  config.vm.box      = 'precise64'
  config.vm.hostname = settings[:hostname]

  config.vm.network :forwarded_port, guest: 80, host: 9393, auto_correct: true
  config.vm.network :forwarded_port, guest: 3306, host: 8306, auto_correct: true

  config.vm.provider :virtualbox do |vb|
    vb.name = settings[:box_name]
  end

  # Install the vagrant plugin 'vagrant-hostsupdater' to have 
  # Vagrant automatically manage your hosts file.
  # vagrant plugin install hostupdater
  config.vm.network "private_network", ip: settings[:box_ip]

  # use nfs for regular dev
  config.vm.synced_folder "./", "/home/vagrant/#{settings[:app_dir]}", nfs: true
  
  # Use rsync when coffeescript-ing
  #config.vm.synced_folder "./", "/home/vagrant/#{settings[:app_dir]}", type: "rsync"

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = 'puppet/manifests'
    puppet.module_path    = 'puppet/modules'
    puppet.facter = settings
  end
end
