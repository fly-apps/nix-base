final: super: {
  ruby_2_7_4 = final.ruby_2_7.overrideAttrs(_: {
    version = "2.7.4";
    src = (final.fetchFromGitHub {
      owner = "ruby";
      repo = "ruby";
      rev = "v2_7_4";
      sha256 = "sha256-t7hcM9cjp8z1neijl4lARAJwJJikVHqVLJMoOjnOOt8=";
    });
  });

  ruby_2_7_5 = final.ruby_2_7.overrideAttrs(_: {
    version = "2.7.5";
    src = (final.fetchFromGitHub {
      owner = "ruby";
      repo = "ruby";
      rev = "v2_7_5";
      sha256 = "sha256-cC3JV/wbmQg1U9ZFVNXb1JCvoa/kNINNhoGEQ70rppg=";
    });
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
