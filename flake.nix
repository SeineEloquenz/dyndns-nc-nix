{
  description = "A very basic flake";

  outputs = { self, nixpkgs }:
  let

    pkgsx86 = import nixpkgs { system = "x86_64-linux"; };
    pkgsArm = import nixpkgs { system = "aarch64-linux"; };
    dyndns-nc-x86 = pkgsx86.callPackage ./package.nix {};
    dyndns-nc-aarch = pkgsArm.callPackage ./package.nix {};
    hass-adapter = ./src/hass_config_adapter.php;

    container = pkgs: pkgs.dockerTools.buildLayeredImage {
      name = "ghcr.io/seineeloquenz/dyndns-netcup";
      tag = "v0.1.3";
      contents = [
        dyndns-nc-aarch
      ];
      config = {
        EntryPoint = [ "${dyndns-nc-aarch}/bin/dyndns-nc" "--config" "${hass-adapter}" ];
      };
    };

  in {

    nixosModules.default = import ./module.nix;

    packages.x86_64-linux.dyndns-nc = dyndns-nc-x86;

    packages.x86_64-linux.default = self.packages.x86_64-linux.dyndns-nc;

    containers.hass-addon = {
      x86_64-linux = container pkgsx86;
      aarch64-linux = container pkgsArm;
    };
  };
}
