{ inputs, lib, config, pkgs, unstable, ... }: {
  home.packages = with pkgs; [
    unstable.opencode
  ];
  xdg.configFile = {
    "opencode/opencode.jsonc" = { source = ./opencode.jsonc; };
    "opencode/AGENTS.md" = { source = ./AGENTS.md; };
  };
}
