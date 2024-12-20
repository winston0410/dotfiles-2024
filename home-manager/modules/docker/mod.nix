{ inputs, lib, config, pkgs, ... }: {
  services.podman = { enable = true; };
  # FIXME enable this once we have upgrade to 25.05
  # services.podman.settings.policy = { };
  home.packages = with pkgs; [ podman ];

  home.shellAliases = { docker = "podman"; };
}
