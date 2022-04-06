{ config, lib, pkgs, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
  ;
  inherit (config.outputs) app;
in
{

  options = {
    templates.rails = {
      enable = mkEnableOption "the Rails template";
      assetInputs = mkOption {
        type = with types; listOf str;
        description = ''
          Project-relative paths to be included in the assets pre-compilation step.

          Default includes the minimum needed for a basic Rails app.
        '';
      };
      gemInputs = mkOption {
        type = with types; listOf str;
        # NOTE: if needed for e.g. local gems, add an additional option that
        #       adds to this internal implementation detail.
        internal = true;
        description = ''
          Project-relative paths to be included for the gems.

          Default includes the minimum assumed required.
        '';
      };
      outputs = {
        assets = mkOption {
          type = types.package;
          internal = true;
          description = ''
            Pre-compiled assets.
          '';
        };
      };
    };
  };

  config = mkIf (config.templates.rails.enable) {
    templates.rails.assetInputs = [
      "app/assets"
      "app/javascript"
      "vendor/javascript"

      # The following components are required for things to work correctly.
      "bin/rails"
      "config"
      "lib/tasks"
      "Rakefile"
      "config.ru"
    ] ++ config.templates.rails.gemInputs;

    templates.rails.gemInputs = [
      "Gemfile"
      "Gemfile.lock"
      ".nix/gemset.nix"
    ];

    # The assets output is a specialization of the main project build.
    templates.rails.outputs.assets = (app.override {
      # The source path is reduced to include only files relevant to the
      # assets pre-compilation
      source = pkgs.fly.keepPaths {
        root = config.app.source;
        paths = config.templates.rails.assetInputs;
      };
    }).overrideAttrs({ installPhase ? "", ... }: {
      # The installPhase is modified to only output the assets build.
      installPhase = ''
        ${installPhase}

        # The main build copied the source to the out path.
        # Clean it up
        rm -rf $out

        # Needs to be created beforehand
        # NOTE: To start from a cached build, copy it here
        mkdir -p public/assets

        # Build the assets
        bundle exec rails assets:precompile

        mkdir -p $out/public
        cp -prf public/assets $out/public/assets
      '';
    });

    outputs = {
      app = pkgs.callPackage (

        { stdenv
        , runCommandNoCC
        , lib
        , ruby
        , bundlerEnv

        # Source of the app
        , source
        # Groups installed in the bundler environment.
        , groups ? [ "default" ]
        }:

        let
          # Cheats and mark unwanted groups optional.
          gemfile =
            let
              # All unique groups referenced in `gemset.nix`; should map to all groups
              # actually present in the Gemfile.
              allGroups = lib.unique (builtins.concatLists (
                lib.mapAttrsToList
                (k: v: v.groups)
                (import (source + "/.nix/gemset.nix"))
              ));

              # [ "default" "development" "test" ] - [ "default ] ⇒ [ "development" "test" ]
              selectedGroups = lib.subtractLists groups allGroups;
            in
            if groups == null
            then source + "/Gemfile"
            else (runCommandNoCC "patched-gemfile" {} ''
              cat ${source}/Gemfile > $out
              cat >> $out <<EOF

              # Mark unwanted groups as "optional" such that we don't need to rely
              # on "BUNDLE_WITHOUT" listing all these groups in an additional layer
              # of wrappers to make bundler happy with missing gems.
              ${lib.concatMapStringsSep "\n" (
                name: "group :${name}, optional: true do end"
              ) selectedGroups}
              EOF
            '')
          ;

          gems = bundlerEnv {
            name = "rails-nix-gems";
            gemset = source + "/.nix/gemset.nix";
            inherit ruby groups gemfile;
            # Keep only files relevant to gems
            gemdir = pkgs.fly.keepPaths {
              root = source;
              paths = config.templates.rails.gemInputs;
            };
          };
        in
        stdenv.mkDerivation {
          name = "rails-app";

          src = source;

          buildInputs = [
            gems
            gems.wrappedRuby
          ];

          installPhase = ''
            cp -vr . $out
          '';

          passthru = {
            inherit ruby;
            inherit gems;
            inherit (gems) wrappedRuby;
          };
        }

      ) {
        inherit (config.app) source ;
        ruby = config.runtimes.ruby.package;
      };

      shell = config.outputs.app.override {
        # Forces all gems to be present
        groups = null;
      };
    };

    # Container layers configuration
    container.applicationLayers = [
      # Runtime
      { contents = [ app.ruby ]; }
      { contents = [ app.wrappedRuby ]; }

      # Pre-built assets
      { contents = [ config.templates.rails.outputs.assets ]; }

      # The app itself
      {
        contents = [ app ];
        config = {
          Cmd = [ "rails" "server" ];
        };
      }
    ];
  };
}
