{ ruby_3_1, fetchFromGitHub }:

ruby_3_1.overrideAttrs(_: {
  version = "3.1.1";
  src = fetchFromGitHub {
    owner = "ruby";
    repo = "ruby";
    rev = "v3_1_1";
    sha256 = "sha256-76t/tGyK5nz7nvcRdHJTjjckU+Kv+/kbTMiNWJ93jU8=";
  };
})
