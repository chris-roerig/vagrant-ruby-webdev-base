Vagrant.configure('2') do |config|
  # Modify settings to reflect your projects needs.
  # This should be the only thing you need to modify.
  # The settings will be used and available in the Puppet manifest.
  settings = {
    box_name:       'My App Box Name',
    app_dir:        '',
    hostname:       'dev.myappdomain.com',
    box_ip:         '192.168.12.120',
    proxy_port:     3000, 
    ruby_version:   '2.0.0-p247',
    gems:           'rails,rspec,rake,pry'
  }

  ##########################################################

  config.vbguest.auto_update = true

  config.vm.box      = 'precise64'
  config.vm.hostname = settings[:hostname]

  config.vm.network :forwarded_port, guest: 80, host: 9393, auto_correct: true
  config.vm.network :forwarded_port, guest: 3306, host: 8306, auto_correct: true

  config.vm.provider :virtualbox do |vb|
    vb.name = settings[:box_name]
  end

  # Only check for Vagrant plugins during the "up" action
  if ARGV[0] == 'up'
    # check for Vagrant plugins
    unless Vagrant.has_plugin?('vagrant-hostsupdater')
      hostsupdater_missing_msg = <<-DESC
      =-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

      vagrant-hostsupdater is not installed.
      The hosts updater plugin will allow Vagrant to automatically
      manage your hosts file. I highly recommend it.

      Do you want me to install it now? (y|n)
      DESC

      print hostsupdater_missing_msg.gsub(/^ {4}/, '')

      if STDIN.gets.chomp.downcase == 'y'
        `vagrant plugin install vagrant-hostsupdater`
      else
        puts "OK, don't forget to add #{settings[:box_ip]} #{settings[:hostname]} to your hosts file."
      end
    end
  end

  config.vm.network "private_network", ip: settings[:box_ip]

  # use nfs for regular dev
  config.vm.synced_folder "./#{settings[:app_dir]}", "/vagrant/", nfs: true
  
  # Use rsync when coffeescript-ing
  #config.vm.synced_folder "./#{settings[:app_dir]}", "/vagrant/", type: "rsync"

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = 'puppet/manifests'
    puppet.module_path    = 'puppet/modules'
    puppet.facter         = settings
  end
end
