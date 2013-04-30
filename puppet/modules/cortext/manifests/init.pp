class cortext {
    define ctrun {
        $src_dir = "/vagrant/src/cortext"
        file{"${src_dir}/${title}":
            ensure => directory,
            mode => 775
        }
        exec{"chmod +x ${src_dir}/${title}/install.sh":
            onlyif    => "/usr/bin/test -f ${src_dir}/${title}/install.sh"
        }
        exec{"chmod +x ${src_dir}/${title}/start.sh":
            onlyif    => "/usr/bin/test -f ${src_dir}/${title}/start.sh"
        }
        exec{"${src_dir}/${title}/install.sh":
            cwd       => "${src_dir}/${title}",
            path      => ["/usr/bin","/usr/local/bin"],
            onlyif    => "/usr/bin/test -f ${src_dir}/${title}/install.sh",
            require   => Exec["chmod +x ${src_dir}/${title}/install.sh"]
        }
        exec{"${src_dir}/${title}/start.sh &":
            cwd       => "${src_dir}/${title}",
            path      => ["/usr/bin","/usr/local/bin"],
            require   => [File['/etc/php5/cli/php.ini'], Exec["${src_dir}/${title}/install.sh"],Exec["chmod +x ${src_dir}/${title}/start.sh"]],
            onlyif    => "/usr/bin/test -f ${src_dir}/${title}/start.sh"
        }
    }

    $dir='/vagrant/src/cortext'
    file {$dir:
        ensure => directory,
        require => File['/usr/local/bin/composer']
    }

    #install and run projects
    ctrun{['cortext-auth','cortext-assets','cortext-manager','cortext-graphs']:}

    #ct manager V1
    file { "/vagrant/src/cortext/cortext/manager/config/databases.yml":
        ensure   => present,
        source   => "puppet:///modules/cortext/ctmanager-databases.yml.dist"
    }

    file { "/vagrant/src/cortext/cortext/manager/apps/frontend/config/app.yml":
        ensure   => present,
        source   => "puppet:///modules/cortext/ctmanager-app.yml.dist"
    }
}
