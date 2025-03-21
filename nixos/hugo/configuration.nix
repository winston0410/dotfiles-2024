{ config, pkgs, lib, inputs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # limit max generations to 5
  boot.loader.systemd-boot.configurationLimit = 5;

  boot.plymouth.enable = true;
  # boot.plymouth.themePackages = with pkgs; [ nixos-bgrt-plymouth ];
  # boot.plymouth.theme = "nixos-bgrt";
  boot.plymouth.theme = "breeze";
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
  # so the boot loader screen does not look blurry
  boot.loader.systemd-boot.consoleMode = "max";

  networking.hostName = "nixos";
  networking.wireless.enable = false;
  networking.networkmanager.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_6_12;
  boot.kernelParams = [ ] ++ (lib.lists.optionals config.hardware.nvidia.open [
    "nvidia_drm.modeset=1"
    "mem_sleep_default=deep"
  ]) ++ (lib.lists.optionals config.boot.plymouth.enable [ "quiet" "splash" ]);
  boot.tmp.cleanOnBoot = true;

  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    modesetting.enable = true;
    open = true;
    powerManagement.enable = true;
    # NOTE my current CPU 7500F does not come with iGPU, therefore we cannot use any offload mode
    powerManagement.finegrained = false;
  };
  # REF https://nixos.wiki/wiki/Scanners
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
    disabledDefaultBackends = [ "escl" ];
  };
  services.udev.packages = [ pkgs.sane-airscan ];
  services.ipp-usb.enable = true;
  # scanner section end
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.excludePackages = with pkgs; [ xterm ];
  programs.dconf.enable = true;
  programs.ssh.enableAskPassword = false;
  services.gnome.gnome-keyring.enable = true;
  services.gnome.games.enable = false;
  services.gnome.core-utilities.enable = false;
  services.gnome.gnome-browser-connector.enable = true;
  environment.gnome.excludePackages =
    (with pkgs; [ gnome-tour gnome-shell-extensions ]);
  programs.gnome-terminal.enable = true;

  # gnome RDP
  services.gnome.gnome-remote-desktop.enable = true;
  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager =
    "${pkgs.gnome-session}/bin/gnome-session";
  services.xrdp.openFirewall = true;
  # NOTE disable suspend completely, as Nvidia GPU does not work correctly on suspend without offloading mode, and we do not have iGPU for offloading
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  security.sudo-rs.enable = true;
  security.pam.services.gdm-password.enableGnomeKeyring = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  # NOTE OpenRGB does not support XPG Lancer Blade RGB yet, cannot turn off RGB light on RAM
  services.hardware.openrgb.enable = true;
  services.hardware.openrgb.motherboard = "amd";
  # REF https://nixos.wiki/wiki/OpenRGB
  systemd.services.no-rgb = let
    no-rgb = pkgs.writeShellScriptBin "no-rgb" ''
      NUM_DEVICES=$(${pkgs.openrgb}/bin/openrgb --noautoconnect --list-devices | grep -E '^[0-9]+: ' | wc -l)

      for i in $(seq 0 $(($NUM_DEVICES - 1))); do
        ${pkgs.openrgb}/bin/openrgb --noautoconnect --device $i --mode static --color 000000
      done
    '';
  in {
    description = "no-rgb";
    serviceConfig = {
      ExecStart = "${no-rgb}/bin/no-rgb";
      Type = "oneshot";
    };
    wantedBy = [ "multi-user.target" ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kghugo = {
    isNormalUser = true;
    description = "kghugo";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };

  services.displayManager.autoLogin.enable = false;
  # Enable automatic login for the user.
  # services.displayManager.autoLogin.enable = true;
  # services.xserver.displayManager.autoLogin.user = "kghugo";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  # systemd.services."getty@tty1".enable = false;
  # systemd.services."autovt@tty1".enable = false;

  nixpkgs.config.allowUnfree = true;
  programs.nano.enable = false;
  environment.systemPackages = with pkgs; [
    vim
    git-credential-manager
    # NOTE to allow all console applications to use system Xserver clipboard
    xclip
  ];
  nix.gc = {
    automatic = true;
    dates = "*-*-* 21:00:00";
    options = "--delete-older-than 7d";
  };
  nix.optimise = {
    automatic = true;
    dates = [ "*-*-* 21:00:00" ];
  };
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
    allowedUDPPortRanges = [{
      from = 1024;
      to = 65534;
    }];
  };
  networking.nftables.enable = true;
  programs.git = {
    enable = true;
    config = {
      core = { editor = "${pkgs.vim}/bin/vim"; };
      user = {
        name = "nobody";
        email = "johndoe@example.com";
      };
      credential = {
        credentialStore = "cache";
        helper = [ "manager" ];
      };
    };
  };
  # NOTE cannot move this to home-manager layer. Revisit this later
  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };
  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    ibus.engines = with pkgs; [ ibus-engines.rime ibus-engines.hangul ];
  };

  virtualisation = {
    containers = { enable = true; };
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # TODO move this to home-manager config in the future
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extest = { enable = true; };
    protontricks = { enable = true; };
  };
  # Steam own hardware support
  hardware.steam-hardware.enable = true;
  # Xbox controller support
  hardware.xpadneo.enable = true;
  xdg.portal = { enable = true; };

  documentation.nixos.enable = false;
  nix.settings.trusted-users = [ "@wheel" ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # REF https://nixos-and-flakes.thiscute.world/best-practices/nix-path-and-flake-registry
  nix.channel.enable = false;
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";
  nix.settings.nix-path = lib.mkForce "nixpkgs=/etc/nix/inputs/nixpkgs";

  system.stateVersion = "24.11"; # Did you read the comment?

}
