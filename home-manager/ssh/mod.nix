{ inputs, lib, config, pkgs, ... }: {
  programs.ssh.enable = true;
  programs.ssh.matchBlocks = {
    "linux-builder" = {
      hostname = "localhost";
      # hostKeyAlias = "linux-builder";
      port = 31022;
    };
  };
}
