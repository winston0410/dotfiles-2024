{ inputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [ k9s ];

  xdg.configFile = {
    "k9s/config.yaml" = { source = ./config.yaml; };
    "k9s/skins/in_the_navy.yaml" = { source = ./skins/in_the_navy.yaml; };
  };
}
