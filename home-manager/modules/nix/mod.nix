{ inputs, lib, config, pkgs, system, ... }: {
  nix.package = pkgs.nix;
  nix.enable = true;
  nix.settings.trusted-users = [ "@wheel" ];
  nix.settings.use-xdg-base-directories = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  news = { display = "show"; };
  home.packages = with pkgs;
    [
      # FIXME wait for this to resolve https://github.com/NixOS/nixpkgs/issues/339576
      # bitwarden-cli
      sqlite
    ];
  home.preferXdgDirectories = true;
  programs.man.enable = false;
}
