tail -f `ls -rt log/*/mcp*.log` | php ./decode_log.php $1
