{ pkgs
, libopus
}:
with pkgs.callPackage ../mixnix/nix/mix2nix.nix {};

mkMixPackage rec {
  name = "lib_opus";
  version = "0.0.1";
  src = ./.;
  mixNix = ./mix.nix;

  buildInputs = [ libopus ];
}
