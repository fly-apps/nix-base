{ ruby_2_7, fetchFromGitHub }:

ruby_2_7.overrideAttrs(_: {
  version = "2.7.5";
  src = fetchFromGitHub {
    owner = "ruby";
    repo = "ruby";
    rev = "v2_7_5";
    sha256 = "sha256-cC3JV/wbmQg1U9ZFVNXb1JCvoa/kNINNhoGEQ70rppg=";
  };
})
