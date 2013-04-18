class apache {
  $packages = ["libapache2-mod-php5","libapache2-mod-wsgi"]

  package { "apache2":
    ensure  => present,
    require => Exec["apt-get update"]
  }

  package {$packages:
    ensure  => present,
    require => Package["apache2"]
  }


  # ensures that mode_rewrite is loaded and modifies the default configuration file
  file { "/etc/apache2/mods-enabled/rewrite.load":
    ensure   => link,
    target   => "/etc/apache2/mods-available/rewrite.load",
    require  => Package["apache2"]
  }

  file { "/etc/apache2/sites-available/cortext":
    ensure   => present,
    source   => "puppet:///manifests/cortext.vhost.dist",
    require  => Package["apache2"]
  }

  file { "/etc/apache2/envvars":
    ensure    => present,
    source    => "puppet:///manifests/apache-envvars.dist",
    require   => Package["apache2"],
    mode      => 0644,
    group     => 'root',
    owner     => 'root'
  }

  file { "/etc/apache2/sites-enabled/cortext":
    ensure  => link,
    target  => "/etc/apache2/sites-available/cortext",
    require => File["/etc/apache2/sites-available/cortext"]
  }

  file {"/etc/apache2/sites-enabled/000-default":
    ensure  => absent,
    require => Package["apache2"]
  }

  # starts the apache2 service once the packages installed, and monitors changes to its configuration files and reloads if nesessary
  service { "apache2":
    ensure    => running,
    require   => Package["apache2"],
    subscribe => [
      File["/etc/apache2/mods-enabled/rewrite.load"],
      File["/etc/apache2/sites-available/cortext"]
    ],
  }
}
