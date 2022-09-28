#!/bin/bash
echo -e "\e[1m\e[32m ________   __ ______ ___  _____ _____   ___________ \e[0m"
echo -e "\e[1m\e[32m | ___ \ \ / / |  ___/ _ \|_   _|  _  | |_   _|  _  \\e[0m"
echo -e "\e[1m\e[32m | |_/ /\ V /  | |_ / /_\ \ | | | | | |   | | | | | |\e[0m"
echo -e "\e[1m\e[32m | ___ \ \ /   |  _||  _  | | | | | | |   | | | | | |\e[0m"
echo -e "\e[1m\e[32m | |_/ / | |   | |  | | | |_| |_\ \/' /  _| |_| |/ / \e[0m"
echo -e "\e[1m\e[32m \____/  \_/   \_|  \_| |_/\___/ \_/\_\  \___/|___/  \e[0m"
echo -e "\e[1m\e[32m                                                     \e[0m"
echo -e "\e[1m\e[32m                                                     \e[0m"
echo -e "\e[1m\e[32m 													\e[0m\n"
echo "\e[1m\e[32m AUTO KILL CHROME BY ASUY ID\e[0m\n\n"
sleep 3
echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
apt update && apt upgrade -y

echo -e "\e[1m\e[32m2. Installing dependencies... \e[0m" && sleep 1
apt-get install xfce4 xfce4-goodies -y
sleep 1
apt install tightvncserver -y
echo -e "\e[1m\e[32m3. set repo... \e[0m" && sleep 1
apt install software-properties-common apt-transport-https wget ca-certificates gnupg2 ubuntu-keyring -y
wget -O- https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor |  tee /usr/share/keyrings/google-chrome.gpg

echo -e "\e[1m\e[32m4. setup repo... \e[0m" && sleep 1
echo deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main |  tee /etc/apt/sources.list.d/google-chrome.list

echo -e "\e[1m\e[32m5. install Chrome.... \e[0m" && sleep 1
apt update && apt install google-chrome-stable -y

echo -e "\e[1m\e[32m6. setup chrome.... \e[0m" && sleep 1
sed -i -e 's@Exec=/usr/bin/google-chrome-stable %U@Exec=/usr/bin/google-chrome-stable %U --no-sandbox@g' /usr/share/applications/google-chrome.desktop 

echo -e "\e[1m\e[32m7. install ngrok.... \e[0m" && sleep 1
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc |  tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" |  tee /etc/apt/sources.list.d/ngrok.list &&  apt update &&  apt install ngrok
echo -n "Masukan Auth Token Ngrok : ";
read autngrok;
ngrok config add-authtoken $autngrok

echo -e "\e[1m\e[32m8. setup pasword vnc.... \e[0m" && sleep 1
vncserver

echo -e "\e[1m\e[32m9. set vncviwer  .... \e[0m" && sleep 1
tee ~/.vnc/xstartup > /dev/null <<EOF
#!/bin/sh
#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
EOF

echo -e "\e[1m\e[32m10. set vncviwer  systemctl.... \e[0m" && sleep 1
tee /etc/systemd/system/vncserver@.service > /dev/null <<EOF
[Unit]
Description=Start TightVNC server at startup
After=syslog.target network.target

[Service]
Type=forking
User=root
Group=root
WorkingDirectory=/root

PIDFile=/root/.vnc/%H:%i.pid
ExecStartPre=-/usr/bin/vncserver -kill :%i > /dev/null 2>&1
ExecStart=/usr/bin/vncserver -depth 24 -geometry 1366x768 -localhost :%i
ExecStop=/usr/bin/vncserver -kill :%i

[Install]
WantedBy=multi-user.target
EOF


systemctl daemon-reload
systemctl enable vncserver@1.service
vncserver -kill :1
systemctl start vncserver@1



echo -e "\e[1m\e[32m9. get host vnc  .... \e[0m" && sleep 1


screen -dmS nvnn
screen -S nvnn -X stuff "ngrok tcp 5901
"

echo -e "\e[1m\e[32m2. get host vnc  .... \e[0m" && sleep 1

screen -r nvnn
