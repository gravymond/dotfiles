#!/bin/sh
#
# Little marquee-text script
# Written by Claudio M. Alessi
#

# Interval between permutation in the current marquee
INTERVAL=.1

# Interval between marquees
INTERVAL2=1

# Output program
#PRINT="$(which xsetroot) -name"
PRINT="echo -ne"

#
# Marquee text from right to the left
#
marquee_left()
{
	string="$*"
	let eidx=${#string}+1

	for i in $(seq 1 $eidx)
	do
		let j=i-1
		strout="$(echo "$string" |cut -b $i-)"
		[ $j -ne 0 ] && strout="$strout$(echo "$string" |cut -b -$j)"
		$PRINT "$strout\r"
		sleep $INTERVAL
	done
}

#
# Marquee text from left to the right
#
marquee_right()
{
	string="$*"
	let eidx=${#string}+1

	for i in $(seq 1 $eidx)
	do
		let j=$eidx-$i+1
		strout="$(echo "$string" | cut -b $j-)"
		let --j
		[ $j -gt 0 ] && strout="$strout$(echo "$string" | cut -b -$j)"
		$PRINT "$strout\r"
		sleep $INTERVAL
	done
}


#
# The main function
#
main()
{
	# Missing output string
	[ -z "$*" ] && echo "Usage: $(basename $0) <string>" && exit 1

	# Empty the title on exit
	for SIG in INT TERM
		do trap "$PRINT '' && exit" $SIG
	done

	n=0
	while true
	do
		let "$n"
		n=$?

		[ $n -ne 0 ] && marquee_right "$*" || marquee_left "$*"
		sleep $INTERVAL2
	done
}

main "$@"