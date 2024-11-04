# Estrutura do home
HOMEDIRS = ~/xdg ~/src ~/.local/bin

# Plugins a serem instalados pelo asdf
PLUGINS = neovim/nightly lua/5.1.5 maven/3.9.9 java/latest:oracle nodejs ripgrep fd tree-sitter lazygit

# Regra principal
#all: sethome asdf asdf_installs docker

# Definindo a função xdgdir
define xdgdir
        @mkdir -p ~/xdg/$1 && \
        if [ -d ~/$1 ]; then \
                if [ -z "$$(ls -1A ~/$1)" ]; then \
			rmdir ~/$1; \
		else \
			mv ~/$1 ~/xdg; \
                fi; \
        fi && \
        xdg-user-dirs-update --set $2 ~/xdg/$1
endef

# Criar diretório ~/xdg se não existir
sethome:
	mkdir -p $(HOMEDIRS)
	$(call xdgdir,Desktop,DESKTOP)
	$(call xdgdir,Documents,DOCUMENTS)
	$(call xdgdir,Downloads,DOWNLOAD)
	$(call xdgdir,Music,MUSIC)
	$(call xdgdir,Pictures,PICTURES)
	$(call xdgdir,Public,PUBLICSHARE)
	$(call xdgdir,Videos,VIDEOS)
	if [ -d ~/Desktop ]; then rmdir ~/Desktop; fi
	if [ -d ~/Downloads ]; then rmdir ~/Downloads; fi
	if [ -d ~/Templates ]; then rmdir ~/Templates; fi
	ln -sf ~/xdg/Downloads ~/Inbox
	rm ~/.bash* ~/.profile
	sudo apt-get install zsh -y
	chsh --shell /bin/zsh

asdf: pkgsbasic
	@if [ ! -x ~/.asdf/bin/asdf ]; then \
		test -d ~/.asdf && rm ~/.asdf; \
		git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.1; \
	fi

SHELL := /bin/bash
asdf_installs: asdf pkgsdevel
	@source ~/.asdf/asdf.sh && for plugin_version in $(PLUGINS); do echo ; \
		plugin=$$(echo $$plugin_version | cut -d'/' -f1); \
		version=$$(echo $$plugin_version | cut -d'/' -f2); \
		if [ "$$version" = "$$plugin_version" ]; then \
			version=latest; \
		fi; \
		if ! asdf plugin list | grep -q "$$plugin"; then \
			asdf plugin add "$$plugin"; \
		fi; \
		if [ -f ~/.tool-versions ]; then \
			echo 'File ~/.tool-versions found' ; \
		else \
			asdf uninstall "$$plugin" $(shell asdf current "$$plugin" | awk '{print $2}'); \
			asdf install "$$plugin" "$$version"; \
			asdf global "$$plugin" "$$version"; \
		fi; \
	done

docker: pkgsbasic
	curl -fsSL https://get.docker.com | bash && \
	sudo apt-get install -y uidmap
	dockerd-rootless-setuptool.sh install

pkgsbasic:
	sudo apt-get install -y git curl tar gzip unzip ca-certificates 

pkgsdevel:
	sudo apt-get install -y jq g++ python3 python3-pip xsel linux-headers-$(shell uname -r) build-essential libreadline-dev 

lazyvim: pkgsbasic asdf_installs
	@rm -rf ~/.config/nvim ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim 2>/dev/null
	git clone https://github.com/LazyVim/starter ~/.config/nvim
	rm -rf ~/.config/nvim/.git


.PHONY: all sethome lazyvim asdf asdf_installs docker pkgsbasic pkgsdevel

# TODO: install JetBrains Mono Nerd Font
# https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip
# ~/.local/share/fonts
# JetBrainsMonoNerdFont-Regular.ttf

# TODO: download avatar pictures
# https://avatars.githubusercontent.com/u/24952?v=4
# https://instagram.fbel1-1.fna.fbcdn.net/v/t51.2885-19/434999623_253637291073528_8914023972321892718_n.jpg?stp=dst-jpg_s150x150&_nc_ht=instagram.fbel1-1.fna.fbcdn.net&_nc_cat=100&_nc_ohc=i1Hy2312itwQ7kNvgHP8z5-&_nc_gid=4f00e04161364a9d89a007b36e0f5244&edm=AOQ1c0wBAAAA&ccb=7-5&oh=00_AYAnZey11C2CXi-gZRAWjBxcnrjM9V1U-TOz6Ku8osI2IA&oe=672CDFB9&_nc_sid=8b3546
o

# TODO: alt-tab to switch only on current workspace in gnome
# https://askubuntu.com/a/759740/1888004
# gsettings set org.gnome.shell.app-switcher current-workspace-only true
