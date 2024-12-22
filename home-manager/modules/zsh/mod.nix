{ inputs, lib, config, pkgs, system, isDarwin, ... }: {
  home.packages = with pkgs; [ neofetch ];
  programs.zsh = {
    enable = true;
    autosuggestion = {
      enable = true;
      strategy = [ "history" "completion" ];
    };
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
    initExtra = let
      linuxInit = ''
        source "$HOME/.config/fzf/fzf-color.sh"
        bindkey '^P' up-line-or-history;
        bindkey '^N' down-line-or-history;

        KEYTIMEOUT=1;
        unsetopt share_history;
      '';
    in if isDarwin then
      ''
        export PATH="$PATH:/opt/homebrew/bin";
        source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh;
        source /nix/var/nix/profiles/default/etc/profile.d/nix.sh;
      '' + linuxInit
    else
      linuxInit;
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
