{ inputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [
    nerdfonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = [ ];
      sansSerif = [ ];
    };
  };
}
