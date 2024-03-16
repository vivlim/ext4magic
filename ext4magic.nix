{ lib, stdenv, fetchurl, fetchpatch, file, libuuid, e2fsprogs, zlib, bzip2, ... }:
# This and glibc-fix.patch were copied from nixpkgs on 2024/03/16
# /pkgs/tools/filesystems/ext4magic/default.nix
# https://github.com/NixOS/nixpkgs/blob/master/pkgs/tools/filesystems/ext4magic/default.nix

stdenv.mkDerivation rec {
  version = "0.3.2";
  pname = "ext4magic";

  src = fetchurl {
    url = "mirror://sourceforge/ext4magic/${pname}-${version}.tar.gz";
    sha256 = "8d9c6a594f212aecf4eb5410d277caeaea3adc03d35378257dfd017ef20ea115";
  };

  patches = [
    (fetchpatch {
        url = "https://sourceforge.net/p/ext4magic/tickets/10/attachment/ext4magic-0.3.2-i_dir_acl.patch";
        sha256 = "1accydd8kigid68yir2fbihm3r3x8ws3iyznp25snkx41w6y6x8c";
    })
    ./glibc-fix.patch
    ./encrypted-segfault-fix.patch
  ];

  buildInputs = [ file libuuid e2fsprogs zlib bzip2 ];
  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Recover / undelete files from ext3 or ext4 partitions";
    longDescription = ''
      ext4magic can recover/undelete files from ext3 or ext4 partitions
      by retrieving file-information from the filesystem journal.

      If the information in the journal are sufficient, ext4magic can
      recover the most file types, with original filename, owner and group,
      file mode bits and also the old atime/mtime stamps.

      It's much more effective and works much better than extundelete.
    '';
    homepage = "https://ext4magic.sourceforge.net/ext4magic_en.html";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.rkoe ];
    mainProgram = "ext4magic";
  };
}
