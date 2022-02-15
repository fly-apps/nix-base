## Nix overlays to support Fly.io deployments

Here we'll keep overlays for package versions we'd like to make available in the Fly binary cache at flyio.cachix.org.
Eventually, this repo should run CI to build and push these packages to Cachix against the current Fly nix version.
Fly users who stick with our official Nix versions will be able to use this cache to speed up deployments.

Stuff we'd like to have:

* Ruby patch versions from 2.5 and up
