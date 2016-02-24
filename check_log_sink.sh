tail -f `ls -rt log/*/sink*.log` | php ./decode_log.php $1
