# Python class
# Python libs needed to execute cortext scripts


class python {
  #cortext install function
  define ct_python_install {
    exec{"easy_install ${title}":
    require => Exec['easy_install pip']
        }
  }



  #packages from debian
  $packages = ["libboost-mpi-python-dev","libboost-mpi-python1.42-dev","libboost-mpi-python1.42.0","libboost-python-dev","libboost-python1.42-dev","libboost-python1.42.0","libpython2.6","python","python-apptools","python-apt","python-apt-common","python-cairo","python-central","python-chaco","python-configobj","python-dateutil","python-dev","python-enable","python-enthoughtbase","python-envisagecore","python-envisageplugins","python-gobject","python-jaxml","python-jsonpickle","python-lxml","python-minimal","python-networkx","python-nose","python-numpy","python-pip","python-pkg-resources","python-pyparsing","python-pyrex","python-reportbug","python-scipy","python-setuptools","python-simplejson","python-sqlite","python-support","python-tk","python-traits","python-traitsbackendwx","python-traitsgui","python-tz","python-vtk","python-wxgtk2.8","python-wxversion","python-yaml","python2.6-dev","r-cran-nws","reportbug","scanerrlog","mayavi2","supervisor"]

  package { $packages:
    ensure => present,
    require => Exec["apt-get update"]
  }

  #install dependencies required to build certain python modules
  exec { "install_deps":
    command => "apt-get -f -y install",
    require => Exec['apt-get update'],
    subscribe =>Package[$packages]
  }

  #install matplot lib with backports
  exec {"matplotlib_backports":
    command  => "apt-get install -y -t squeeze-backports python-matplotlib",
    require  => Exec['install_deps']
  }

  #other packages with pip
  exec { 'easy_install pip':
        path => "/usr/local/bin:/usr/bin:/bin",
        refreshonly => true,
        require => Package["python-setuptools"],
        subscribe => Package["python-setuptools"]
    }

  #supervisor
  exec { 'easy_install supervisor':
        path => "/usr/local/bin:/usr/bin:/bin",
        require => Package["python-setuptools"]
    }

  ct_python_install{["BeautifulSoup","Pygments","Pyste","Tenjin","Whoosh","argparse","chardet","httpie","iconv","jsonpickle","matplotlib","networkx","nltk","nose","numpy","pytz","requests","wsgiref","wxPython"]:}

}
