{ inputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [
    kubectl
    kubernetes-helm
    # FIXME cannot build this with Nix, as it requires kubectl-go
    # (pkgs.rustPlatform.buildRustPackage rec {
    #   pname = "kubectl_client";
    #   version = "v2.7.12";
    #
    #   src = pkgs.fetchFromGitHub {
    #     owner = "Ramilito";
    #     repo = "kubectl.nvim";
    #     rev = version;
    #     sha256 = "sha256-NZfc6juOUjlzVw0RbHNK319s/XI1Ed+vo1bHMhzwV1M=";
    #   };
    #
    #   cargoHash = "sha256-nbR8XTZEOaeAT7T3w75YfOFHc7C/T91hMTDbE+2TfO0=";
    #
    #   meta = with pkgs.lib; {
    #     homepage = "https://github.com/Ramilito/kubectl.nvim";
    #     license = licenses.mit;
    #     platforms = platforms.unix;
    #   };
    # })
    (pkgs.rustPlatform.buildRustPackage rec {
      pname = "kubediff";
      version = "0.1.7";

      src = pkgs.fetchFromGitHub {
        owner = "Ramilito";
        repo = "kubediff";
        rev = version;
        sha256 = "sha256-JGV3CnMFtOVZrETOdA4JAYPTenFSx91Ob/Uqmu+uW+Y=";
      };

      cargoHash = "sha256-hNM5P+hZb+EW8ymN1rOHxq1gVPZ9CcuKN2JbytP8nAA=";

      buildInputs = with pkgs; [ zlib ];

      meta = with pkgs.lib; {
        description = "Source VS Deployed";
        homepage = "https://github.com/Ramilito/kubediff";
        license = licenses.mit;
        platforms = platforms.unix;
      };
    })
  ];
}
