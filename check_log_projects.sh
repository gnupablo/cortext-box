tail -f `ls -rt log/*/projects*.log` | php ./decode_log.php $1
