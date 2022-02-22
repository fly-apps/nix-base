## Nix derivations and tools for Fly.io deployments

This repo serves as the single point of truth for Nix deployments on Fly.io.

Some things we want to do here:

* Store Nix code extracted from our [Rails Nix](https://github.com/fly-apps/rails-nix) experiment, to be referenced by builds
* Curate and build patch releases for Ruby back to v2.7.0, with jemalloc and YJIT enabled where possible
* Cache builds on Cachix or possibly an internal cache store
* Run CI to automate builds and build caching
