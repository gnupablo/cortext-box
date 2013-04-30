class bootstrap {
  # this makes puppet and vagrant shut up about the puppet group
	group { 'puppet':
	ensure => 'present'
    }
  	file { "/etc/apt/sources.list":
        ensure => file,
        owner => root,
        group => root,
        source => "puppet:///modules/bootstrap/sources.list",
	}

	exec { "import-gpg":
		command => "/usr/bin/wget -q http://www.dotdeb.org/dotdeb.gpg -O -| /usr/bin/apt-key add -",
        require => File ['/etc/apt/sources.list']
	}

	exec { 'apt-get update':
		require => [File["/etc/apt/sources.list"], Exec["import-gpg"]],
	}
}