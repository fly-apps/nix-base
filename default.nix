{ pkgs ? (import ./nixpkgs.nix {}) }:

# The evaluated expression here is the full Nixpkgs package set given as an
# input, *composed* with the provided overlay.
pkgs.appendOverlays [
  (import ./overlay.nix)
]
