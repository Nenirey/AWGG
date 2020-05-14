rem This script run from create_packages.bat
rem If you run it direct, set up %BUILD_PACK_DIR% first

rem Prepare all installation files

set AWGG_INSTALL_DIR=%BUILD_PACK_DIR%\awgg
mkdir  %AWGG_INSTALL_DIR%

rem Copy directories
xcopy /E language %AWGG_INSTALL_DIR%\language\

rem Copy files
copy doc\*.txt                      %AWGG_INSTALL_DIR%\doc\
copy awgg.exe                  %AWGG_INSTALL_DIR%\
copy awgg.zdli                 %AWGG_INSTALL_DIR%\
copy awgg.ext.example          %AWGG_INSTALL_DIR%\
rem Copy libraries
copy *.dll                          %AWGG_INSTALL_DIR%\
