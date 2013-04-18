class cortext {
    define ctrun {
        $src_dir = "/vagrant/src/cortext"
        file{"${src_dir}/${title}":
            ensure => directory,
            mode => 775
        }
        exec{"${src_dir}/${title}/install.sh":
            cwd       => "${src_dir}/${title}",
            path      => ["/usr/bin","/usr/local/bin"],
            onlyif    => "/usr/bin/test -f ${src_dir}/${title}/install.sh"
        }
        exec{"${src_dir}/${title}/start.sh &":
            cwd       => "${src_dir}/${title}",
            path      => ["/usr/bin","/usr/local/bin"],
            require   => Exec["${src_dir}/${title}/install.sh"],
            onlyif    => "/usr/bin/test -f ${src_dir}/${title}/start.sh"
        }
    }

    $dir='/vagrant/src/cortext'
    file {$dir:
    ensure => directory,
    require => File['/usr/local/bin/composer']
    }

    #install and run projects
    ctrun{['cortext-auth','cortext-assets','cortext-manager']:}
}
