{ inputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [ neofetch ];
  programs.zsh = {
    enable = true;
    autosuggestion = { enable = true; };
    enableCompletion = true;
    syntaxHighlighting = { enable = true; };
    zplug = {
      enable = true;
      plugins = [
        {
          name = "mafredri/zsh-async";
          tags = [ "from:github" ];
        }
        {
          name = "sindresorhus/pure";
          tags = [ "use:pure.zsh" "from:github" "as:theme" ];
        }
      ];
    };
    initExtra = ''
      source "$HOME/.config/fzf/fzf-color.sh"
      # this has to match the keybinding of Wezterm, this corresponding to <Char-0xAA>. Cannot use 0x here
      bindkey '\u00AA' vi-cmd-mode;
      # for navigating prev and next command in history
      bindkey '\u00AB' up-line-or-history;
      bindkey '\u00AC' down-line-or-history;
      # REF https://unix.stackexchange.com/a/290403
      bindkey -v '^?' backward-delete-char

      KEYTIMEOUT=1
      unsetopt share_history
      neofetch;
    '';
  };

  programs.direnv.enable = true;
  programs.direnv.enableZshIntegration = true;

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };
}
