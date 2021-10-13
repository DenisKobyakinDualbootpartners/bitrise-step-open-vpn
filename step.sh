#!/bin/bash
set -eu
case "$OSTYPE" in
linux*)
    echo "Linux operative system: $OSTYPE, exiting"
    exit 1
    ;;
darwin*)
    echo "Configuring for Mac OS"

    # We create the .conf file with the parameters of the VPN, including the authorization through the txt file
    cat <<EOF >client.conf
${ovpn_file}
EOF
    echo ${ca_crt} | base64 -D -o ca.crt
    echo ${client_crt} | base64 -D -o client.crt
    echo ${client_key} | base64 -D -o client.key
    echo ${user} >auth.conf
    echo ${password} >>auth.conf

    sudo openvpn --config client.conf --auth-user-pass auth.conf

    echo "$(date) Sleeping"
    sleep 10
    echo "$(date) Fully awake"

    ping http://10.10.30.76/ || exit 1

    if ifconfig -l | grep utun0 >/dev/null; then
        echo "VPN connection succeeded"
    else
        echo "VPN connection failed!"
        exit 1
    fi
    ;;
*)
    echo "Unknown operative system: $OSTYPE, exiting"
    exit 1
    ;;
esac
