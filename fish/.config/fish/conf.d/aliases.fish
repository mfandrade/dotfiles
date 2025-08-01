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

    if not count $argv >/dev/null
        return 3
    end

    set -l file $argv[1]

    if not test -f "$file"
        return 2
    end

    if file -bL --mime "$file" | grep -q 'binary$'
        return 1
    end

    xsel --clipboard <"$file"
end

# tmux
alias tn='tmux new-session'
alias tl='tmux list-sessions'
alias ta='tmux attach-session'

# git
alias g=git

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
