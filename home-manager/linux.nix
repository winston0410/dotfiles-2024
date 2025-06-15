{ inputs, lib, config, pkgs, unstable, ... }: {
  imports = [
    ./common.nix
    ./modules/docker/mod.nix
    ./modules/vscode/mod.nix
    ./modules/gnome/mod.nix
    ./modules/firefox/mod.nix
    ./modules/email/mod.nix
    ./modules/steam/mod.nix
  ];


  home = {
    username = "kghugo";
    homeDirectory = "/home/kghugo";
  };

  # secret-tool store --label="vaultwarden master password" service "vaultwarden.28281428.xyz"
  programs.zsh.initContent = lib.mkBefore (''
    vaultwarden_password="$(secret-tool lookup service 'vaultwarden.28281428.xyz')"
    export BW_SESSION="$(bw unlock $vaultwarden_password --raw)"
  '');

  home.packages = with pkgs; [
    dconf-editor
    libsecret
    signal-desktop
    element-desktop
    telegram-desktop
    spotube
    discord
    # REF https://github.com/NixOS/nixpkgs/pull/385105
    # kulala-ls
  ];
}
