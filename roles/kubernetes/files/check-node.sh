#!/bin/bash
#date:2021-07-09
echo 0 >  /root/binary-kubernetes-double-master/node_number
NODE_NUMBER=`cat /root/binary-kubernetes-double-master/node_number`
until [[ $NODE_NUMBER == $1 ]]
do
	echo $(kubectl get csr | grep "Pending" | awk '{print $1}' | wc -l) > /root/binary-kubernetes-double-master/node_number
	NODE_NUMBER=`cat /root/binary-kubernetes-double-master/node_number`
done
rm /root/binary-kubernetes-double-master/node_number -f
