Vagrant - Ruby Web Dev Base
===========

An easy way to setup a Ruby web development Vagrant box using Puppet.

###Whats in the box?

* Server OS: Ubuntu Precise 64.
* Web Server: Nginx ready to reverse proxy all your favorite Ruby web servers.
* RVM with ruby version 2.0.0
* MongoDB


###Future plans

* Choose which databases are installed


###Getting Started

Modify the settings section in the Vagrantfile to your liking. **Note**, make
sure your gem list is comma delimited **with no spaces**.

```ruby
  settings = {
    appname:  'myapp',
    hostname: 'dev.myappdomain.com',
    boxname:  'My App Box Name',
    boxip:    '192.168.12.138',
    gems:     'shotgun,rails,sinatra,pry,guard,resque'
  }
```

Once your settings have been updated you can build the box.

    $ vagrant up


fin
