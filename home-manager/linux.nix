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

  programs.zsh.initExtra = lib.mkBefore (''
    vaultwarden_password="$(secret-tool lookup service 'vaultwarden.28281428.xyz')"
    export BW_SESSION="$(bw unlock $vaultwarden_password --raw)"
  '');

  home.packages = with pkgs; [
    dconf-editor
    signal-desktop
    element-desktop
    telegram-desktop
    spotube
    discord
    # FIXME cannot build correctly on Darwin and Linux yet
    # (pkgs.buildNpmPackage rec {
    #   pname = "@mistweaverco/kulala-ls";
    #   version = "1.3.0";
    #
    #   src = pkgs.fetchFromGitHub {
    #     owner = "mistweaverco";
    #     repo = "kulala-ls";
    #     rev = "v${version}";
    #     hash = "sha256-IavvGIBUPnPRlHbyaJbkUuXQXKEEzv/SKY0Ii2eLDNs=";
    #   };
    #
    #   nativeBuildInputs = [ pkgs.python3 pkgs.libtool pkgs.cacert ];
    #
    #   npmDepsHash = "sha256-/6JZYsIYDJHS/8TOPjtR/SrRbzTbL43X0g/tPIn2YfQ=";
    # })
  ];
}
