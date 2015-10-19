#!/bin/sh
#This creates the links for the log tools
cd /vagrant/log/
ln -s ../tools/check_log_api.sh check_log_api
ln -s ../tools/check_log_assets.sh check_log_assets
ln -s ../tools/check_log_auth.sh check_log_auth
ln -s ../tools/check_log_manager.sh check_log_manager
ln -s ../tools/check_log_mcp.sh check_log_mcp
ln -s ../tools/check_log_projects.sh check_log_projects
ln -s ../tools/check_log.sh check_log
ln -s ../tools/check_log_sink.sh check_log_sink
ln -s ../tools/check_log_worker.sh check_log_worker
ln -s ../tools/decode_worker.php decode_log
