tail -f `ls -rt ./manager*.log ./*/manager*.log` | php ./decode_log $1
