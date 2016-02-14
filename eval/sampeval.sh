#!/bin/bash
SAMPSIZE=500
if [ $# -ge 2 ]
then
	echo "Usage: bash sampeval.sh [-d|-x]"
	exit 1
fi
TEANGA=""
if [ $# -eq 1 ]
then
	if [ "${1}" = "-x" ]
	then
		TEANGA="-gv"
	else
		if [ "${1}" = "-d" ]
		then
			TEANGA="-gd"
		else
			echo "Usage: bash sampeval.sh [-d|-x]"
			exit 1
		fi
	fi
fi
TMPSPRIOC=`mktemp`
TMPX=`mktemp`
(cd ..; paste "eval/testpre${TEANGA}.txt" "eval/testpost${TEANGA}.txt" | shuf | head -n $SAMPSIZE | tee $TMPSPRIOC | cut -f 1 | bash tiomanai.sh $@ | sed 's/^.* => //' | perl detokenize.pl) > "$TMPX"
sed -i "s/^.*\t//" $TMPSPRIOC
echo `date '+%Y-%m-%d %H:%M:%S'` `bash eval.sh "$TMPX" "$TMPSPRIOC"` >> "wer${TEANGA}.txt"
tail -n 10 "wer${TEANGA}.txt"
rm -f "$TMPSPRIOC" "$TMPX"