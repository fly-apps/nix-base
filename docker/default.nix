{ nix-base ? (import ./nix-base.nix {})
}:
let
  toml = if builtins.pathExists ../nix.toml then
    (builtins.fromTOML (builtins.readFile ../nix.toml))
  else
    "";
in
(nix-base.fly.evalSpec) {
  config = { pkgs, ... }: {
    templates.rails.enable = true;
    app.source = ../.;
    runtimes.ruby.version = toml.runtime.ruby_version or "3.1.1";
    runtimes.ruby.withJemalloc = toml.runtime.use_jemalloc or false;

    # Define additional paths required for asset compilation
    templates.rails.assetInputs = toml.build.asset_compilation_files or [""];

    # Define additional files required for bundling gems
    templates.rails.gemInputs = toml.build.gem_inputs or [""];

    # This could also be further abstracted in the nix-base modules by
    # providing an option that only takes packages as input, and adds the
    # layer. This would provide more isolation from the implementation details.
    container.additionalLayers = [
      {
        contents = with pkgs; [ ffmpeg ];
      }
    ];

    # Include the base layer which contains useful tools (ca-certs, bash, etc)
    container.includeBaseLayer = toml.build.nix_include_tools or false;
  };
}
