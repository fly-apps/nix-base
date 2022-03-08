{ lib, nix-filter }:

{ root, paths }:

nix-filter {
  inherit root;
  include =
    # Given a list of paths, provides prefixes so that the directories are
    # included in the `nix-filter` lookup.
    lib.flatten (
      map (str:
        let
          # "a/b/c" → [ "a" "b" "c" ]
          parts = lib.splitString "/" str;
          # [ "a" "b" "c" ] → [ "a" "a/b" "a/b/c" ]
          paths = lib.foldl (result: component:
          result ++ [((lib.last result) + "/" + component)]
          ) [ (lib.head parts) ] parts;
        in
        [
          parts
          (nix-filter.inDirectory str)
        ]
      ) paths 
    )
  ;
}
