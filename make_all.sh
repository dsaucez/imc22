#!/bin/bash

# Copyright (c) 2022, Damien Saucez
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its
#    contributors may be used to endorse or promote products derived from
#    this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

_IFS=${IFS}
IFS=$'\n'
threads=15

while getopts 'r:' flag; do
  case "${flag}" in
    r) crop="true" && camera_w=`echo ${OPTARG} | sed 's/\(.*\)x\(.*\)/\1/'` && camera_h=`echo ${OPTARG} | sed 's/\(.*\)x\(.*\)/\2/'` ;;
  esac
done

mkdir -f final

for paper in `ls -1 cam-*.mkv`; do

 paper=`echo "${paper}" | sed 's/cam-\(.*\).mkv/\1/'`

 echo "Generating video for paper #$paper"

 slides="slides-${paper}.mkv"
 camera="cam-${paper}.mkv"
 paper=`echo ${paper} | tr " " "_"`

 if [ -n $crop ]; then
   echo "# crop camera"
   croppedfile=cropped.mkv
   ffmpeg -i ${camera} -filter:v "crop=${camera_w}:${camera_h}:(iw-${camera_w})/2:(ih-${camera_h})/2" -c:a copy -threads $threads -y ${croppedfile}
   camera=$croppedfile
 fi

 echo "# create PIP in mp4 (stereo)"
 ffmpeg -i "${camera}" -i "$slides" -filter_complex "[0:a][0:a]amerge=inputs=2[a]; [0]scale=${camera_w:-iw}/5:${camera_h:-ih}/5 [pip]; [1][pip] overlay=main_w-overlay_w-10:main_h-overlay_h-10" -map "[a]" -profile:v main -level 3.1 -b:v 440k -ar 44100 -ab 128k -s 1920x1080  -bsf:v h264_mp4toannexb -threads $threads -y ${paper}.mp4

 echo "# convert input to correct format"
 ffmpeg -i ${paper}.mp4 -c copy -bsf:v h264_mp4toannexb -f mpegts -threads $threads -y ${paper}.ts

 if [ ! -f "logo.ts" ]; then
   ffmpeg -i logo.m4v -c copy -bsf:v h264_mp4toannexb -f mpegts -threads $threads logo.ts
 fi

 echo "# concatenate logo and presentation"
 ffmpeg -i "concat:logo.ts|${paper}.ts" -c copy -c:v libx264 -c:a aac -threads $threads -y final/${paper}.m4v

 echo "clean temporary files"
 rm $croppedfile
 rm ${paper}.mp4
 rm ${paper}.ts
done
