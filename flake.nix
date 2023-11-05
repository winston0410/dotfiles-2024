{
  description = "Your new nix config";

  inputs = {
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

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, unstable, home-manager, nixd, ... }@inputs:
    let inherit (self) outputs;
    in {

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        "hugosum" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          extraSpecialArgs = {
            inherit inputs outputs;
            unstable = unstable.legacyPackages.aarch64-darwin;
          };
          modules = [ ./home-manager/home.nix ];
        };
      };
    };
}
