#! /bin/bash
#display menu
echo '--------------------------'
echo 'User Name: parkhyemin'
echo 'Student Number: 12223547'
echo "[ MENU ]"
echo "1. Get the data of the movie identified by a specific 'movie id' from 'u.item'"
echo "2. Get the data of action genre movies from 'u.item’"
echo "3. Get the average 'rating’ of the movie identified by specific 'movie id' from 'u.data'"
echo "4. Delete the ‘IMDb URL’ from ‘u.item'"
echo "5. Get the data about users from 'u.user’"
echo "6. Modify the format of 'release date' in 'u.item’"
echo "7. Get the data of movies rated by a specific 'user id from 'u.data'"
echo "8.  Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'"
echo "9. Exit"
echo '--------------------------'
#get input from the user
read -p "Enter your choice [ 1-9 ] " choice
echo -e "\n"
#repeat(until 9)
while true
do
        case $choice in
        1)
                read -p "Please enter 'movie id'(1~1682):" movie_id
		echo -e "\n" 
                cat ./"$1" | awk -v movie_id="$movie_id" -F '|' '$1==movie_id'
                ;;
        2)
                read -p "Do you want to get the data of 'action' genre movies from 'u.item'?(y/n): " answer
                if [ "$answer" == "y" ]
                then
                        echo -e "\n"
                        cat ./"$1" | awk -F '|' '$7==1{print $1, $2}' | head -n 10 | sort -k 1n
                fi
                ;;
        3)
                read -p "Please enter the 'movie id’(1~1682):" movie_id
                sum=0
                num=0
                cat ./"$2" | awk -v movie_id="$movie_id" '$2==movie_id{sum+=$3;num+=1} END {printf("\naverage rating of %d: %.5f", movie_id, sum/num)}'
                ;;
        4)
                read -p "Do you want to delete the 'IMDb URL' from 'u.item'?(y/n): " answer
		echo -e "\n"
                if [ "$answer" == "y" ]
                then
                        cat ./"$1" | sed -E 's/|[^|]*|//5' | head -n 10

                fi
                ;;
        5)
                read -p "Do you want to get the data about users from‘u.user’?(y/n): " answer
		if [ "$answer" == "y" ]
		then
			cat ./"$3" | head -n 10 | sed 's/F/female/; s/M/male/' | awk -F '|' '{printf("\nuser %d is %d years old %s %s", $1, $2, $3, $4)}'

    
		fi
		;;
                
        6)
                read -p "Do you want to Modify the format of ‘release data’ in ‘u.item’?(y/n): " answer
		echo -e "\n"
                if [ "$answer" == "y" ]
                then
                        cat ./"$1" | tail -n 10 | sed -E -e 's/([0-9]+)-([A-Za-z]+)-([0-9]+)/\3\2\1/' | sed -e 's/Jan/01/g' -e 's/Feb/02/g' -e 's/Mar/03/g' -e 's/Apr/04/g'\
                        -e 's/May/05/g' -e 's/Jun/06/g' -e 's/Jul/07/g' -e 's/Aug/08/g' -e 's/Sep/09/g' -e 's/Oct/10/g' -e 's/Nov/11/g' -e 's/Dec/12/g'    
		fi
                ;;
        7)
                read -p "Please enter the ‘user id’(1~943):" user_id
		echo -e "\n" 
                cat ./"$2" | awk -v user_id="$user_id" '$1==user_id{print $2}' | sort -n | tr '\n' '|' > rated_movieID.txt
                cat ./"rated_movieID.txt"
		echo -e "\n"
                cat ./"rated_movieID.txt" | tr '|' '\n' | head -n 10 | while read movie_id; do
                        awk -F '|' -v movie_id="$movie_id" '$1 == movie_id {printf("\n%d|%s", $1, $2)}' $1
                done
		rm rated_movieID.txt
                ;;
        8)
		read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n): " answer
		echo -e "\n"
		if [ "$answer" == "y" ]; then
			cat ./"$3" | awk -F '|' '$2 >= 20 && $2 <= 29 && $4 == "programmer"{print $1}' > programmer_20s_id.txt
    			cat ./"programmer_20s_id.txt" | while read user_id; do
				awk -v user_id="$user_id" '$1 == user_id {printf("\n%d %d", $2, $3)}' $2 >> rating_info_by_20s_programmer.txt
			done
			sum=0
			count=0
			cat ./"rating_info_by_20s_programmer.txt" | awk '{
    				sum[$1] += $2;
    				count[$1] += 1
			} 
			END {
    			    for (i in sum) {
        			if (count[i] > 0 && i>0) {
          			  printf("%d %.6g\n", i, sum[i]/count[i])
        			}
   			    }
			}' | sort -n
			rm programmer_20s_id.txt rating_info_by_20s_programmer.txt
		fi
		;;

        9)
                echo "Bye!"
                exit 0
                ;;
        esac
        echo -e "\n"
        read -p "Enter your choice [ 1-9 ] " choice
	echo -e "\n"
done
