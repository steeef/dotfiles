{
  lib,
  buildGoModule,
  fetchFromGitea,
}:
buildGoModule {
  pname = "fgj";
  version = "0.4.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "romaintb";
    repo = "fgj";
    rev = "v0.4.0";
    hash = "sha256-7/ITo+8QCj/hy4xlOw+kfjnJbHTWjGh+VYOZxvqghAQ=";
  };

  vendorHash = "sha256-ZBdSSif9YFpFyBQNpZ/XttVw/dgDS54L+0ZA+9ObSSg=";

  meta = {
    description = "CLI for Forgejo and Gitea instances";
    homepage = "https://codeberg.org/romaintb/fgj";
    license = lib.licenses.mit;
    mainProgram = "fgj";
  };
}
