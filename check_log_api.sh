tail -f `ls -rt log/*/api*.log` | php ./decode_log.php $1
