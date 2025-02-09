{ inputs, lib, config, pkgs, system, isDarwin, ... }: {
  home.packages = with pkgs; [ wezterm ];

  xdg.configFile = {
    "wezterm/wezterm.lua" = {
      source = if isDarwin then ./darwin.lua else ./linux.lua;
    };
    "wezterm/common.lua" = { source = ./common.lua; };
    "wezterm/.luarc.json" = { source = ./.luarc.json; };
  };
}
