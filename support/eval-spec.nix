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
    "misc/nixpkgs.nix"
  ];

  # Default nixpkgs module config
  # Referring to the input `pkgs` needs to be done outside the actual modules eval.
  nixpkgsConfig = {
    nixpkgs = {
      pkgs = lib.mkOptionDefault pkgs;
      system = lib.mkOptionDefault pkgs.system;
      initialSystem = lib.mkOptionDefault pkgs.system;
    };
  };
in

{
  eval = (lib.evalModules {
    modules = [
      # Get `pkgs` in there
      { _module.args.pkgs = pkgs; }
    ] ++
    modulesFromNixpkgs ++
    [
      nixpkgsConfig
      # Import the local modules
      ../modules
      # Apply the user config
      config
    ];
  });
}
