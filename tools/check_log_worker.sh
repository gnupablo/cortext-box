tail -f `ls -rt ./worker*.log ./*/worker*.log` | php ./decode_log $1
