#!/bin/sh
#if there are no args or only one
if [ $# -le 1 ] 
then
	echo You should enter the path name for course files and at least one command.
	echo Use: labtest1.sh path command [arg1 arg2 ...]
	echo For the list of all commands use:
	echo Example1: labtest1.sh . h
	echo For the list of number of registered students in each course use:
	echo Example2: labtest1.sh . creg
fi

path=$1
course_files=`find $path -type f -name '*.rec' -perm /444`
# check if we find at least one file
if [ "X${course_files}" = "X" ]
then
  echo 'There is not readable *.rec file exists in the specified path or its subdirectories'
  exit 1
fi

com=$2
if [[ $com = "h" ]]
then
	echo Here are defined commands:
	echo creg: give the list of course names with the total number of students registered in each course.
	echo stc \#\#\#\#\#\#: gives the name of all course names in which the student with \#\#\#\#\#\# id registered in.
	echo gpa '######: gives the GPA of the student defined with id ###### using the following formula: (course_1*credit_1 +   
. . . + course_n*credit_n) / (credit_1+ . . . + credit_n)'
	echo h: prints the current message.
elif [[ $com = "creg" ]]
then
 for course in $course_files
 do
     # read can read from files. d1 and d2 are summy variables which contain
     # "COURSE and "NAME:" entries. The $course_name variable gets the course name entry 
     read d1 d2 d3 course_name < $course
     wc -l $course >> number
     echo In $course_name, `grep -c "^[0-9]" $course` students register.     
done
elif [[ $com =  "stc" ]]
then 
studentid=$3
counter=0
touch temp.txt
	if [ -z $3 ]
	then
	echo The student id should be 6 numbers.
	elif [ ${#studentid} -ne 6 ]
	then
	echo The student id should be 6 numbers.
	else
		if [ `grep -o  "$studentid" $course_files` ]
then
	for course in $course_files
	do
		if [ `grep -o  "$studentid" $course` ]
		then
		counter=$((counter+1))
    	 # read can read from files. d1 and d2 are summy variables which contain
   		  # "COURSE and "NAME:" entries. The $course_name variable gets the course name entry 
   	 	 read d1 d2 d3 course_name < $course
   	 	 credits=`grep -i "credits" $course | grep -o [0-9]` 
   	 	 echo $counter. $course_name which has $credits credits >> temp.txt
   	 	 fi
	done
    	 echo The student with id: $studentid, is registered in the following courses:
    	 cat temp.txt
    	 rm temp.txt
		else
		echo The student with id: $studentid is not registered in any course.
fi
	fi
    	
fi
