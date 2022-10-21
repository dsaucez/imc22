#!/bin/bash
USAGE="Usage: $0 paper_id"
if [ "$#" == "0" ]; then
	echo "$USAGE"
	exit 1
fi

paper=$1
shift

echo "Preparing paper #$paper"

# 1. convert input to correct format
ffmpeg -i 'presentation.mkv' -c copy -bsf:v h264_mp4toannexb -f mpegts -y presentation.ts
# 2. concatenate logo and presentation
ffmpeg -i "concat:logo.ts|presentation.ts" -c copy -c:v libx264 -c:a aac ${paper}.m4v -y
# 3. clean temporary files
rm presentation.ts
