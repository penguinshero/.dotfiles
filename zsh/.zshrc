# shell options
setopt autocd interactivecomments magicequalsubst nonomatch notify
setopt numericglobsort promptsubst autopushd pushdminus pushdignoredups
setopt pushdsilent extendedglob

WORDCHARS='_-'
PROMPT_EOL_MARK=""

# disable XON/XOFF so ctrl+s is free for kitty prefix
stty -ixon


# history
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=5000
setopt hist_expire_dups_first hist_ignore_dups hist_ignore_all_dups
setopt hist_save_no_dups hist_find_no_dups hist_ignore_space
setopt hist_verify hist_reduce_blanks share_history inc_append_history

alias history="history 0"


# completion
autoload -Uz compinit

_ZCOMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zcompdump"
if [[ -n $_ZCOMPDUMP(#qN.mh+24) ]]; then
    compinit -d "$_ZCOMPDUMP"
else
    compinit -C -d "$_ZCOMPDUMP"
fi

mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/completion"

zstyle ':completion:*:*:*:*:*'            menu select
zstyle ':completion:*'                    matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*'                    rehash true
zstyle ':completion:*'                    use-cache on
zstyle ':completion:*'                    cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/completion"
zstyle ':completion:*'                    list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:kill:*'             command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'


# colors
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    export LS_COLORS="$LS_COLORS:ow=30;44:"
fi

LS_COLORS="di=38;2;0;95;175"
export LS_COLORS


# autosuggestions
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'
    ZSH_AUTOSUGGEST_USE_ASYNC=1
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    bindkey '^ ' autosuggest-accept
fi


# fzf
export FZF_DEFAULT_OPTS="
    --height=40%
    --layout=reverse
    --border=rounded
    --prompt='❯ '
    --pointer='▶'
    --marker='✓'
    --color=bg+:#1C1C1C,bg:#111111,spinner:#46D9FF,hl:#FF6C6B
    --color=fg:#D0D0D0,header:#4C4C4C,info:#ECBE7B,pointer:#46D9FF
    --color=marker:#98BE65,fg+:#FFFFFF,prompt:#C678DD,hl+:#FF6C6B
"

export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fdfind --type d --hidden --follow --exclude .git'
export FZF_CTRL_T_OPTS="--preview 'batcat --color=always --style=numbers --line-range=:200 {}' --preview-window=right:50%"
export FZF_ALT_C_OPTS="--preview 'eza --tree --icons --color=always {} | head -50' --preview-window=right:50%"

source <(fzf --zsh)


# zoxide — replaces cd via frecency matching
eval "$(zoxide init zsh --cmd cd)"


# bat
export BAT_THEME="base16"
alias bat='batcat'
alias cat='batcat --paging=never'


# eza
alias ls='eza --icons --group-directories-first'
alias ll='eza -lh --icons --group-directories-first --git'
alias la='eza -lah --icons --group-directories-first --git'
alias l='eza --icons'
alias tree='eza --tree --icons'


# ripgrep
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"


# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias mkdir='mkdir -pv'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'


# zsh config
alias zload='source ~/.zshrc'
alias zedit='nvim ~/.zshrc'


# xdg-open — quick file/url opener (background, silent)
open() { xdg-open "$@" &>/dev/null & }


# zen — zsh extension node
zen() {
    local profile_dir="$HOME/.dotfiles/zen"
    local cmd="${1:-}"

    case "$cmd" in

        list)
            echo "profiles:"
            for f in ${profile_dir}/*; do
                [[ -f "$f" ]] || continue
                local name="${f:t}"
                if typeset -f "__zen_unload_${name}" > /dev/null 2>&1; then
                    echo "  • $name (loaded)"
                else
                    echo "  • $name"
                fi
            done
            ;;

        load)
            local profile="$2"
            if [[ -z "$profile" ]]; then
                echo "usage: zen load <profile>"
                return 1
            fi

            local file="$profile_dir/${profile}"
            if [[ ! -f "$file" ]]; then
                echo "[-] profile not found: $profile"
                return 1
            fi

            if typeset -f "__zen_unload_${profile}" > /dev/null 2>&1; then
                echo "[*] already loaded: $profile"
                return 0
            fi

            source "$file"
            echo "[+] loaded: $profile"
            ;;

        unload)
            local profile="$2"
            if [[ -z "$profile" ]]; then
                echo "usage: zen unload <profile>"
                return 1
            fi

            if ! typeset -f "__zen_unload_${profile}" > /dev/null 2>&1; then
                echo "[-] not loaded: $profile"
                return 1
            fi

            "__zen_unload_${profile}"
            unfunction "__zen_unload_${profile}"
            echo "[-] unloaded: $profile"
            ;;

        *)
            echo "zen — Zsh Extension Node"
            echo ""
            echo "usage:"
            echo "  zen list              list all profiles"
            echo "  zen load <profile>    load a profile"
            echo "  zen unload <profile>  unload a profile"
            ;;
    esac
}


# package management
alias sysup='sudo apt update && sudo apt upgrade'
alias pkgi='sudo apt install -y'
alias pkgs='sudo apt show'
alias pkgsr='sudo apt search'
alias pkgr='sudo apt purge'
alias pkgfix='sudo apt --fix-broken install'
alias pkgclean='sudo apt autoremove -y && sudo apt autoclean'


# kitty
kreload() { pkill -SIGUSR1 kitty && echo "kitty config reloaded"; }


# clipboard — usage: clip < file.txt  OR  cat file.txt | clip
clip() {
    if [ -t 0 ]; then
        wl-copy "$@"
    else
        wl-copy
    fi
}


# python venv — activates project venv
pyactive() { source "$HOME/Public/python/.venv/bin/activate"; }


# filesystem — tree view
t() {
    local depth=1
    local files_only=false

    [[ "$1" =~ ^[0-9]+$ ]] && depth="$1"
    [[ "$1" == "f" || "$2" == "f" ]] && files_only=true

    if $files_only; then
        tree -L "$depth"
    else
        tree -L "$depth" -d
    fi
}


# go
goclean() {
    echo -n "clear all go module cache? [y/N] "
    read -r ans
    [[ "$ans" =~ ^[Yy]$ ]] && go clean -modcache && echo "module cache cleared" || echo "aborted"
}


# print specific line or range — usage: cmd | line 5  OR  cmd | line 3-7  OR  cmd | line 8,9,10
line() {
    if [ -z "$1" ]; then
        wc -l
        return
    fi
    if [[ "$1" == *-* ]]; then
        local start=$(echo "$1" | cut -d- -f1)
        local end=$(echo "$1" | cut -d- -f2)
        sed -n "${start},${end}p"
    elif [[ "$1" == *,* ]]; then
        local script=""
        for n in ${(s:,:)1}; do
            script+="${n}p;"
        done
        sed -n "$script"
    else
        sed -n "${1}p"
    fi
}


# pick columns from output — usage: cmd | pick 1 3  OR  cmd | pick -d: 1 2  OR  cmd | pick 1-3
pick() {
    local delim='[[:space:]]+'
    local cols=""
    local ofs=" "
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -d) delim="$2"; shift 2 ;;
            -o) ofs="$2";   shift 2 ;;
            *)  cols="$1";  shift   ;;
        esac
    done
    if [[ -z "$cols" ]]; then
        echo "usage: pick [-d delim] [-o output_delim] cols"
        return 1
    fi
    awk -F"$delim" -v cols="$cols" -v OFS="$ofs" '
    BEGIN { n = split(cols, c, ",") }
    {
        out = ""
        for (i = 1; i <= n; i++) {
            if (c[i] ~ /^[0-9]+-[0-9]+$/) {
                split(c[i], r, "-")
                for (j = r[1]; j <= r[2]; j++)
                    out = out (out ? OFS : "") $j
            } else {
                idx = c[i]
                if (idx < 0) idx = NF + idx + 1
                out = out (out ? OFS : "") $(idx)
            }
        }
        print out
    }'
}


# system utils — process kill, disk usage, listening ports
killp() {
    local pid
    pid=$(ps -ef | sed 1d | fzf -m --header='select process to kill' | awk '{print $2}')
    [[ -n "$pid" ]] && echo "$pid" | xargs kill -9
}


# disk usage — show total size of a file or directory
sizeof() { du -sh "${1:-.}" }


# network ports — list listening and bound TCP/UDP sockets with process info
listen() { ss -tunlp | awk 'NR==1 || /LISTEN|UNCONN/' | pick 1,5,7 }


# environment
export GOPATH="$HOME/Public/go"
export GOBIN="$GOPATH/bin"
export PATH="$PATH:$GOBIN"


# prompt
setopt PROMPT_SUBST
PROMPT='%F{red}╭─[%f%F{cyan}penguinshero%f%F{red}]─[%f%F{yellow}%~%f%F{red}]%f
%F{red}╰─%f%F{green}❯%f '
