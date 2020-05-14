
rem Set AWGG version
set AWGG_VER=0.5.0

rem Path to subversion
set SVN_EXE="c:\Program Files\SlikSvn\bin\svn.exe"

rem Path to Inno Setup compiler
set ISCC_EXE="c:\Program Files\Inno Setup 5\ISCC.exe"

rem The new package will be created from here
set BUILD_PACK_DIR=%TEMP%\awgg-%DATE: =%

rem The new package will be saved here
set PACK_DIR=%CD%\windows\release

rem Create temp dir for building
set BUILD_AWGG_TMP_DIR=%TEMP%\awgg-%AWGG_VER%
rm -rf %BUILD_AWGG_TMP_DIR%
%SVN_EXE% export ..\ %BUILD_AWGG_TMP_DIR%

rem Save revision number
mkdir %BUILD_AWGG_TMP_DIR%\.svn
copy ..\.svn\entries %BUILD_AWGG_TMP_DIR%\.svn\

rem Prepare package build dir
rm -rf %BUILD_PACK_DIR%
mkdir %BUILD_PACK_DIR%
mkdir %BUILD_PACK_DIR%\release

rem Copy needed files
copy windows\awgg.iss %BUILD_PACK_DIR%\
copy windows\portable.diff %BUILD_PACK_DIR%\

rem Get processor architecture
if "%CPU_TARGET%" == "" (
  if "%PROCESSOR_ARCHITECTURE%" == "x86" (
    set CPU_TARGET=i386
    set OS_TARGET=win32
  ) else if "%PROCESSOR_ARCHITECTURE%" == "AMD64" (
    set CPU_TARGET=x86_64
    set OS_TARGET=win64
  )
)

rem Copy libraries
copy windows\lib\%CPU_TARGET%\*.dll    %BUILD_AWGG_TMP_DIR%\

cd /D %BUILD_AWGG_TMP_DIR%

rem Build all components of AWGG
call build.bat beta

rem Prepare install files
call %BUILD_AWGG_TMP_DIR%\install\windows\install.bat

cd /D %BUILD_PACK_DIR%
rem Create *.exe package
%ISCC_EXE% /F"awgg-%AWGG_VER%.%CPU_TARGET%-%OS_TARGET%" awgg.iss

rem Move created package
move release\*.exe %PACK_DIR%

rem Create *.zip package
zip -9 -Dr %PACK_DIR%\awgg-%AWGG_VER%.%CPU_TARGET%-%OS_TARGET%.zip awgg

rem Clean temp directories
cd \
rm -rf %BUILD_AWGG_TMP_DIR%
rm -rf %BUILD_PACK_DIR%
