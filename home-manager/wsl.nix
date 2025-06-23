{ inputs, lib, config, pkgs, ... }: {
  imports = [
    ./modules/git/mod.nix
    ./modules/nvim/mod.nix
    ./modules/bat/mod.nix
    ./modules/lsd/mod.nix
    ./modules/wezterm/mod.nix
    ./modules/ripgrep/mod.nix
    ./modules/bottom/mod.nix
    ./modules/zsh/mod.nix
    ./modules/du/mod.nix
    ./modules/tree/mod.nix
    ./modules/font/mod.nix
    ./modules/k9s/mod.nix
    ./modules/android/mod.nix
    ./modules/xdg/mod.nix
    ./modules/sops/mod.nix
    ./modules/font/mod.nix
    ./modules/nix/mod.nix
  ];

  home.packages = with pkgs; [ wslu ];
  home = {
    username = "hugosum";
    homeDirectory = "/home/hugosum";
  };

  # REF https://superuser.com/a/1368878
  home.sessionVariables = { BROWSER = "wslview"; };

  fonts.fontconfig.enable = lib.mkForce false;

  programs.git.extraConfig.user.name = lib.mkForce "Hugo Sum";
  programs.git.extraConfig.credential.helper = lib.mkForce
    [ "/mnt/c/Program\\ Files/Git/mingw64/bin/git-credential-manager.exe" ];
  xdg.mime.enable = lib.mkForce false;
  xdg.mimeApps.enable = lib.mkForce false;
  xdg.userDirs.enable = lib.mkForce false;
  xdg.desktopEntries = lib.mkForce { };

  nix.settings.use-xdg-base-directories = lib.mkForce false;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
