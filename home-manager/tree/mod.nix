{ inputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [ tre-command ];

  home.shellAliases = { tree = "tre"; };
}
