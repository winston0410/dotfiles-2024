{ inputs, lib, config, pkgs, ... }: {
  xdg.configFile = {
    "opencode/opencode.jsonc" = { source = ./opencode.jsonc; };
    "opencode/AGENTS.md" = { source = ./AGENTS.md; };
  };
}
