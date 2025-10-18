{ inputs, lib, config, pkgs, system, ... }: {
  # NOTE This only set which Nix version we are targeting, instead of installing that version for us
  nix.package = pkgs.nix;
  nix.enable = true;
  # TODO figure out why the list here never worked
  # https://discourse.nixos.org/t/trusted-users-is-ignored-in-config-nix-nix-conf/41885
  nix.settings.trusted-users = [ ]
    ++ lib.optionals pkgs.stdenv.isDarwin [ "@admin" ]
    ++ lib.optionals pkgs.stdenv.isLinux [ "@wheel" ];
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
  home.packages = with pkgs; [ sqlite nix ];
  home.preferXdgDirectories = true;
  programs.man.enable = false;
}
