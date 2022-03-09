{ defaultGemConfig }:

defaultGemConfig // {

  # Prevent the entire postgresql dependency tree from installing along with this gem
  # by stripping files that keep `final.postgresql` refs in the closure.
  pg = attrs: (defaultGemConfig.pg attrs) // {
    postInstall = ''
      find $out/lib/ruby/gems/ -name 'pg-*.info' -delete
    '';
  };

  # Ensure newer verisons of the grpc gem can be built.
  # TODO: Correctly apply this at the relevant version and submit to upstream nixpkgs
  grpc = attrs: (defaultGemConfig.grpc attrs) // {
    postPatch = ''
      substituteInPlace Makefile \
        --replace '-Wno-invalid-source-encoding' ""
      substituteInPlace src/ruby/ext/grpc/extconf.rb \
        --replace "ENV['AR']" "ENV['NONE']"
      substituteInPlace src/ruby/ext/grpc/extconf.rb \
        --replace "ENV['ARFLAGS']" "ENV['NONE']"
    '';
  };

  # Prevent v8 from being installed with execjs, since almost everybody
  # uses nodejs with this gem, and v8 does not install correctly on Darwin arm64.
  execjs = attrs: (defaultGemConfig.execjs attrs) // {
    propagatedBuildInputs = [];
  };
}
