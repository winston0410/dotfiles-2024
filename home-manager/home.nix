{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    ./nvim/mod.nix
    ./bat/mod.nix
    ./lsd/mod.nix
    ./wezterm/mod.nix
    ./ripgrep/mod.nix
    ./bottom/mod.nix
  ];

  nixpkgs = {
    overlays = [];
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # TODO: Set your username
  home = {
    username = "hugosum";
    homeDirectory = "/Users/hugosum";
  };

  news = {
    display = "show";
  };

  home.packages = with pkgs; [ 
    fd
    fzf
    dua
    procs
  ];

  programs.man.enable = false;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
