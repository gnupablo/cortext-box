class php {
  $packages = ["php5", "php5-cli", "php5-mysql", "php-pear", "php5-dev", "php5-gd","php5-sqlite","php5-curl","php5-fpm"]

  package { $packages:
    ensure => present,
    require => Exec["apt-get update"]
  }
  
  file {'/etc/php5/cli/suhosin.ini':
      ensure     =>   present,
      source     =>   'puppet:///modules/php/suhosin.ini',
      require    =>   Package[$packages]
  }
  file {'/etc/php5/cli/php.ini':
      ensure     =>   present,
      source    =>   'puppet:///modules/php/php.ini',
      require    =>   Package[$packages]
  }

}
