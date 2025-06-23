{ inputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    nerd-fonts._0xproto
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
