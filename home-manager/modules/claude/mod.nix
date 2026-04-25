{ inputs, lib, config, pkgs, unstable, ... }: {
  home.packages = [ unstable.claude-code unstable.claude-agent-acp ];
  home.file = {
    ".claude/keybindings.json" = { source = ./keybindings.json; };
  };
  # This doesn't work, because claude dump state and everything into this config dir
  # home.sessionVariables = { CLAUDE_CONFIG_DIR = "${config.xdg.configHome}/claude"; };
  # xdg.configFile = {
  #   "claude/keybindings.json" = { source = ./keybindings.json; };
  # };
}
