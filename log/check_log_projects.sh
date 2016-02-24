tail -f `ls -rt ./projects*.log ./*/projects*.log` | php ./decode_log $1
