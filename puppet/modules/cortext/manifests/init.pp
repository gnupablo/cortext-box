class cortext{
    $dir = "/vagrant/src/cortext/";
    file {$dir:
    ensure => directory
    }
    $cortext_projects =[
        'cortext-auth',
        'cortext-assets',
        'cortext-manager'
    ];
    #create directories for projects
    cortext:project{$cortext_projects:
    }
    
    
}
