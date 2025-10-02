function fish_greeting
end
set -U fish_color_autosuggestion 'a79e67'
set -U fish_color_command 'D48E01'
set -U fish_color_param 'D1B88E'

alias so="source ~/tool/proxy.sh"
alias gu="git pull"
alias gp="git push"
alias ls="lsd"
alias ll="lsd -lrt"
alias yay='paru'
alias ys='paru -Sy'
alias yr='paru -R'
alias s='sudo'
alias y='yazi'
alias z='zeditor'
alias lg='lazygit'
alias e='exit'
alias FontsFamilyName="fc-query -f '%{family[0]}\n'"

export PATH=:/home/wrq/.cargo/bin:/home/wrq/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/home/wrq/.local/bin:

# add extra PATH
fish_add_path /home/wrq/.nvm/versions/node/v18.14.2/bin
fish_add_path /opt/go/bin
fish_add_path /home/wrq/.cargo/bin

zoxide init fish --cmd j | source

bind shift-down 'backward-kill-word'

# set -x RUSTUP_UPDATE_ROOT https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup
# set -x RUSTUP_DIST_SERVER https://mirrors.tuna.tsinghua.edu.cn/rustup

# fzf.fish

fzf_configure_bindings  --history="shift-up" \
                        --git_log="alt-I" \
                        --directory="alt-O" \
                        --variables="alt-L" \
                        --process="alt-P" \
                        --git_status=""
