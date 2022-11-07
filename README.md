# Generate video
## Install `ffmpeg` and `ffprobe`

## Create the PIP with the presentation and the 
`ffmpeg -i camera.mkv -i presentation.mkv -filter_complex "[0]scale=iw/5:ih/5 [pip]; [1][pip] overlay=main_w-overlay_w-10:main_h-overlay_h-10" -profile:v main -level 3.1 -b:v 440k -ar 44100 -ab 128k -s 720x400  -bsf:v h264_mp4toannexb  pip.mp4`

## Concatenate the logo with the presentation video

Given that `logo.ts` and `presentation.ts` are the logo and the presentation videos, respectively:

`ffmpeg -i "concat:logo.ts|presentation.ts" -c copy -c:v libx264 -c:a aac out.m4v -y`

To generate the proper MPEG Transport Stream (MPEG-TS) file (i.e., `.ts`):

`ffmpeg -i file.m4v -c copy -bsf:v h264_mp4toannexb -f mpegts file.ts`

# Use the script to generate videos
The `generate_video.sh` script automatically generate video files for papers. It generates `<paper-id>.m4v` where `paper-id` is the id of the paper.

It takes the following parameters:

* c       : include camera feed in the video
* f string: presentation video filename
* p int   : paper id

The paper id must be specified. If no video filename is provided, the presentation feed will be taken from `<paper-id>-presentation.mkv` otherwise it is taken diretly from the provided filename. The camera feed is always taken from `<paper-id>-camera.mkv`.

## Examples of call
Generate slides only video in `666.m4v` from `666-presentation.mkv`
```bash
sh generate_video.sh -p 666
```

Generate slides with picture in picture camera in `666.m4v` from `666-presentation.mkv` and `666-camera.mkv`
```bash
sh generate_video.sh -p 666 -c
```

Generate slides only video in `381.m4v` from `381-presentation.mpeg`
```bash
sh generate_video.sh -p 666 -f 381-presentation.mpeg
```

Generate slides with picture in picture camera in `381.m4v` from `381-presentation.mpeg` and `381-camera.mkv`
```bash
sh generate_video.sh -p 666 -f 381-presentation.mpeg
```
## Generate IMC'22 videos
in the directory with the videos:

```bash
sh make_all.sh -r "1440x1080"
```
