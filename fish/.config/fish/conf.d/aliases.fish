# cat
alias cat='bat -n'

# bak
function bak
    if test (count $argv) -ne 1
        return 1
    end

    set original $argv[1]
    set backup "$original.bak"

    cp -iv $original $backup
end


# xsel
function ctrlc
    set -l file $argv[1]

    if not count $argv >/dev/null
        return 3
    end

    if not test -f "$file"
        return 2
    end

    if file -bL --mime "$file" | grep -q 'binary$'
        return 1
    end

    xsel --clipboard <"$file"
end

# git
alias g=git
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
alias apadd='asdf plugin add'
alias aplist='asdf plugin list'
alias aplistall='asdf plugin list all'
function alatest
    set -l plugin $argv[1]
    set -l latest latest
    if [ $plugin = java ]
        set latest "latest:openjdk"
    end
    asdf install $plugin $latest && asdf set --home $plugin $latest
end

# nala
function sudo
    if test (count $argv) -gt 0
        if test "$argv[1]" = apt -o "$argv[1]" = apt-get
            set -e argv[1]
            command sudo nala $argv
        else
            command sudo $argv
        end
    else
        command sudo
    end
end
