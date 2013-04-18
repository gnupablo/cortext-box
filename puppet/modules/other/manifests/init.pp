class other {
  $packages = ["curl", "vim", "htop","git","nano"]
  package { $packages:
    ensure => present,
    require => Exec["apt-get update"]
  }
  file { '/etc/motd':
        content => "
                Welcome to your Cortext Box !
                ==============================
                You\'re running a Debian Squeeze 64bit.
                Comments welcome on https://github.com/cortext/cortext-box\n"
  }
}
