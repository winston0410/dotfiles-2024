{ inputs, lib, config, pkgs, ... }: {
  imports = [ ./common.nix ./modules/font/mod.nix ];

  home.packages = with pkgs; [ ];
  home = {
    username = "hugosum";
    homeDirectory = "/home/hugosum";
  };

  # REF https://superuser.com/a/1368878
  home.sessionVariables = { BROWSER = "wslview"; };

  fonts.fontconfig.enable = lib.mkForce false;
  programs.git.extraConfig.credential.helper = lib.mkForce
    [ "/mnt/c/Program\\ Files/Git/mingw64/bin/git-credential-manager.exe" ];
}
