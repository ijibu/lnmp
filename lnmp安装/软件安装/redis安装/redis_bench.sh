#!/bin/bash
#最小的并发数
minC=5000
c=0

for ((i=0;i<1;i++))
do
	let "c = $minC + $i*1000"
	echo 
	echo "redis-benchmark -h 192.168.1.240 -p 6379 -n 200000 -c $c -q"
	redis-benchmark -h 192.168.1.240 -p 6379 -n 200000 -c $c -q
	echo 
	#echo $c
done
