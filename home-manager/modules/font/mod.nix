{ inputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [
    nerdfonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "Noto Sans Mono CJK HK" ];
      serif = [ "Noto Serif CJK HK" ];
      sansSerif = [ "Noto Sans CJK HK" ];
    };
  };
}
