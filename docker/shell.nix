{ nix-base ? (import ./nix-base.nix {}) }:
(import ./. { inherit nix-base; }).eval.config.outputs.shell
