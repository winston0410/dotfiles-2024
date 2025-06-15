{ inputs, lib, config, pkgs, unstable, ... }: {
  imports = [
    ./common.nix
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

    vaultwarden_password="$(security find-internet-password -s 'vaultwarden.28281428.xyz' -w)"
    export BW_SESSION="$(bw unlock $vaultwarden_password --raw)"
  '');

  home = {
    username = "hugosum";
    homeDirectory = "/Users/hugosum";
  };
  xdg.mime.enable = lib.mkForce false;
  xdg.mimeApps.enable = lib.mkForce false;
  xdg.userDirs.enable = lib.mkForce false;
  xdg.desktopEntries = lib.mkForce { };

  nix.settings.use-xdg-base-directories = lib.mkForce false;
  programs.firefox.package = lib.mkForce pkgs.firefox-bin;
  programs.firefox.nativeMessagingHosts = lib.mkForce [ ];
}
