{ inputs, lib, config, pkgs, system, ... }: {
  home.packages = with pkgs; [ ];
  programs.zsh = {
    enable = true;
    # NOTE somehow this path is relative
    dotDir = ".config/zsh";
    history = { path = "${config.xdg.stateHome}/zsh/history"; };
    autosuggestion = {
      enable = true;
      strategy = [ "history" "completion" ];
    };
    enableCompletion = true;
    syntaxHighlighting = { enable = true; };
    zplug = {
      enable = true;
      zplugHome = "${config.xdg.dataHome}/zplug";
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
    initContent = ''
      source "$HOME/.config/fzf/fzf-color.sh"
      bindkey '^P' up-line-or-history;
      bindkey '^N' down-line-or-history;

      # Fix the default Vi behavior of Zsh, that prevents us from using backspace in Insert Mode like in Vim.
      # REF https://unix.stackexchange.com/a/290403
      bindkey -v '^?' backward-delete-char

      KEYTIMEOUT=1;
      unsetopt share_history;
    '';
  };
  home.sessionVariables = {
    ZPLUG_HOME = config.programs.zsh.zplug.zplugHome;
    HISTFILE = config.programs.zsh.history.path;
    ZDOTDIR = config.programs.zsh.dotDir;
  };

  programs.direnv.enable = true;
  programs.direnv.enableZshIntegration = true;
  programs.direnv.nix-direnv.enable = true;

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };
}
