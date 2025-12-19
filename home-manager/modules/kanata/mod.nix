{ inputs, lib, config, pkgs, unstable, ... }: {
  home.packages = with pkgs; [ kanata ];

  xdg.configFile = { "kanata/config.kbd" = { source = ./config.kbd; }; };
}
