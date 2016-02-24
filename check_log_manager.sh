tail -f `ls -rt log/*/manager*.log` | php ./decode_log.php $1
