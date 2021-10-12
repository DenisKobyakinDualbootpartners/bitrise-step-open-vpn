#!/bin/bash
    echo "Configuring for Mac OS"

    mkdir ./openvpn

    echo ${ca_crt} | base64 -D -o ca.crt > /dev/null 2>&1
    echo ${client_crt} | base64 -D -o client.crt > /dev/null 2>&1
    echo ${client_key} | base64 -D -o client.key > /dev/null 2>&1
    echo ${user} > ./openvpn/auth.conf
    echo ${password} >> ./openvpn/auth.conf

    sudo openvpn --client --dev tun --proto ${proto} --remote ${host} ${port} --askpass auth.conf --status /run/openvpn.status 10 --daemon --resolv-retry infinite --nobind --persist-key --persist-tun --comp-lzo --verb 3 --ca ca.crt --cert client.crt --key client.key > /dev/null 2>&1 &

    sleep 10

    ifconfig

    ping http://10.10.30.76/

    if ifconfig -l | grep utun0 > /dev/null
    then
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
