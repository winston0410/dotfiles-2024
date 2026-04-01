{ inputs, lib, config, pkgs, unstable, ... }:
let
  weztermTerminfoSrc = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/wezterm/wezterm/main/termwiz/data/wezterm.terminfo";
    hash = "sha256-XjhvsUmyoWtxtNmjc8VHN8nlaU62f+ONk7JHBbk0N+0=";
  };

  weztermTerminfoCompiled = pkgs.runCommand "wezterm-terminfo" {
    nativeBuildInputs = [ pkgs.ncurses ];
  } ''
    mkdir -p "$out"
    tic -x -o "$out" "${weztermTerminfoSrc}"
  '';
in {
  programs.wezterm.enable = true;
  programs.wezterm.enableBashIntegration = true;
  programs.wezterm.enableZshIntegration = true;

  xdg.configFile = {
    "wezterm/wezterm.lua" = { source = ./linux.lua; };
    "wezterm/common.lua" = { source = ./common.lua; };
    "wezterm/.luarc.json" = { source = ./.luarc.json; };
  };

  home.file.".terminfo" = {
    source = weztermTerminfoCompiled;
    recursive = true;
  };
}
