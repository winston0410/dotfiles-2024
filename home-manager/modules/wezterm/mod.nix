{ inputs, lib, config, pkgs, system, ... }: {
  home.packages = with pkgs; [ wezterm ];

  xdg.configFile = {
    "wezterm/wezterm.lua" = {
      source = if lib.strings.hasInfix "linux" system then
        ./linux.lua
      else
        ./darwin.lua;
    };
    "wezterm/common.lua" = { source = ./common.lua; };
  };
}
