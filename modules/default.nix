# Entry-point to the fly Nix base modules.

{ config, lib, pkgs, ... }:

{
  imports = [
    ./helpers.nix
    ./nixpkgs.nix
  ];
}
