#!/bin/bash

#chmod u+x xtractSndAddId3v2Tags.sh

cd /home/paolot/gitstuff/coursera/introfinance-008/

counter=0

for directory in $(ls -d */)
do
    chapter=${directory/%/}
    echo $chapter
    for files in $directory/*.mp4
    do
	let counter=counter+1
	fileName=${files#0*//}
	echo $fileName
	file1="${fileName/%.mp4}.wav";
	echo "extracting sound file" $fileName;
 	mplayer -ao pcm:fast:file=$file1 -vo null -vc null -ni $files;
	echo "processing extracted sound stream"
	# increase volume
  	sox $file1 out.wav compand 0.3,1 6:-70,-60,-20 -5 -90 0.2
	# optimize audio for head phone play
	#	sox out.wav $file1 earwax
	
	# simplify file name
	title="${fileName/%.mp4}";
	title=${title/[0-9][0-9][_]}; 
	weekNum=`expr "$title" : '\([0-9]\)'`;
	title=${title/[0-9].};
	str=`expr "$title" : '\([0-9]\)'`;
	title=${title/[0-9][_]};
	#file2="$title.ogg";
	file2="$title.mp3"; # id3v2 tags seem not to work with ogg files 
 	sox out.wav $file2 rate 8000 tempo -s 1.65 # process speech at 1.65 = 65% faster
	
	rm -f out.wav;
	rm -f $file1;

	echo "assign id3v2 tag"
 	id3v2 -D $file2;
#  	id3v2 -2 $file2; # write only id3v2 tag
 	id3v2 --TIT1 "Intro to finance" $file2;
 	id3v2 --TIT2 "$title/Chapter $weekNum" $file2;
 	id3v2 -a "Gautam Kaul" $file2;
 	id3v2 -y "2008" $file2;
# 
#	id3v2 -T $str $file2;
	id3v2 -T $counter $file2;
 	id3v2 -A "week $weekNum" $file2;
# 	echo $counter
    done
    
done    
