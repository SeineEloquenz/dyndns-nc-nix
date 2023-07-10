{ lib
, php
, stdenv
, fetchFromGitHub
}:

let

  myPhp = (php.buildEnv {
    extensions = ({ enabled, all }: enabled ++ (with all; [
      curl
    ]));
  });

in stdenv.mkDerivation rec {

  pname = "dyndns-nc";
  version = "4.0";

  src = fetchFromGitHub {
    owner = "stecklars";
    repo = "dynamic-dns-netcup-api";
    rev = "v${version}";
    hash = "sha256-dmkB4TDC459Aogz8Da/TjcIjb/T7NH8MTRnREeJXiG4=";
  };

  buildInputs = [
    myPhp
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src/functions.php $out/bin/functions.php
    cp $src/update.php $out/bin/dyndns-nc
  '';
}
