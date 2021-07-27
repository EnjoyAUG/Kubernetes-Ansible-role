#/bin/bash
#date:2021-07-03
#
mkdir -pv /etc/calico/
cat > /etc/calico/calicoctl.cfg << EOF
apiVersion: projectcalico.org/v3
kind: CalicoAPIConfig
metadata:
spec:
  datastoreType: "kubernetes"
  kubeconfig: "/root/.kube/config"
EOF

cat > /opt/kubernetes/cfg/ippool-ipip-always.yaml << EOF 
apiVersion: projectcalico.org/v3
kind: IPPool
metadata:
  name: my-ippool
spec:
  cidr: 172.15.0.0/16
  ipipMode: Always
  natOutgoing: true
  nodeSelector: all()
  disabled: false
EOF
#calicoctl apply -f /opt/kubernetes/cfg/ippool-ipip-always.yaml
