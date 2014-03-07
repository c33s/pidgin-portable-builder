@ECHO OFF
Setlocal EnableDelayedExpansion
echo.
echo Pidgin Portable Builder
echo.

if [%1]==[--help] goto usage
if [%1]==[--clean] goto clean


@rem Setting Versions & Directories
if [%1]==[] (
set VERSION=2.10.9
) else (
set VERSION=%1
)
@rem ## Directories
set BUILDDIR=build\%VERSION%
set TMPDIR=tmp
set CONFIGDIR=config
set CLAMDBDIR=C:\ProgramData\.clamwin\db
set CLAMBIN=C:\Program Files (x86)\ClamWin\bin\clamscan.exe
set CLAMPARAMS=--infected --show-progress --recursive --detect-pua --include-pua=CAT --detect-structured=yes --structured-ssn-format=2 --scan-mail --phishing-sigs=yes --phishing-scan-urls=yes --algorithmic-detection --detect-broken=yes

@rem ## Versions
set GTKVERSION=2.16.6.2
set OTRVERSION=4.0.0-1
set KNOTVERSION=0.3.6
set GNTPVERSION=rev23
@rem Open Steam
set OSTEAMVERSION=1.4
@rem Privacy Please
set PPVERSION=0.7.1
set TOXVERSION=0.3.0
set PENCVERSION=3.1
set TWTRVERSION=0.12.0
set TORCVERSION=2.0-alpha-14

set LOCALES=af am ar ast az be@latin bg bn bn_IN bs ca CA@VAL~1 cs da de dz el en_AU en_CA en_GB eo es et eu fa fi fr ga gl gu he hi hr hu hy id it ja ka km kn ko ku lo lt mai mhr mk mn mr ms_MY my_MM nb ne nl nn oc or pa pl ps pt pt_BR ro ru si sk sl sq sr sr@latin sv sw ta te th tr uk ur vi xh zh_CN zh_HK zh_TW

@rem ###############################################################################################
@rem ###############################################################################################
@rem ###############################################################################################
@rem ###############################################################################################
@rem ###############################################################################################
echo building Pidgin %VERSION%
call :prepare 

@rem ### Pidgin ####################################################################################
@rem # url: https://www.pidgin.im/download/
@rem ###############################################################################################
call :wget http://downloads.sourceforge.net/project/pidgin/Pidgin/%VERSION%/pidgin-%VERSION%-win32-bin.zip
call :uncompress pidgin-%VERSION%-win32-bin.zip
if not exist "./%BUILDDIR%/Pidgin/pidgin.dll" xcopy /q /e /y "./%TMPDIR%/pidgin-%VERSION%-win32-bin" "./%BUILDDIR%/Pidgin/*" /EXCLUDE:%CONFIGDIR%\excludes-pidgin.txt >nul 2>&1
call :copy .\%TMPDIR%\pidgin-%VERSION%-win32-bin\pidgin.exe pidgin-portable.exe ./%BUILDDIR%/Pidgin


@rem ### Pidgin Gtk ################################################################################
@rem # url: https://www.pidgin.im/download
@rem ###############################################################################################
call :wget "http://downloads.sourceforge.net/project/pidgin/GTK+ for Windows/%GTKVERSION%/gtk-runtime-%GTKVERSION%.zip" gtk-runtime-%GTKVERSION%.zip
call :uncompress gtk-runtime-%GTKVERSION%.zip
if not exist "./%BUILDDIR%/GTK/bin" xcopy /q /e /y "./%TMPDIR%/gtk-runtime-%GTKVERSION%" "./%BUILDDIR%/GTK/*" /EXCLUDE:%CONFIGDIR%\excludes-gtk.txt  >nul 2>&1


@rem ### Pidgin Perl Test ##########################################################################
@rem # 
@rem ###############################################################################################
call :copy .\share\perl-plugin-example\test.pl


@rem ### Pidgin Installer Extra Plugins ###
@rem call :wget  http://downloads.sourceforge.net/project/pidgin/Pidgin/%VERSION%/pidgin-%VERSION%.exe pidgin-%VERSION%-installer.exe
@rem call :uncompress pidgin-%VERSION%-installer.exe
@rem if not exist "./%TMPDIR%/pidgin-%VERSION%-win32-installer" 7z e ./%TMPDIR%/pidgin-%VERSION%.exe  -y -o%TMPDIR%\pidgin-%VERSION%-win32-installer
@rem TODO: copy needed plugins


@rem ### Off-the-Record (OTR) Messaging ############################################################
@rem # url: https://otr.cypherpunks.ca/
@rem ###############################################################################################
call :wget https://otr.cypherpunks.ca/binaries/windows/pidgin-otr-%OTRVERSION%.exe
call :uncompress pidgin-otr-%OTRVERSION%.exe
call :copy .\%TMPDIR%\pidgin-otr-%OTRVERSION%\pidgin-otr.dll pidgin-otr-%OTRVERSION%.dll
@rem call :copylocales  pidgin-otr-%OTRVERSION%\pidgin-otr.mo


@rem ### Pidgin-GNTP Plugin - Growl support for Pidgin #############################################
@rem # url http://dimovski.se/pidgin-gntp/
@rem ###############################################################################################
call :wget http://dimovski.se/pidgin-gntp/files/pidgin-gntp_%GNTPVERSION%.zip pidgin-gntp-%GNTPVERSION%.zip
call :uncompress pidgin-gntp-%GNTPVERSION%.zip
call :copy .\%TMPDIR%\pidgin-gntp-%GNTPVERSION%\plugins\pidgin-gntp.dll pidgin-gntp-%GNTPVERSION%.dll
call :copy .\%TMPDIR%\pidgin-gntp-%GNTPVERSION%\growl.dll - ./%BUILDDIR%/Pidgin
call :copy .\%TMPDIR%\pidgin-gntp-%GNTPVERSION%\pixmaps\pidgin\growl_icon.png - .\%BUILDDIR%\Pidgin\pixmaps\pidgin


@rem ### Pidgin Privacy Please - A privacy plugin for the pidgin instant messenger #################
@rem # url: https://code.google.com/p/pidgin-privacy-please/
@rem ###############################################################################################
call :wget https://pidgin-privacy-please.googlecode.com/files/pidgin-privacy-please-%PPVERSION%.exe
call :uncompress pidgin-privacy-please-%PPVERSION%.exe
call :copy .\%TMPDIR%\pidgin-privacy-please-%PPVERSION%\pidgin-pp.dll
@rem call :copylocales pidgin-privacy-please-%PPVERSION%\pidgin-privacy-please.mo


@rem ### Pidgin-Encryption - transparently encrypts your instant messages with RSA encryption. #####
@rem url: http://pidgin-encrypt.sourceforge.net/
@rem ###############################################################################################
call :wget "http://downloads.sourceforge.net/project/pidgin-encrypt/Windows Self-Installer/pidgin-encryption-%PENCVERSION%.exe" pidgin-encryption-%PENCVERSION%.exe
call :uncompress pidgin-encryption-%PENCVERSION%.exe
call :copylocales pidgin-encryption-%PENCVERSION%\pidgin-encryption.mo
call :copy .\%TMPDIR%\pidgin-encryption-%PENCVERSION%\encrypt.dll encrypt-%PENCVERSION%.dll
if not exist "./%BUILDDIR%/Pidgin/pixmaps/pidgin-encryption" mkdir ".\%BUILDDIR%\Pidgin\pixmaps\pidgin-encryption"
call :copy .\%TMPDIR%\pidgin-encryption-%PENCVERSION%\crypto.png - .\%BUILDDIR%\Pidgin\pixmaps\pidgin-encryption
call :copy .\%TMPDIR%\pidgin-encryption-%PENCVERSION%\icon_in_lock.png - .\%BUILDDIR%\Pidgin\pixmaps\pidgin-encryption
call :copy .\%TMPDIR%\pidgin-encryption-%PENCVERSION%\icon_in_unlock.png - .\%BUILDDIR%\Pidgin\pixmaps\pidgin-encryption
call :copy .\%TMPDIR%\pidgin-encryption-%PENCVERSION%\icon_out_capable.png - .\%BUILDDIR%\Pidgin\pixmaps\pidgin-encryption
call :copy .\%TMPDIR%\pidgin-encryption-%PENCVERSION%\icon_out_lock.png - .\%BUILDDIR%\Pidgin\pixmaps\pidgin-encryption
call :copy .\%TMPDIR%\pidgin-encryption-%PENCVERSION%\icon_out_unlock.png - .\%BUILDDIR%\Pidgin\pixmaps\pidgin-encryption


@rem ### tox-prpl - Tox Protocol Plugin For Pidgin #################################################
@rem url: http://tox.dhs.org/
@rem url: https://github.com/jin-eld/tox-prpl
@rem url: http://wiki.tox.im/Tox_Pidgin_Protocol_Plugin
@rem ###############################################################################################
call :wget http://tox.dhs.org/downloads/tox-prpl-pidgin-installer-%TOXVERSION%.exe
call :uncompress tox-prpl-pidgin-installer-%TOXVERSION%.exe
call :copy .\%TMPDIR%\tox-prpl-pidgin-installer-%TOXVERSION%\tox.png - ./%BUILDDIR%/Pidgin/pixmaps/pidgin/protocols/16
call :copy .\%TMPDIR%\tox-prpl-pidgin-installer-%TOXVERSION%\tox.png - ./%BUILDDIR%/Pidgin/pixmaps/pidgin/protocols/22
call :copy .\%TMPDIR%\tox-prpl-pidgin-installer-%TOXVERSION%\tox.png - ./%BUILDDIR%/Pidgin/pixmaps/pidgin/protocols/48
call :copy .\%TMPDIR%\tox-prpl-pidgin-installer-%TOXVERSION%\libtox.dll libtox-%TOXVERSION%.dll
call :copy .\%TMPDIR%\tox-prpl-pidgin-installer-%TOXVERSION%\libsodium-4.dll - ./%BUILDDIR%/Pidgin
call :copy .\%TMPDIR%\tox-prpl-pidgin-installer-%TOXVERSION%\libtoxcore-0.dll - ./%BUILDDIR%/Pidgin


@rem ###  prpltwtr - libpurple twitter protocol  ###################################################
@rem # url: https://code.google.com/p/prpltwtr/
@rem ###############################################################################################
@rem call :wget http://prpltwtr.googlecode.com/files/prpltwtr-%TWTRVERSION%.exe
@rem call :uncompress prpltwtr-%TWTRVERSION%.exe
@rem TODO: copy


@rem ### TorChat - Decentralized anonymous instant messenger on top of Tor Hidden Services #########
@rem # url: https://github.com/prof7bit/TorChat
@rem ###############################################################################################
call :wget https://github.com/downloads/prof7bit/TorChat/libpurpletorchat-%TORCVERSION%-Windows-i368.zip
call :uncompress libpurpletorchat-%TORCVERSION%-Windows-i368.zip
call :copy .\%TMPDIR%\libpurpletorchat-%TORCVERSION%-Windows-i368\purpletorchat.dll purpletorchat-%TORCVERSION%.dll
rem TODO: uncompress does not work, zip has directory inside, copy


@rem ###  pidgin-knotifications - A Pidgin plugin that provides KDE4/Gnome/Growl ###################
@rem # url: https://code.google.com/p/pidgin-knotifications/
@rem ###############################################################################################
call :wget https://pidgin-knotifications.googlecode.com/files/knotifications-%KNOTVERSION%-win.pl
call :copy .\%TMPDIR%\knotifications-%KNOTVERSION%-win.pl


@rem ### WhatsApp Pidgin plugin ####################################################################
@rem # url: http://davidgf.net/page/39/whatsapp-on-your-computer:-pidgin-plugin
@rem # url: http://whatspie.com/
@rem ###############################################################################################
call :wget http://web.davidgf.net/nightly/whatsapp-purple/win32/last-whatsapp.dll
call :copy .\%TMPDIR%\last-whatsapp.dll


@rem ### pidgin-opensteamworks - Steam Friends plugin for Pidgin (libpurple) #######################
@rem # url: https://code.google.com/p/pidgin-opensteamworks/
@rem ###############################################################################################
call :wget http://pidgin-opensteamworks.googlecode.com/svn/trunk/steam-mobile/releases/libsteam-%OSTEAMVERSION%.dll
call :copy .\%TMPDIR%\libsteam-%OSTEAMVERSION%.dll


@rem ### microblog-purple - Libpurple (Pidgin) plug-in supporting microblog services like Twitter ##
@rem # url: https://code.google.com/p/microblog-purple/
@rem ###############################################################################################
@rem disabled
@rem call :wget https://microblog-purple.googlecode.com/files/pidgin-microblog-0.3.0.exe
@rem TODO: uncompress & copy


@rem echo scanning...
"%CLAMBIN%" %CLAMPARAMS% --database="%CLAMDBDIR%" ./%TMPDIR%
"%CLAMBIN%" %CLAMPARAMS% --database="%CLAMDBDIR%" ./%BUILDDIR%

@rem call :garbagecollector
echo Done.

goto :eof











@rem ###############################################################################################
@rem ###############################################################################################
@rem # Functions ###################################################################################
@rem ###############################################################################################
@rem ###############################################################################################
:prepare
	if not exist "./%BUILDDIR%" mkdir "./%BUILDDIR%"
	if not exist "./%TMPDIR%" mkdir "./%TMPDIR%"
	if not exist "./%BUILDDIR%/Pidgin" mkdir "./%BUILDDIR%/Pidgin"
	if not exist "./%BUILDDIR%/Gtk" mkdir "./%BUILDDIR%/Gtk"
exit /b

@rem ### copylocales ###############################################################################
@rem # copies the plugin.mo file to all locale directories.
@rem # 
@rem # @param %1 directory/file
@rem # 
@rem ###############################################################################################
:copylocales
call :getfilename "%1"
	set filename=!LASTFILENAME!
	for %%F in (%LOCALES%) do (
		if not exist "./%BUILDDIR%/Pidgin/locale/%%F/LC_MESSAGES/!FILENAME!" copy ".\%TMPDIR%\%1" "./%BUILDDIR%/Pidgin/locale/%%F/LC_MESSAGES/!FILENAME!" >nul 2>&1
	)
exit /b

@rem ### copy ######################################################################################
@rem # copies only if target does not exists. copies to plugin dir per default
@rem # 
@rem # @param %1 file to copy
@rem # @param %2 target filename
@rem # @param %3 targetdirectory
@rem # 
@rem ###############################################################################################
:copy
	set FILENAME=%2
	if [%2]==[] (
		call :getfilename %1
		set FILENAME=!LASTFILENAME!
	)
	if [%2]==[-] (
		@rem echo xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
		call :getfilename %1
		set FILENAME=!LASTFILENAME!
	) 
	if [%3]==[] (
		set TARGETDIR=.\%BUILDDIR%\Pidgin\plugins
	) else (
		@rem echo ---------------------- parameter target dir
		set TARGETDIR=%3
	)
	@rem echo ++++++++++++++++++++++!TARGETDIR!
	@rem echo ++++++++++++++++++++++!FILENAME!
	@rem echo ++++++++++++++++++++++%1
	@rem echo ++++++++++++++++++++++%2
	@rem echo ++++++++++++++++++++++%3
	@rem echo ++++++++++++++++++++++!TARGETDIR!\!FILENAME!

	if not exist "!TARGETDIR!\!FILENAME!" copy "%1" "!TARGETDIR!\!FILENAME!" >nul 2>&1
	@rem echo if not exist "!TARGETDIR!\!FILENAME!" copy "%1" "!TARGETDIR!\!FILENAME!"
exit /b


@rem ### wget ######################################################################################
@rem # automates the wget process, only downloads the file if it does not exists and able to change the
@rem # downloaded filename.
@rem # 
@rem # @param %1 url of the file to download (required)
@rem # @param %2 filename provide if you want to change to filename of the downloaded file
@rem # 
@rem # currently it is not possible to add a filename with a subdirectory except the subdirectory allready
@rem # exists.
@rem # 
@rem # downloads the file index.html to %TMPDIR%\index.html
@rem # wget http://example.com/index.html
@rem # 
@rem # downloads the file index.html to %TMPDIR%\newfilename.html
@rem # wget http://example.com/index.html newfilename.html
@rem # 
@rem ###############################################################################################
:wget
	if [%2]==[] (
		call :getfilename "%1"
		set filename=!LASTFILENAME!
	) else (
		set filename=%2
	)
	if not exist ./%TMPDIR%/!FILENAME! (
		wget --no-check-certificate %1 -O "./%TMPDIR%/!FILENAME!"
	)
exit /b

@rem ### getfilename ###############################################################################
@rem # "returns" the filename of a path or an url. the function does not really return the filename, 
@rem # it stores it in an environment variable named "lastfilename".
@rem # 
@rem # @param %1 path/url where the filename should be taken from
@rem # 
@rem # returns index.html
@rem # getfilename http://example.com/subdirectory/anothersubdirectory/index.html
@rem # 
@rem ###############################################################################################
:getfilename
	set lastfilename=%~nx1
exit /b

@rem ### getplainfilename ##########################################################################
@rem # "returns" the filename without extension of a path or an url. the function does not really 
@rem # return the filename, it stores it in an environment variable named "lastplainfilename".
@rem # 
@rem # @param %1 path/url where the filename should be taken from
@rem # 
@rem # returns index
@rem # getfilename http://example.com/subdirectory/anothersubdirectory/index.html
@rem # 
@rem ###############################################################################################
:getplainfilename
	set lastplainfilename=%~n1
exit /b

@rem ### uncompress ################################################################################
@rem # a wrapper around 7z and unzip, depending on the file extension the according uncompress program
@rem # is called.
@rem # 
@rem # @param %1 zipfilename the file to uncompress
@rem # @param %2 targetdirectory the directory where the data should be uncompressed to
@rem # 
@rem ###############################################################################################
:uncompress
	if [%2]==[] (
		call :getplainfilename "%1"
		set plainfilename=!LASTPLAINFILENAME!
	) else (
		set plainfilename=%2
	)
	@rem echo !plainfilename!
	set counter=0
	if not exist ./%TMPDIR%/!PLAINFILENAME! (
		@rem echo ./%TMPDIR%/!PLAINFILENAME!
		@rem echo **************************************************************************************
		echo.%1 | findstr /C:"zip" 1>nul
		if errorlevel 1 (
			7z e ./%TMPDIR%/%1 -y -o%TMPDIR%\!PLAINFILENAME!
		) ELSE (
			unzip -q ./%TMPDIR%/%1 -d ./%TMPDIR%/!PLAINFILENAME!
		)
	) else (
		@rem echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	)

	for /d %%I in (./%TMPDIR%/!PLAINFILENAME!/*) do (
		set /a counter+=1
		@rem echo !COUNTER!
		@rem echo %%I
		set extractdirectory=%%~nI%%~xI
	)

	if exist ./%TMPDIR%/!PLAINFILENAME!/!EXTRACTDIRECTORY!/* (
		if !counter! == 1 (
			@rem echo XXXXXXXXXXXXXXXXXXXXXXXXXXXX moving
			rename "./%TMPDIR%/!PLAINFILENAME!" "!PLAINFILENAME!-tmp"
			mkdir "./%TMPDIR%/!PLAINFILENAME!"
			xcopy /e /y /q ".\%TMPDIR%\!PLAINFILENAME!-tmp\!EXTRACTDIRECTORY!\*" ".\%TMPDIR%\!PLAINFILENAME!\"
			rmdir ".\%TMPDIR%\!PLAINFILENAME!-tmp" /s /q 2>NUL
		) else (
			@rem echo xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx counter bigger than 1
		)
	) else (
		@rem echo xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx ./%TMPDIR%/!PLAINFILENAME!/!EXTRACTDIRECTORY!/* does not exist
	)
exit /b

@rem ### clean #####################################################################################
@rem # deletes the temp and the build directory
@rem # 
@rem ###############################################################################################
:clean
	echo cleanup...
	rmdir "./%TMPDIR%" /s /q 2>NUL
	rmdir "./%BUILDDIR%" /s /q 2>NUL
goto :eof

@rem ### clean #####################################################################################
@rem # deletes the temp and the build directory
@rem # 
@rem ###############################################################################################
:garbagecollector
	set LASTFILENAME=
	set LASTPLAINFILENAME=
exit /b
