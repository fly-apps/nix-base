{ lib, closureInfo, dockerTools }:

let
  inherit (lib)
    foldl
  ;
in
{
  buildSpecifiedLayers =
    { layeredContent
    # An image to start building from. Note that store path deduplication will
    # not be attempted when starting from an existing image.
    , fromImage ? null
    }:
    (
      foldl (prev:
        # Name of the layer.
        { name ? "layer"
        # Derivations to directly include in the layer.
        # The content of the store path of these derivations (and not their
        # dependencies) will be linked at the root of the image.
        , contents ? []
        # Commands to run in the context of the layer build.
        # The result will not be copied in the Nix store, meaning access rights
        # and other properties stripped by the Nix store are kept.
        , extraCommands ? ""
        # Any extra given to `buildLayeredImage`.
        , ...
        }@layerConfig:
        let
          # Increases the layer count.
          maxLayers = prev.maxLayers + 1;
          layer = {
            layerNumber = prev.layerNumber + 1;
            inherit maxLayers;
            contents = prev.contents ++ contents;
            currentStorePaths = "${closureInfo { rootPaths = contents; }}/store-paths";
            previousStorePaths = "${closureInfo { rootPaths = prev.contents; }}/store-paths";

            image = dockerTools.buildLayeredImage (layerConfig // {
              inherit name;
              # Layer on top of the previous step.
              fromImage = prev.image;
              # We're consuming only one layer per step, but `buildLayeredImage`
              # assumes there is at least one layer for store paths, and one
              # customization layer.
              maxLayers = maxLayers + 1;
              # Skip the built-in implementation of the copy operation.
              includeStorePaths = false;
              # Since we're skipping the built-in implementation, let's add our store paths:
              extraCommands = ''
                paths() {
                  # Given:
                  #   - currentStorePaths = [ c d e f ]
                  #   - previousStorePaths = [ a b c e ]
                  # This returns [ d f ]
                  # `uniq -u` keeps only unique path entries, and we're duplicating unwanted inputs.
                  sort \
                    "${layer.currentStorePaths}" \
                    "${layer.previousStorePaths}" \
                    "${layer.previousStorePaths}" \
                    | uniq -u
                }

                echo ":: Building layer #${toString layer.layerNumber}"

                mkdir -p ./"$NIX_STORE"
                paths | while read path; do
                  echo " → Copying '$path' in layer"
                  cp -prf "$path" "./$path"
                done

                ${extraCommands}
              '';
            });
          };
        in
        layer
      )
      { contents = []; layerNumber = 0; maxLayers = 1; image = fromImage; }
      layeredContent
    )
    # Export the build artifact (image) from the last step.
    .image
  ;
}
