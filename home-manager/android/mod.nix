{ inputs, lib, config, pkgs, ... }: {
  imports = [ ./lsp.nix ./formatter.nix ];

  home.packages = with pkgs; [ ];

  home.sessionVariables = { ANDROID_HOME = "$HOME/Library/Android/sdk"; };
}
