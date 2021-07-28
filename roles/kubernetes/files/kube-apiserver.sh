#!/bin/bash
#date: 2021-06-30

#=========================
cd /opt/kubernetes
tar zxvf kubernetes-server-linux-amd64.tar.gz
cd kubernetes/server/bin
cp kube-apiserver kube-scheduler kube-controller-manager /opt/kubernetes/bin
cp kubectl /usr/bin/

#=========================
TOKEN=`head -c 16 /dev/urandom | od -An -t x | tr -d ' '`
cat > /opt/kubernetes/cfg/token.csv << EOF
$TOKEN,kubelet-bootstrap,10001,"system:node-bootstrapper"
EOF

#=========================
cat > /lib/systemd/system/kube-apiserver.service << EOF
[Unit]
Description=Kubernetes API Server
Documentation=https://github.com/kubernetes/kubernetes
[Service]
EnvironmentFile=/opt/kubernetes/cfg/kube-apiserver.conf
ExecStart=/opt/kubernetes/bin/kube-apiserver \$KUBE_APISERVER_OPTS
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF

#=========================
systemctl daemon-reload
systemctl start kube-apiserver
systemctl enable kube-apiserver

#=========================
#kubectl create clusterrolebinding kubelet-bootstrap \
#	--clusterrole=system:node-bootstrapper \
#	--user=kubelet-bootstrap
