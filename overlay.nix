final: super:

let
  inherit (final) callPackage;
  inherit (final.lib) genAttrs;

  #
  # Simple wrapper around `import` that works like `callPackage`, but does not
  # shadow `override`.
  # When using `callPackage, `callPackage` adds its own `override` function to
  # override the inputs. This can be problematic if the overlaid expression is
  # intended to be further manipulated as-is.
  #
  # Use this when overriding versions in packages from Nixpkgs.
  # Do not use for newly added packages or helpers.
  #
  callPackageNotOverridable = file: args:
    let 
      fn = import file;
      fnArgs = builtins.attrNames (builtins.functionArgs fn);
      selectedArgs = genAttrs fnArgs (name: final."${name}");
    in
    fn selectedArgs
  ;
in
{
  ruby_2_7_4 = callPackageNotOverridable ./pkgs/ruby/2.7.4.nix { };
  ruby_2_7_5 = callPackageNotOverridable ./pkgs/ruby/2.7.5.nix { };
  ruby_3_1_1 = callPackageNotOverridable ./pkgs/ruby/3.1.1.nix { };

  defaultGemConfig = callPackage ./pkgs/ruby/gem-config.nix {
    defaultGemConfig = super.defaultGemConfig;
  };

  fly = final.lib.makeScope final.newScope (self: {
    evalSpec = callPackage ./support/eval-spec.nix { };

    # Image tools and helpers
    baseLayer = callPackage ./support/base-layer.nix { };
    imageTools = callPackage ./support/image-tools.nix { };

    keepPaths = callPackage ./support/keep-paths.nix {
      nix-filter = import (builtins.fetchurl {
        url = "https://raw.githubusercontent.com/numtide/nix-filter/e4e8649a3b6f0d3c181955945a84e6918d3f832a/default.nix";
        sha256 = "17s5q9fjwxivr0gjq9bqyias1s38wn78znk3a93q8g05jzgn94wq";
      });
    };
  });
}
