{ inputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [
    kubectl
    kubernetes-helm
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

      meta = with pkgs.lib; {
        description = "Source VS Deployed";
        homepage = "https://github.com/Ramilito/kubediff";
        license = licenses.mit;
        platforms = platforms.unix;
      };
    })
  ];
}
