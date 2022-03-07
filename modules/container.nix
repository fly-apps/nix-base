{ config, lib, pkgs, ... }:

let
  inherit (lib)
    mkDefault
    mkIf
    mkOption
    types
  ;
  inherit (config.helpers) applyAssertions;
  layerType = with types; submodule {
    options = {
      contents = mkOption {
        type = listOf package;
        default = [];
        description = ''
          Derivations that will be copied in the new layer.

          Content of the derivations will be linked at the root, but content of
          transitive dependencies will only be copied to the Nix store path.
        '';
      };
      config = mkOption {
        type = attrsOf unspecified;
        default = {};
        description = ''
          `config` is used to specify the configuration of the containers that
          will be started off the built image in Docker. The available options
          are listed in the [Docker Image Specification v1.2.0](https://github.com/moby/moby/blob/master/image/spec/v1.2.md#image-json-field-descriptions).
        '';
      };
    };
  };
in
{
  options = {
    container = {
      additionalLayers = mkOption {
        type = types.listOf layerType;
        default = [];
        description = ''
          List of additional layers to include in the container image.

          They are added between the base runtime layers, and the application-specific layers.
        '';
      };
      applicationLayers = mkOption {
        type = types.listOf layerType;
        default = [];
        description = ''
          List of application-specific layers to include in the container image.
        '';
      };
      includeBaseLayer = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to include the base runtime layer or not.
        '';
      };
      fromImage = mkOption {
        type = with types; nullOr package;
        default = null;
        internal = true;
        description = ''
          An image to use as a starting point.

          Left internal; it shouldn't be configured by end-users.
        '';
      };
    };

    outputs = {
      container.image = mkOption {
        type = types.package;
        description = ''
          The container image.
        '';
      };
    };
  };

  config = {
    container = {
      fromImage = mkIf config.container.includeBaseLayer (mkDefault pkgs.fly.baseLayer);
    };
    outputs = {
      container.image = applyAssertions (pkgs.fly.imageTools.buildSpecifiedLayers {
        inherit (config.container) fromImage;
        layeredContent =
          config.container.additionalLayers ++
          config.container.applicationLayers
        ;
      });
    };
  };
}
