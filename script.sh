#!/bin/bash

export WINEPREFIX=/srv/wine
export WINEARCH=win32

winecfg

wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
chmod +x winetricks

./winetricks dotnet20sp2 vcrun2008 dotnet40

wine "c:\\windows\\Microsoft.NET\\Framework\\v4.0.30319\\ngen.exe" update

wine /eac/eac.exe

cat >> .bashrc <<EOL
function eac {
local wineprefix="/srv/wine"
local eacdir="/srv/wine/drive_c/Program Files/Exact Audio Copy"
pushd "/srv/wine/drive_c/Program Files/Exact Audio Copy/Microsoft.VC80.CRT"
WINEPREFIX=/srv/wine WINEDEBUG=-all wine "/srv/wine/drive_c/Program Files/Exact Audio Copy/EAC.exe"
popd
}
EOL

mkdir -p "/srv/wine/drive_c/users/user/Application Data/EAC/"
ln -s /Profiles "/srv/wine/drive_c/users/user/Application Data/EAC/"
