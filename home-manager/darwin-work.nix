{ inputs, lib, config, pkgs, unstable, ... }: {
  home = {
    username = lib.mkForce "hsum";
    homeDirectory = lib.mkForce "/Users/hsum";
  };
  programs.git.extraConfig = {
    user = {
      email = lib.mkForce "hsum@trintech.com";
      name = "Hugo Sum";
    };
  };
}
