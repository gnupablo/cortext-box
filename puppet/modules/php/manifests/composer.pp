class php::composer {
    $home_dir='/home/vagrant'
    require php
    #install composer
    exec {'composer_install':
            command   =>'curl -sS https://getcomposer.org/installer | php',
            require   => [Package["curl"], Package["php5"]],
            cwd       => "${home_dir}",
            creates   =>"${home_dir}/composer.phar"
    }
    #rename it composer and make it available to any user
    exec { 'composer':      
            command   =>'sudo mv ${home_dir}/composer.phar /usr/local/bin/composer',
            cwd       => "${home_dir}",
            creates   =>"/usr/local/bin/composer",
            require   =>Exec['composer_install']
    }
}
