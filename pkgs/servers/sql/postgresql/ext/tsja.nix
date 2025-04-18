{
  fetchzip,
  lib,
  mecab,
  nixosTests,
  postgresql,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tsja";
  version = "0.5.0";

  src = fetchzip {
    url = "https://www.amris.jp/tsja/tsja-${finalAttrs.version}.tar.xz";
    hash = "sha256-h59UhUG/7biN8NaDiGK6kXDqfhR9uMzt8CpwbJ+PpEM=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail /usr/local/pgsql ${lib.getDev postgresql} \
      --replace-fail -L/usr/local/lib "" \
      --replace-fail -I/usr/local/include ""
    substituteInPlace tsja.c --replace-fail /usr/local/lib/mecab ${mecab}/lib/mecab
  '';

  buildInputs = [
    mecab
    postgresql
  ];

  installPhase = ''
    mkdir -p $out/lib $out/share/postgresql/extension
    mv libtsja.so $out/lib
    mv dbinit_libtsja.txt $out/share/postgresql/extension/libtsja_dbinit.sql
  '';

  passthru.tests = nixosTests.postgresql.tsja.passthru.override postgresql;

  meta = {
    description = "PostgreSQL extension implementing Japanese text search";
    homepage = "https://www.amris.jp/tsja/index.html";
    maintainers = with lib.maintainers; [ chayleaf ];
    # GNU-specific linker options are used
    platforms = lib.platforms.gnu;
    license = lib.licenses.gpl2Only;
  };
})
