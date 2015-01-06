class other {
  file { '/etc/motd':
        content => "
                Welcome to your Cortext Box !
                ==============================
                You\'re running a Ubuntu 64bit.
                Comments welcome at https://github.com/cortext/cortext-box\n"
  }
}
