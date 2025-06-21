{
  description = "My system flake";

  # REF https://github.com/Mic92/sops-nix
  # investigate later
  inputs = {
    proxy-flake.url = "github:winston0410/proxy-flake?main";
    nixpkgs.follows = "proxy-flake/nixpkgs";
    nur.follows = "proxy-flake/nur";
    flake-parts.follows = "proxy-flake/flake-parts";
    sops-nix.follows = "proxy-flake/sops-nix";

    unstable.url = "github:nixos/nixpkgs";

    nixd.url = "github:nix-community/nixd";

    darwin.url = "github:lnl7/nix-darwin";

    rust-overlay.url = "github:oxalica/rust-overlay?tag=snapshot/2025-01-11";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";
    nixpkgs-firefox-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, unstable, home-manager, nixd, darwin, rust-overlay
    , sops-nix, nur, nixpkgs-firefox-darwin, ... }@inputs:

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
            system = darwinArmSystem;
            unstable = unstable.legacyPackages.aarch64-darwin;
          };
          modules = [
            inputs.sops-nix.homeManagerModules.sops
            ./home-manager/darwin.nix
          ];
        };
        "linux" = home-manager.lib.homeManagerConfiguration {
          pkgs = linuxAmdPkgs;
          extraSpecialArgs = {
            inherit inputs outputs;
            system = linuxAmdSystem;
            unstable = unstable.legacyPackages.x86_64-linux;
          };
          modules = [
            inputs.sops-nix.homeManagerModules.sops
            ./home-manager/linux.nix
          ];
        };
        "wsl" = home-manager.lib.homeManagerConfiguration {
          pkgs = linuxAmdPkgs;
          extraSpecialArgs = {
            inherit inputs outputs;
            system = linuxAmdSystem;
            unstable = unstable.legacyPackages.x86_64-linux;
          };
          modules =
            [ inputs.sops-nix.homeManagerModules.sops ./home-manager/wsl.nix ];
        };
      };

      nixosConfigurations = {
        hugo = nixpkgs.lib.nixosSystem {
          system = linuxAmdSystem;
          modules =
            [ ./nixos/hugo/configuration.nix sops-nix.nixosModules.sops ];
          specialArgs = { inherit inputs outputs; };
        };
      };

      darwinConfigurations = {
        "darwin" = darwin.lib.darwinSystem {
          system = darwinArmSystem;
          modules = [{
            # REF https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.enableCompletion
            environment.pathsToLink = [ "/share/zsh" ];

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
