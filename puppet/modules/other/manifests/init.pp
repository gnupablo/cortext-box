class other {
  $packages = ["curl", "vim"]
  package { $packages:
    ensure => present,
    require => Exec["apt-get update"]
  }
  file { '/etc/motd':
     content => "Welcome to your Cortext Box !\n
                You\'re running a Debian Squeeze 64bit.\n
		Comments welcome on https://github.com/cortext/box"
  }
}
