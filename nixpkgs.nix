#
# This can be replaced by any method of tracking inputs.
#   - niv     https://github.com/nmattia/niv
#   - npins   https://github.com/andir/npins
#   - Flakes  https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html
#
# Using this simple purely-Nix shim serves as a placeholder.

let
  # Tracking https://github.com/NixOS/nixpkgs/tree/master
  rev = "d44916d12f1d39baa02325040b381311364ad93a";
  sha256 = "sha256:1rbbxyl09z9wf0dzvc55sk52ia6px6g7hfcsh8w1wgqf85smx6lk";
  tarball = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
    inherit sha256;
  };
in
  # The builtins.trace is optional; serves as a reminder.
  builtins.trace "Using default Nixpkgs revision '${rev}'..."
  (import tarball)
