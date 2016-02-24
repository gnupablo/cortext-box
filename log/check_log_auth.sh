tail -f `ls -rt ./*auth*.log ./*/*auth*.log` | php ./decode_log $1
