{
  description = "A very basic flake";

  outputs = { self, nixpkgs }:
  let

    pkgs = import nixpkgs { system = "x86_64-linux"; };
    dyndns-nc = pkgs.callPackage ./package.nix {};
    hass-adapter = ./src/hass_config_adapter.php;

  in {

    nixosModules.default = import ./module.nix;

    packages.x86_64-linux.dyndns-nc = dyndns-nc;

    packages.x86_64-linux.default = self.packages.x86_64-linux.dyndns-nc;

    containers.hass-addon = pkgs.dockerTools.buildLayeredImage {
      name = "ghcr.io/seineeloquenz/dyndns-netcup";
      tag = "v0.1.2";
      contents = [
        dyndns-nc
      ];
      config = {
        EntryPoint = [ "${dyndns-nc}/bin/dyndns-nc" "--config" "${hass-adapter}" ];
      };
    };
  };
}
