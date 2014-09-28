$as_vagrant   = 'sudo -u vagrant -H bash -l -c'
$home         = '/home/vagrant'
$app_path     = "/vagrant/${app_dir}"
$gems_array   = split($gems, ',')

Exec {
  path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin']
}

# --- Apt Packages -----------------------------------------------------------------

exec { 'apt-update':
    command => '/usr/bin/apt-get update'
}

$apt_packages = [
  'curl',
  'yasm',
  'build-essential',
  'git-core',
  'vim',
  'nfs-common',
  'portmap',
  'imagemagick',
  'sqlite3',
  'libsqlite3-dev',
  # Nokogiri dependencies.
  'libxslt-dev',
  'libxml2-dev',
  # ExecJS runtime.
  'nodejs'
]

package { $apt_packages:
  ensure => 'installed',
  require => Exec['apt-update']
}

# --- Ruby via rbenv ---------------------------------------------------------------------

class { 'rbenv': }

rbenv::build { $ruby_version: global => true }

# required 
rbenv::plugin { [ 'sstephenson/rbenv-vars', 'sstephenson/ruby-build' ]: }

# install gems
rbenv::gem { $gems_array: 
  ruby_version => $ruby_version
}

# --- Nginx (For reverse proxy) -----------------------------------------------

class { 'nginx': }

# make sure the proxy port you are using is 
# in this list.
nginx::resource::upstream { 'puppet_rack_app':
  members => [
    'localhost:3000', # WEBrick (Rails)
    'localhost:4567', # Sinatra
    'localhost:8080', # Thin
    'localhost:9393', # Shotgun
  ],
}

nginx::resource::vhost { $hostname:
  proxy => "http://127.0.0.1:${proxy_port}",
}

# --- Redis ---------------------------------------------------------------------

class { 'redis': }

# --- MongoDB ------------------------------------------------------------------

class {'::mongodb::server':
  port => 27017
}

# --- Bash profile customization ---------------------------------------------------------------------

exec { 'login_to_project': 
  command => "${as_vagrant} 'echo \"cd /vagrant\" >> ${home}/.profile'"
}
