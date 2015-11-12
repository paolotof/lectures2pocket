#!/bin/bash

#chmod u+x xtractSndAddId3v2Tags.sh
# could give info contained in the mp4/mov file
# mplayer -vo null -ao null -identify -frames 0 http://example.com/myvideo.mkv
# ffprobe file2read.avi

# cd /mnt/disk2/courseraDownloads/coursera/audio-002/
cd /Users/laptopKno/Downloads/statisticalLearning/

counter=0

# for directory in $(ls -d */)
# do
#     chapter=${directory/%/}
#     echo $chapter
    rm *.mp3 # remove all previous attempts
    for files in *.m*
    do
      	let counter=counter+1
      	fileName=${files#0*//}
      	echo $fileName
        if [[ $fileName == *mp4 ]];
        then
          file1="${fileName/%.mp4}.wav";
        else
          file1="${fileName/%.mov}.wav";
        fi

      	echo "extracting sound file" $fileName;
#      	mplayer -ao pcm:fast:file=$file1 -vo null -vc null -ni $files;
# # resample and make mono, to make wav file smaller
        mplayer -ao pcm:fast:waveheader:file=$file1 -af resample=22050,pan=1:0.5:0.5 -vo null -vc null -ni $files;
      	echo "increase volume"
#        sox $file1 out.wav compand 0.3,1 6:-70,-60,-20 -5 -90 0.2
        sox $file1 out1.wav compand 0.3,1 6:-70,-60,-20 -5 -90 0.2
      	# optimize audio for head phone play
      	#	sox out.wav $file1 earwax // works only with stereo sound @ 44.1 K
        # sox make stereo, change sample rate, fade-in, nomalize, and stores the result at a bit-depth of 16. −b 16 does not work
        # sox out1.wav -b 16 out.wav channels 2 rate 16k fade 3 norm
        sox out1.wav out.wav channels 2 rate 16k fade 3 norm
      	# simplify file name
        if [[ $fileName == *mp4 ]];
        then
          title="${fileName/%.mp4}";
        else
          title="${fileName/%.mov}";
        fi
      	title=${title/[0-9][0-9][_]};
      	weekNum=`expr "$title" : '\([0-9]\)'`;
      	title=${title/[0-9].};
      	str=`expr "$title" : '\([0-9]\)'`;
      	title=${title/[0-9][_]};
      	file2="$title.mp3"; # id3v2 tags seem not to work with ogg files
      	echo "downsample and increase speed"
      	sox out.wav $file2 rate 8000 tempo -s 1.25 # process speech at 1.65 = 65% faster

        rm -f out.wav;
        rm -f out1.wav;
      	rm -f $file1;

      	echo "assign id3v2 tag"

      	case $OSTYPE in
          linux*)
            echo "I am on a " $OSTYPE
            id3v2 -D $file2;
            id3v2 --TIT1 "ASPMA course" $file2;
            id3v2 --TIT2 "Chapter $weekNum" $file2;
            id3v2 --TIT3 "$title" $file2;
            id3v2 -a "Xavier Serra" $file2;
            id3v2 -y "2015" $file2;
            id3v2 --TRCK $counter $file2;
            id3v2 --TALB "Audio Signal Processing for Music Applications" $file2;
            ;;
          darwin*)
            echo "I am a Mac : $OSTYPE"
            # you need id3tag -h to check for how to use
            id3tag -A"Statistical Learning" $file2;
            id3tag -c"Chapter $weekNum" $file2;
            id3tag -s"$title" $file2;
            id3tag -a"Trevor" $file2;
            id3tag -y"2015" $file2;
            id3tag -t$counter $file2;
            ;;
          *) echo "unknown: $OSTYPE" ;;
        esac
      	# if [[ $OSTYPE == darwin* ]];
      	# then echo I am a Mac;
        # fi
      	# homebrew install
      	# homebrew update -v
      	# homebrew upgrade
      	# homebrew install mplayer
      	# homebrew install id3lib
      	# id3info
      	# id3tag
      	# id3cp
      	# id3convert

    done

# done
