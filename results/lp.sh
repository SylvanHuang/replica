#!/bin/sh
cd ..
echo "$1\n$2\n$3\n$4\n$5\n$6\n$7" > conf
make opt
./comp conf
cd results
gcc ../LP/lp.c -o test -lglpk -fno-stack-protector 
for r in `seq 1 $7`; do
#	ssh slsu0-01.dsi-ext.ens-lyon.fr
	for s in `seq 1 $3`; do
		./test $3 $s $r
		if [ "$3" -lt 25 ]; then
			cplex -c "r pbm_size=$3_serv=${s}_iter=${r}_general.lp" "opt"|grep "Objective ="| cut -d " " -f 10 >> result_$3_${s}_${r}.temp
			cplex -c "r pbm_size=$3_serv=${s}_iter=${r}_greedy_located.lp" "opt"|grep "Objective ="| cut -d " " -f 10 >> result_$3_${s}_${r}.temp
			cplex -c "r pbm_size=$3_serv=${s}_iter=${r}_move1_located.lp" "opt"|grep "Objective ="| cut -d " " -f 10 >> result_$3_${s}_${r}.temp
			cplex -c "r pbm_size=$3_serv=${s}_iter=${r}_move2_located.lp" "opt"|grep "Objective ="| cut -d " " -f 10 >> result_$3_${s}_${r}.temp
		else 
			echo "\n" >> result_$3_${s}_${r}.temp
		fi
	done
done
#wait
for r in `seq 1 $7`; do
	for s in `seq 1 $3`; do
		cat result_$3_${s}_${r}.temp >> result_$3_$4_$6.score
#		echo "\n" >> result_$3_$4_$6.score
	done
done
rm ../conf *.log *.temp pbm_size=$3_* size=$3_*
