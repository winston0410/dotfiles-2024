{ inputs, lib, config, pkgs, unstable, ... }: {
  imports = [
    ./git/mod.nix
    ./nvim/mod.nix
    ./bat/mod.nix
    ./lsd/mod.nix
    ./wezterm/mod.nix
    ./ripgrep/mod.nix
    ./bottom/mod.nix
    ./zsh/mod.nix
    ./fzf/mod.nix
    ./du/mod.nix
    ./tree/mod.nix
    # ./android/mod.nix
    # ./ssh/mod.nix
    # # ./rust/mod.nix
  ];

  nix.package = pkgs.nix;
  nix.settings = {
    extra-trusted-users = "kghugo";
    builders-use-substitutes = true;
  };

  nixpkgs = {
    overlays = [ ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "kghugo";
    homeDirectory = "/Users/hugosum";
  };

  news = { display = "show"; };

  home.packages = with pkgs; [ procs unstable.go ];

  xdg.enable = true;

  programs.man.enable = false;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
