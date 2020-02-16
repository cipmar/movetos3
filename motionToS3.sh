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

	if [ $? = 0 ]; then
		echo [$(date)] "file successfully copied to S3: ${file}"
		sudo rm -f $videoFolder/${file}
		echo [$(data)] "file successfully deleted: ${file}"
	else
		echo [$(data)] "copy to S3 failed: ${file}"
	fi
    done
