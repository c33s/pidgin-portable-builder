rem @ECHO OFF
echo.
echo Pidgin Portable Builder
echo.

if [%1]==[--help] goto usage
if [%1]==[--clean] goto clean


rem Setting Versions & Directories
if [%1]==[] (
set VERSION=2.10.9
) else (
set VERSION=%1
)
rem ## Directories
set BUILDDIR=build/%VERSION%
set TMPDIR=tmp
set CONFIGDIR=config
set CLAMDBDIR=C:\ProgramData\.clamwin\db
set CLAMBIN=C:\Program Files (x86)\ClamWin\bin\clamscan.exe

rem ## Versions
set GTKVERSION=2.16.6.2
set OTRVERSION=4.0.0-1
set KNOTVERSION=0.3.6
set GNTPVERSION=rev23
rem Open Steam
set OSTEAMVERSION=1.4
rem Privacy Please
set PPVERSION=0.7.1
set TOXVERSION=0.3.0
set PENCVERSION=3.1
set TWTRVERSION=0.12.0
set TORCVERSION=2.0-alpha-14

echo building Pidgin %VERSION%

rem Prepearing Directories
if not exist "./%BUILDDIR%" mkdir "./%BUILDDIR%"
if not exist "./%TMPDIR%" mkdir "./%TMPDIR%"
if not exist "./%BUILDDIR%/Pidgin" mkdir "./%BUILDDIR%/Pidgin"
if not exist "./%BUILDDIR%/Gtk" mkdir "./%BUILDDIR%/Gtk"

rem mkdir "./%BUILDDIR%/Gtk" 2>NUL


echo downloading...
rem Core
if not exist ./%TMPDIR%/pidgin-%VERSION%-win32-bin.zip wget http://downloads.sourceforge.net/project/pidgin/Pidgin/%VERSION%/pidgin-%VERSION%-win32-bin.zip -O "./%TMPDIR%/pidgin-%VERSION%-win32-bin.zip"
if not exist ./%TMPDIR%/gtk-runtime-%GTKVERSION%.zip wget "http://downloads.sourceforge.net/project/pidgin/GTK+ for Windows/%GTKVERSION%/gtk-runtime-%GTKVERSION%.zip" -O "./%TMPDIR%/gtk-runtime-%GTKVERSION%.zip"
if not exist ./%TMPDIR%/pidgin-%VERSION%.exe wget http://downloads.sourceforge.net/project/pidgin/Pidgin/%VERSION%/pidgin-%VERSION%.exe -O "./%TMPDIR%/pidgin-%VERSION%.exe"


rem Plugins
if not exist "./%TMPDIR%/pidgin-otr-%OTRVERSION%.exe" wget --no-check-certificate https://otr.cypherpunks.ca/binaries/windows/pidgin-otr-%OTRVERSION%.exe -O "./%TMPDIR%/pidgin-otr-%OTRVERSION%.exe"
if not exist "./%TMPDIR%/pidgin-gntp_%GNTPVERSION%.zip" wget http://dimovski.se/pidgin-gntp/files/pidgin-gntp_%GNTPVERSION%.zip -O "./%TMPDIR%/pidgin-gntp_%GNTPVERSION%.zip"
if not exist "./%TMPDIR%/knotifications-%KNOTVERSION%-win.pl" wget --no-check-certificate https://pidgin-knotifications.googlecode.com/files/knotifications-%KNOTVERSION%-win.pl -O "./%TMPDIR%/knotifications-%KNOTVERSION%-win.pl"
if not exist "./%TMPDIR%/last-whatsapp.dll" wget http://web.davidgf.net/nightly/whatsapp-purple/win32/last-whatsapp.dll -O "./%TMPDIR%/last-whatsapp.dll"
if not exist "./%TMPDIR%/libsteam-%OSTEAMVERSION%.dll" wget http://pidgin-opensteamworks.googlecode.com/svn/trunk/steam-mobile/releases/libsteam-%OSTEAMVERSION%.dll -O "./%TMPDIR%/libsteam-%OSTEAMVERSION%.dll"
if not exist "./%TMPDIR%/pidgin-privacy-please-%PPVERSION%.exe" wget --no-check-certificate https://pidgin-privacy-please.googlecode.com/files/pidgin-privacy-please-%PPVERSION%.exe -O "./%TMPDIR%/pidgin-privacy-please-%PPVERSION%.exe"
if not exist "./%TMPDIR%/tox-prpl-%TOXVERSION%.exe" wget http://tox.dhs.org/downloads/tox-prpl-pidgin-installer-%TOXVERSION%.exe -O "./%TMPDIR%/tox-prpl-%TOXVERSION%.exe"
if not exist "./%TMPDIR%/pidgin-encryption-%PENCVERSION%.exe" wget "http://downloads.sourceforge.net/project/pidgin-encrypt/Windows Self-Installer/pidgin-encryption-%PENCVERSION%.exe" -O "%TMPDIR%/pidgin-encryption-%PENCVERSION%.exe"
rem if not exist "./%TMPDIR%/prpltwtr-%TWTRVERSION%.exe" wget http://prpltwtr.googlecode.com/files/prpltwtr-%TWTRVERSION%.exe -O "./%TMPDIR%/prpltwtr-%TWTRVERSION%.exe"
rem if not exist "./%TMPDIR%/torchat-%TORCVERSION%.zip" wget https://github.com/downloads/prof7bit/TorChat/libpurpletorchat-%TORCVERSION%-Windows-i368.zip -O "./%TMPDIR%/torchat-%TORCVERSION%.zip"
rem if not exist "./%TMPDIR%/pidgin-microblog-0.3.0.exe" wget --no-check-certificate https://microblog-purple.googlecode.com/files/pidgin-microblog-0.3.0.exe -O "./%TMPDIR%/pidgin-microblog-0.3.0.exe"

echo unziping...
rem Core
if not exist ./%TMPDIR%/pidgin-%VERSION%-win32bin unzip -q ./%TMPDIR%/pidgin-%VERSION%-win32-bin.zip -d ./%TMPDIR%
if not exist ./%TMPDIR%/Gtk-%GTKVERSION% unzip -q ./%TMPDIR%/gtk-runtime-%GTKVERSION%.zip -d ./%TMPDIR%/Gtk-%GTKVERSION%
if not exist "./%TMPDIR%/pidgin-%VERSION%-win32-installer" 7z e ./%TMPDIR%/pidgin-%VERSION%.exe  -y -o%TMPDIR%\pidgin-%VERSION%-win32-installer

rem Plugins
if not exist ./%TMPDIR%/otr-%OTRVERSION% 7z e ./%TMPDIR%/pidgin-otr-%OTRVERSION%.exe -y -o%TMPDIR%\otr-%OTRVERSION%
if not exist ./%TMPDIR%/gntp-%GNTPVERSION% unzip -q "./%TMPDIR%/pidgin-gntp_%GNTPVERSION%.zip" -d ./%TMPDIR%/gntp-%GNTPVERSION%
if not exist ./%TMPDIR%/pp-%PPVERSION% 7z e ./%TMPDIR%/pidgin-privacy-please-%PPVERSION%.exe -y -o%TMPDIR%\pp-%PPVERSION%
if not exist "./%TMPDIR%/pidgin-encryption-%PENCVERSION%" 7z e ./%TMPDIR%/pidgin-encryption-%PENCVERSION%.exe  -y -o%TMPDIR%\pidgin-encryption-%PENCVERSION%
if not exist "./%TMPDIR%/prpltwtr-%TWTRVERSION%" 7z e ./%TMPDIR%/prpltwtr-%TWTRVERSION%.exe -y -o%TMPDIR%\prpltwtr-%TWTRVERSION%
rem if not exist "./%TMPDIR%/torchat-%TORCVERSION%" unzip -q ./%TMPDIR%/torchat-%TORCVERSION%.zip -d ./%TMPDIR%/torchat-%TORCVERSION%




echo scanning...
rem "%CLAMBIN%" --infected --show-progress --recursive --detect-pua --include-pua=CAT --detect-structured=yes --structured-ssn-format=2 --scan-mail --phishing-sigs=yes --phishing-scan-urls=yes --algorithmic-detection --detect-broken=yes --database="%CLAMDBDIR%" ./%TMPDIR%



echo copying...
rem Core
if not exist "./%BUILDDIR%/Pidgin/pidgin.dll" xcopy /q /e /y "./%TMPDIR%/pidgin-%VERSION%-win32bin" "./%BUILDDIR%/Pidgin/*" /EXCLUDE:%CONFIGDIR%\excludes-pidgin.txt
if not exist "./%BUILDDIR%/Pidgin/pidgin-portable.exe" copy ".\%TMPDIR%\pidgin-%VERSION%-win32bin\pidgin.exe" "./%BUILDDIR%/Pidgin/pidgin-portable.exe"
if not exist "./%BUILDDIR%/GTK/bin" xcopy /q /e /y "./%TMPDIR%/GTK" "./%BUILDDIR%/GTK/*" /EXCLUDE:%CONFIGDIR%\excludes-gtk.txt
rem Plugins
if not exist "./%BUILDDIR%/Pidgin/plugins/otr-%OTRVERSION%.dll" copy ".\%TMPDIR%\otr-%OTRVERSION%\pidgin-otr.dll" "./%BUILDDIR%/Pidgin/plugins/otr-%OTRVERSION%.dll"
if not exist "./%BUILDDIR%/Pidgin/plugins/growl-%GNTPVERSION%.dll" copy ".\%TMPDIR%\gntp-%GNTPVERSION%\growl.dll" "./%BUILDDIR%/Pidgin/plugins/growl-%GNTPVERSION%.dll"
if not exist "./%BUILDDIR%/Pidgin/plugins/knotifications-%KNOTVERSION%.pl" copy ".\%TMPDIR%\knotifications-%KNOTVERSION%-win.pl" "./%BUILDDIR%/Pidgin/plugins/knotifications-%KNOTVERSION%.pl"
if not exist "./%BUILDDIR%/Pidgin/plugins/whatsapp.dll" copy ".\%TMPDIR%\last-whatsapp.dll" "./%BUILDDIR%/Pidgin/plugins/whatsapp.dll"
if not exist "./%BUILDDIR%/Pidgin/plugins/opensteam-%OSTEAMVERSION%.dll" copy ".\%TMPDIR%\libsteam-%OSTEAMVERSION%.dll" "./%BUILDDIR%/Pidgin/plugins/opensteam-%OSTEAMVERSION%.dll"
if not exist "./%BUILDDIR%/Pidgin/plugins/test.pl" copy ".\share\perl-plugin-example\test.pl" "./%BUILDDIR%/Pidgin/plugins/test.pl"
if not exist "./%BUILDDIR%/Pidgin/plugins/pp-%PPVERSION%.dll" copy ".\%TMPDIR%\pp-%PPVERSION%\pidgin-pp.dll" "./%BUILDDIR%/Pidgin/plugins/pp-%PPVERSION%.dll"


rem if not exist "./%BUILDDIR%/Pidgin/plugins/" copy ".\%TMPDIR%\\" "./%BUILDDIR%/Pidgin/plugins/"


rem not used any more, copying all themes
rem xcopy /y "./%TMPDIR%/GTK/share/themes/MS-Windows/gtk-2.0/gtkrc" "./%BUILDDIR%/GTK/etc/gtk-2.0/gtkrc"


echo Done.

goto :eof

:clean
echo cleanup...
rmdir "./%TMPDIR%" /s /q 2>NUL
rmdir "./%BUILDDIR%" /s /q 2>NUL
goto :eof

:usage
echo call with correct version number "build.bat 2.10.9"
exit /B 1

