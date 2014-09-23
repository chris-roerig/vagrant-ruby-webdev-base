Vagrant - Ruby Web Dev Base
===========

An easy way to setup a Ruby web development Vagrant box using Puppet.

###Whats in the box?

* Server OS: Ubuntu Trusty (14.04 LTS) 64 bit.
* Web Server: Nginx ready to reverse proxy all your favorite Ruby web servers.
* [rbenv](https://github.com/sstephenson/rbenv) with Ruby version 2.0.0
* Sqlite3
* MongoDB


###Future plans

* Choose which databases are installed.


###Getting Started

Modify the settings section in the Vagrantfile to your liking. **Note**, make
sure your gem list is comma delimited **with no spaces**.

```ruby
  settings = {
    box_name:       'My App Box Name',
    app_dir:        'myapp',
    hostname:       'dev.myappdomain.com',
    box_ip:         '192.168.12.120',
    proxy_port:     3000, 
    ruby_version:   '2.0.0-p247',
    gems:           'shotgun,pry,guard,resque'
  }
```

Once your settings have been updated you can build the box.

    $ vagrant up


### Settings

* **box_name**
    
    The Virtual Box machine name.

* **app_dir**
    
    The folder Vagrant should keep synced. Keep in mind this is relative to the Vagrantfile so leaving it blank will resolve to the root path of the Vagrant project:
    
    `app_dir: ''    # the same as /path/to/my/project`
    
    `app_dir: 'foo' # the same as /path/to/my/project/foo`
    
* **hostname**

    The url you will be using to access the site during development. If you have the Vagrant hosts-updater plugin installed you will not need to update your hosts file.
    
* **box_ip**

    The IP address to allocate for the virtual machine. Make sure these are unique if you are running multiple boxes at the same time.
    
* **proxy_port**

    This should be the port you plan on reverse proxy-ing. Its easiest to stick with the default port your Ruby websever is using. For example, if you are working with Rails and using WEBrick, the default port is `3000`. If you are using Sinatra the default port is `4567`.
    
* **ruby_version**

    rbenv is used to manage the installed Ruby versions. Any Ruby version that can be loaded by rbenv can be specified here.
    
* **gems**

    A list of Ruby Gems installed automatically during provisioning. It is important that each gem is seperated by a command `,` and **no spaces**. It is not possible to specify a gem version at this time but you could modify the provisioning file to your hearts content.
    


Improvements welcomed.