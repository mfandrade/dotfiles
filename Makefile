# vim: fdm=marker fmr={{{,}}}

# TODO make it easy to install other fonts
# https://stackoverflow.com/a/74742720

# ~/.local/share/fonts/JetBrainsMonoNerdFont-Regular.ttf:
# 	wget -nv https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.tar.xz \
# 		&& tar -xJf nerdfont.txz -C ~/.local/share/fonts JetBrainsMonoNerdFont-Regular.ttf \
# 		&& fc-cache -fv

# ~/.local/share/fonts/UbuntuMonoNerdFont-Regular.ttf:
# 	wget -O nerdfont.txz -nv https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/UbuntuMono.tar.xz \
# 		&& tar -xJf nerdfont.txz -C ~/.local/share/fonts UbuntuMonoNerdFont-Regular.ttf && rm nerdfont.txz \
# 		&& fc-cache -fv
#

# home content
# -----------------------------------------------------------------------------
HOMECONTENT = ~/xdg ~/src ~/bin

define xdgdir # {{{
        @mkdir -p ~/xdg/$1 && \
        if [ -d ~/$1 ]; then \
					if [ -z "$$(ls -1A ~/$1)" ]; then \
						rmdir ~/$1; \
					else \
						mv ~/$1 ~/xdg; \
					fi; \
        fi && \
        xdg-user-dirs-update --set $2 ~/xdg/$1
endef # }}}

# sethome {{{
.PHONY := sethome
sethome:
	mkdir -p $(HOMECONTENT)
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
	echo "0 */2 * * * rm -rf ~/Inbox/*") | crontab -
# }}}

# asdf {{{
PACKAGES = curl wget git links fish bash bash-completion command-not-found tmux
.PHONY := $(PACKAGES)
$(PACKAGES):
	command -v $@ 2>&1 > /dev/null || $(SUDO) apt-get install -y $@

LATEST  := $(shell curl -sI https://github.com/asdf-vm/asdf/releases/latest | awk 'BEGIN{FS="/"}/^[Ll]ocation:/{print $$NF}')
CURRENT := $(shell asdf version 2>/dev/null | awk '{print $$1}')
.PHONY := asdf
asdf:
	if [ -z "$(CURRENT)" ] || [ "$(CURRENT)" != "$(LATEST)" ]; then \
		wget -O asdf.tgz -nv https://github.com/asdf-vm/asdf/releases/download/"$(LATEST)"/asdf-"$(LATEST)"-linux-amd64.tar.gz && \
		tar -zxvf asdf.tgz && $(SUDO) install asdf /usr/local/bin && \
		rm asdf.tgz asdf; \
	fi
# }}}

# asdf_conf_bash {{{
CONF_BASH := ~/.bash_profile
.PHONY := asdf_conf_bash
asdf_conf_bash: asdf bash
	echo 'export PATH="$${ASDF_DATA_DIR:-$$HOME/.asdf}/shims:$$PATH"' >> $(CONF_BASH)
	. $(CONF_BASH)
# }}}

# asdf_conf_fish {{{
CONF_FISH := ~/.config/fish/conf.d/asdf.fish
.PHONY := asdf_conf_fish
asdf_conf_fish: asdf fish
	curl -o $(CONF_FISH) https://raw.githubusercontent.com/mfandrade/dotfiles/refs/heads/main/asdf/.config/fish/conf.d/asdf.fish
	. $(CONF_FISH)
# }}}

# asdf_plugins {{{
PLUGINS := neovim lua/5.1.5 java/latest:oracle nodejs ripgrep fd tree-sitter lazygit bat difftastic shfmt
.PHONY := asdf_plugins
asdf_plugins: asdf
	for plugin_version in $(PLUGINS); do \
		plugin=$$(echo $$plugin_version | cut -d'/' -f1); \
		version=$$(echo $$plugin_version | cut -d'/' -f2); \
		if [ "$$version" = "$$plugin_version" ]; then \
			version=latest; \
		fi; \
		\
		if ! asdf plugin list | grep -q "$$plugin"; then \
			asdf plugin add "$$plugin"; \
		fi; \
		\
		current_global_version=$$(asdf current "$$plugin" 2>/dev/null | awk '{print $$2}'); \
		if [ "$$current_global_version" != "$$version" ]; then \
			if ! asdf list "$$plugin" | grep -q "$$version"; then \
				asdf install "$$plugin" "$$version"; \
			fi; \
			asdf set --home "$$plugin" "$$version"; \
		fi; \
		\
	done
# }}}

# lazyvim {{{
.PHONY := lazyvim
lazyvim: git asdf_plugins
	rm -rf ~/.config/nvim/ ~/.local/share/nvim/ ~/.local/state/nvim/ ~/.cache/nvim/
	git clone https://github.com/mfandrade/lazyvim ~/.config/nvim && rm -rf ~/.config/nvim/.git
	# }}}

# tmux {{{
tmux: curl tmux
	curl -O https://raw.githubusercontent.com/mfandrade/dotfiles/refs/heads/main/tmux/.tmux.conf
# }}}
