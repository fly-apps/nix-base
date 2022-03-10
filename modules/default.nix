# Entry-point to the fly Nix base modules.

{ config, lib, pkgs, ... }:

{
  imports = [
    ./app.nix
    ./container.nix
    ./helpers.nix
    ./runtimes
    ./templates
  ];
}
