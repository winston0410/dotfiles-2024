{ inputs, lib, unstable, config, pkgs, system, ... }: {
  # home.shell.enableShellIntegration = true;

  programs.zsh = {
    enable = true;
    package = unstable.zsh;
    # NOTE somehow this path is relative
    dotDir = ".config/zsh";
    history = { path = "${config.xdg.stateHome}/zsh/history"; };
    autosuggestion = {
      enable = true;
      strategy = [ "history" "completion" ];
    };
    enableCompletion = true;
    syntaxHighlighting = { enable = true; };
    initExtra = ''
      # Set module path, so zsh can load *.so from /nix/store correctly
      module_path="${pkgs.zsh}/lib/${pkgs.zsh.pname}/${pkgs.zsh.version}"
    '' + (builtins.readFile ./init.sh);
  };

  home.sessionVariables = {
    ZPLUG_HOME = config.programs.zsh.zplug.zplugHome;
    HISTFILE = config.programs.zsh.history.path;
    ZDOTDIR = config.programs.zsh.dotDir;
  };

  programs.direnv.enable = true;
  programs.direnv.enableZshIntegration = true;
  programs.direnv.enableNushellIntegration = true;
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
  programs.starship.enable = true;
  programs.starship.enableBashIntegration = true;
  programs.starship.enableFishIntegration = true;
  programs.starship.enableZshIntegration = true;
  programs.starship.package = unstable.starship;
  programs.starship.settings =
    builtins.fromTOML (builtins.readFile ./starship.toml);

  programs.oh-my-posh.enable = false;
  programs.oh-my-posh.package = unstable.oh-my-posh;
  programs.oh-my-posh.enableZshIntegration = true;
  programs.oh-my-posh.enableBashIntegration = true;
  programs.oh-my-posh.enableFishIntegration = true;
  programs.oh-my-posh.enableNushellIntegration = true;
  programs.oh-my-posh.settings =
    builtins.fromJSON (builtins.readFile ./oh-my-posh-theme.json);

  programs.carapace.enable = config.programs.nushell.enable;
  programs.carapace.enableNushellIntegration = true;
  programs.carapace.package = unstable.carapace;

  programs.nushell.enable = true;
  programs.nushell.package = unstable.nushell;
  programs.nushell.configFile.source = ./config.nu;
}
