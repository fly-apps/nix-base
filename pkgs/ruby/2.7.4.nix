{ ruby_2_7, fetchFromGitHub }:

ruby_2_7.overrideAttrs(_: {
  version = "2.7.4";
  src = fetchFromGitHub {
    owner = "ruby";
    repo = "ruby";
    rev = "v2_7_4";
    sha256 = "sha256-t7hcM9cjp8z1neijl4lARAJwJJikVHqVLJMoOjnOOt8=";
  };
})
