{ inputs, lib, config, pkgs, unstable, ... }: {
  home = {
    username = lib.mkForce "hsum";
    homeDirectory = lib.mkForce "/Users/hsum";
  };
}
