#
# This can be replaced by any method of tracking inputs.
#   - niv     https://github.com/nmattia/niv
#   - npins   https://github.com/andir/npins
#   - Flakes  https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html
#
# Using this simple purely-Nix shim serves as a placeholder.

let
  toml = (builtins.fromTOML (builtins.readFile ../nix.toml));
  rev = toml.build.nix_base_revision or "7f455becd1491747d88c0bdb01deb81f5d2a3024";
  sha256 = toml.build.nix_base_sha256 or "sha256:1nw5l177byk2p69cdc9s5hps1qd3llgg0pppv4b9avlpw5x1wlz7";
  tarball = builtins.fetchTarball {
    url = "https://github.com/fly-apps/nix-base/archive/${rev}.tar.gz";
    inherit sha256;
  };
in import tarball
