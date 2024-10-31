.DEFAULT_GOAL:= help
.PHONY: lazyvim lazyvim-clean neovim neovimtools asdf docker basictools sethome

lazyvim: ~/.config/nvim /usr/bin/nvim ##- Setup LazyVim

~/.config/nvim: lazyvim-clean
	git clone https://github.com/LazyVim/starter ~/.config/nvim
	rm -rf ~/.config/nvim/.git

neovim: /usr/bin/nvim ##- Builds Neovim from sources

/usr/bin/nvim: neovimtools ~/src/neovim
	cd ~/src/neovim && \
	git pull && \
	$(MAKE) CMAKE_BUILD_TYPE=Release && \
	cd build && \
	cpack -G DEB && \
	sudo apt-get install ./nvim-linux64.deb; \

~/src/neovim: ~/src
	cd ~/src && git clone https://github.com/neovim/neovim.git

~/src:
	mkdir ~/src

lazyvim-clean: ##- Cleans LazyVim volatile files
	rm -rf ~/.config/nvim
	rm -rf ~/.local/share/nvim
	rm -rf ~/.local/state/nvim
	rm -rf ~/.cache/nvim

asdf: ~/.asdf/bin/asdf ##- Installs ASDF

~/.asdf/bin/asdf: basictools
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.1

docker: basictools /etc/apt/keyrings ##- Install Docker from the convenience script
	curl -fsSL https://get.docker.com | sh

/etc/apt/keyrings:
	sudo ln -s /etc/apt/trusted.gpg.d/ /etc/apt/keyrings/

basictools: ##- Installs the most basic packages
	sudo apt-get install git curl ca-certificates -y

neovimtools: ##- Installs the packages needed to build Neovim
	sudo apt-get install ninja-build gettext cmake unzip curl build-essential -y

sethome: ~/xdg

.ONESHELL:
~/xdg:
	mkdir ~/xdg
	test -d ~/Desktop && mv ~/Desktop ~/xdg
	test -d ~/Downloads && mv ~/Downloads ~/xdg
	test -d ~/Templates && mv ~/Templates ~/xdg
	test -d ~/Documents && mv ~/Documents ~/xdg
	test -d ~/Music && mv ~/Music ~/xdg
	test -d ~/Pictures && mv ~/Pictures ~/xdg
	test -d ~/Videos && mv ~/Videos ~/xdg
	cat <<EOF > ~/.config/user-dirs.dirs
	# This file is written by xdg-user-dirs-update
	# If you want to change or add directories, just edit the line you're
	# interested in. All local changes will be retained on the next run.
	# Format is XDG_xxx_DIR="$HOME/yyy", where yyy is a shell-escaped
	# homedir-relative path, or XDG_xxx_DIR="/yyy", where /yyy is an
	# absolute path. No other format is supported.
	# 
	XDG_DESKTOP_DIR="$$HOME/xdg/Desktop"
	XDG_DOWNLOAD_DIR="$$HOME/xdg/Downloads"
	XDG_TEMPLATES_DIR="$$HOME/xdg/Templates"
	XDG_PUBLICSHARE_DIR="$$HOME/xdg/Public"
	XDG_DOCUMENTS_DIR="$$HOME/xdg/Documents"
	XDG_MUSIC_DIR="$$HOME/xdg/Music"
	XDG_PICTURES_DIR="$$HOME/xdg/Pictures"
	XDG_VIDEOS_DIR="$$HOME/xdg/Videos"
	EOF

help: ##- This message.
	@echo 'USAGE: make <TARGET> [VARNAME=value]'
	@echo
	@echo 'TARGET can be:'
	@sed -e '/#\{2\}-/!d; s/\\$$//; s/:[^#\t]*/\t\t- /; s/#\{2\}- *//' $(MAKEFILE_LIST)
