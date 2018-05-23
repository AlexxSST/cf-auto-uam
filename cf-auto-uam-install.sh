#!/bin/bash

cat << "EOF"
        _____                        __                                         
  _____/ ____\        _____   __ ___/  |_  ____            __ _______    _____  
_/ ___\   __\  ______ \__  \ |  |  \   __\/  _ \   ______ |  |  \__  \  /     \ 
\  \___|  |   /_____/  / __ \|  |  /|  | (  <_> ) /_____/ |  |  // __ \|  Y Y  \
 \___  >__|           (____  /____/ |__|  \____/          |____/(____  /__|_|  /
     \/                    \/                                        \/      \/ 
EOF

printf "\033[1;34mWelcome to the cf-auto-uam installer.\r\nVersion 1.0\033[0m"
printf "\r\n\r\n"

if [ -d "/root/cf-auto-uam/" ]; then
  printf "\033[1;31mDetected previous installation of cf-auto-uam.\r\n"
  sleep .5
  printf "Removing it...\r\n\033[0m"
  rm -rf /root/cf-auto-uam
fi

sleep .5

printf "\033[1;34m\nCloudFlare E-Mail (example@mail.com) :\n> \033[0m"
read cfemail

emailregex="^([A-Za-z]+[A-Za-z0-9]*((\.|\-|\_)?[A-Za-z]+[A-Za-z0-9]*){1,})@(([A-Za-z]+[A-Za-z0-9]*)+((\.|\-|\_)?([A-Za-z]+[A-Za-z0-9]*)+){1,})+\.([A-Za-z]{2,})+"

if ! [[ $cfemail =~ $emailregex ]] ; then

	printf "\033[1;31mInvalid email.\r\n\033[0m"
	exit

fi

printf "\033[1;34m\nCloudFlare API Key :\n> \033[0m"
read cfapikey

printf "\033[1;34m\nCloudFlare Zone ID :\n> \033[0m"
read cfzoneid

if [[ -e /etc/debian_version ]]; then

	printf "\033[1;32mUpdating and upgrading your system.\r\n\033[0m"
	sleep 1
	apt upgrade -y
	apt update -y
	sleep 1
	printf "\033c"
	printf "\033[1;32mInstalling depencies.\r\n\033[0m"
	sleep 1
	apt install cron curl bsdmainutils -y
	sleep 1
	printf "\033c"
	printf "\033[1;32mBuilding files.\r\n\033[0m"
	sleep 1
	mkdir /root/cf-auto-uam
	cd /root/cf-auto-uam
cat > activate.sh << EOF
#!/bin/bash
loadavg=load.avg
cat /proc/loadavg | colrm 6 > \$loadavg
grep -w "[0.00-10.00]" \$loadavg > /dev/null
if [ \$? -eq 0 ]
then
exit
else
bash /root/cf-auto-uam/uam.sh
fi
EOF
cat > deactivate.sh << EOF
#!/bin/bash
loadavg=load.avg
cat /proc/loadavg | colrm 6 > \$loadavg
grep -w "[0.00-9.00]" \$loadavg > /dev/null
if [ \$? -eq 0 ]
then
bash /root/cf-auto-uam/high.sh
else
exit
fi
EOF
cat > high.sh << EOF
curl -s -X PATCH "https://api.cloudflare.com/client/v4/zones/$cfzoneid/settings/security_level" \\
     -H "X-Auth-Email: $cfemail" \\
     -H "X-Auth-Key: $cfapikey" \\
     -H "Content-Type: application/json" \\
     --data '{"value":"high"}'
EOF
cat > uam.sh << EOF
curl -s -X PATCH "https://api.cloudflare.com/client/v4/zones/$cfzoneid/settings/security_level" \\
     -H "X-Auth-Email: $cfemail" \\
     -H "X-Auth-Key: $cfapikey" \\
     -H "Content-Type: application/json" \\
     --data '{"value":"under_attack"}'
EOF

	touch /root/cf-auto-uam/load.avg
	chmod 500 /root/cf-auto-uam/
	chmod 500 /root/cf-auto-uam/activate.sh
	chmod 500 /root/cf-auto-uam/deactivate.sh
	chmod 500 /root/cf-auto-uam/high.sh
	chmod 500 /root/cf-auto-uam/uam.sh
	chmod 600 /root/cf-auto-uam/load.avg
	crontab -l > cron1
	echo "* * * * * cd /root/cf-auto-uam/ ; bash activate.sh" >> cron1
	crontab cron1
	rm cron1
	crontab -l > cron2
	echo "* * * * * cd /root/cf-auto-uam/ ; sleep 15 ; bash activate.sh" >> cron2
	crontab cron2
	rm cron2
	crontab -l > cron3
	echo "* * * * * cd /root/cf-auto-uam/ ; sleep 30 ; bash activate.sh" >> cron3
	crontab cron3
	rm cron3
	crontab -l > cron4
	echo "* * * * * cd /root/cf-auto-uam/ ; sleep 45 ; bash activate.sh" >> cron4
	crontab cron4
	rm cron4
	crontab -l > cron5
	echo "10,30 * * * * cd /root/cf-auto-uam/ ; bash deactivate.sh" >> cron5
	crontab cron5
	rm cron5
	service cron restart

elif [[ -e /etc/centos-release ]]; then

	printf "\033[1;32mUpdating and upgrading your system.\r\n\033[0m"
	sleep 1
	yum upgrade -y
	yum update -y
	sleep 1
	printf "\033c"
	printf "\033[1;32mInstalling depencies.\r\n\033[0m"
	sleep 1
	yum install cronie curl util-linux-ng -y
	sleep 1
	printf "\033c"
	printf "\033[1;32mBuilding files.\r\n\033[0m"
	sleep 1
	mkdir /root/cf-auto-uam
	cd /root/cf-auto-uam
cat > activate.sh << EOF
#!/bin/bash
loadavg=load.avg
cat /proc/loadavg | colrm 6 > \$loadavg
grep -w "[0.00-10.00]" \$loadavg > /dev/null
if [ \$? -eq 0 ]
then
exit
else
bash /root/cf-auto-uam/uam.sh
fi
EOF
cat > deactivate.sh << EOF
#!/bin/bash
loadavg=load.avg
cat /proc/loadavg | colrm 6 > \$loadavg
grep -w "[0.00-9.00]" \$loadavg > /dev/null
if [ \$? -eq 0 ]
then
bash /root/cf-auto-uam/high.sh
else
exit
fi
EOF
cat > high.sh << EOF
curl -s -X PATCH "https://api.cloudflare.com/client/v4/zones/$cfzoneid/settings/security_level" \\
     -H "X-Auth-Email: $cfemail" \\
     -H "X-Auth-Key: $cfapikey" \\
     -H "Content-Type: application/json" \\
     --data '{"value":"high"}'
EOF
cat > uam.sh << EOF
curl -s -X PATCH "https://api.cloudflare.com/client/v4/zones/$cfzoneid/settings/security_level" \\
     -H "X-Auth-Email: $cfemail" \\
     -H "X-Auth-Key: $cfapikey" \\
     -H "Content-Type: application/json" \\
     --data '{"value":"under_attack"}'
EOF

	touch /root/cf-auto-uam/load.avg
	chmod 500 /root/cf-auto-uam/
	chmod 500 /root/cf-auto-uam/activate.sh
	chmod 500 /root/cf-auto-uam/deactivate.sh
	chmod 500 /root/cf-auto-uam/high.sh
	chmod 500 /root/cf-auto-uam/uam.sh
	chmod 600 /root/cf-auto-uam/load.avg
	crontab -l > cron1
	echo "* * * * * cd /root/cf-auto-uam/ ; bash activate.sh" >> cron1
	crontab cron1
	rm cron1
	crontab -l > cron2
	echo "* * * * * cd /root/cf-auto-uam/ ; sleep 15 ; bash activate.sh" >> cron2
	crontab cron2
	rm cron2
	crontab -l > cron3
	echo "* * * * * cd /root/cf-auto-uam/ ; sleep 30 ; bash activate.sh" >> cron3
	crontab cron3
	rm cron3
	crontab -l > cron4
	echo "* * * * * cd /root/cf-auto-uam/ ; sleep 45 ; bash activate.sh" >> cron4
	crontab cron4
	rm cron4
	crontab -l > cron5
	echo "10,30 * * * * cd /root/cf-auto-uam/ ; bash deactivate.sh" >> cron5
	crontab cron5
	rm cron5
	service crond restart

else
	printf "Looks like you aren't running this installer on Debian, Ubuntu or CentOS."
	exit 1
fi

printf "\033[1;32mInstallation finished successfully without any errors!\033[0m"
printf "\r\n\r\n"
exit
