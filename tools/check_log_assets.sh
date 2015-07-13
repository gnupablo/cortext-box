tail -f `ls -rt ./*assets*.log ./*/*assets*.log` | php ./decode_log $1
