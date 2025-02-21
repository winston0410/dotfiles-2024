{ inputs, lib, config, pkgs, unstable, ... }: {
  imports = [ ./common.nix ./modules/firefox/mod.nix ];

  nix.settings = {
    extra-trusted-users = "hugosum";
    builders-use-substitutes = true;
  };

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
  # # FIX for this bug that prevents installing firefox on darwin https://github.com/nix-community/home-manager/issues/5717
  # # REF https://github.com/booxter/home-manager/commit/c200ff63c0f99c57fac96aac667fd50b5057aec7
  # home.sessionVariables = lib.mkIf isDarwin {
  #   MOZ_LEGACY_PROFILES = 1;
  #   MOZ_ALLOW_DOWNGRADE = 1;
  # };
}
