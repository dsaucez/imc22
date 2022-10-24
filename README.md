# Generate video
## Install `ffmpeg` and `ffprobe`

## Create the PIP with the presentation and the 
`ffmpeg -i camera.mkv -i presentation.mkv -filter_complex "[0]scale=iw/5:ih/5 [pip]; [1][pip] overlay=main_w-overlay_w-10:main_h-overlay_h-10" -profile:v main -level 3.1 -b:v 440k -ar 44100 -ab 128k -s 720x400  -bsf:v h264_mp4toannexb  pip.mp4`

## Concatenate the logo with the presentation video

Given that `logo.ts` and `presentation.ts` are the logo and the presentation videos, respectively:

`ffmpeg -i "concat:logo.ts|presentation.ts" -c copy -c:v libx264 -c:a aac out.m4v -y`

To generate the proper MPEG Transport Stream (MPEG-TS) file (i.e., `.ts`):

`ffmpeg -i file.m4v -c copy -bsf:v h264_mp4toannexb -f mpegts file.ts`
