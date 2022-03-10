## Nix derivations and tools for Fly.io deployments

This repo serves as the single point of truth for Nix deployments on Fly.io.

Some things we want to do here:

* Store Nix code extracted from our [Rails Nix](https://github.com/fly-apps/rails-nix) experiment, to be referenced by builds
* Curate and build patch releases for Ruby back to v2.7.0, with jemalloc and YJIT enabled where possible
* Cache builds on Cachix or possibly an internal cache store
* Run CI to automate builds and build caching

## Building against a local copy

The correct way is to pass a reference to the local checkout to the build:

```
 $ ls
 my-project
 nix-base
 $ cd my-project
 $ nix-build --arg fly-base '(import ../nix-base {})' [...]
```

An incorrect way would be to change the contents of the `fly-base.nix` pin to:

```nix
import ../nix-base
```

Note the lack of `{}`; when provided as an argument it needs to be an evaluated
reference to the Fly `nix-base` package set. When used as a pin, it should not
be evaluated to the package set yet, it is handled when evaluated in the
default arguments.
