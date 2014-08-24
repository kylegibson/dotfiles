HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
COLORTERM=yes
REPORTTIME=10 # print elapsed time when more than 10 seconds

EDITOR=vim
PAGER=less
RSYNC_RSH=/usr/bin/ssh
FIGNORE='.o:.out:~'
DISPLAY=:0.0

# output colored grep
GREP_OPTIONS='--color=auto'
GREP_COLOR='7;31'

JAVA_HOME=$HOME/java
PATH=$HOME/bin:$HOME/node_modules/.bin:$JAVA_HOME/bin:$HOME/.gem/ruby/1.8/bin:$HOME/.rvm/bin:$PATH
LS_COLORS='no=0:fi=0:di=1;34:ln=1;36:pi=40;33:so=1;35:do=1;35:bd=40;33;1:cd=40;33;1:or=40;31;1:ex=1;32:*.tar=1;31:*.tgz=1;31:*.arj=1;31:*.taz=1;31:*.lzh=1;31:*.zip=1;31:*.rar=1;31:*.z=1;31:*.Z=1;31:*.gz=1;31:*.bz2=1;31:*.tbz2=1;31:*.deb=1;31:*.pdf=1;31:*.jpg=1;35:*.jpeg=1;35:*.gif=1;35:*.bmp=1;35:*.pbm=1;35:*.pgm=1;35:*.ppm=1;35:*.pnm=1;35:*.tga=1;35:*.xbm=1;35:*.xpm=1;35:*.tif=1;35:*.tiff=1;35:*.png=1;35:*.mpg=1;35:*.mpeg=1;35:*.mov=1;35:*.avi=1;35:*.wmv=1;35:*.ogg=1;35:*.mp3=1;35:*.mpc=1;35:*.wav=1;35:*.au=1;35:*.swp=1;30:*.pl=36:*.c=36:*.cc=36:*.h=36:*.core=1;33;41:*.gpg=1;33:'
ZLS_COLORS="$LS_COLORS"

export PATH JAVA_HOME GREP_COLOR GREP_OPTIONS TERM EDITOR PAGER
export RSYNC_RSH CVSROOT FIGNORE DISPLAY NNTPSERVER COLORTERM
export HISTFILE HISTSIZE SAVEHIST REPORTTIME LS_COLORS ZLS_COLORS
export PYTHONSTARTUP=$HOME/.pythonrc

# Allow functions in prompt
setopt prompt_subst
# Make cd push the old directory onto the directory stack.
setopt autopushd
# Don’t push multiple copies of the same directory onto the directory stack.
setopt PUSHD_IGNORE_DUPS
# Do not print the directory stack after pushd or popd.
setopt PUSHD_SILENT
# Do not enter command lines into the history list if they are duplicates of
# the previous event.
setopt HIST_IGNORE_DUPS
# Remove command lines from the history list when the first character on the
# line is a space, or when one of the expanded aliases contains a leading
# space.
setopt HIST_IGNORE_SPACE
# N/A
setopt SHARE_HISTORY
# Save each command’s beginning timestamp (in seconds since the epoch) and the
# duration (in seconds) to the history file.
setopt EXTENDED_HISTORY

setopt CORRECT
setopt INTERACTIVE_COMMENTS
# Allow the character sequence '' to signify a single quote within singly
# quoted strings.
setopt RC_QUOTES

# Whenever the user enters a line with history expansion, don’t execute the line
# directly; instead, perform history expansion and reload the line into the
# editing buffer.
setopt HIST_VERIFY

bindkey -v
bindkey -M viins 'zz' vi-cmd-mode
bindkey "^P" history-beginning-search-backward
bindkey "^N" history-beginning-search-forward

. /etc/zsh_command_not_found

fpath=(~/.zsh.d/functions $fpath)

autoload -U colors
autoload -U promptinit
autoload -Uz vcs_info
autoload pstat
autoload unlock
autoload activate
autoload frozen
autoload -U compinit
autoload -U bashcompinit
compinit
bashcompinit
colors
promptinit

PROMPT=$'%{${fg[red]}%}<%{${fg[green]}%}%m%{${fg[red]}%}> %{${fg[cyan]}%}%B%~%b%{${fg[default]}%} %20(l.\n.)%(?..[%?])> '

zstyle ':vcs_info:*' actionformats \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats       \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'

zstyle ':vcs_info:*' enable git

# or use pre_cmd, see man zshcontrib
vcs_info_wrapper() {
  vcs_info
  if [ -n "$vcs_info_msg_0_" ]; then
    echo "%{$fg[grey]%}${vcs_info_msg_0_}%{$reset_color%}$del"
  fi
}
RPROMPT=$'$(vcs_info_wrapper)'

zstyle :compinstall filename $HOME/.zshrc

alias ls='ls --color=always'
alias ll='LANG=C ls -o --group-directories-first'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias g=git
alias gs='g st'
alias gd='g diff'
alias commit='g ci'
alias pull='g pull'
alias stash='g stash'
alias master='g co master'
alias vup='vagrant up dev --no-provision'
alias mv='mv -i'

if [ "$TERM" != "screen" ]; then
    detached=$(screen -ls | grep Detached | cut -f2)
    if [ -n "$detached" ]; then
        screen -r "$detached"
    else
        screen
    fi
else
    function preexec {
      title=$(echo $1 | cut -c1-20)
      echo -ne "\ek$title\e\\"
    }
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # This loads RVM into a shell session.


export PYENV_ROOT="${HOME}/.pyenv"
if [ -d "${PYENV_ROOT}" ]; then
  export PATH="${PYENV_ROOT}/bin:${PATH}"
  eval "$(pyenv init -)"
fi

_nosetests()
{
  cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=($($(which nosecomplete) ${cur} 2>/dev/null))
}
complete -o nospace -F _nosetests nosetests

# Null glob is silent when empty
for F in $HOME/.zsh.d/secrets/*.sh(N); do
  source $F
done
