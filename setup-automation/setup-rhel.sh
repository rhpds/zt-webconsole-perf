#!/bin/bash
while [ ! -f /opt/instruqt/bootstrap/host-bootstrap-completed ]
do
   echo "Waiting for Instruqt to finish booting the VM"
   sleep 1
done

subscription-manager config --rhsm.manage_repos=1
subscription-manager register --activationkey=${ACTIVATION_KEY} --org=12451665 --force

echo "Adding wheel" > /root/post-run.log
usermod -aG wheel rhel

echo "setting password" >> /root/post-run.log
echo redhat | passwd --stdin rhel

echo "exclude=kernel*" >> /etc/yum.conf

echo "Install PCP packages" >> /root/post-run.log
dnf install pcp-zeroconf cockpit-pcp stress-ng -y

echo "restart cockpit" >> /root/post-run.log
systemctl restart cockpit

echo "DONE" >> /root/post-run.log

touch /root/post-run.log.done

n=1
GREEN='\033[0;32m' 
NC='\033[0m' # No Color

while [ ! -f /root/post-run.log.done ] ;
do
      if test "$n" = "1"
      then
	    clear
            n=$(( n+1 ))	 # increments $n
      else
	    printf "."
      fi
      sleep 2
done
clear
echo -e "${GREEN}Ready to start your scenario${NC}"
