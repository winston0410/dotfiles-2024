{ inputs, lib, config, pkgs, unstable, ... }:
let username = "hsum";
in {
  home = {
    username = lib.mkForce username;
    homeDirectory = lib.mkForce "/Users/${username}";
    packages = with pkgs; [ docker_28 ];
  };
  programs.git.settings = {
    user = {
      email = lib.mkForce "hsum@trintech.com";
      name = lib.mkForce "Hugo Sum";
    };
  };
}
