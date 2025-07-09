{ inputs, unstable, lib, config, pkgs, ... }: {
  sops = { age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt"; };
  home.packages = [ pkgs.age pkgs.sops ];
}
