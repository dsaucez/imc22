# Generate video
## Install `ffmpeg` and `ffprobe`

## Create the PIP with the presentation and the 
`./ffmpeg-scripts/ffmpeg-scripts/overlay-pip -i slides.mp4 -v camera.mp4  -p 0 -x br -w 128 -o pip.mp4`

## Concatenate the logo with the presentation video

Given that `logo.ts` and `presentation.ts` are the logo and the presentation videos, respectively:

`ffmpeg -i "concat:logo.ts|presentation.ts" -c copy -c:v libx264 -c:a aac out.m4v -y`

To generate the proper MPEG Transport Stream (MPEG-TS) file (i.e., `.ts`):

`ffmpeg -i file.m4v -c copy -bsf:v h264_mp4toannexb -f mpegts file.ts`
