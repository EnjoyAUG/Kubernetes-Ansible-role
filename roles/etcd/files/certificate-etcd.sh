#!/bin/bash
#date: 2021-06-25
#
#MASTER_01=192.168.81.197
#MASTER_02=192.168.81.198
#WORKER_01=192.168.81.199
#WORKER_02=192.168.81.200
##down load certificate tools
#curl -L https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 -o /usr/local/bin/cfssl
#curl -L https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 -o /usr/local/bin/cfssljson
#curl -L https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64 -o /usr/local/bin/cfssl-certinfo
#chmod  +x   /usr/local/bin/cfssl
#chmod  +x   /usr/local/bin/cfssljson
#chmod  +x   /usr/local/bin/cfssl-certinfo

cd /usr/local/bin/
ln -s cfssl-certinfo_linux-amd64 cfssl-certinfo
ln -s cfssljson_linux-amd64 cfssljson
ln -s cfssl_linux-amd64 cfssl

#create direactory
#mkdir /opt/etcd/{bin,cfg,ssl} -p
#mkdir -p ~/TLS/{etcd,k8s} 
cd ~/TLS/etcd

#Create CA
cat > ca-config.json << EOF
{
  "signing": {
    "default": {
      "expiry": "87600h"
    },
    "profiles": {
      "www": {
         "expiry": "87600h",
         "usages": [
            "signing",
            "key encipherment",
            "server auth",
            "client auth"
        ]
      }
    }
  }
}
EOF

cat > ca-csr.json << EOF
{
    "CN": "etcd CA",
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "L": "Beijing",
            "ST": "Beijing"
        }
    ]
}
EOF
cfssl gencert -initca ca-csr.json | cfssljson -bare ca -
#Create certificate
cat > server-csr.json << EOF
{
    "CN": "etcd",
    "hosts": [
    $1
    ],
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "L": "BeiJing",
            "ST": "BeiJing"
        }
    ]
}
EOF
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=www server-csr.json | cfssljson -bare server
