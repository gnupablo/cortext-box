class php::composer {
    $home_dir='/home/vagrant'
    require php
    #install composer
    exec {'composer_install':
            command   => 'curl -sS https://getcomposer.org/installer | php',
            require   => [Package["curl"], Package["php5"]],
            cwd       => "${home_dir}",
            creates   => "${home_dir}/composer.phar"

    }
    #rename it composer and make it available to any user
    file { '/usr/local/bin/composer':
        ensure   => link,
        target   => "${home_dir}/composer.phar",
        require  => Exec["composer_install"]
    }
}
