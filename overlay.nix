final: super:

let
  inherit (final) callPackage;
in
{
  ruby_2_7_4 = callPackage ./pkgs/ruby/2.7.4.nix { };
  ruby_2_7_5 = callPackage ./pkgs/ruby/2.7.5.nix { };

  defaultGemConfig = callPackage ./pkgs/ruby/gem-config.nix {
    defaultGemConfig = super.defaultGemConfig;
  };
}
