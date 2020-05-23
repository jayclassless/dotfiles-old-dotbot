# Utilities
shell_is_linux () { [[ "$OSTYPE" == *'linux'* ]] ; }
shell_is_osx () { [[ "$OSTYPE" == *'darwin'* ]] ; }

# History settings
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=500
setopt APPEND_HISTORY EXTENDED_HISTORY HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_DUPS
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A'  up-line-or-beginning-search
bindkey '^[OA'  up-line-or-beginning-search
bindkey '^[[B'  down-line-or-beginning-search
bindkey '^[OB'  down-line-or-beginning-search

# Environment variables
EDITOR=vim
PAGER=less
PYTHONSTARTUP=$HOME/.python/startup
PIP_REQUIRE_VIRTUALENV=true

unsetopt beep
bindkey -e

# Completions
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi
autoload -Uz compinit
compinit

# Color support
CLICOLOR=1
if shell_is_osx; then
    alias ls='ls -G'
else
    alias ls='ls --color=auto'
fi
alias grep='grep --color=auto'

# Prompt
setopt prompt_subst
PROMPT="%F{blue}%n%F{cyan}@%F{blue}%m%F{white}%#%f "
RPROMPT="%F{green}%~%f"
if type vcsinfo &>/dev/null; then
    VCSPROMPT='%F{yellow}$(vcsinfo)%f'
    RPROMPT="$RPROMPT $VCSPROMPT"
fi

# Give a heads up if there are screens running.
if type screen &>/dev/null; then
    sc=`screen -list | grep "No Sockets"`
    if [ -z "$sc" ]; then
        screen -list
    fi
    unset sc
fi
# Give a heads up if there are tmux sessions running.
if type tmux &>/dev/null; then
    tmux list-sessions 2>/dev/null
fi

# Keep a predictably-named alias available for our SSH agent
SOCK="/tmp/ssh-agent-$USER-screen"
if test $SSH_AUTH_SOCK && [ $SSH_AUTH_SOCK != $SOCK ]; then
    rm -f $SOCK
    ln -sf $SSH_AUTH_SOCK $SOCK
    export SSH_AUTH_SOCK=$SOCK
fi

# Aliases.
alias l='ls -laF'
alias lw='ls -CaF'
alias gpip='PIP_REQUIRE_VIRTUALENV="" pip "$@"'

# Enable pyenv if it's around.
if type pyenv &>/dev/null; then
    export PYENV_ROOT=/usr/local/var/pyenv
    eval "$(pyenv init -)"
fi

# Enable direnv if it's around.
if type direnv &>/dev/null; then
    eval "$(direnv hook zsh)"
fi

# Bring in a local zsh configuration.
if [ -f $HOME/.zshrc_local ]; then
    . $HOME/.zshrc_local
fi

