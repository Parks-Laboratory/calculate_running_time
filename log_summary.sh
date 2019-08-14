# Note: depends on Rscript (comes with R installation)

if [ $# -ne 1 ]; then
	echo Usage: $0 path/to/chtc/log_file
	exit
elif [ ! -f $1 ]; then
	echo Could not find file \"$1\"
	exit
fi

function printds {
	echo -e $* \\n
}

function countJobs {
	echo $(grep "$1" "$2" | wc -l)
}


if [ ! -x "$(command -v Rscript)" ]; then
	echo -e "\\n(Additional statistics available if Rscript is installed)"
	printds \\n===============================================
	exit
fi

printds \\n===============================================

firstSubmission=$( grep ^000 "$1" | head -1 | awk '{print $3" "$4}' )
lastTermination=$( grep ^005 "$1" | tail -1 | awk '{print $3" "$4}' )
echo "First job submitted on $firstSubmission"
echo "Last job finished on $lastTermination"

echo '
args=commandArgs(trailingOnly = TRUE);
s=strptime(c(args[1], args[2]), format="%m/%d  %H:%M:%S");
s[2]-s[1];
' > getDuration.R

echo
Rscript getDuration.R "$firstSubmission" "$lastTermination"

grep 'Run Remote Usage' "$1" > lines
awk 'match($3, /([^,]*)/, a) {print a[1]}' lines > col
echo '
args=commandArgs(trailingOnly = TRUE);
t=strptime(scan(args[1],
what="character", quiet=TRUE), format="%H:%M:%S");
s=sum(c(t$hour*3600, t$min*60, t$sec));
cat(paste(s/60,"mins"));

' > runtime.R
echo $(Rscript runtime.R col) >> runEachJobTime.txt

rm lines col getDuration.R runtime.R
