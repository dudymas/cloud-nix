{lib, stdenv, fetchFromGitHub, bash}:

stdenv.mkDerivation rec {
  pname = "adr";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "npryce";
    repo = "adr-tools";
    rev = "3.0.0";
    hash = "sha256-JEwLn+SY6XcaQ9VhN8ARQaZc1zolgAJKfIqPggzV+sU=";
  };

  nativeBuildInputs = [ bash ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src/src/* $out/bin
  '';

  meta = {
    description = "Command-line tools for working with Architecture Decision Records";
    license = lib.licenses.mit;
  };
}