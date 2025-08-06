{ inputs, lib, config, pkgs, system, unstable, ... }: {
  home.packages = with pkgs; [ wezterm unstable.zellij ];

  xdg.configFile = {
    "wezterm/wezterm.lua" = { source = ./linux.lua; };
    "wezterm/common.lua" = { source = ./common.lua; };
    "wezterm/.luarc.json" = { source = ./.luarc.json; };
    "zellij/config.kdl" = { source = ./config.kdl; };
  };
}
