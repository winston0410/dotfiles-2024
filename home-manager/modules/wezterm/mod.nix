{ inputs, lib, config, pkgs, system, ... }: {
  home.packages = with pkgs; [ wezterm ];

  xdg.configFile = {
    "wezterm/wezterm.lua" = { source = ./linux.lua; };
    "wezterm/common.lua" = { source = ./common.lua; };
    "wezterm/.luarc.json" = { source = ./.luarc.json; };
  };
}
