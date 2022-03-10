{ config, lib, pkgs, ... }:

let
  inherit (lib)
    mkDefault
    mkForce
    mkMerge
    mkOption
    types
  ;
  inherit (config.runtimes.ruby)
    rubyInterpreters
  ;
in
{
  options = {
    runtimes = {
      ruby = {
        version = mkOption {
          type = types.enum (builtins.attrNames rubyInterpreters);
          default = pkgs.ruby.version.majMinTiny;
          description = ''
            Version of the Ruby interpreter to use.
          '';
        };
        package = mkOption {
          type = types.package;
          internal = true;
          description = ''
            The selected Ruby package.

            Note that overriding this option with a Ruby package will not
            intrinsically configure it with version or features customization.

            When overriden, the overriden version will be used as-is.
          '';
        };
        rubyInterpreters = mkOption {
          type = with types; attrsOf package;
          description = ''
            Definition of known Ruby interpreters
          '';
          internal = true;
        };
      };
    };
  };

  config = {
    runtimes.ruby = {
      package = mkDefault (rubyInterpreters."${config.runtimes.ruby.version}");
      rubyInterpreters = mkMerge [
        # Ruby packages maintained in the Fly overlay
        {
          "2.7.4" = pkgs.ruby_2_7_4;
          "2.7.5" = pkgs.ruby_2_7_5;
          "3.1.1" = pkgs.ruby_3_1_1;
        }
        # Force the default `ruby` packages from Nixpkgs in the attrset.
        # It is important for the default `pkgs.ruby.version.majMinTiny` usage
        # in the default value for `runtimes.ruby.version`.
        {
          "${pkgs.ruby_2_7.version.majMinTiny}" = mkForce pkgs.ruby_2_7;
          "${pkgs.ruby_3_0.version.majMinTiny}" = mkForce pkgs.ruby_3_0;
          "${pkgs.ruby_3_1.version.majMinTiny}" = mkForce pkgs.ruby_3_1;
        }
      ];
    };
  };
}
