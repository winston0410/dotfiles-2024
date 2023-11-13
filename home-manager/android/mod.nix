{ inputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [ ];

  home.sessionVariables = { ANDROID_HOME = "$HOME/Library/Android/sdk"; };
}
