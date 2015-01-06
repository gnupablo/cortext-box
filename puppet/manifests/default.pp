# default path
Exec {
  path => ['/usr/bin', '/bin', '/usr/sbin',
            '/sbin', '/usr/local/bin', '/usr/local/sbin']
}

include bootstrap
include other
include apache
#include nginx
#include python
include php
include php::pear
include php::pecl
include php::composer
include mysql
include mongodb
include cortext
