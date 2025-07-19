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
    ./modules/kanata/mod.nix
    # ./modules/bw/mod.nix
    ./modules/nix/mod.nix
    ./modules/mcphub/mod.nix
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
  programs.zsh.initExtra = lib.mkBefore (''
    export PATH="$PATH:/opt/homebrew/bin";
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh;
    source /nix/var/nix/profiles/default/etc/profile.d/nix.sh;
  '');

  home = {
    username = "hugosum";
    homeDirectory = "/Users/hugosum";
  };
  home.packages = with pkgs; [ kubectl ];
  xdg.mime.enable = lib.mkForce false;
  xdg.mimeApps.enable = lib.mkForce false;
  xdg.userDirs.enable = lib.mkForce false;
  xdg.desktopEntries = lib.mkForce { };

  nix.settings.use-xdg-base-directories = lib.mkForce false;
  programs.firefox.package = lib.mkForce pkgs.firefox-bin;
  programs.firefox.nativeMessagingHosts = lib.mkForce [ ];
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
