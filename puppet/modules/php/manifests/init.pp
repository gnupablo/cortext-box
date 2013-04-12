class php {
  $packages = ["php5", "php5-cli", "php5-mysql", "php-pear", "php5-dev", "php5-gd"]
  
  package { $packages:
    ensure => present,
    require => Exec["apt-get update"]
  }
}

class {"composer":
  target_dir      => '/usr/local/bin',
  composer_file   => 'composer',
  download_method => 'curl', # download methods are curl or wget
  logoutput       => false
}
