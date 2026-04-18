{ inputs, lib, config, pkgs, unstable, ... }:
let username = "hsum";
in {
  home = {
    username = lib.mkForce username;
    homeDirectory = lib.mkForce "/Users/${username}";
    packages = with pkgs; [ docker_28 (azure-cli.withExtensions [ pkgs.azure-cli.extensions.azure-devops ]) unstable.claude-code];
  };
  
  programs.git.settings = {
    user = {
      email = lib.mkForce "hsum@trintech.com";
      name = lib.mkForce "Hugo Sum";
    };
  };
}
