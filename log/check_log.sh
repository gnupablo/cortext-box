cd /vagrant/log
tail -f `ls -rt ./*.log ./*/*.log` | php ./decode_log $1
