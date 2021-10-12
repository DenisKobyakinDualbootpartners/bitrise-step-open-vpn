#!/bin/bash
set -eu
case "$OSTYPE" in
linux*)
    echo "Linux operative system: $OSTYPE, exiting"
    exit 1
    ;;
darwin*)
    echo "Configuring for Mac OS"

    mkdir ./openvpn

    # We create the .conf file with the parameters of the VPN, including the authorization through the txt file
    cat <<EOF >./openvpn/client.conf
${ovpn_file}
EOF
    echo ${user} >./openvpn/auth.conf
    echo ${password} >>./openvpn/auth.conf

    sudo openvpn --config ./openvpn/client.conf --auth-user-pass ./openvpn/auth.conf

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
