#
# This can be replaced by any method of tracking inputs.
#   - niv     https://github.com/nmattia/niv
#   - npins   https://github.com/andir/npins
#   - Flakes  https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html
#
# Using this simple purely-Nix shim serves as a placeholder.

let
  # Tracking https://github.com/NixOS/nixpkgs/tree/nixos-unstable
  rev = "0c7c76fa9e2f5c7b446c1182c79eabac08588392";
  sha256 = "sha256:0n0j1zg237pfjr1xg2cpg8fwj0fg93knwrxxjv7xwqdks7jy89yf";
  tarball = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
    inherit sha256;
  };
in
  # The builtins.trace is optional; serves as a reminder.
  builtins.trace "Using default Nixpkgs revision '${rev}'..."
  (import tarball)
