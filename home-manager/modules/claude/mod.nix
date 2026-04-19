{ inputs, lib, config, pkgs, ... }: {
  home.file = {
    ".claude/keybindings.json" = {
      source = ./keybindings.json;
    };
  };
  # This doesn't work, because claude dump state and everything into this config dir
  # home.sessionVariables = { CLAUDE_CONFIG_DIR = "${config.xdg.configHome}/claude"; };
  # xdg.configFile = {
  #   "claude/keybindings.json" = { source = ./keybindings.json; };
  # };
}
