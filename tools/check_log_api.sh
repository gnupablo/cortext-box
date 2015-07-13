tail -f `ls -rt ./api*.log ./*/api*.log` | php ./decode_log $1
