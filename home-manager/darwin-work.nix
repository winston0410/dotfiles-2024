{ inputs, lib, config, pkgs, unstable, ... }:
let username = "hsum";
in {
  home = {
    username = lib.mkForce username;
    homeDirectory = lib.mkForce "/Users/${username}";
  };
  nix.settings = { extra-trusted-users = lib.mkForce username; };
  programs.git.extraConfig = {
    user = {
      email = lib.mkForce "hsum@trintech.com";
      name = lib.mkForce "Hugo Sum";
    };
  };
}
