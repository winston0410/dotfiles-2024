{
  description = "My system flake";

  # REF https://github.com/Mic92/sops-nix
  # investigate later
  inputs = {
    proxy-flake.url = "github:winston0410/proxy-flake/main";

    nixpkgs.follows = "proxy-flake/nixpkgs";
    nur.follows = "proxy-flake/nur";
    flake-parts.follows = "proxy-flake/flake-parts";
    sops-nix.follows = "proxy-flake/sops-nix";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    unstable.url = "github:nixos/nixpkgs";

    mac-app-util.url = "github:hraban/mac-app-util";
    mac-app-util.inputs.nixpkgs.follows = "nixpkgs";

    oxeylyzer.url = "github:o-x-e-y/oxeylyzer";
    oxeylyzer.inputs.nixpkgs.follows = "nixpkgs";
    oxeylyzer.inputs.rust-overlay.follows = "rust-overlay";

    emmylua-analyzer-rust.url = "github:EmmyLuaLs/emmylua-analyzer-rust";
    emmylua-analyzer-rust.inputs.nixpkgs.follows = "nixpkgs";
    emmylua-analyzer-rust.inputs.rust-overlay.follows = "rust-overlay";

    # unstable
    nixd.url = "github:nix-community/nixd";

    config-lsp.url = "github:Myzel394/config-lsp";
    config-lsp.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:lnl7/nix-darwin";

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs-firefox-darwin.url =
      "github:bandithedoge/nixpkgs-firefox-darwin?rev=7ae689d7b8a17209854d7966641d4201926f12c7";
    nixpkgs-firefox-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, unstable, home-manager, mac-app-util, nixd, darwin
    , rust-overlay, sops-nix, nur, nixpkgs-firefox-darwin, ... }@inputs:

    let
      inherit (self) outputs;
      lib = nixpkgs.lib;
      darwinArmSystem = "aarch64-darwin";
      linuxArmSystem =
        builtins.replaceStrings [ "darwin" ] [ "linux" ] darwinArmSystem;
      linuxAmdSystem = "x86_64-linux";

      overlays = [
        nur.overlays.default
      ];

      darwinArmPkgs = import nixpkgs {
        system = darwinArmSystem;
        overlays = overlays ++ [
          rust-overlay.overlays.default
          nixpkgs-firefox-darwin.overlay
        ];
      };
      linuxAmdPkgs = import nixpkgs {
        system = linuxAmdSystem;
        overlays = overlays;
      };

      linuxArmPkgs = import nixpkgs {
        system = linuxArmSystem;
        overlays = overlays;
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
        "darwin-work" = home-manager.lib.homeManagerConfiguration {
          pkgs = darwinArmPkgs;
          extraSpecialArgs = {
            inherit inputs outputs;
            system = darwinArmSystem;
            unstable = unstable.legacyPackages.aarch64-darwin;
          };
          modules = [
            mac-app-util.homeManagerModules.default
            inputs.sops-nix.homeManagerModules.sops
            ./home-manager/darwin.nix
            ./home-manager/darwin-work.nix
          ];
        };
        "darwin" = home-manager.lib.homeManagerConfiguration {
          pkgs = darwinArmPkgs;
          extraSpecialArgs = {
            inherit inputs outputs;
            system = darwinArmSystem;
            unstable = unstable.legacyPackages.aarch64-darwin;
          };
          modules = [
            mac-app-util.homeManagerModules.default
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

        "devcontainer-arm" = home-manager.lib.homeManagerConfiguration {
          pkgs = linuxArmPkgs;
          extraSpecialArgs = {
            inherit inputs outputs;
            system = linuxArmSystem;
            unstable = unstable.legacyPackages.aarch64-linux;
          };
          modules = [
            inputs.sops-nix.homeManagerModules.sops
            ./home-manager/devcontainer.nix
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
