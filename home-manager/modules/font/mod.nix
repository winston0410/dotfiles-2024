{ inputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [
    nerd-fonts._0xproto
    dejavu_fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "0xProto Nerd Font Mono" "Noto Sans Mono CJK HK" "DejaVu Sans Mono" ];
      serif = [ "Noto Serif CJK HK" ];
      sansSerif = [ "Inter" "Noto Sans CJK HK" ];
    };
  };
}
