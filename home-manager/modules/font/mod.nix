{ inputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [
    nerdfonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      # monospace = [ "0xProto Nerd Font" "Noto Sans Mono CJK HK" ];
      # serif = [ "0xProto Nerd Font" "Noto Serif CJK HK" ];
      # sansSerif = [ "0xProto Nerd Font" "Noto Sans CJK HK" ];
      monospace = [ "Iosevka Nerd Font Mono" "Noto Sans Mono CJK HK" ];
      serif = [ "Iosevka Nerd Font" "Noto Serif CJK HK" ];
      sansSerif = [ "Iosevka Nerd Font" "Noto Sans CJK HK" ];
    };
  };
}
