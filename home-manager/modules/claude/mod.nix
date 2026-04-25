{ inputs, lib, config, pkgs, unstable, ... }:
let
  claude-agent-acp-src = pkgs.fetchFromGitHub {
    owner = "zed-industries";
    repo = "claude-agent-acp";
    tag = "v0.31.0";
    hash = "sha256-lWAuf8EO5Y1x1HhcNrbNQUgOsdGG5SXYTiXevWBEhSQ=";
  };
  claude-agent-acp = unstable.claude-agent-acp.overrideAttrs (old: {
    version = "0.31.0";
    src = claude-agent-acp-src;
    npmDeps = unstable.fetchNpmDeps {
      name = "claude-agent-acp-0.31.0-npm-deps";
      src = claude-agent-acp-src;
      hash = "sha256-lKGj7J9UduqfVPUiYh+ZcCqZ8tfzmV4mVI2dGSZWj0Q=";
    };
  });
in {
  home.packages = [
    unstable.claude-code
    (lib.hiPrio claude-agent-acp)
  ];
  home.file = {
    ".claude/keybindings.json" = { source = ./keybindings.json; };
  };
  # This doesn't work, because claude dump state and everything into this config dir
  # home.sessionVariables = { CLAUDE_CONFIG_DIR = "${config.xdg.configHome}/claude"; };
  # xdg.configFile = {
  #   "claude/keybindings.json" = { source = ./keybindings.json; };
  # };
}
