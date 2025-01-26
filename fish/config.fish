if status is-interactive
    # atuin init fish | source
    source ~/.config/fish/conf.d/atuin.fish
    # Commands to run in interactive sessions can go here
end

function fish_greeting
end
set -U fish_color_autosuggestion 'a79e67'
set -U fish_color_command 'D48E01'
set -U fish_color_param 'D1B88E'

alias ls="lsd"
alias ll="lsd -lrt"
alias ys='yay -Sy'
alias yr='yay -R'
alias s='sudo'
alias y='yazi'
alias lg='lazygit'
alias e='exit'
alias FontsFamilyName="fc-query -f '%{family[0]}\n'"

export PATH=:/home/wrq/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/home/wrq/.local/bin:

# add extra PATH
fish_add_path /home/wrq/.nvm/versions/node/v18.14.2/bin
fish_add_path /opt/go/bin
fish_add_path /home/wrq/.cargo/bin

zoxide init fish --cmd j | source

# bind \cj 'nvim'

# 粘贴
# bind \cj 'fish_clipboard_paste'

