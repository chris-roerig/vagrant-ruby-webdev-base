Vagrant.configure('2') do |config|
  # You will want to modify these to reflect your projects needs.
  # This should be the only thing you need to modify
  # These settings also be used in the Puppet manifest.
  settings = {
    appname:  'myapp',
    hostname: 'dev.myappdomain.com',
    boxname:  'My App Box Name',
    boxip:    '192.168.12.120',
    gems:     'shotgun,rails,pry,guard,resque'
  }

  config.vbguest.auto_update = true

  config.vm.box      = 'precise64'
  config.vm.box_url  = 'http://files.vagrantup.com/precise64.box'
  config.vm.hostname = settings[:hostname]

  config.vm.network :forwarded_port, guest: 80, host: 9393, auto_correct: true
  config.vm.network :forwarded_port, guest: 3306, host: 8306, auto_correct: true

  config.vm.provider :virtualbox do |vb|
    vb.name = settings[:boxname]
  end

  # Install the vagrant plugin 'vagrant-hostsupdater' to have 
  # Vagrant automatically manage your hosts file.
  # vagrant plugin install hostupdater
  config.vm.network "private_network", ip: settings[:boxip]

  # use nfs for regular dev
  config.vm.synced_folder "./", "/home/vagrant/#{settings[:appname]}", nfs: true
  
  # Use rsync when coffeescript-ing
  #config.vm.synced_folder "./", "/home/vagrant/#{settings[:appname]}", type: "rsync"

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = 'puppet/manifests'
    puppet.module_path    = 'puppet/modules'
    puppet.facter = settings
  end
end