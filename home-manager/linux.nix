{ inputs, lib, config, pkgs, unstable, ... }: {
  imports = [
    ./common.nix
    ./modules/docker/mod.nix
    ./modules/vscode/mod.nix
    ./modules/gnome/mod.nix
    ./modules/firefox/mod.nix
  ];

  nix.settings = { extra-trusted-users = "kghugo"; };

  home = {
    username = "kghugo";
    homeDirectory = "/home/kghugo";
  };

  home.packages = with pkgs; [
    dconf-editor
    signal-desktop
    element-desktop
    telegram-desktop
    spotube
  ];
}
