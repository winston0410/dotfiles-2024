{ inputs, lib, config, pkgs, unstable, ... }:
let username = "hsum";
in {
  imports = [
    ./modules/claude/mod.nix
    ./modules/codex/mod.nix
  ];
  home = {
    username = lib.mkForce username;
    homeDirectory = lib.mkForce "/Users/${username}";
    packages = with pkgs; [ docker_28 (azure-cli.withExtensions [ pkgs.azure-cli.extensions.azure-devops ]) ];
  };
  
  programs.git.settings = {
    user = {
      email = lib.mkForce "hsum@trintech.com";
      name = lib.mkForce "Hugo Sum";
    };
  };
}
