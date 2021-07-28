#!/bin/bash
#date:2021-06-30
#
cat > /opt/kubernetes/cfg/kube-scheduler.conf << EOF
KUBE_SCHEDULER_OPTS="--logtostderr=false \\
--v=2 \\
--log-dir=/opt/kubernetes/logs \\
--leader-elect \\
--kubeconfig=/opt/kubernetes/cfg/kube-scheduler.kubeconfig \\
--bind-address=$1"
EOF

#========================
cd /opt/kubernetes/ssl
KUBE_CONFIG="/opt/kubernetes/cfg/kube-scheduler.kubeconfig"
KUBE_APISERVER="$2"

kubectl config set-cluster kubernetes \
	  --certificate-authority=/opt/kubernetes/ssl/ca.pem \
	  --embed-certs=true \
	  --server=${KUBE_APISERVER} \
	  --kubeconfig=${KUBE_CONFIG}
kubectl config set-credentials kube-scheduler \
	  --client-certificate=./kube-scheduler.pem \
	  --client-key=./kube-scheduler-key.pem \
	  --embed-certs=true \
	  --kubeconfig=${KUBE_CONFIG}
kubectl config set-context default \
	  --cluster=kubernetes \
	  --user=kube-scheduler \
	  --kubeconfig=${KUBE_CONFIG}
kubectl config use-context default --kubeconfig=${KUBE_CONFIG}

#==========================
cat > /lib/systemd/system/kube-scheduler.service << EOF
[Unit]
Description=Kubernetes Scheduler
Documentation=https://github.com/kubernetes/kubernetes

[Service]
EnvironmentFile=/opt/kubernetes/cfg/kube-scheduler.conf
ExecStart=/opt/kubernetes/bin/kube-scheduler \$KUBE_SCHEDULER_OPTS
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

#=========================
systemctl daemon-reload
systemctl start kube-scheduler
systemctl enable kube-scheduler
