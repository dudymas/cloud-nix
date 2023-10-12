/* This function downloads a github checksums file and returns a map of checksums
 */
{ repo
, owner
, version
, version_path ? "v${version}"
, sha256 ? null
, filename
, fetchurl
}:

let
  url = "https://github.com/${owner}/${repo}/releases/download/${version_path}/${filename}";
  checksum_file = fetchurl { inherit sha256 url; };
  checksums = import ./checksum-map.nix { inherit checksum_file;};
in checksums