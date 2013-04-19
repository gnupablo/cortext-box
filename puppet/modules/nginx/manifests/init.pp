#nginx puppet
class nginx {
  # package { 'nginx':
  #   ensure  => latest,
  #   require => Exec["apt-get update"]
  # }
  exec {"nginx_backports":
    command  => "apt-get install -y -t squeeze-backports nginx",
    require  => Exec['apt-get update']
  }

  file { '/etc/nginx/sites-available/default':
    ensure   => present,
    source   => "puppet:///modules/nginx/vhost.cortext.dist",
    require  => Exec ["nginx_backports"]
  }

  file { "/etc/nginx/sites-enabled/default":
    ensure  => link,
    target  => "/etc/nginx/sites-available/default",
    require => File['/etc/nginx/sites-available/default']
  }

  # starts the nginx service once the packages installed, and monitors changes to its configuration files and reloads if nesessary
  service { "nginx":
    ensure    => running,
    require   => Exec ["nginx_backports"],
    subscribe => File["/etc/nginx/sites-enabled/default"]
  }
}

