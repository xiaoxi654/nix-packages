{ lib, fetchurl, appimageTools }:

let
  pname = "osu-lazer-appimage";
  version = "2022.902.1";
  name = "osu-lazer-appimage-${version}";
  nameExecutable = pname;
  src = fetchurl {
    url = "https://github.com/ppy/osu/releases/download/${version}/osu.AppImage";
    name = "osu-${version}.AppImage";
    sha256 = "2547582cf88f4c3b5a371c2e19951cde09845525c1d477bfcf3e20472d6b9c26";
  };
  appimageContents = appimageTools.extractType2 { inherit name src; };
in
appimageTools.wrapType2 {
  inherit name src;
  extraPkgs = pkgs: (appimageTools.defaultFhsEnvArgs.multiPkgs pkgs)
    ++ [ pkgs.icu ];
  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/osu\!.desktop "$out/share/applications/osu!(AppImage).desktop"
    substituteInPlace "$out/share/applications/osu!(AppImage).desktop" \
      --replace 'Name=osu!' 'Name=osu!(AppImage)' \
      --replace 'Exec=osu!' 'Exec=${pname}' \
      --replace 'Icon=osu!' 'Icon=osu!(AppImage)'
    for i in 16 32 48 64 96 128 256 512 1024; do
      install -m 444 -D ${appimageContents}/osu\!.png $out/share/icons/hicolor/''${i}x$i/apps/osu\!\(AppImage\).png
    done
  '';

  meta = with lib; {
    description = "Rhythm is just a *click* away";
    homepage = "https://osu.ppy.sh";
    license = with licenses; [
      mit
      cc-by-nc-40
      unfreeRedistributable # osu-framework contains libbass.so in repository
    ];
    platforms = [ "x86_64-linux" ];
  };
}
