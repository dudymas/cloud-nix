/* This function downloads a github checksums file and returns a map of checksums
 */
{ repo
, owner
, version
, version_path ? "v${version}"
, version_sha ? null
, checksum_filename ? "checksums.txt"
, fetchurl
}:

let
  sha256 = version_sha;
  url = "https://github.com/${owner}/${repo}/releases/download/${version_path}/${checksum_filename}";
  checksum_file = fetchurl { inherit sha256 url; };
  checksums = import ./checksum-map.nix { inherit checksum_file;};
in checksums