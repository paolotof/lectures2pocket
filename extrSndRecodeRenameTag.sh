#!/bin/bash

# chmod u+x script1.sh
# NOTE: bash does not use spaces in the sintax.

cd /home/paolot/gitstuff/coursera/introfinance-008/02_Week_2

shopt -s globstar # enable ** globstar/recursivity
for files in **/*.mp4; do
    [[ -d "$files" ]] && continue # skip directories
    file1="${files/%.mp4}.wav";
    echo "extracting sound file" $files;
    mplayer -ao pcm:fast:file=$file1 -vo null -vc null $files;
    file2="${files/%.mp4}.ogg";
    echo "processing extracted sound stream"
	sox $file1 $file2 rate 8000	tempo -s 1.65 # process speech at 1.65 = 65% faster
    rm -f $file1;

	str=${file2:0:2}
	nmfile="${files/%.mp4}"; # strips extension

	id3v2 -D $file2
	id3v2 -a "Gautam Kaul" $file2
	id3v2 -y "2008" $file2
	id3v2 -A "Chapter 2" $file2
	id3v2 -T $str $file2
	id3v2 -t $nmfile $file2
	id3v2 -s $file2

done
