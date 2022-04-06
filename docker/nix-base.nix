#
# This can be replaced by any method of tracking inputs.
#   - niv     https://github.com/nmattia/niv
#   - npins   https://github.com/andir/npins
#   - Flakes  https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html
#
# Using this simple purely-Nix shim serves as a placeholder.

let
  # Use bin/update-nix.sh to get the latest values to place here
  toml = (builtins.fromTOML (builtins.readFile ../fly.toml));
  rev = toml.build.nix_base_revision;
  sha256 = toml.build.nix_base_sha256;
  tarball = builtins.fetchTarball {
    url = "https://github.com/fly-apps/nix-base/archive/${rev}.tar.gz";
    inherit sha256;
  };
in import tarball
