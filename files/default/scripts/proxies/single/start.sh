#!/bin/bash
echo "Stopping squid ..."
run_cmd service squid stop  && echo "stopped successfully"

# Make the right config file
echo "Copying squid configuration ..."
run_cmd cp $PROXY_TESTS_DIR/proxies/single/squid.conf /etc/squid/squid.conf

# Deny all traffic except squid
echo "Setting routes to deny all traffic except ssh and squid ..."
run_cmd iptables -F OUTPUT
run_cmd iptables -A OUTPUT -j ACCEPT -p tcp -dport 443 --dst-range 13.107.6.0-13.107.6.254
run_cmd iptables -A OUTPUT -j ACCEPT -p tcp -dport 443 --dst-range 13.107.9.0-13.107.9.254
run_cmd iptables -A OUTPUT -j ACCEPT -p tcp -dport 443 --dst-range 13.107.42.0-13.107.43.254
run_cmd iptables -A OUTPUT -j ACCEPT -p tcp --dport 22
run_cmd iptables -A OUTPUT -j ACCEPT -m owner --uid-owner proxy
run_cmd iptables -A OUTPUT -j DROP ! -o lo+ -m state --state NEW -p tcp
run_cmd iptables -A OUTPUT -j ACCEPT

echo "Starting squid ..."
run_cmd service squid start
sleep 2
