#!/bin/sh
#read -p 'rmax: ' var1 
#read -p 'tree_type: ' var2
#read -p 'size_of_tree: ' var3
#read -p 'number of speeds: ' var4
#read -p 'static energy: ' var5
#read -p 'max_speed: ' var6
#read -p 'regularity of speeds: ' var7
#read -p 'number of tests: ' var8
#read -p 'expe number: ' var9
cd ..
echo "$1\n$2\n$3\n$4\n$5\n$6\n$7\n$8\n$9" > conf
make opt
./comp conf
cd results
gcc ../LP/new_lp.c -o test -lglpk -fno-stack-protector 
case $9 in
	0 )
	for nodes in `seq 1 $3`; do
		for iter in `seq 1 $8`; do
			./test ${nodes} $5 $9 ${iter}
			rm size=${nodes}_idle=${5}_expe=$9_iter=${iter}.dat
			if [ "${nodes}" -lt 31 ]; then
				cplex -c "r pbm_size=${nodes}_idle=$5_expe=$9_iter=${iter}_general.lp" "opt"|grep "Objective ="| cut -d "=" -f 2 >> result_${nodes}_${5}_${9}_${iter}.temp
			else
				echo "" >> result_${nodes}_${5}_${9}_${iter}.temp
			fi
			rm pbm_size=${nodes}_idle=$5_expe=$9_iter=${iter}_general.lp
		done
	done
	for nodes in `seq 1 $3`; do
		for iter in `seq 1 $8`; do
			cat result_${nodes}_${5}_${9}_${iter}.temp >> result_$3_$4_$5_$7_$9.score
			rm result_${nodes}_${5}_${9}_${iter}.temp
		done
	done
	rm *.log
	cd ../exploitation_results
	echo "$1\n$2\n$3\n$4\n$5\n$6\n$7\n$8\n$9" > conf
	make
	./comp conf < ../results/result_$3_$4_$5_$7_$9.score
	gnuplot maxnodes_$3_rmax=$1_treetype=$2_nspeed=$4_maxspeed=$6_typespeed=$7_static=$5.p
	;;
	1 )
	for nodes in `seq 1 $3`; do
		for iter in `seq 1 $8`; do
			./test ${nodes} $5 $9 ${iter}
			rm size=${nodes}_idle=${5}_expe=$9_iter=${iter}.dat
			if [ "${nodes}" -lt 26 ]; then
				cplex -c "r pbm_size=${nodes}_idle=$5_expe=$9_iter=${iter}_general.lp" "opt"|grep "Objective ="| cut -d "=" -f 2 >> result_${nodes}_${5}_${9}_${iter}.temp
			else
				echo "" >> result_${nodes}_${5}_${9}_${iter}.temp
			fi
			rm pbm_size=${nodes}_idle=$5_expe=$9_iter=${iter}_general.lp
		done
	done
	for nodes in `seq 1 $3`; do
		for iter in `seq 1 $8`; do
			cat result_${nodes}_${5}_${9}_${iter}.temp >> result_$3_$4_$5_$7_$9.score
			rm result_${nodes}_${5}_${9}_${iter}.temp
		done
	done
	rm *.log
	cd ../exploitation_results
	echo "$1\n$2\n$3\n$4\n$5\n$6\n$7\n$8\n$9" > conf
	make
	./comp conf < ../results/result_$3_$4_$5_$7_$9.score
	gnuplot maxnodes_$3_rmax=$1_treetype=$2_nspeed=$4_maxspeed=$6_typespeed=$7_static=$5.p
#	echo "You have tried an expe_number that is not yet implemented."
	;;
	2 )
	for iter in `seq 1 $8`; do
		./test ${3} $5 $9 ${iter}
		rm size=${3}_idle=${5}_expe=$9_iter=${iter}.dat
		if [ "${3}" -lt 26 ]; then
			cplex -c "r pbm_size=${3}_idle=$5_expe=$9_iter=${iter}_general.lp" "opt"|grep "Objective ="| cut -d "=" -f 2 >> result_${3}_${5}_${9}_${iter}.temp
		else
			echo "" >> result_${3}_${5}_${9}_${iter}.temp
		fi
		rm pbm_size=${3}_idle=$5_expe=$9_iter=${iter}_general.lp
	done
	for iter in `seq 1 $8`; do
		cat result_${3}_${5}_${9}_${iter}.temp >> result_$3_$4_$7_$9.score
		rm result_${3}_${5}_${9}_${iter}.temp
	done
	rm *.log
	cd ../exploitation_results
	echo "$1\n$2\n$3\n$4\n$5\n$6\n$7\n$8\n$9" > conf
	make
	./comp conf < ../results/result_$3_$4_$7_$9.score
	gnuplot static_energy_$5_nodes=$3_rmax=$1_treetype=$2_nspeed=$4_maxspeed=$6_typespeed=$7.p
	;;
	3 )
	for static in `seq 0 1000 $5`; do
		for iter in `seq 1 $8`; do
			./test ${3} $5 $9 ${iter}
			rm size=${3}_idle=${5}_expe=$9_iter=${iter}.dat
			if [ "${3}" -lt 26 ]; then
				cplex -c "r pbm_size=${3}_idle=$5_expe=$9_iter=${iter}_general.lp" "opt"|grep "Objective ="| cut -d " " -f 10 >> result_${3}_${5}_${9}_${iter}.temp
			else
				echo "" >> result_${3}_${5}_${9}_${iter}.temp
			fi
			rm pbm_size=${3}_idle=$5_expe=$9_iter=${iter}_general.lp
		done
		for iter in `seq 1 $8`; do
			cat result_${3}_${5}_${9}_${iter}.temp >> result_$3_$4_$5_$7_$9.score
			rm result_${3}_${5}_${9}_${iter}.temp
		done
	done
	rm *.log
	cd ../exploitation_results
	echo "$1\n$2\n$3\n$4\n$5\n$6\n$7\n$8\n$9" > conf
	make
	./comp conf < ../results/result_$3_$4_$5_$7_$9.score
	gnuplot static_energy_$5_nodes=$3_rmax=$1_treetype=$2_nspeed=$4_maxspeed=$6_typespeed=$7.p
	;;
	* ) 
	echo "You have tried an expe_number that is not yet implemented."
	;;
esac
#for r in `seq 1 $8`; do
##	ssh slsu0-01.dsi-ext.ens-lyon.fr
#	for s in `seq 1 $3`; do
#		./test $3 $s $r
#		if [ "$9" -eq 1 ]; then
#			if [ "$3" -lt 25 ]; then
#				cplex -c "r pbm_size=$3_idle=%d_expe=%d_iter=%d_general.lp" "opt"|grep "Objective ="| cut -d " " -f 10 >> result_$3_${s}_${r}_$9.temp
#			else 
#				echo "\n" >> result_$3_${s}_${r}_$9.temp
#			fi
#		else
#			if [ "$3" -lt 25 ]; then
#				cplex -c "r pbm_size=$3_serv=${s}_iter=${r}_general.lp" "opt"|grep "Objective ="| cut -d " " -f 10 >> result_$3_${s}_${r}_$9.temp
#				cplex -c "r pbm_size=$3_serv=${s}_iter=${r}_greedy_located.lp" "opt"|grep "Objective ="| cut -d " " -f 10 >> result_$3_${s}_${r}_$9.temp
##				echo "\n" >> result_$3_${s}_${r}_$9.temp
#			else 
#				echo "\n" >> result_$3_${s}_${r}_$9.temp
#			fi
#		fi
#	done
#done
##wait
#for r in `seq 1 $8`; do
#	for s in `seq 1 $3`; do
#		cat result_$3_${s}_${r}_$9.temp >> result_$3_$4_$7_$9.score
#	done
#done
#rm ../conf *.log *.temp pbm_size=$3_* size=$3_*
#cd ../exploitation_results
#echo "$1\n$2\n$3\n$4\n$6\n$7\n$8\n$9" > conf
#make
#./comp conf < ../results/result_$3_$4_$7_$9.score
#gnuplot $1_$2_$3_$4_$5_$6_$7_$9.p
