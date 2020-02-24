for i in *.mp4; do ffmpeg -i "$i" -vn "output/${i%.*}.ogg"; done
