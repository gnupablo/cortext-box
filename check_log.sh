tail -f `ls -rt log/*/*.log` | php ./decode_log.php $1
