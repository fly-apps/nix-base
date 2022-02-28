{ defaultGemConfig }:

defaultGemConfig // {
  pg = attrs: (defaultGemConfig.pg attrs) // {
    # Strip files that keep `final.postgresql` refs in the closure.
    postInstall = ''
      find $out/lib/ruby/gems/ -name 'pg-*.info' -delete
    '';
  };
}
