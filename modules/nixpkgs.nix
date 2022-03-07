{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (import ../overlay.nix)
  ];
}
