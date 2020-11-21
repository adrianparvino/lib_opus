{ pkgs ? import <nixpkgs> {} }:

let this = (pkgs.callPackage ./. {}).overrideAttrs (_: {
      MIX_ENV = "dev";
    });
in pkgs.mkShell {
  inputsFrom = [ this ];
  buildInputs = with pkgs; [ inotify-tools ];
}
