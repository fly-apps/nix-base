{ config, lib, pkgs, ... }:

let
  inherit (lib)
    mkOption
    types
  ;
in
{
  options = {
    app = {
      source = mkOption {
        type = with types; oneOf [ path package ];
        description = ''
          Source of the application.
        '';
      };
    };

    outputs = {
      app = mkOption {
        type = with types; nullOr package;
        default = null; # to allow usage of assertions for errors.
        description = ''
          The application to run.
        '';
      };
    };
  };

  config = {
    assertions = [
      {
        assertion = config.outputs.app != null;
        message = "No application output for the current configuration.";
      }
    ];
  };
}
