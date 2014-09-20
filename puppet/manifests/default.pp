$as_vagrant   = 'sudo -u vagrant -H bash -l -c'
$home         = '/home/vagrant'
$app_path     = "/home/vagrant/${appname}"
$gems_array   = split($gems, ',')

Exec {
  path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin']
}

# --- Preinstall Stage ---------------------------------------------------------

stage { 'preinstall':
  before => Stage['main']
}

class apt_get_update {
  exec { 'apt-get -y update':
    unless => "test -e ${home}/.rvm"
  }
}
class { 'apt_get_update':
  stage => preinstall
}

# --- Nginx (For reverse proxy) -----------------------------------------------

class { 'nginx': }

nginx::resource::upstream { 'puppet_rack_app':
  members => [
    'localhost:3000',
    'localhost:4567',
    'localhost:9393',
  ],
}

nginx::resource::vhost { $hostname:
  proxy => 'http://127.0.0.1:9393',
}

# --- Packages -----------------------------------------------------------------

package { 'curl':
  ensure => installed
}

package { "yasm":
  ensure => installed,
}

package { 'build-essential':
  ensure => installed
}

package { 'git-core':
  ensure => installed
}

package { 'vim':
  ensure => installed
}

package { 'nfs-common':
  ensure => installed
}

package { 'portmap':
  ensure => installed
}

package { 'imagemagick':
  ensure => installed
}

# Nokogiri dependencies.
package { ['libxml2', 'libxml2-dev', 'libxslt1-dev']:
  ensure => installed
}

# ExecJS runtime.
package { 'nodejs':
  ensure => installed
}

# --- Redis ---------------------------------------------------------------------
class { 'redis': }

# --- MongoDB ------------------------------------------------------------------
class {'::mongodb::server':
  port => 27017
}

# --- Ruby ---------------------------------------------------------------------


# https://forge.puppetlabs.com/maestrodev/rvm 
include rvm
rvm::system_user { vagrant: ; }
rvm_system_ruby {
  'ruby-2.0':
    #build_opts  => ['--binary'];
    ensure      => 'present',
    default_use => true;
}

rvm_gem {

}

exec { 'install_rvm':
  command => "${as_vagrant} 'curl -L https://get.rvm.io | bash -s stable'",
  creates => "${home}/.rvm/bin/rvm",
  require => Package['curl']
}

exec { 'install_ruby':
  # We run the rvm executable directly because the shell function assumes an
  # interactive environment, in particular to display messages or ask questions.
  # The rvm executable is more suitable for automated installs.
  #
  # Thanks to @mpapis for this tip.
  command => "${as_vagrant} '${home}/.rvm/bin/rvm install 2.0 --fuzzy --binary --autolibs=enabled && rvm --fuzzy alias create default 2.0'",
  creates => "${home}/.rvm/bin/ruby",
  require => Exec['install_rvm']
}

exec { 'install_bundler':
  command => "${as_vagrant} 'gem install bundler --no-rdoc --no-ri'",
  creates => "${home}/.rvm/bin/bundle",
  require => Exec['install_ruby']
}

# --- Install Ruby Gems ---------------------------------------------------------------------
package { $gems_array:
    ensure   => 'installed',
    provider => 'gem',
    require => Exec['install_bundler']
}

# --- Bash profile customization ---------------------------------------------------------------------

exec { 'login_to_project': 
  command => "${as_vagrant} 'echo \"cd ${app_path}\" >> ${home}/.profile'"
}
