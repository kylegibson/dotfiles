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

export GREP_COLOR GREP_OPTIONS TERM EDITOR PAGER RSYNC_RSH CVSROOT FIGNORE DISPLAY NNTPSERVER COLORTERM PATH HISTFILE HISTSIZE SAVEHIST REPORTTIME

setopt promptsubst
setopt autocd autopushd pushdignoredups
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HISTVERIFY

bindkey -v
bindkey -M viins 'jj' vi-cmd-mode

autoload -U promptinit && promptinit
# use the walters prompt as a default from the built ins
# to view others use: prompt <tab>
prompt clint

zstyle :compinstall filename '/home/kyle/.zshrc'

LS_COLORS='no=0:fi=0:di=1;34:ln=1;36:pi=40;33:so=1;35:do=1;35:bd=40;33;1:cd=40;33;1:or=40;31;1:ex=1;32:*.tar=1;31:*.tgz=1;31:*.arj=1;31:*.taz=1;31:*.lzh=1;31:*.zip=1;31:*.rar=1;31:*.z=1;31:*.Z=1;31:*.gz=1;31:*.bz2=1;31:*.tbz2=1;31:*.deb=1;31:*.pdf=1;31:*.jpg=1;35:*.jpeg=1;35:*.gif=1;35:*.bmp=1;35:*.pbm=1;35:*.pgm=1;35:*.ppm=1;35:*.pnm=1;35:*.tga=1;35:*.xbm=1;35:*.xpm=1;35:*.tif=1;35:*.tiff=1;35:*.png=1;35:*.mpg=1;35:*.mpeg=1;35:*.mov=1;35:*.avi=1;35:*.wmv=1;35:*.ogg=1;35:*.mp3=1;35:*.mpc=1;35:*.wav=1;35:*.au=1;35:*.swp=1;30:*.pl=36:*.c=36:*.cc=36:*.h=36:*.core=1;33;41:*.gpg=1;33:'
ZLS_COLORS="$LS_COLORS"

alias ls='ls --color=always'
alias ll='ls -l'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

autoload -Uz compinit
compinit

bindkey "^P" history-beginning-search-backward
bindkey "^N" history-beginning-search-forward

#insert_sudo     () { zle beginning-of-line; zle -U "sudo "         }
#insert_apt      () { zle beginning-of-line; zle -U "sudo apt-get " }
#insert_install  () { zle -U "install "     }

#zle -N insert-sudo      insert_sudo
#zle -N insert-apt       insert_apt
#zle -N insert-install   insert_install

#bindkey "^N" insert-install
#bindkey "^k" insert-sudo
#bindkey "^a" insert-apt

[[ -s $HOME/.pythonbrew/etc/bashrc ]] && source $HOME/.pythonbrew/etc/bashrc
alias ll='LANG=C ls -o --group-directories-first'
export JAVA_HOME=$HOME/java
export PATH=~/bin:$JAVA_HOME/bin:/home/kyle/.gem/ruby/1.8/bin:$PATH
pstat() {
  . $HOME/PolicyStat.env/bin/activate
  pushd $HOME/PolicyStat
  export DJANGO_SETTINGS_MODULE=pstat.settings
  export PYTHONPATH=$(pwd):$(pwd)/pstat:$PYTHONPATH
  ssh-add $HOME/vault/policystat/keys/*.key
  da() {
    pushd $HOME/PolicyStat/pstat
    django-admin.py $@
    popd
  }
  rs() {
    da runserver 0.0.0.0:8000 $@
  }
  resetdb() {
    mv $HOME/policystat.db{,-$(date +%s)}
    migrate && $HOME/PolicyStat/scripts/load_testing_fixtures.py
  }
  migrate() {
    da syncdb --migrate --noinput
  }
  rt() {
    rm -f $HOME/policystat.test.db
    pushd $HOME/PolicyStat
    #if [ -e "$1" ]; then
        # echo pstat/core/implementation/tests/test_upload.py | sed -e 's@/@.@g' -e 's@\.py@@g'
    #fi
    ./scripts/run_tests.py $@
    popd
  }
  selenium() {
    pushd $HOME/PolicyStat
    ./scripts/run_selenium_tests.py $@
    popd
  }
  workoff() {
    popd
    deactivate
    unset da rt rs
    ssh-add -D
  }
}
alias git=hub

function zle-line-init zle-keymap-select {
    RPS1="${${KEYMAP/vicmd/-- COMMAND --}/(main|viins)/-- INSERT --}"
    RPS2=$RPS1
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
