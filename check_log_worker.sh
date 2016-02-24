tail -f `ls -rt log/*/worker*.log` | php ./decode_log.php $1
