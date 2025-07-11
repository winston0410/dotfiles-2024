{ inputs, lib, config, pkgs, unstable, ... }: {
  imports = [
    ./modules/git/mod.nix
    ./modules/nvim/mod.nix
    ./modules/bat/mod.nix
    ./modules/lsd/mod.nix
    ./modules/wezterm/mod.nix
    ./modules/ripgrep/mod.nix
    ./modules/bottom/mod.nix
    ./modules/shell/mod.nix
    ./modules/du/mod.nix
    ./modules/font/mod.nix
    ./modules/k9s/mod.nix
    ./modules/android/mod.nix
    ./modules/xdg/mod.nix
    ./modules/sops/mod.nix
    ./modules/docker/mod.nix
    ./modules/vscode/mod.nix
    ./modules/gnome/mod.nix
    ./modules/firefox/mod.nix
    ./modules/email/mod.nix
    ./modules/steam/mod.nix
    ./modules/nix/mod.nix
  ];

  home = {
    username = "kghugo";
    homeDirectory = "/home/kghugo";
  };

  programs.zsh.initExtra = lib.mkBefore "";

  home.packages = with pkgs; [
    bitwarden-cli
    dconf-editor
    signal-desktop
    element-desktop
    telegram-desktop
    discord
    devpod-desktop
    podman-compose
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
