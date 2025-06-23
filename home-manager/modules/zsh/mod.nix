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
    initContent = ''
      ZINIT_HOME="''${XDG_DATA_HOME:-''${HOME}/.local/share}/zinit/zinit.git"
      [ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
      [ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
      source "''${ZINIT_HOME}/zinit.zsh"

      zinit ice pick"async.zsh" src"pure.zsh" # with zsh-async library that's bundled with it.
      zinit light sindresorhus/pure

      zinit ice wait lucid
      zinit light zsh-users/zsh-completions
      zinit light Aloxaf/fzf-tab

      zstyle ':fzf-tab:*' use-fzf-default-opts yes

      zi snippet OMZP::git
      zi snippet OMZP::kubectl
      zi snippet OMZP::dotnet
      zi snippet OMZP::docker
      zi snippet OMZP::docker-compose
      zi snippet OMZP::deno
      zi snippet OMZP::bun
      zi snippet OMZP::rbw
    '' + ''
      bindkey '^P' up-line-or-history;
      bindkey '^N' down-line-or-history;

      # Fix the default Vi behavior of Zsh, that prevents us from using backspace in Insert Mode like in Vim.
      # REF https://unix.stackexchange.com/a/290403
      bindkey -v '^?' backward-delete-char

      KEYTIMEOUT=1;
    '' + ''
      setopt HIST_REDUCE_BLANKS;
      setopt INC_APPEND_HISTORY;
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

  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;
  programs.fzf.defaultOptions = [
    # seems to be not needed at the moment
    # "--preview 'bat --style=numbers --color=always {}'"
    "--highlight-line"
    "--info=inline-right"
    "--ansi"
    "--layout=reverse"
    "--border=none"
    # REF https://github.com/folke/tokyonight.nvim/blob/main/extras/fzf/tokyonight_storm.sh
    "--color=bg+:#2e3c64"
    "--color=bg:#1f2335"
    "--color=border:#29a4bd"
    "--color=fg:#c0caf5"
    "--color=gutter:#1f2335"
    "--color=header:#ff9e64"
    "--color=hl+:#2ac3de"
    "--color=hl:#2ac3de"
    "--color=info:#545c7e"
    "--color=marker:#ff007c"
    "--color=pointer:#ff007c"
    "--color=prompt:#2ac3de"
    "--color=query:#c0caf5:regular"
    "--color=scrollbar:#29a4bd"
    "--color=separator:#ff9e64"
    "--color=spinner:#ff007c"
  ];
}
