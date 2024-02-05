{
  description = "My system flake";

  inputs = {
    flake-utils.url =
      "github:numtide/flake-utils?rev=ff7b65b44d01cf9ba6a71320833626af21126384";
    # Nixpkgs
    nixpkgs.url =
      # 23-05
      "github:nixos/nixpkgs?rev=621f51253edffa1d6f08d5fce4f08614c852d17e";
    unstable.url =
      # unstable
      "github:nixos/nixpkgs?rev=9d5d25bbfe8c0297ebe85324addcb5020ed1a454";

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
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, unstable, home-manager, nixd, darwin, flake-utils, rust-overlay
    , ... }@inputs:
    # FIXME use system based config with flake-utils https://github.com/nix-community/home-manager/issues/3075
    # let
    #   inherit (self) outputs;
    #   darwinSystem = "aarch64-darwin";
    # in flake-utils.lib.eachSystem flake-utils.lib.allSystems (system: {
    #   homeConfigurations = {
    #     "hugosum" = home-manager.lib.homeManagerConfiguration {
    #       pkgs = nixpkgs.legacyPackages.aarch64-darwin;
    #       extraSpecialArgs = {
    #         inherit inputs outputs;
    #         system = system;
    #         unstable = unstable.legacyPackages.aarch64-darwin;
    #       };
    #       modules = [ ./home-manager/home.nix ];
    #     };
    #   };
    #
    #   darwinConfigurations = {
    #     machine1 = darwin.lib.darwinSystem {
    #       system = system;
    #       modules = [{
    #         nix.distributedBuilds = true;
    #         nix.buildMachines = [{
    #           hostName = "ssh://builder@localhost";
    #           system = builtins.replaceStrings [ "darwin" "linux" ] system;
    #           maxJobs = 4;
    #           supportedFeatures = [ "kvm" "benchmark" "big-parallel" ];
    #         }];
    #       }];
    #     };
    #   };
    # });
    let
      inherit (self) outputs;
      darwinSystem = "aarch64-darwin";
      linuxSystem =
        builtins.replaceStrings [ "darwin" ] [ "linux" ] darwinSystem;
      # pkgs = nixpkgs.legacyPackages."${darwinSystem}";

        pkgs = import nixpkgs {
          system = darwinSystem;
          overlays = [ rust-overlay.overlays.default ];
        };

      darwin-builder = nixpkgs.lib.nixosSystem {
        system = linuxSystem;
        modules = [
          "${nixpkgs}/nixos/modules/profiles/macos-builder.nix"
          {
            virtualisation.host.pkgs = pkgs;
            # REF https://github.com/NixOS/nixpkgs/issues/229542
            system.nixos.revision = nixpkgs.lib.mkForce null;
          }
        ];
      };
    in {
      homeConfigurations = {
        "hugosum" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs;
          extraSpecialArgs = {
            inherit inputs outputs;
            system = darwinSystem;
            unstable = unstable.legacyPackages.aarch64-darwin;
          };
          modules = [ ./home-manager/home.nix ];
        };
      };

      darwinConfigurations = {
        "hugosum" = darwin.lib.darwinSystem {
          system = darwinSystem;
          modules = [{
            nix.distributedBuilds = true;
            nix.buildMachines = [{
              hostName = "localhost";
              sshUser = "builder";
              system = linuxSystem;
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
