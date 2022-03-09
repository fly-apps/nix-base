#
# This can be replaced by any method of tracking inputs.
#   - niv     https://github.com/nmattia/niv
#   - npins   https://github.com/andir/npins
#   - Flakes  https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html
#
# Using this simple purely-Nix shim serves as a placeholder.

let
  # Tracking https://github.com/NixOS/nixpkgs/tree/nixos-21.11
  rev = "a7ecde854aee5c4c7cd6177f54a99d2c1ff28a31";
  sha256 = "sha256:162dywda2dvfj1248afxc45kcrg83appjd0nmdb541hl7rnncf02";
  tarball = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
    inherit sha256;
  };
in
  # The builtins.trace is optional; serves as a reminder.
  builtins.trace "Using default Nixpkgs revision '${rev}'..."
  (import tarball)
