if [[ -n $SET_P10K ]];then
    zinit ice depth=1; zinit light romkatv/powerlevel10k 
fi

zinit light zsh-users/zsh-autosuggestions  
zinit light zsh-users/zsh-completions
zinit light Aloxaf/fzf-tab  
zinit light zsh-users/zsh-syntax-highlighting 
# zinit light edte/zsh-autocomplete 


autoload -U compinit && compinit