#!/bin/sh

#Prassana Sivakumaran 215091259

#Check if the user has input a parameter
if [ $# -eq 0 ]
then
echo 'you have not enetered a path'
exit 1
fi

filepath=$1

#Use only file that end iwht .rec and are readable
coursefile=`find $path -type f -name '*.rec' -perm /444`

# check if we find at least one file
if [ "X${coursefile}" = "X" ]
then
  echo 'There is not readable *.rec file exists in the specified path or 
its subdirectories!'
  exit 1
fi

#main method
user_c="command: "
printf $user_c

while true
do 
read command
case $command in
	l | list) echo 'Here is a list of the files found:'
		echo $coursefile;;
	q | quit) echo 'Process done'
		 break;;
	*) echo 'Unrecognized cmd';;
esac
done



exit 0
