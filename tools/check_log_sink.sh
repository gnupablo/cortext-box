tail -f `ls -rt ./sink*.log ./*/sink*.log` | php ./decode_log $1
