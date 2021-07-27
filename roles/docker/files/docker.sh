#!/bin/bash
#date: 2021-06-29
#
#wget https://download.docker.com/linux/static/stable/x86_64/docker-20.10.7.tgz
cd /opt/docker
tar zxvf docker-*
mv docker/* /usr/bin
#=======
cat > /lib/systemd/system/docker.service << EOF
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target firewalld.service
Wants=network-online.target
[Service]
Type=notify
ExecStart=/usr/bin/dockerd
ExecReload=/bin/kill -s HUP $MAINPID
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
TimeoutStartSec=0
Delegate=yes
KillMode=process
Restart=on-failure
StartLimitBurst=3
StartLimitInterval=60s
[Install]
WantedBy=multi-user.target
EOF
#=======
mkdir /etc/docker
cat > /etc/docker/daemon.json << EOF
 {
"registry-mirrors": ["https://jo6348gu.mirror.aliyuncs.com"],
"bip": "172.30.0.1/16"
 }
EOF
#========
systemctl daemon-reload 
systemctl start docker
systemctl enable docker
