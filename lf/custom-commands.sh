#!/usr/bin/env bash

# Interactive menu for opening files with appropriate applications
cmd menu-open ${{
    current_file="$f"
    
    if [ -z "$current_file" ]; then
        lf -remote "send $id echo No file under cursor"
        exit 1
    fi

    # Determine file type
    if [ -d "$current_file" ]; then
        file_type="folder"
    else
        mime=$(file --mime-type "$(readlink -f "$current_file")" -b)
        case $mime in
            text/*|application/json|inode/x-empty|application/octet-stream)
                file_type="text"
                ;;
            image/*)
                file_type="image"
                ;;
            video/*|application/octet-stream)
                file_type="video"
                ;;
            audio/*)
                file_type="audio"
                ;;
            application/zip|application/gzip|application/x-bzip|application/x-bzip2|application/x-tar|application/x-7z-compressed|application/x-rar)
                file_type="archive"
                ;;
            application/pdf|application/epub+zip|application/x-mobipocket-ebook)
                file_type="document"
                ;;
            *)
                file_type="fallback"
                ;;
        esac
    fi

    # Define applications for each file type
    case $file_type in
        folder)
            apps=("neovim" "vscode" "zed" "lazygit" "archive")
            ;;
        archive)
            apps=("ouch decompress")
            ;;
        text)
            apps=("neovim" "vscode" "zed")
            ;;
        image)
            apps=("sxiv" "gthumb")
            ;;
        video)
            apps=("mpv" "convert to gif")
            ;;
        audio)
            apps=("mpv")
            ;;
        document)
            apps=("xdg-open" "okular" "foliate")
            ;;
        *)
            apps=("xdg-open")
            ;;
    esac

    # Use fzf to select application
    selected_app=$(printf "%s\n" "${apps[@]}" | fzf \
        --height 30% \
        --layout=reverse \
        --border rounded \
        --prompt "Open with: " \
        --info=inline \
        --pointer=">" \
        --marker=">")

    if [ -z "$selected_app" ]; then
        lf -remote "send $id echo No app selected"
        exit 1
    fi

    # Execute command based on selected application
    case $selected_app in
        "neovim")
            nvim "$current_file"
            ;;
        "vscode")
            code "$current_file" >/dev/null 2>&1 &
            ;;
        "zed")
            zeditor "$current_file" >/dev/null 2>&1 &
            ;;
        "lazygit")
            fish -c "lazygit -p '$current_file'"
            ;;
        "archive")
            tar --use-compress-program=pigz -cf ~/down/$(basename "$current_file").tar.gz "$current_file" >/dev/null 2>&1 &
            ;;
        "ouch decompress")
            ouch decompress "$current_file" >/dev/null 2>&1 &
            ;;
        "sxiv")
            sxiv -a "$current_file" >/dev/null 2>&1 &
            ;;
        "gthumb")
            gthumb "$current_file" >/dev/null 2>&1 &
            ;;
        "mpv")
            mpv "$current_file" >/dev/null 2>&1 &
            ;;
        "convert to gif")
            ffmpeg -i "$current_file" -vf "fps=10" -loop 0 "$current_file.gif" >/dev/null 2>&1 &
            ;;
        "xdg-open")
            xdg-open "$current_file" >/dev/null 2>&1 &
            ;;
        "okular")
            okular "$current_file" >/dev/null 2>&1 &
            ;;
        "foliate")
            GTK_IM_MODULE=fcitx5 foliate "$current_file" >/dev/null 2>&1 &
            ;;
    esac

    lf -remote "send $id echo Opened $(basename "$current_file") with $selected_app"
}}

# Default file opening behavior based on file type
cmd open &{{
    for f in $fx; do
        if [ -d "$f" ]; then
            # Enter directory (only for first directory)
            lf -remote "send $id cd '$f'"
            break
        else
            mime=$(file --mime-type "$(readlink -f "$f")" -b)
            case $mime in
                text/*|application/json|inode/x-empty|application/octet-stream)
                    # Text files: open all selected text files with neovim
                    lf -remote "send $id \$nvim \$fx"
                    break
                    ;;
                image/*)
                    # Images: open all selected images with sxiv
                    sxiv -a $fx >/dev/null 2>&1 &
                    break
                    ;;
                video/*|application/octet-stream)
                    # Videos: open all selected videos with mpv
                    mpv $fx >/dev/null 2>&1 &
                    break
                    ;;
                audio/*)
                    # Audio: open all selected audio with mpv
                    mpv $fx >/dev/null 2>&1 &
                    break
                    ;;
                application/zip|application/gzip|application/x-bzip|application/x-bzip2|application/x-tar|application/x-7z-compressed|application/x-rar)
                    # Archives: extract each one
                    ouch decompress "$f" >/dev/null 2>&1 &
                    ;;
                application/pdf|application/epub+zip|application/x-mobipocket-ebook)
                    # Documents: open each one
                    xdg-open "$f" >/dev/null 2>&1 &
                    ;;
                *)
                    # Other files: open each one
                    xdg-open "$f" >/dev/null 2>&1 &
                    ;;
            esac
        fi
    done
}}

# Move files to trash with confirmation
cmd trash !{{
    set -f
    printf "Trash $fx? [y/N] "
    read -n 1 ans
    echo
    if [[ $ans == "y" || $ans == "Y" ]]; then
        if command -v trash-put >/dev/null 2>&1; then
            trash-put $fx
            lf -remote "send $id echo Trashed $(echo $fx | wc -w) items"
        elif command -v gio >/dev/null 2>&1; then
            for file in $fx; do
                gio trash "$file"
            done
            lf -remote "send $id echo Trashed $(echo $fx | wc -w) items"
        else
            lf -remote "send $id echo Error: No trash command found"
        fi
    else
        lf -remote "send $id echo Canceled"
    fi
}}

# Selection management
cmd select-all :unselect; invert
cmd unselect-all :unselect

# Bulk file renaming using vidir (requires moreutils package)
cmd bulk-rename ${{
    if [ -n "$fx" ]; then
        file_count=$(echo "$fx" | wc -w)
        
        if [ "$file_count" -eq 1 ]; then
            # Single file: use internal rename of lf
            lf -remote "send $id rename"
        else
            # Multiple files: use vidir
            printf '%s\n' $fx | vidir -
            lf -remote "send $id reload"
        fi
    else
        # No selection: use all files in current directory
        vidir .
        lf -remote "send $id reload"
    fi
}}

# Copy operations
# 复制文件名（仅文件名，不包括路径）
cmd copy-filename ${{
    names="$(echo $fx | tr ' ' '\n' | xargs -I{} basename {})"
    
    # 检测桌面环境并选择合适的剪贴板工具
    if [ -n "$WAYLAND_DISPLAY" ]; then
        # Wayland 环境
        echo "$names" | wl-copy
    elif [ -n "$DISPLAY" ]; then
        # X11 环境
        echo "$names" | xclip -selection clipboard
    else
        # 无图形环境，使用终端剪贴板或显示错误
        echo "$names" | xclip -selection clipboard 2>/dev/null || \
        echo "$names" | wl-copy 2>/dev/null || \
        lf -remote "send $id echo No clipboard tool available"
    fi
    
    lf -remote "send $id echo Copied $(echo "$names" | wc -l) filename(s) to clipboard"
}}

# 复制绝对路径
cmd copy-absolute-path ${{
    # 检测桌面环境并选择合适的剪贴板工具
    if [ -n "$WAYLAND_DISPLAY" ]; then
        echo $fx | tr ' ' '\n' | wl-copy
    elif [ -n "$DISPLAY" ]; then
        echo $fx | tr ' ' '\n' | xclip -selection clipboard
    else
        echo $fx | tr ' ' '\n' | xclip -selection clipboard 2>/dev/null || \
        echo $fx | tr ' ' '\n' | wl-copy 2>/dev/null || \
        lf -remote "send $id echo No clipboard tool available"
    fi
    
    lf -remote "send $id echo Copied $(echo $fx | wc -w) path(s) to clipboard"
}}

# Image selection integration with sxiv
cmd sxiv-select ${{
    current_dir="$PWD"
    sxiv_output=$(sxiv -a -t "$current_dir"/* 2>/dev/null)
    
    if [[ -n "$sxiv_output" ]]; then
        echo "$sxiv_output" | while IFS= read -r line; do
            if [[ "$line" =~ ^jump###(.*) ]]; then
                # Jump mode
                file_path="${BASH_REMATCH[1]}"
                dir=$(dirname "$file_path")
                base=$(basename "$file_path")
                lf -remote "send $id cd \"$dir\""
                lf -remote "send $id select \"$base\""
            elif [[ "$line" =~ ^select###(.*) ]]; then
                # Selection mode
                file_path="${BASH_REMATCH[1]}"
                lf -remote "send $id toggle \"$file_path\""
                lf -remote "send $id select \"$file_path\""
            fi
        done
    else
        lf -remote "send $id echo No output from sxiv"
    fi
}}

# External tools integration
cmd lazygit ${{
    lazygit
}}

cmd fish ${{
    fish
}}

# Zoxide integration for quick directory jumping
cmd zi ${{
    result="$(zoxide query -i | sed 's/\\/\\\\/g;s/"/\\"/g')"
    lf -remote "send $id cd \"$result\""
}}

# Visual mode selection toggle
cmd visual-toggle &{{
    while read -r file; do
        lf -remote "send $id toggle \"$file\""
    done <<< "$fv"
    lf -remote "send $id visual-discard"
}}

# Fuzzy finding commands
cmd fzf-jump ${{
    selected_file=$(fd --type f --hidden --follow --exclude .git . | fzf --prompt '> ')
    
    if [[ -n "$selected_file" ]]; then
        dir=$(dirname "$selected_file")
        base=$(basename "$selected_file")
        lf -remote "send $id cd \"$dir\""
        lf -remote "send $id select \"$base\""
        lf -remote "send $id echo Jumped to $base"
    else
        lf -remote "send $id echo No file selected"
    fi
}}

cmd fzf-rg-jump-with-action ${{
    selected=$(rg --color=always --line-number --no-heading --smart-case . | \
        fzf --ansi \
            --delimiter : \
            --preview 'bat --style=numbers --color=always --highlight-line {2} {1}' \
            --preview-window 'top:60%:+{2}-6' \
            --prompt '> ')

    if [[ -n "$selected" ]]; then
        file_path=$(echo "$selected" | cut -d: -f1)
        line_number=$(echo "$selected" | cut -d: -f2)

        action=$(echo -e "nvim\nhelix\njump" | fzf \
            --height 50% \
            --layout=reverse \
            --border rounded \
            --info=inline \
            --pointer="➤" \
            --marker="✓" \
            --prompt 'Action: ')

        case "$action" in
            "nvim")
                nvim +$line_number "$file_path"
                ;;
            "helix")
                helix +$line_number "$file_path"
                ;;
            "jump"|*)
                dir=$(dirname "$file_path")
                base=$(basename "$file_path")
                lf -remote "send $id cd \"$dir\""
                lf -remote "send $id select \"$base\""
                lf -remote "send $id echo Jumped to $base"
                ;;
        esac
    else
        lf -remote "send $id echo No file selected"
    fi
}}

# Drag and drop functionality
cmd dragx ${{ 
    QT_QPA_PLATFORM=xcb ~/deskenv/archieve/qxdrag/qxdrag.py -x -e -b -p "$f"
}}

cmd dragw ${{ 
    QT_QPA_PLATFORM=wayland ~/deskenv/archieve/qxdrag/qxdrag.py -x -e -b -p "$f"
}}

# File/directory creation
cmd create ${{
    printf "Enter name (end with / for directory): "
    read name
    
    if [ -z "$name" ]; then
        lf -remote "send $id echo Creation canceled"
        exit 1
    fi
    
    if [[ "$name" == */ ]]; then
        # Create directory
        mkdir -p "$name"
        lf -remote "send $id echo Created directory: $name"
    else
        # Create file
        touch "$name"
        lf -remote "send $id echo Created file: $name"
    fi
}}