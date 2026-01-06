{ inputs, lib, config, pkgs, unstable, ... }:
let username = "hsum";
in {
  imports = [
    ./modules/opencode/mod.nix
  ];
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
  programs.zsh.initContent = lib.mkBefore (# zsh
  ''
    export PATH="$PATH:/opt/homebrew/bin:/usr/local/bin";
  '');
}
