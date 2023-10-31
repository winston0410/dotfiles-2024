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
    ./nvim.nix
  ];

  # xdg.configFile = {
  #   "fzf/fzf-color.sh" = { source = ../../dotfiles/fzf/fzf-color.sh; };
  #   "bottom/bottom.toml" = { source = ../../dotfiles/bottom/bottom.toml; };
  #   "lsd/config.yaml" = { source = ../../dotfiles/lsd/config.yaml; };
  #   "procs/config.toml" = { source = ../../dotfiles/procs/config.toml; };
  #   "bat/config" = { source = ../../dotfiles/bat/config; };
  #   "ripgrep/config" = { source = ../../dotfiles/ripgrep/config; };
  #   "git/" = { source = ../../dotfiles/git; };
  # };

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
    ripgrep
    fd
    fzf
    dua
    bat
    procs
  ];

  programs.man.enable = false;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
