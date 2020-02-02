#!/bin/bash

videoFolder=/ram/motion/video
inotifywait -m $videoFolder -e close_write |
    while read path action file; do
        year=${file:0:4}
	month=${file:5:2}
	day=${file:8:2}
	s3File=${file:11:12}
	s3Object=s3://rpicamera1/$year/$month/$day/$s3File
	aws s3 cp $videoFolder/${file} $s3Object
	sudo rm -f $videoFolder/${file}
    done

