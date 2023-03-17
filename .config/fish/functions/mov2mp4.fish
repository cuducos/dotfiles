function mov2mp4
    set -l src $argv
    set -l target (string replace ".mov" ".mp4" $src)
    ffmpeg -i $src -acodec copy -vcodec copy $target
end
