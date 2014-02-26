autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

git_dirty() {
  git_info=""
  st=$(/usr/bin/git status 2>/dev/null | tail -n 1)
  if [[ $st == "" ]]
  then
    echo ${git_info}
  else
    git_info+="\u00B1 "
    if [[ $st =~ ^nothing ]]
    then
      git_info+="on %{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%}"
    else
      git_info+="on %{$fg_bold[red]%}$(git_prompt_info)%{$reset_color%}"
    fi
	git_info+=$(need_push)
	echo ${git_info}
  fi
}

git_prompt_info () {
 ref=$(/usr/bin/git symbolic-ref HEAD 2>/dev/null) || return
 echo "${ref#refs/heads/}"
}

unpushed () {
  /usr/bin/git cherry -v @{upstream} 2>/dev/null
}

need_push () {
  if [[ $(unpushed) == "" ]]
  then
    echo " "
  else
    echo " with %{$fg_bold[magenta]%}unpushed%{$reset_color%} "
  fi
}

rvm_prompt(){
  if $(which rvm &> /dev/null)
  then
	  echo "%{$fg_bold[yellow]%}| $(rvm tools identifier)%{$reset_color%}"
	else
	  echo ""
  fi
}

directory_name(){
  echo "%{$fg_bold[cyan]%}$(pwd | sed -e "s,^$HOME,~,")/%{$reset_color%}"
}

curtime() {
  echo "%{$fg_bold[blue]%}[%*]%{$reset_color%}"
}

whonwhere() {
  echo "%{$fg_bold[green]%}%n%{$reset_color%}@%m"
}

export PROMPT=$'\n$(curtime) $(whonwhere):$(directory_name) $(git_dirty)$(rvm_prompt)\n\u2318 > '

