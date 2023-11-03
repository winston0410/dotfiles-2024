{ inputs, lib, config, pkgs, ... }: {
  # bindkey '\xAA[' vi-cmd-mode;
  programs.zsh.enable = true;
  programs.zsh.initExtra = ''
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh;
    source /nix/var/nix/profiles/default/etc/profile.d/nix.sh;

    # this has to match the keybinding of Wezterm, this corresponding to <Char-0xAA>. Cannot use 0x here
    bindkey '\u00AA' vi-cmd-mode;

    KEYTIMEOUT=1
    unsetopt share_history

    # FIXME use native or better way to load zsh plugins
    # No good solution in 1 Nov 2023

    ### Added by Zinit's installer
    if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
            print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
            command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
            command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
                    print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
                    print -P "%F{160}▓▒░ The clone has failed.%f%b"
    fi

    source "$HOME/.zinit/bin/zinit.zsh"
    autoload -Uz _zinit
    (( ''${+_comps} )) && _comps[zinit]=_zinit

    # Load a few important annexes, without Turbo
    # (this is currently required for annexes)
    zinit light-mode for \
            zinit-zsh/z-a-rust \
            zinit-zsh/z-a-as-monitor \
            zinit-zsh/z-a-patch-dl \
            zinit-zsh/z-a-bin-gem-node

    ### End of Zinit's installer chunk

    zinit wait lucid light-mode for \
            zsh-users/zsh-autosuggestions \
            atinit"zicompinit; zicdreplay" \
            compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh' \
            sindresorhus/pure \
            zdharma/fast-syntax-highlighting \
            as"completion" \
            OMZP::docker/_docker \
            OMZP::node \
            OMZP::npm \
            OMZP::yarn \
            OMZP::brew \
            OMZP::deno \
            OMZP::docker-compose \
            OMZP::gitfast \
            OMZP::pip \
            OMZP::golang \
            # OMZP::tmux \
            # OMZP::rustup/_rustup \

            source "$HOME/.config/fzf/fzf-color.sh";
  '';

  programs.direnv.enable = true;
  programs.direnv.enableZshIntegration = true;

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };
}
