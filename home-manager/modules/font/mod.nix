{ inputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [
    nerd-fonts._0xproto
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "0xProto Nerd Font Mono" "Noto Sans Mono CJK HK" ];
      serif = [ "Noto Serif CJK HK" ];
      sansSerif = [ "Inter" "Noto Sans CJK HK" ];
    };
  };
}
