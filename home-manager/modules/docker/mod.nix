{ inputs, lib, config, pkgs, ... }: {
  services.podman = {
    enable = true;

  };
  home.packages = with pkgs; [ podman ];

  home.shellAliases = { docker = "podman"; };
}
