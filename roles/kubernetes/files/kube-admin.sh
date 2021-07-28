#!/bin/bash
#date:2021-06-30
#
mkdir /root/.kube
cd /opt/kubernetes/kubernetes/server/bin
cp kubectl /usr/bin/

KUBE_CONFIG="/root/.kube/config"
KUBE_APISERVER="$1"

cd /opt/kubernetes/ssl

kubectl config set-cluster kubernetes \
	  --certificate-authority=/opt/kubernetes/ssl/ca.pem \
	  --embed-certs=true \
	  --server=${KUBE_APISERVER} \
	  --kubeconfig=${KUBE_CONFIG}
kubectl config set-credentials cluster-admin \
	  --client-certificate=./admin.pem \
	  --client-key=./admin-key.pem \
	  --embed-certs=true \
	  --kubeconfig=${KUBE_CONFIG}
kubectl config set-context default \
	  --cluster=kubernetes \
	  --user=cluster-admin \
	  --kubeconfig=${KUBE_CONFIG}
kubectl config use-context default --kubeconfig=${KUBE_CONFIG}
