{ inputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [ lsd ];

  home.shellAliases = {
    ls = "lsd -a";
    tree = "lsd --tree";
  };

  xdg.configFile = { "lsd/config.yaml" = { source = ./config.yaml; }; };
}
