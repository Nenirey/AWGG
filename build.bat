@echo off

rem the next two line must be changed before run on your computer
set lazpath=C:\lazarus\

set PATH=%lazpath%;%PATH%

rem You can execute this script with different parameters:
rem components - compiling components needed for DC
rem plugins - compiling all DC plugins
rem all - compiling components, plugins and DC
rem default - compiling DC only 
rem beta - compile in beta mode (using by default)
if not "%OS_TARGET%" == "" (
  set AWGG_ARCH=%AWGG_ARCH% --os=%OS_TARGET%
)
if not "%CPU_TARGET%" == "" (
  set AWGG_ARCH=%AWGG_ARCH% --cpu=%CPU_TARGET%
)

if "%1"=="beta" ( call :beta
) else (
if "%1"=="release" ( call :release
) else (
if "%1"=="default" ( call :default
) else (
if "%1"=="alpha" ( call :alpha
) else (
if "%1"=="all" ( call :all
) else (
if "%1"=="" ( call :beta
) else (
  echo ERROR: Mode not defined: %1
  echo Available modes: alpha, beta, release
))))))

pause
GOTO:EOF

:beta

  rem Build versionitis
  lazbuild src\versionitis.lpi

  rem update version info
  src\versionitis -verbose

  rem Build AWGG
  call :replace_old
  lazbuild src\awgg.lpi --bm=beta %AWGG_ARCH%

  rem Build Dwarf LineInfo Extractor
  lazbuild tools\extractdwrflnfo.lpi

  rem Extract debug line info
  tools\extractdwrflnfo awgg.dbg
GOTO:EOF

:release

  rem Build versionitis
  lazbuild src\versionitis.lpi

  rem update version info
  src\versionitis -verbose

  rem Build AWGG
  call :replace_old
  lazbuild src\awgg.lpi --bm=release %AWGG_ARCH%

  rem Build Dwarf LineInfo Extractor
  lazbuild tools\extractdwrflnfo.lpi

  rem Extract debug line info
  tools\extractdwrflnfo awgg.dbg
GOTO:EOF

:default
  call :replace_old
  lazbuild src\awgg.lpi %AWGG_ARCH%
GOTO:EOF

:alpha
  call :replace_old
  lazbuild src\awgg.lpi --bm=nightly %AWGG_ARCH%
GOTO:EOF

:replace_old
  del /Q awgg.exe.old
  ren awgg.exe awgg.exe.old
GOTO:EOF
