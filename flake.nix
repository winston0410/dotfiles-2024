{
  description = "My system flake";

  # REF https://github.com/Mic92/sops-nix
  # investigate later

  inputs = {
    flake-utils.url =
      "github:numtide/flake-utils?rev=ff7b65b44d01cf9ba6a71320833626af21126384";
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/release-24.11";
    unstable.url =
      "github:nixos/nixpkgs?rev=75d54b468a2a51b38c56aa8d09e33ac38cd732bc";

    nixd.url =
      # unstable
      "github:nix-community/nixd?rev=29904e121cc775e7caaf4fffa6bc7da09376a43b";

    darwin.url =
      "github:lnl7/nix-darwin?rev=e67f2bf515343da378c3f82f098df8ca01bccc5f";

    rust-overlay.url =
      "github:oxalica/rust-overlay?rev=16ab5af8f23b63f34dd7a48a68ab3b50dc3dd2b6";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
    rust-overlay.inputs.flake-utils.follows = "flake-utils";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # nur
    nur.url =
      "github:nix-community/NUR?rev=142f0732df8dce2521240d9e1e983160a6a0c669";
    nur.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs-firefox-darwin.url =
      "github:bandithedoge/nixpkgs-firefox-darwin?rev=7ae689d7b8a17209854d7966641d4201926f12c7";
    nixpkgs-firefox-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, unstable, home-manager, nixd, darwin, flake-utils
    , rust-overlay, nur, nixpkgs-firefox-darwin, ... }@inputs:

    let
      inherit (self) outputs;
      lib = nixpkgs.lib;
      darwinArmSystem = "aarch64-darwin";
      linuxArmSystem =
        builtins.replaceStrings [ "darwin" ] [ "linux" ] darwinArmSystem;
      linuxAmdSystem = "x86_64-linux";

      darwinArmPkgs = import nixpkgs {
        system = darwinArmSystem;
        overlays = [
          rust-overlay.overlays.default
          nur.overlays.default
          nixpkgs-firefox-darwin.overlay
        ];
      };
      linuxAmdPkgs = import nixpkgs {
        system = linuxAmdSystem;
        overlays = [ nur.overlays.default ];
      };

      darwin-builder = nixpkgs.lib.nixosSystem {
        system = linuxArmSystem;
        modules = [
          "${nixpkgs}/nixos/modules/profiles/macos-builder.nix"
          {
            virtualisation.host.pkgs = darwinArmPkgs;
            # REF https://github.com/NixOS/nixpkgs/issues/229542
            system.nixos.revision = nixpkgs.lib.mkForce null;
          }
        ];
      };
    in {
      homeConfigurations = {
        "darwin" = home-manager.lib.homeManagerConfiguration {
          pkgs = darwinArmPkgs;
          extraSpecialArgs = {
            inherit inputs outputs;
            isDarwin = lib.strings.hasInfix "darwin" darwinArmSystem;
            system = darwinArmSystem;
            unstable = unstable.legacyPackages.aarch64-darwin;
          };
          modules = [ ./home-manager/darwin.nix ];
        };
        "linux" = home-manager.lib.homeManagerConfiguration {
          pkgs = linuxAmdPkgs;
          extraSpecialArgs = {
            inherit inputs outputs;
            isDarwin = lib.strings.hasInfix "darwin" linuxAmdSystem;
            system = linuxAmdSystem;
            unstable = unstable.legacyPackages.x86_64-linux;
          };
          modules = [ ./home-manager/linux.nix ];
        };
      };

      darwinConfigurations = {
        "darwin" = darwin.lib.darwinSystem {
          system = darwinArmSystem;
          modules = [{
            nix.distributedBuilds = true;
            nix.buildMachines = [{
              hostName = "localhost";
              sshUser = "builder";
              system = linuxArmSystem;
              maxJobs = 4;
              supportedFeatures = [ "kvm" "benchmark" "big-parallel" ];
              protocol = "ssh-ng";
            }];

            launchd.daemons.darwin-builder = {
              command =
                "${darwin-builder.config.system.build.macos-builder-installer}/bin/create-builder";
              serviceConfig = {
                KeepAlive = true;
                RunAtLoad = true;
                StandardOutPath = "/var/log/darwin-builder.log";
                StandardErrorPath = "/var/log/darwin-builder.log";
                WorkingDirectory = "/etc/nix/";
              };
            };
          }];
        };
      };
    };
}
