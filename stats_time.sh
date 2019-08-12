for i in $(find . -type f -name "epistasis_*.log"  | xargs -r0 )
do 
	echo $i;./log_summary.sh $i | grep -Eoh 'Time difference of [0-9]*.[0-9]* \w+$' | grep -Eoh '[0-9]*.[0-9]* \w+$';
done


awk '$2 ~ /mins/ {print$1}' runEachJobTime.txt >> jobsInMins.txt

awk '{s+=$1}END{print s}' jobsInMins.txt > 0_totalTimeInMins.txt


