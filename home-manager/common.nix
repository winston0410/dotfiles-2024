{ inputs, lib, config, pkgs, unstable, system, isDarwin, ... }: {
  imports = [
    ./modules/git/mod.nix
    ./modules/nvim/mod.nix
    ./modules/bat/mod.nix
    ./modules/lsd/mod.nix
    ./modules/wezterm/mod.nix
    ./modules/ripgrep/mod.nix
    ./modules/bottom/mod.nix
    ./modules/zsh/mod.nix
    ./modules/fzf/mod.nix
    ./modules/du/mod.nix
    ./modules/tree/mod.nix
    ./modules/font/mod.nix
    ./modules/k9s/mod.nix
    ./modules/android/mod.nix
    ./modules/xdg/mod.nix
    ./modules/sops/mod.nix
    # # ./rust/mod.nix
  ];

  nix.package = pkgs.nix;
  nix.enable = true;
  nix.settings.trusted-users = [ "@wheel" ];
  nix.settings.use-xdg-base-directories = !isDarwin;
  nix.settings.experimental-features =
    [ "nix-command" "flakes" "pipe-operators" ];
  nix.settings.auto-optimise-store = true;

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  news = { display = "show"; };
  home.packages = with pkgs; [ procs unstable.go brave ];
  home.preferXdgDirectories = true;
  programs.man.enable = false;
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
