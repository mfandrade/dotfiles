# Estrutura do home
HOMEDIRS = ~/xdg ~/src ~/.local/bin

# Plugins a serem instalados pelo asdf
PLUGINS = neovim/nightly lua/5.1.5 maven/3.9.9 java/latest:oracle nodejs ripgrep fd tree-sitter lazygit

# Regra principal
all: sethome asdf asdf_installs docker

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
	ln -sf ~/xdg/Downloads ~/Inbox

asdf: pkgsbasic
	@if [ ! -x ~/.asdf/bin/asdf ]; then \
		test -d ~/.asdf && rm ~/.asdf; \
		git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.1; \
	fi

asdf_installs: asdf pkgsdevel
	@for plugin_version in $(PLUGINS); do echo ; \
		plugin=$$(echo $$plugin_version | cut -d'/' -f1); \
		version=$$(echo $$plugin_version | cut -d'/' -f2); \
		if [ "$$version" = "$$plugin_version" ]; then \
			version=latest; \
		fi; \
		if ! asdf plugin list | grep -q "$$plugin"; then \
			asdf plugin add "$$plugin"; \
		fi; \
		asdf install "$$plugin" "$$version"; \
		asdf global "$$plugin" "$$version"; \
	done

docker: pkgsbasic
	curl -fsSL https://get.docker.com | bash && \
	dockerd-rootless-setuptool.sh install

pkgsbasic:
	sudo apt-get install -y git curl tar gzip unzip ca-certificates

pkgsdevel:
	sudo apt-get install -y jq g++ python3 python3-pip xsel tmux


.PHONY: all sethome lazyvim asdf asdf_installs pkgsbasic pkgsdevel
