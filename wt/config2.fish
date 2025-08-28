# Location of this is https://snips.sh/f/leQYOwBiIc
# You will call i for writing wih this code
# curl https://snips.sh/f/leQYOwBiIc > ~/.config/fish/config.fish
starship init fish | source
starship preset pure-preset > ~/.config/starship.toml
# --- This section is for fish --- #

# eza
alias e="eza -lahHo --git --git-repos --icons --color-scale --color-scale-mode=gradient --color=always --group-directories-first --time-style=long-iso --total-size"

# Command Aliases
alias fzf="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"

# Github aliases
alias gl="git log --oneline --decorate --graph"
alias gp="git add . && git commit && git push"
alias gb="git branch -a"
alias gsb="gb && git switch"
alias gpp="git add . && git commit --allow-empty --allow-empty-message && git push --progress"
alias pd="pnpm run dev --turbo"
alias gor="go run"

# bash Shell 
eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)

