class php {
  $packages = ["php5", "php5-cli", "php5-mysql", "php-pear", "php5-dev", "php5-gd","php5-sqlite","php5-curl","php5-fpm"]

  package { $packages:
    ensure => present,
    require => Exec["apt-get update"]
  }
  file {'/etc/php5/cli/conf.d/suhosin.ini':
      ensure     =>   present,
      content    =>   'puppet:///modules/php/suhosin.ini',
      require    =>   Package[$packages]
  }
  file {'/etc/php5/cli/conf.d/php.ini':
      ensure     =>   present,
      content    =>   'puppet:///modules/php/php.ini',
      require    =>   Package[$packages]
  }
}
