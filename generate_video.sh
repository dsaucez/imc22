#!/bin/bash
USAGE="Usage: $0 paper_id"
if [ "$#" == "0" ]; then
        echo "$USAGE"
        exit 1
fi

paper=$1
shift

echo "Preparing paper #$paper"

# 0. create PIP
ffmpeg -i camera.mkv -i presentation.mkv -filter_complex "[0]scale=iw/5:ih/5 [pip]; [1][pip] overlay=main_w-overlay_w-10:main_h-overlay_h-10" -profile:v main -level 3.1 -b:v 440k -ar 44100 -ab 128k -s 1920x1080  -bsf:v h264_mp4toannexb  pip.mp4

# 1. convert input to correct format
ffmpeg -i 'pip.mp4' -c copy -bsf:v h264_mp4toannexb -f mpegts -y presentation.ts

# 2. concatenate logo and presentation
ffmpeg -i "concat:logo.ts|presentation.ts" -c copy -c:v libx264 -c:a aac ${paper}.m4v -y

# 3. clean temporary files
rm pip.mp4
rm presentation.ts
