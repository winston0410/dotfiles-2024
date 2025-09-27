{ inputs, lib, config, pkgs, unstable, ... }:
let

  username = "hugosum";
in {
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
    ./modules/kanata/mod.nix
    # ./modules/bw/mod.nix
    ./modules/nix/mod.nix
    ./modules/mcphub/mod.nix
    ./modules/k8s/mod.nix
    # Firefox just won't start
    # ./modules/firefox/mod.nix
  ];

  nix.settings = {
    extra-trusted-users = "hugosum";
    builders-use-substitutes = true;
  };
  xdg.configFile = {
    "wezterm/wezterm.lua" = {
      source = lib.mkForce ./modules/wezterm/darwin.lua;
    };
  };
  programs.zsh.initContent = lib.mkBefore (''
    export PATH="$PATH:/opt/homebrew/bin";
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh;
    source /nix/var/nix/profiles/default/etc/profile.d/nix.sh;
  '');

  home = {
    inherit username;
    homeDirectory = "/Users/${username}";
  };
  home.packages = with pkgs; [ inputs.oxeylyzer.packages.${system}.default unstable.opencode ];
  xdg.mime.enable = lib.mkForce false;
  xdg.mimeApps.enable = lib.mkForce false;
  xdg.userDirs.enable = lib.mkForce false;
  xdg.desktopEntries = lib.mkForce { };

  programs.wezterm.enable = lib.mkForce false;

  nix.settings.use-xdg-base-directories = lib.mkForce false;
  programs.firefox.package = lib.mkForce pkgs.firefox-bin;
  programs.firefox.nativeMessagingHosts = lib.mkForce [ ];
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
