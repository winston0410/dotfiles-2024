{ inputs, lib, config, pkgs, system, ... }: {
  nix.package = pkgs.nix;
  nix.enable = true;
  nix.settings.trusted-users = [ "@wheel" ];
  nix.settings.use-xdg-base-directories = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  programs.nh.enable = true;

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  news = { display = "notify"; };
  home.packages = with pkgs; [ sqlite ];
  home.preferXdgDirectories = true;
  programs.man.enable = false;
}
