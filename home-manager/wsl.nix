{ inputs, lib, config, pkgs, ... }: {
  imports = [ ./common.nix ./modules/font/mod.nix ];

  home.packages = with pkgs; [ wslu ];
  home = {
    username = "hugosum";
    homeDirectory = "/home/hugosum";
  };

  # REF https://superuser.com/a/1368878
  home.sessionVariables = { BROWSER = "wslview"; };

  fonts.fontconfig.enable = lib.mkForce false;
}
