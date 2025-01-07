@echo off
set DEFAULT_COLOR=0 215 72

rem ask for color values
set /p "RED=Enter RED value (0-255): "
set /p "GREEN=Enter GREEN value (0-255): "
set /p "BLUE=Enter BLUE value (0-255): "

rem handle default values more efficiently
if "%RED%%GREEN%%BLUE%"=="" (
    echo No color values provided, using default: %DEFAULT_COLOR%
    set "COLOR_VALUE=%DEFAULT_COLOR%"
) else (
    set "COLOR_VALUE=%RED% %GREEN% %BLUE%"
)

echo Using Color: %COLOR_VALUE%...

rem combine registry operations
set "BASE_PATH=HKEY_CURRENT_USER\Control Panel\Colors"
echo Creating backup of Colors registry...
reg export "%BASE_PATH%" "colors_backup.reg" /y

echo Updating color values...

rem batch the registry updates together
(
    reg add "%BASE_PATH%" /v Hilight /t REG_SZ /d "%COLOR_VALUE%" /f
    reg add "%BASE_PATH%" /v MenuHilight /t REG_SZ /d "%COLOR_VALUE%" /f
    reg add "%BASE_PATH%" /v HotTrackingColor /t REG_SZ /d "%COLOR_VALUE%" /f
) >nul 2>&1

echo Color values updated successfully.
echo The new colors will take effect after restarting the system.

choice /c yn /m "Do you want to restart the system now"
if errorlevel 2 goto :eof
shutdown /r /t 0