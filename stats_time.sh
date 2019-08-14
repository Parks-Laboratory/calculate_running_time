for i in $(find . -type f -name "epistasis_*.log" )
do 
	echo $i;./log_summary.sh $i | grep -Eoh 'Time difference of [0-9]*.[0-9]* \w+$' | grep -Eoh '[0-9]*.[0-9]* \w+$';
done


awk '{print$1}' runEachJobTime.txt >> 0_jobsInMins.txt

awk '{s+=$1}END{print s}' 0_jobsInMins.txt > 0_totalTimeInMins.txt

rm 0_jobsInMins.txt

