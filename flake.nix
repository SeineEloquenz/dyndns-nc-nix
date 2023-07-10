{
  description = "A very basic flake";

  outputs = { self, nixpkgs }:
  let

    pkgs = import nixpkgs { system = "x86_64-linux"; };

  in {

    nixosModules.default = import ./module.nix;

    packages.x86_64-linux.dyndns-nc = pkgs.callPackage ./package.nix {};

    packages.x86_64-linux.default = self.packages.x86_64-linux.dyndns-nc;

  };
}
