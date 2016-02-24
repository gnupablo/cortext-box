tail -f `ls -rt log/*/*auth*.log` | php ./decode_log.php $1
