define project($name=$title){
    $src_dir = "/Vagrant/src/cortext"
    file{"${src_dir}/${name}"
        ensure => directory,
        mode => 775
    }
    Exec{"composer update":
        cwd   => "${dir}/${name}",
        path  => "/usr/local/bin"
    }
}
