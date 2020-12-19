#!/bin/bash

function eac {
local wineprefix="/srv/wine"
local eacdir="/srv/wine/drive_c/Program Files/Exact Audio Copy"
pushd "/srv/wine/drive_c/Program Files/Exact Audio Copy/Microsoft.VC80.CRT"
WINEPREFIX=/srv/wine WINEDEBUG=-all wine "/srv/wine/drive_c/Program Files/Exact Audio Copy/EAC.exe"
popd
}

eac
