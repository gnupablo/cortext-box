
<?php 
echo "Class ZMQ existante : ";
var_dump(class_exists('ZMQContext'));

echo "\n ZMQcontext :";
$ctx = new ZMQContext();
var_dump($ctx);

echo "Socket creation :";
$output = new ZMQSocket($ctx, ZMQ::SOCKET_PUSH);
$output->bind("tcp://*:9999");

var_dump($output);





 //phpinfo()
