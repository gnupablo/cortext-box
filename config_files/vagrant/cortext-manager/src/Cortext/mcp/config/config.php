<?php
/**
 * Fichier de configuration pour la gestion des communications Serveur/Worker via MCP/SINK/WORKER/PROXY
 */

// Définition du niveau de rapports d'erreur
//error_reporting(E_NOTICE);
error_reporting(E_ALL);

// Définition des niveaux d'état des jobs
define( "CREATED",    0 );
define( "QUEUED",     1 );
define( "STARTING",   2 );
define( "STARTED",    3 );
define( "RUNNING",    4 );
define( "PROC_ERROR", 8 );
define( "FINISHED",   9 );

// Définition des niveaux de progression hors script
define( "PROGRESS_INIT", 0 );
define( "PROGRESS_STARTED", 10 );
// Le traitement par le script évoluera entre les valeurs STARTED et FINISHED
define( "PROGRESS_FINISHED", 100 );

// Paramètres de connexion à la BDD des jobs
$databases['localhost'] = array( 
    "dbServer"   => "localhost",
    "dbPort"     => 3306,
    "dbName"     => "ct_manager",
    "dbUserName" => "root",
    "dbUserPass" => "",
    "assetsUrl"  => "http://assets.cortext.dev" );

// Liste d'urls pour les points d'API ou les callbacks
//$assetsUrl  = "http://assets.cortext.dev";
//$managerUrl = "http://www.cortext.dev:8080";

// Définition des interfaces
// MCP push to worker
$socket_mcp_output = 'tcp://*:1234';

// Worker pull from mcp
$socket_worker_input = 'tcp://localhost:1234';

// Worker push to sink
$socket_worker_output = 'tcp://localhost:1236';

// Sink pull from worker
$socket_sink_input = 'tcp://*:1236';

// Temps d'attente entre chaque check de la BDD par le MCP
define( "MCP_WAIT_TIME", 2 );

