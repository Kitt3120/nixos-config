# Check if at least 1 argument is provided
if [ "$#" -lt 1 ]; then
    echo "Usage: davinci-resolve-fix-audio <file/directory> [directory]"
    exit 1
fi

# Variables
FFMPEG_AUDIO_CODEC="flac"
FFMPEG_VIDEO_CODEC="copy"
FFMPEG_VIDEO_CONTAINER="mp4"
FILE_EXTENSION="mp4"
FIND_EXTENSIONS=("mov" "mp4" "mkv" "avi")

SOURCE_PATH="$(realpath "$1")"
if [ ! -e "$SOURCE_PATH" ]; then
    echo "Error: Source path '$SOURCE_PATH' does not exist."
    exit 1
fi

IS_SOURCE_PATH_DIR=false
if [ -d "$SOURCE_PATH" ]; then
    IS_SOURCE_PATH_DIR=true
fi

if [ "$IS_SOURCE_PATH_DIR" = true ] && [[ "$SOURCE_PATH" != */ ]]; then
    SOURCE_PATH="$SOURCE_PATH/"
fi

TARGET_DIR="$SOURCE_PATH"
if [ "$IS_SOURCE_PATH_DIR" = false ]; then
    TARGET_DIR="$(dirname "$SOURCE_PATH")"
fi
if [ "$#" -ge 2 ]; then
    TARGET_DIR="$(realpath "$2")"
fi
if [[ "$TARGET_DIR" != */ ]]; then
    TARGET_DIR="$TARGET_DIR/"
fi
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Target directory '$TARGET_DIR' does not exist."
    exit 1
fi
if [ -f "$TARGET_DIR" ]; then
    echo "Error: Target path '$TARGET_DIR' is a file, not a directory."
    exit 1
fi

# Functions
function process_file {
    local file_path
    file_path="$(realpath "$1")"

    local file_name_without_ext
    file_name_without_ext="$(basename "$file_path")"
    file_name_without_ext="${file_name_without_ext%.*}"
    local target_file_path
    target_file_path="${TARGET_DIR}${file_name_without_ext}.${FILE_EXTENSION}"
    if [ -e "$target_file_path" ]; then
    target_file_path="${TARGET_DIR}${file_name_without_ext}_fixed.${FILE_EXTENSION}"
    fi

    printf "Processing file: %s -> %s " "$file_path" "$target_file_path"
    ffmpeg -i "$file_path" -c:v "${FFMPEG_VIDEO_CODEC}" -c:a "${FFMPEG_AUDIO_CODEC}" "$target_file_path" -hide_banner -loglevel error -n
    local result
    result=$?
    if [ $result -ne 0 ]; then
    printf "\r[FAIL] Failed to process file: %s\n" "$file_path"
    else
    printf "\r[OK] Processed file: %s -> %s\n" "$file_path" "$target_file_path"
    fi
}

function process_directory {
    local dir_path
    dir_path="$(realpath "$1")"

    local find_command
    find_command=("find" "$dir_path" -type f \( )
    local first
    first=true
    for ext in "${FIND_EXTENSIONS[@]}"; do
    if [ "$first" = true ]; then
        first=false
    else
        find_command+=(-o)
    fi
    find_command+=(-iname "*.$ext")
    done
    find_command+=(\) )

    # First collect files, then process them to avoid issues because of the \r used in process_file
    local files
    files=()
    while IFS= read -r -d "" file; do
    files+=("$file")
    done < <("${find_command[@]}" -print0)

    for file in "${files[@]}"; do
    process_file "$file"
    done
}

echo "Video codec: $FFMPEG_VIDEO_CODEC, Audio codec: $FFMPEG_AUDIO_CODEC, Container: $FFMPEG_VIDEO_CONTAINER"
if [ "$IS_SOURCE_PATH_DIR" = true ]; then
    process_directory "$SOURCE_PATH"
else
    process_file "$SOURCE_PATH"
fi