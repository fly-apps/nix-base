{ pkgs # Refers to the Nixpkgs eval
, lib
}:

# Interface used in projects:
{ config ? {} }:

let
  # Modules added from `pkgs.path` need to be added **before** evaluation.
  # Or else `pkgs.path` depends on the modules eval, making an infinite recursion.
  fromNixpkgs = map (module: "${toString pkgs.path}/nixos/modules/${module}");
  modulesFromNixpkgs = fromNixpkgs [
    "misc/assertions.nix"
  ];
in

{
  eval = (lib.evalModules {
    modules = [
      # Get `pkgs` in there
      {
        # Prevents `<unknown-file>` from being reported.
        _file = ./eval-spec.nix;
        # Provides the `pkgs` argument for modules.
        _module.args.pkgs = pkgs;
      }
    ] ++
    modulesFromNixpkgs ++
    [
      # Import the local modules
      ../modules
      # Apply the user config
      config
    ];
  });
}
