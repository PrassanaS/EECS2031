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
#make a variable that consists of only readable files
course_files=`find $path -type f -name '*.rec' -perm /444`
# check if we find at least one file with permission to read
if [ "X${course_files}" = "X" ]
then
  echo 'There is not readable *.rec file exists in the specified path or its subdirectories'
  exit 1
fi

#assign a variable for the second argument
com=$2
#is com h?
if [[ $com = "h" ]]
then
	echo Here are defined commands:
	echo creg: give the list of course names with the total number of students registered in each course.
	echo stc \#\#\#\#\#\#: gives the name of all course names in which the student with \#\#\#\#\#\# id registered in.
	echo gpa '######: gives the GPA of the student defined with id ###### using the following formula: (course_1*credit_1 +   
. . . + course_n*credit_n) / (credit_1+ . . . + credit_n)'
	echo h: prints the current message.
#else if com is creg
elif [[ $com = "creg" ]]
then
count=0
	for course in $course_files
	do
	#we do not want the "course" or "name" or ":" from the *.rec files  
	read d1 d2 d3 course_name < $course
	count=$((count+1))
	#grep counts the number of lines that start with number aka the number of students
	echo $count. In \"${course_name^^}\", `grep -c "^[0-9]" $course` students register.     
	done
#else if com is stc
elif [[ $com =  "stc" ]]
then 
	studentid=$3
	counter=0
	touch temp.txt
#also make sure its not anything but 6 char long
		if [ ${#studentid} -ne 6 ]
		then
		echo The student id should be 6 numbers.
else
#if this id exists in some .rec file
			if [[ `grep -o  "$studentid" $course_files` ]]	
			then
			for course in $course_files
			do
#check if the student exists in each individual course
				if [ `grep -o  "$studentid" $course` ]
				then
#up the counter by 1 representing the number of classes the student is in
				counter=$((counter+1))
				# line taken from creg 
   	 			read d1 d2 d3 course_name < $course
				#the credit value is the single digit number on the credit line, we find this by...
   	 			credits=`grep -i "credits" $course | grep -o [0-9]` 
				#append the course name and credit to a temp file
   	 			echo $counter. ${course_name^^} which has $credits credits >> temp.txt
   	 			fi
			done
			#my print statement, the first echo is outside the loop because we dont want any part of it to be repeated
			#for the list of classes the student is in, we cat the temp file which we appended stuff in
    			echo The student with id: $studentid, is registered in the following courses:
    			cat temp.txt
			#remove the temp file
    			rm temp.txt
			#in case the student isnt in any .rec file provided
			else
			echo The student with id: $studentid is not registered in any course.
			fi
			fi
#if com is gpa
elif [[ $com = "gpa" ]]
then
studid=$3
	#samething form the previous block, more efficient because we dont check if arg3 is empty
	if [ ${#studid} -ne 6 ]
	then
	echo The student id should be 6 numbers.
	#if the student exists in the .rec files
	elif [ `grep -o "$studid" $course_files` ]
	then
	echo not done
	#if the student does not exist in .rec files.
	else 
	echo The student with id: $studid is not registered in any course.
	fi
    	
fi
