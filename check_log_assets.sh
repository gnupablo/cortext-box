tail -f `ls -rt log/*/*assets*.log` | php ./decode_log.php $1
