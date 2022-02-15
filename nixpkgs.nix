#
# This can be replaced by any method of tracking inputs.
#   - niv     https://github.com/nmattia/niv
#   - npins   https://github.com/andir/npins
#   - Flakes  https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html 
#
# Using this simple purely-Nix shim serves as a placeholder.

let
  # Tracking https://github.com/NixOS/nixpkgs/tree/nixos-21.11
  rev = "c28fb0a4671ff2715c1922719797615945e5b6a0"; # nixos-21.11
  sha256 = "sha256:1qzvhxcsxb6s410xlfs4ggcvm1xbbd4jrazy6cpxc1rkrxbyz0kk";
  tarball = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
    inherit sha256;
  };
in
  # The builtins.trace is optional; serves as a reminder.
  builtins.trace "Using default Nixpkgs revision '${rev}'..."
  (import tarball)
