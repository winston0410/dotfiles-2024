{ inputs, lib, config, pkgs, ... }:
{
  # # FIXME enable this once we have upgrade to 25.05, as this option does not exist in home-manager yet, and this module is failing to run
  # services.podman = { enable = true; };
  # # services.podman.settings.policy = { };
  # home.packages = with pkgs; [ podman ];
  #
  # home.shellAliases = { docker = "podman"; };
}
