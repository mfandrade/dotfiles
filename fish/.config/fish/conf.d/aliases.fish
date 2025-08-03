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
    if test (count $argv) -ne 1
        return 3
    end

    set file $argv[1]

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
function tt
    set session unnamed
    if test (count $argv) -gt 0
        set session $argv[1]
    end

    tmux has-session -t "$session" >/dev/null 2>&1
    if test $status -eq 0
        tmux attach-session -t "$session"
    else
        tmux new-session -s "$session"
    end
end

# git
alias g=git
function git_alias_to_shell
    set lines (git config --get-regexp '^alias\.' | sort)

    for line in $lines
        set raw_key (echo $line | cut -d' ' -f1)
        set key (echo $raw_key | sed 's/^alias\.//')
        set value (echo $line | cut -d' ' -f2-)

        if string match -rq '^!' $value
            set shell_cmd (string replace -r '^!' '' $value)
            eval "function g$key; $shell_cmd; end"
        else
            alias g$key="git $value"
        end
    end
end

# asdf
alias apadd='asdf plugin add'
alias aplist='asdf plugin list'
alias aplistall='asdf plugin list all'
function apsearch
    asdf plugin list all | grep $argv
end
alias alist='asdf list'
alias alistall='asdf list all'
function auninstall
    set -l plugin $argv[1]
    if test (count (asdf list $plugin)) -gt 0
        for v in (asdf list $plugin)
            asdf uninstall $plugin $v
        end
    end
end
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
