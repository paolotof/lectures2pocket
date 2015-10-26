#!/bin/bash

# to make executable...
#chmod u+x xtractSndAddId3v2Tags.sh

cd /mnt/disk2/courseraDownloads/coursera/audio-002/

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

	echo "increase volume"
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
	file2="$title.mp3";  
	echo "downsample and increase speed"
	sox out.wav $file2 rate 8000 tempo -s 1.25 # process speech at 1.25 = 25% faster

	rm -f out.wav;
	rm -f $file1;

	echo "assign id3v2 tag"
 	id3v2 -D $file2;
	id3v2 --TIT1 "ASPMA course" $file2;
	id3v2 --TIT2 "Chapter $weekNum" $file2;
	id3v2 --TIT3 "$title" $file2;
	id3v2 -a "Xavier Serra" $file2;
	id3v2 -y "2015" $file2;

	id3v2 --TRCK $counter $file2;
	id3v2 --TALB "Audio Signal Processing for Music Applications" $file2;
    done
    
done    
