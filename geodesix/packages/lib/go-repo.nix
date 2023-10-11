/* * Simply a repo derivation for go binaries that are rudimentary
 */
{ stdenv
, buildGoModule
, fetchFromGitHub

, pname
, version
, owner
, repo
, rev
, sha256
, vendorSha256 ? sha256
, subPackages ? ["cmd"]
, description
, homepage
}:

buildGoModule rec {
  inherit pname version subPackages vendorSha256;

  src = fetchFromGitHub {
    inherit owner repo rev sha256;
  };

  meta = with stdenv.lib; {
    inherit description homepage;
  };
}