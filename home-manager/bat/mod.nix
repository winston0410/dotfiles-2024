{ inputs, lib, config, pkgs, ... }: {
  home.shellAliases = { cat = "bat"; };

  home.packages = with pkgs; [ bat ];

  xdg.configFile = {
    "bat/config" = { source = ./config; };
    "bat/themes" = { source = ./themes; };
  };
}
