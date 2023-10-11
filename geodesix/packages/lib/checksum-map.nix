/* This function turns a checksum file into a mapping from filenames to checksums.
 */
{ checksum_file
}:
let
  # Fetch the checksums file and split it into lines
  checksum_filter = entry: builtins.isString entry && builtins.stringLength entry > 0;
  checksum_lines = builtins.filter checksum_filter (builtins.split "\n" (builtins.readFile checksum_file));
  # Split each line into a checksum and filename
  checksum_rec = parts: { "${(builtins.elemAt parts 2)}" = builtins.elemAt parts 0; };
  checksum_split = line: builtins.split " +" line;
  checksum_mapper = result: line: result // checksum_rec (checksum_split line);
  checksums = builtins.foldl' checksum_mapper { } checksum_lines;
in checksums