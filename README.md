
This repo houses [Nix modules](https://nixos.wiki/wiki/Module) for simplifying shared development environments and production deployments based purely on Nix. Today, this repo contains modules targetting Rails applications. The goal is to extend it for other runtimes, frameworks and deployment scenarios.

Currently, the module system is capable of taking a standard Rails application from development to production using only Nix conventions and a few wrapper shell scripts. A prerequisite for using it in development is having [installed Nix itself](https://nixos.wiki/wiki/Nix_Installation_Guide). You can check out [the sample Rails application](https://github.com/fly-apps/rails-nix) that's setup to use these modules.

This guide assumes you generally understand what Nix is and why it's useful. We'll be writing about that and
linking to that writing here.

Note that nothing here is tailored for Fly.io infrastruture, though [flyctl](https://github.com/superfly/flyctl) will integrate it for running builds on remote builder VMs. We encourage comments and collaboration from others interested in Nix-based deployments!

## Usage

For usage instructions, check out the [Rails sample app](https://github.com/fly-apps/rails-nix).
## Features

The module system offers these features:

* A bootstrapped [nix-shell](https://nixos.org/manual/nix/unstable/command-ref/nix-shell.html) for working with the same packages in development as in production
* Configurable Ruby versions baesd on our custom Ruby [Nix overlays](pkgs/ruby)
* Optimized Docker image builds for production deployments
* A separate Docker layer for gems
* A separate Docker layer for Rails asset compilation
* Customizing which file changes trigger asset compilation
* Adding additional packages into their own image layer
* Customizing the Docker image command

You can see how these options are used in the Rails sample project [default.nix](https://github.com/fly-apps/rails-nix/blob/main/default.nix).

## Rails support

These modules should work with most Rails apps that use `rails asset:precompile` for asset compilation.

Most pure-Ruby gems should work fine. Most popular Gems requiring binary builds should work, but we don't know if they're all covered here. For special cases we've added a [Nix overlay](pkgs/ruby/gem-config.nix).
## Caching builds for reuse

One nix killer feature is the ability to cache any build in a remote store as a simple tarball. We've setup a binary cache on [cachix.org](https://cachix.org) for storing our custom Ruby builds, and perhaps gems and other useful things.

A starting point for this is in [this Github Actions workflow](.github/workflows/cache.yaml).
## Developing on nix-base

If your project is in the same directory as `nix-base`:

```
 $ ls
 my-project
 nix-base
 $ cd my-project
 $ nix-build --arg fly-base '(import ../nix-base {})' [...]
```
## Future plans

Things we'd like to do next:

* Setup build caching CI for more Ruby versions and architectures
* Add more top-level module options for customizing behavior
* Support multiple builds per repo (for example, for running Anycable alongside Rails)
* Move options to a TOML/JSON "app spec"
* Support more asset compilation scenarios (esbuid, webpack, vite, etc)