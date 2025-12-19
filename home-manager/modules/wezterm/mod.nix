{ inputs, lib, config, pkgs, system, unstable, ... }: {
  programs.wezterm.enable = true;
  programs.wezterm.enableBashIntegration = true;
  programs.wezterm.enableZshIntegration = true;
  home.packages = with pkgs; [ zellij ];

  xdg.configFile = {
    "wezterm/wezterm.lua" = { source = ./linux.lua; };
    "wezterm/common.lua" = { source = ./common.lua; };
    "wezterm/.luarc.json" = { source = ./.luarc.json; };
    "zellij/config.kdl" = { source = ./config.kdl; };
  };
}
