# cat
alias cat='bat -n'

# git
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gca='git commit -a'
alias gcm='git commit -m'
alias gcam='git commit -am'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gst='git status -s'
alias gr='git remote -v'
alias grv='git remote -v'
alias gra='git remote add'
alias gd='git diff'
alias gdc='git diff --cached'

# asdf
alias apa='asdf plugin add'
alias apl='asdf plugin list'
alias apla='asdf plugin list all'
function ailatest
    set -l plugin $argv[1]
    set -l latest latest
    if [ $plugin = java ]
        set latest "latest:openjdk"
    end
    asdf install $plugin $latest && asdf set --home $plugin $latest
end

function sudo
    if test (count $argv) -gt 0
        if test "$argv[1]" = apt -o "$argv[1]" = apt-get
            # Shift the first argument ("apt" or "apt-get") and run with nala
            set -e argv[1]
            command sudo nala $argv
        else
            # Execute the original sudo command
            command sudo $argv
        end
    else
        # If no arguments, just run sudo (this might prompt for help or show usage)
        command sudo
    end
end
