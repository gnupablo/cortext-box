tail -f `ls -rt ./mcp*.log ./*/mcp*.log` | php ./decode_log $1
