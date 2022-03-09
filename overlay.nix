final: super:

let
  inherit (final) callPackage;
in
{
  ruby_2_7_4 = callPackage ./pkgs/ruby/2.7.4.nix { };
  ruby_2_7_5 = callPackage ./pkgs/ruby/2.7.5.nix { };

  defaultGemConfig = callPackage ./pkgs/ruby/gem-config.nix {
    defaultGemConfig = super.defaultGemConfig;
  };

  fly = final.lib.makeScope final.newScope (self: {
    evalSpec = callPackage ./support/eval-spec.nix { };

    # Image tools and helpers
    baseLayer = callPackage ./support/base-layer.nix { };
    imageTools = callPackage ./support/image-tools.nix { };

    keepPaths = callPackage ./support/keep-paths.nix {
      nix-filter = import (builtins.fetchurl {
        url = "https://raw.githubusercontent.com/numtide/nix-filter/e4e8649a3b6f0d3c181955945a84e6918d3f832a/default.nix";
        sha256 = "17s5q9fjwxivr0gjq9bqyias1s38wn78znk3a93q8g05jzgn94wq";
      });
    };
  });

  ruby_2_7_3 = final.ruby_2_7.overrideAttrs(_: {
    version = "2.7.3";
    src = (final.fetchFromGitHub {
      owner = "ruby";
      repo = "ruby";
      rev = "v2_7_3";
      sha256 = "sha256-cC3JV/wbmQg1U9ZFVNXb1JCvoa/kNINNhoGEQ70rppg=";
    });
  });

  ruby_2_7_2 = final.ruby_2_7.overrideAttrs(_: {
    version = "2.7.2";
    src = (final.fetchFromGitHub {
      owner = "ruby";
      repo = "ruby";
      rev = "v2_7_2";
      sha256 = "sha256-cC3JV/wbmQg1U9ZFVNXb1JCvoa/kNINNhoGEQ70rppg=";
    });
  });

}
