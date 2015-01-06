 define python::ct_python_install {
    exec{"easy_install ${title}":
    require => Exec['easy_install pip']
        }
}