function __user_host
  set -l content 
  if [ (id -u) = "0" ];
    echo -n (set_color --bold "#CB0000")
  else
    echo -n (set_color "#b6b620")
  end
  echo -n $USER@(hostname|cut -d . -f 1) (set color normal)
end

function __current_path
  echo -n (set_color "#D48E01") (pwd) (set_color normal) 
end

function _git_branch_name
  echo (command git symbolic-ref HEAD 2> /dev/null | sed -e 's|^refs/heads/||')
end

function _git_is_dirty
  echo (command git status -s --ignore-submodules=dirty 2> /dev/null)
end

function __git_status
  if [ (_git_branch_name) ]
    set -l git_branch (_git_branch_name)

    if [ (_git_is_dirty) ]
      set git_info '‹'$git_branch"*"'›'
    else
      set git_info '‹'$git_branch'›'
    end

    echo -n (set_color "#dc8bbf")$git_info (set_color normal) 
  end
end

function __parent_process
  set parent_process (cat /proc/$fish_pid/status | awk '/PPid/{print $2}' | xargs -I {} cat /proc/{}/status | awk '/Name/{print $2}')
  echo -n (set_color "#CB0000")‹$parent_process› (set_color normal)
end

function fish_prompt
  set -l last_status $status

  echo -n (set_color "#D0B78D")"╭─"(set_color normal)
  __user_host
  __current_path
  __git_status
  __parent_process
  echo -e ''
  if [ $last_status != 0 ]
    echo -n (set_color "#D0B78D")"╰─"(set_color --bold "#CB0000")"󰣇 "(set_color normal)
  else
    echo -n (set_color "#D0B78D")"╰─"(set_color --bold "#C4939D")"󰣇 "(set_color normal)
  end
end