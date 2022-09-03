{ lib, fetchurl, appimageTools }:

let
  pname = "heroic-appimage";
  version = "2.4.2";
  name = "${pname}-${version}";
  src = fetchurl {
    url = "https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher/releases/download/v${version}/Heroic-${version}.AppImage";
    sha256 = "8510ea27a9b630dbac7ab1046974bfc032cbc0e28690237e9cafe80cab83d316";
  };
  appimageContents = appimageTools.extractType2 { inherit name src; };

in
appimageTools.wrapType2 {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    mkdir -p $out/share/${pname}
    cp -a ${appimageContents}/locales $out/share/${pname}
    cp -a ${appimageContents}/resources $out/share/${pname}
    install -m 444 -D ${appimageContents}/heroic-appimage.desktop -t $out/share/applications
    cp -a ${appimageContents}/usr/share/icons $out/share/
    substituteInPlace $out/share/applications/heroic-appimage.desktop \
      --replace 'Exec=AppRun' 'Exec=heroic-appimage'
  '';

  meta = with lib; {
    description = "A Native GUI Epic Games Launcher for Linux, Windows and Mac";
    homepage = "https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher";
    license = licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
  };
}