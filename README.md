# Generate video
## Install `ffmpeg` and `ffprobe`

# Create the PIP with the presentation and the 
`./ffmpeg-scripts/ffmpeg-scripts/overlay-pip -i slides.mp4 -v camera.mp4  -p 0 -x br -w 128 -o pip.mp4`

# Concatenate the banner with the presentation video
`ffmpeg -f concat -i list.txt -c copy final.mp4`
