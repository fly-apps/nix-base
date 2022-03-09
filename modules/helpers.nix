{ config, lib , ... }:

let
  inherit (lib)
    concatStringsSep
    filter
    mkOption
    showWarnings
    types
  ;
  failedAssertions = map (x: x.message) (filter (x: !x.assertion) config.assertions);
  applyAssertions = result:
    if failedAssertions != []
    then throw "\nFailed assertions:\n${concatStringsSep "\n" (map (x: "- ${x}") failedAssertions)}"
    else showWarnings config.warnings result
  ;
in
{
  options.helpers = {
    applyAssertions = mkOption {
      type = with types; functionTo anything;
      internal = true;
      description = ''
        Helper that applies assertions before returning the argument.

        Use at any "end" of an evaluation, for example an image build, or an application build.
      '';
    };
  };

  config = {
    helpers = {
      inherit applyAssertions;
    };
  };
}
