Vagrant - Rails Base
===========

An easy way to setup a Ruby Vagrant box using Puppet.

###Getting Started

Modify the config section in the Vagrantfile to your liking. 

```ruby
  config = {
    appname:  'myapp',
    hostname: 'dev.myappdomain.com',
    boxname:  'My App Box Name',
    boxip:    '192.168.12.138',
    gems:     ['shotgun', 'pry', 'guard', 'rake', 'resque']
  }
```

Once your settings have been updated you can build the box.

    $ vagrant up && vagrant provision


fin
