<?php
/* cortext assets config file */

//constants
define('CORPUS_EXTENSIONS','txt|csv|zip|db|html|htm');
define('ALL_DOCUMENTS','');
define('RESERVED_FILENAMES','MAIN_READLOCK|MAIN_WRITELOCK|log.txt|\.pkl|\.yml|\.yaml|^_.*');

//urls
define('URL_OAUTH_SERVER','http://auth.cortext.dev');
define('URL_MANAGER','http://manager.cortext.dev');
define('URL_FILES','http://documents.cortext.dev:8080/');
define('URL_HTTP_HOST_EXTERNAL','http://assets.cortext.dev:8080');
define('URL_CGU','http://auth.cortext.dev:8080/cgu');

//debug
define('APP_DEBUG', true);

//database
define('DB_DRIVER', 'pdo_mysql');
define('DB_HOST', 'localhost');
define('DB_DBNAME', 'ct_assets');
define('DB_USER', 'ct_assets');
define('DB_PASSWORD', '');

////////////////////////////////////////////////////

//Parameters Construction
$parameters = array();
$parameters['db_options']['driver'] = DB_DRIVER;

$parameters['db_options'] = array(
    'driver'   => DB_DRIVER,
    'host'     => DB_HOST,
    'dbname'   => DB_DBNAME,
    'user'     => DB_USER,
    'password' => DB_PASSWORD
);

$parameters['logFile'] = '/../../../log/cortext/assets.log';
$parameters['logAppName'] = 'Assets';
$parameters['rootPath'] = __DIR__.'/../documents/';
