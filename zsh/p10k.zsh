[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# 必须放在开头保证瞬时加载p10k提示符
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi



SET_P10K=true