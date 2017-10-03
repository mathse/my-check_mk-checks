#!/bin/bash
for i in $(docker inspect --format='{{.Name}};{{.State.Running}};{{.Image}}' $(docker ps -a -q --no-trunc) | cut -c2-)
do
	name=$(echo $i | cut -f1 -d';')
    state=$(echo $i | cut -f2 -d';')
	image=$(echo $i | cut -f3 -d';')
	imageid=$(echo $image | cut -f2 -d':' | cut -c1-12)
	imagename=$(docker image ls | grep $imageid | awk '{print $1}' | uniq)
	if [ "$state" == "true" ]
	then
		if [ "$imagename" == "<none>" ]
		then
	            	echo "1 container_$name - OK - container $name is running with image $imageid ((!)$imagename) = update is needed"
		else
			echo "0 container_$name - OK - container $name is running with image $imageid ($imagename)"
		fi
	else
                echo "2 container_$name - OK - container $name is not running"
	fi
done
