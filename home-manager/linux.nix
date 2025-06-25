{ inputs, lib, config, pkgs, unstable, ... }: {
  imports = [
    ./modules/git/mod.nix
    ./modules/nvim/mod.nix
    ./modules/bat/mod.nix
    ./modules/lsd/mod.nix
    ./modules/wezterm/mod.nix
    ./modules/ripgrep/mod.nix
    ./modules/bottom/mod.nix
    ./modules/zsh/mod.nix
    ./modules/du/mod.nix
    ./modules/tree/mod.nix
    ./modules/font/mod.nix
    ./modules/k9s/mod.nix
    ./modules/android/mod.nix
    ./modules/xdg/mod.nix
    ./modules/sops/mod.nix
    ./modules/docker/mod.nix
    ./modules/vscode/mod.nix
    ./modules/gnome/mod.nix
    ./modules/firefox/mod.nix
    ./modules/email/mod.nix
    ./modules/steam/mod.nix
    ./modules/nix/mod.nix
  ];

  home = {
    username = "kghugo";
    homeDirectory = "/home/kghugo";
  };

  programs.zsh.initExtra = lib.mkBefore (''
    vaultwarden_password="$(secret-tool lookup service 'vaultwarden.28281428.xyz')"
    BW_SESSION_OUTPUT=$(bw unlock "$vaultwarden_password" --raw)
    if [ $? -eq 0 ]; then
        echo "Successfully unlocked Bitwarden vault"
    else 
        echo "Error: Failed to unlock Bitwarden vault"
    fi

    export BW_SESSION="$BW_SESSION_OUTPUT"
  '');

  home.packages = with pkgs; [
    dconf-editor
    libsecret
    signal-desktop
    element-desktop
    telegram-desktop
    spotube
    discord
    # REF https://github.com/NixOS/nixpkgs/pull/385105
    # kulala-ls
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
