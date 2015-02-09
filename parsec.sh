#!/bin/bash
#export xxPARSECDIRxx="/home/kuan-hao/thesis/parsec-3.0"
#./parsec-3.0/env.sh

# Core
#core_list="1\n"
core_list="1\n2\n4\n"

# 0 is with orignal 1 is without orignal
only_val=0
run()
{
	local cmd="$1"
	for num in $(printf $core_list); do
		echo "$1 $num" >> out
		i="0"
		while [ $i != $test_times ]
		do
			case $cmd in
			facesim)
				(time ./parsec-3.0/pkgs/apps/facesim/inst/amd64-linux.gcc-pthreads/bin/facesim -timing -threads $num) 2>&1 | grep real | awk '{print $2}' >> out
			;;
			ferret)
				rm output.txt
				(time ./parsec-3.0/pkgs/apps/ferret/inst/amd64-linux.gcc-pthreads/bin/ferret corel lsh queries 10 20 $num output.txt) 2>&1 | grep real | awk '{print $2}' >> out
				rm output.txt
			;;
			fluidanimate)
				rm out.fluid
				(time ./parsec-3.0/pkgs/apps/fluidanimate/inst/amd64-linux.gcc-pthreads/bin/fluidanimate $num 5 in_300K.fluid out.fluid) 2>&1 | grep real | awk '{print $2}' >> out
				rm out.fluid
			;;
			raytrace)
				(time ./parsec-3.0/pkgs/apps/raytrace/inst/amd64-linux.gcc-pthreads/bin/rtview happy_buddha.obj -automove -nthreads $num -frames 3 -res 1920 1080) 2>&1 | grep real | awk '{print $2}' >> out
			;;
			x264)
				rm eledream.264
				(time ./parsec-3.0/pkgs/apps/x264/inst/amd64-linux.gcc-pthreads/bin/x264 --quiet --qp 20 --partitions b8x8,i4x4 --ref 5 --direct auto --b-pyramid --weightb --mixed-refs --no-fast-pskip --me umh --subme 7 --analyse b8x8,i4x4 --threads $num -o eledream.264 eledream_640x360_128.y4m) 2>&1 | grep real | awk '{print $2}' >> out
				rm eledream.264
			;;
			canneal)
				(time ./parsec-3.0/pkgs/kernels/canneal/inst/amd64-linux.gcc-pthreads/bin/canneal $num 15000 2000 400000.nets 128) 2>&1 | grep real | awk '{print $2}' >> out
			;;
			dedup)
				rm output.dat.ddp
				(time ./parsec-3.0/pkgs/kernels/dedup/inst/amd64-linux.gcc-pthreads/bin/dedup -c -p -v -t $num -i media.dat -o output.dat.ddp) 2>&1 | grep real | awk '{print $2}' >> out
				rm output.dat.ddp
			;;
			streamcluster)
				rm output.txt
				(time ./parsec-3.0/pkgs/kernels/streamcluster/inst/amd64-linux.gcc-pthreads/bin/streamcluster 10 20 128 16384 16384 1000 none output.txt $num) 2>&1 | grep real | awk '{print $2}' >> out
				rm output.txt
			;;
			ffmpeg)
				rm ./ffmpeg-0.6.3/test.avi
				(time ./ffmpeg-0.6.3/ffmpeg -threads $num -i ./ffmpeg-0.6.3/out_10.MOV -f avi -vcodec mpeg4 -s pal -aspect 4:3 -qscale 4 -acodec mp2 -ac 1 ./ffmpeg-0.6.3/test.avi) 2>&1 | grep real | awk '{print $2}' >> out
				rm ./ffmpeg-0.6.3/test.avi
			;;
			hmmsearch)
				(time ./hmmer-2.3.2/src/hmmsearch  --cpu $num ./hmmer-2.3.2/testsuite/weeviterbi_test.hmm ./hmmer-2.3.2/testsuite/sitchensis.fa) 2>&1 | grep real | awk '{print $2}' >> out
			;;
			pbzip)
				rm ./pbzip2-1.1.12/test.tar*
				cp ./pbzip2-1.1.12/arch.tar ./pbzip2-1.1.12/test.tar
				sync
				(time ./pbzip2-1.1.12/pbzip2 -p$num ./pbzip2-1.1.12/test.tar) 2>&1 | grep real | awk '{print $2}' >> out
				rm ./pbzip2-1.1.12/test.tar*
			;;
			esac
			i=$((i+1))
			sync
			sleep 5
		done
		echo "valgrind $num" >> out
		i="0"
		while [ $i != $test_times ]
		do
			case $cmd in
			facesim)
				(time ./valgrind-3.10.0/coregrind/valgrind --tool=memcheck --leak-check=yes --show-reachable=yes ./parsec-3.0/pkgs/apps/facesim/inst/amd64-linux.gcc-pthreads/bin/facesim -timing -threads $num) 2>&1 | grep real | awk '{print $2}' >> out
			;;
			ferret)
				rm output.txt
				(time ./valgrind-3.10.0/coregrind/valgrind --tool=memcheck --leak-check=yes --show-reachable=yes ./parsec-3.0/pkgs/apps/ferret/inst/amd64-linux.gcc-pthreads/bin/ferret corel lsh queries 10 20 $num output.txt) 2>&1 | grep real | awk '{print $2}' >> out
				rm output.txt
			;;
			fluidanimate)
				rm out.fluid
				(time ./valgrind-3.10.0/coregrind/valgrind --tool=memcheck --leak-check=yes --show-reachable=yes ./parsec-3.0/pkgs/apps/fluidanimate/inst/amd64-linux.gcc-pthreads/bin/fluidanimate $num 5 in_300K.fluid out.fluid) 2>&1 | grep real | awk '{print $2}' >> out
				rm out.fluid
			;;
			raytrace)
				(time ./valgrind-3.10.0/coregrind/valgrind --tool=memcheck --leak-check=yes --show-reachable=yes ./parsec-3.0/pkgs/apps/raytrace/inst/amd64-linux.gcc-pthreads/bin/rtview happy_buddha.obj -automove -nthreads $num -frames 3 -res 1920 1080) 2>&1 | grep real | awk '{print $2}' >> out
			;;
			x264)
				rm eledream.264
				(time ./valgrind-3.10.0/coregrind/valgrind --tool=memcheck --leak-check=yes --show-reachable=yes ./parsec-3.0/pkgs/apps/x264/inst/amd64-linux.gcc-pthreads/bin/x264 --quiet --qp 20 --partitions b8x8,i4x4 --ref 5 --direct auto --b-pyramid --weightb --mixed-refs --no-fast-pskip --me umh --subme 7 --analyse b8x8,i4x4 --threads $num -o eledream.264 eledream_640x360_128.y4m) 2>&1 | grep real | awk '{print $2}' >> out
				rm eledream.264
			;;
			canneal)
				(time ./valgrind-3.10.0/bin/bin/valgrind --tool=memcheck --leak-check=yes --show-reachable=yes ./parsec-3.0/pkgs/kernels/canneal/inst/amd64-linux.gcc-pthreads/bin/canneal $num 15000 2000 400000.nets 128) 2>&1 | grep real | awk '{print $2}' >> out
			;;
			dedup)
				rm output.dat.ddp
				(time ./valgrind-3.10.0/coregrind/valgrind --tool=memcheck --leak-check=yes --show-reachable=yes ./parsec-3.0/pkgs/kernels/dedup/inst/amd64-linux.gcc-pthreads/bin/dedup -c -p -v -t $num -i media.dat -o output.dat.ddp) 2>&1 | grep real | awk '{print $2}' >> out
				rm output.dat.ddp
			;;
			streamcluster)
				rm output.txt
				(time ./valgrind-3.10.0/coregrind/valgrind --tool=memcheck --leak-check=yes --show-reachable=yes ./parsec-3.0/pkgs/kernels/streamcluster/inst/amd64-linux.gcc-pthreads/bin/streamcluster 10 20 128 16384 16384 1000 none output.txt $num) 2>&1 | grep real | awk '{print $2}' >> out
				rm output.txt
			;;
			ffmpeg)
				rm ./ffmpeg-0.6.3/test.avi
				(time ./valgrind-3.10.0/coregrind/valgrind --tool=memcheck --leak-check=yes --show-reachable=yes ./valgrind-3.10.0/coregrind/valgrind --tool=memcheck --leak-check=yes --show-reachable=yes ./ffmpeg-0.6.3/ffmpeg -threads $num -i ./ffmpeg-0.6.3/out_10.MOV -f avi -vcodec mpeg4 -s pal -aspect 4:3 -qscale 4 -acodec mp2 -ac 1 ./ffmpeg-0.6.3/test.avi) 2>&1 | grep real | awk '{print $2}' >> out
				rm ./ffmpeg-0.6.3/test.avi
			;;
			hmmsearch)
				(time ./valgrind-3.10.0/coregrind/valgrind --tool=memcheck --leak-check=yes --show-reachable=yes ./hmmer-2.3.2/src/hmmsearch  --cpu $num ./hmmer-2.3.2/testsuite/weeviterbi_test.hmm ./hmmer-2.3.2/testsuite/sitchensis.fa) 2>&1 | grep real | awk '{print $2}' >> out
			;;
			pbzip)
				rm ./pbzip2-1.1.12/test.tar*
				cp ./pbzip2-1.1.12/arch.tar ./pbzip2-1.1.12/test.tar
				sync
				(time ./valgrind-3.10.0/coregrind/valgrind --tool=memcheck --leak-check=yes --show-reachable=yes ./pbzip2-1.1.12/pbzip2 -p$num ./pbzip2-1.1.12/test.tar) 2>&1 | grep real | awk '{print $2}' >> out
				rm ./pbzip2-1.1.12/test.tar*
			;;
			esac
			i=$((i+1))
			sync
			sleep 5
		done
	done
}

rm  out
test_times=5
#run facesim
#run ferret
run fluidanimate
#run raytrace
#run x264
run canneal
#run dedup
#run streamcluster
#run ffmpeg
run hmmsearch
run pbzip
