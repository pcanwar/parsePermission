
#! /bin/bash

R=

BAD=

perm="-rw-r--r--"

size=

noDir=

recursivels () {

  if ! [ -d $1 ]

  then

     if [ `stat -c %A $1` = $perm ]

     then

		ls -l $1

        size=$[ size + `stat -c %B $1`]

     fi

  else

    for f in `ls -a $1`

    do

      if [ "$f" != "." ] && [ "$f" != ".." ]

      then

        recursivels $1/$f

      fi

    done

  fi

}



processdir () {



    if [ -n "$1" ]   

	then

			if [ -e "$1" ]

			then

				  if ! [ -d "$1" ]

				  then

					ls -l $1

				  else

						if [ -z "$R" ]

						then

							for f in `ls -a $1`

							do

								if ! [ -d $f ]

								then

										if [ `stat -c %A $1/$f` = $perm ]

										then

										 ls -l $1/$f

										 size=$[ size + `stat -c %B $1/$f`]

										fi

								fi

							done

						else

						  recursivels $1  # fix this

						fi

				   fi

			else

			  echo "Error: $1 does not exist"

			fi

	  else

		echo "Error: missing file or directory name"

	  fi

  }

  

parsePermission () {

	k=`expr length "$1"`

	if [ $k -ne 3 ]

	then

		echo "Permission must be 3 digits long"

		exit

	fi



testperm=$1

stringperm=""

testperm1=$testperm



while [ $testperm1 -gt 0 ] 2>/dev/null

do

	x=$(($testperm1%10))

	if [ ! "$x" -eq "$x" ] 2>/dev/null

	then

	  echo "invalid file permission in command line argument1"

		exit

	fi



	if [ $x -lt 0 -o $x -gt 7  ]

	then

   		echo "invalid file permission in command line argument2"

		exit

	fi

	if [ $x -eq 0 ]

	then

	y="---"

	fi

	if [ $x -eq 1 ]

	then

	y="--x"

	fi

	if [ $x -eq 2 ]

	then

	y="-w-"

	fi

	if [ $x -eq 3 ]

	then

	y="-wx"

	fi

	if [ $x -eq 4 ]

	then

	y="r--"

	fi

	if [ $x -eq 5 ]

	then

	y="r-x"

	fi

	if [ $x -eq 6 ]

	then

	y="rw-"

	fi

	if [ $x -eq 7 ]

	then

	y="rwx"

	fi

	stringperm="$y$stringperm"

	testperm1=$(($testperm1/10))

done

stringperm="-$stringperm"

echo $stringperm

}  



while getopts ":rp:" option

do

   case $option in

     r) R=found

        ;;

		p) Perm=`parsePermission $OPTARG`

		;;

     ?) echo "Permission digits missing -$OPTARG"

        BAD=found

   esac

done



if [ "$BAD" = "found" ]   

then

  exit 1

else

     shift $[ OPTIND - 1]

	 if [ ! -n "$1" ]

	 then

		processdir "."

	 fi

	 while [ -n "$1" ]

	 do

		  if [ -n "$1" ]

			then

				processdir $1

		  else

			echo "Error: missing file or directory name"

		  fi

		shift

	done

	echo "Total size is $size"

 fi

  

