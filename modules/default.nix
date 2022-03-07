# Entry-point to the fly Nix base modules.

{ config, lib, pkgs, ... }:

{
  imports = [
    ./container.nix
    ./helpers.nix
    ./nixpkgs.nix
  ];
}
