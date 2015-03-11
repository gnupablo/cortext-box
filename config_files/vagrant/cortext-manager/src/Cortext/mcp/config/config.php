<?php
/**
 * Cortext MCP - config file
 * 
 */


error_reporting(E_NOTICE);


define("QUEUED", 0);
define("STARTED", 1);
define("PROC_ERROR", 8);
define("FINISHED", 9);


/**
 * job database
 */
$server="localhost";
$userName="root";
$userPass="";
$dbName="ct_manager";

/* urls */
$assetsUrl = "http://assets.cortext.dev";
$managerUrl = "http://www.cortext.dev:8080";
?>
