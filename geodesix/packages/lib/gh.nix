/* This function creates a derivation for installing binaries directly
  * from releases.hashicorp.com.
*/
{ name
, repo
, owner
, version
, version_path ? "v${version}"
, extension ? ""
, sha256 ? null
, system ? builtins.currentSystem
, pname ? "${name}-bin"
, checksum_file ? "checksums.txt"
, filename ? ""
, fileNamer ? conf: "${conf.name}_${conf.version}_${conf.system_mapping}${conf.extension}"
, systemMap ? {
    x86_64-linux = "linux_amd64";
    i686-linux = "linux_386";
    x86_64-darwin = "darwin_amd64";
    i686-darwin = "darwin_386";
    aarch64-linux = "linux_arm64";
    aarch64-darwin = "darwin_arm64";
  }

, lib
, stdenv
, fetchurl
, unzip
, autoPatchelfHook
}:

let
  # Mapping of Nix systems to the GOOS/GOARCH pairs.
  checksums = import ./gh-checksums.nix {
    inherit repo owner version version_path sha256 fetchurl;
    filename = checksum_file;
  };

  # Get our system
  system_mapping = systemMap.${system} or (throw "unsupported system: ${system}");
  default_filename = fileNamer { inherit name pname owner repo version version_path system system_mapping extension; };
  url_filename = if filename == "" then default_filename else filename;
  checksum_attrs = builtins.concatStringsSep " " (builtins.attrNames checksums);
  checksum_lookup = checksums."${url_filename}" or (throw "no checksum found for ${url_filename}. Pick from [${checksum_attrs}]");

  # url for downloading composed of all the other stuff we built up.
  url = "https://github.com/${owner}/${repo}/releases/download/${version_path}/${url_filename}";
  release_sha256 = if checksum_file == "" then sha256 else checksum_lookup;
in
stdenv.mkDerivation {
  inherit pname version;
  src = fetchurl { inherit url; sha256 = release_sha256; };

  # Our source is right where the unzip happens, not in a "src/" directory (default)
  sourceRoot = ".";

  # Stripping breaks darwin Go binaries
  dontStrip = lib.strings.hasPrefix "darwin" system_mapping;

  nativeBuildInputs = [ unzip ] ++ (if stdenv.isLinux then [
    # On Linux we need to do this so executables work
    autoPatchelfHook
  ] else [ ]);

  unpackPhase =
    if extension == "" then ''
      cp $src ${name}
      chmod +x ${name}
    '' else null;

  installPhase = ''
    mkdir -p $out/bin
    mv ${name} $out/bin
  '';
}
