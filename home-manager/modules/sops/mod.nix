{ inputs, unstable, lib, config, pkgs, ... }: {
  sops = { age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt"; };
}
