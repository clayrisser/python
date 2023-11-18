{ nixpkgs ? import <nixpkgs> {} }:

nixpkgs.stdenv.mkDerivation rec {
  name = "packages";
  LANG = "en_US.UTF-8";
  buildInputs = [
    nixpkgs.cloc
    nixpkgs.gnumake42
    nixpkgs.gnused
    nixpkgs.jq
  ];
}
