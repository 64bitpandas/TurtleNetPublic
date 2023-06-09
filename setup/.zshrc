# TURTLENET SAMPLE ZSHRC
# Edit all lines to customize your installation.


# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$PATH:$HOME/.local/bin:$HOME/.gem/ruby/2.7.0/bin

#############################
# ZSH CONFIG
#############################

# Path to your oh-my-zsh installation.
export ZSH="/home/turtle/.oh-my-zsh" # TODO: Edit path

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source $ZSH/oh-my-zsh.sh

### ALIASES ###
alias vi='vim'
alias ls='colorls'
alias cat='batcat'
function chpwd() {
  ls
}
alias ga='git add . && git status'
alias gc='git commit -m'
alias gp='git push'
alias gb='git branch'
alias gs='git status'

alias dc='sudo docker-compose'
alias dcr='sudo docker-compose up -d --force-recreate'
alias dcl='sudo docker-compose logs'
alias dk='sudo docker'

alias zedit='vim ~/.zshrc && source ~/.zshrc'
alias zr='source ~/.zshrc'
alias sai='sudo apt install -y'

### LOAD
pfetch