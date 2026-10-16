
@echo off
setlocal EnableExtensions
title Old PC Maintenance and Security Scan

:: Check administrator permission
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Administrator permission is required.
    echo Requesting permission...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

:: Create a log file beside this BAT file
set "LOG=%~dp0PC_Maintenance_Log.txt"

echo ================================================== > "%LOG%"
echo OLD PC MAINTENANCE REPORT >> "%LOG%"
echo Started: %date% %time% >> "%LOG%"
echo ================================================== >> "%LOG%"

color 0A
cls
echo ==================================================
echo       OLD PC MAINTENANCE AND SECURITY SCAN
echo ==================================================
echo.
echo Please keep the computer connected to power.
echo Do not turn off the PC while repairs are running.
echo.

:: STEP 1 - Clean current user's temporary files
echo [1/7] Cleaning user temporary files...
echo Cleaning user temporary files... >> "%LOG%"
if exist "%TEMP%\" (
    del /f /s /q "%TEMP%\*" >> "%LOG%" 2>&1
    for /d %%D in ("%TEMP%\*") do rd /s /q "%%D" >> "%LOG%" 2>&1
)
echo User temporary cleanup finished.
echo.

:: STEP 2 - Clean Windows temporary files
echo [2/7] Cleaning Windows temporary files...
echo Cleaning Windows temporary files... >> "%LOG%"
if exist "%SystemRoot%\Temp\" (
    del /f /s /q "%SystemRoot%\Temp\*" >> "%LOG%" 2>&1
    for /d %%D in ("%SystemRoot%\Temp\*") do rd /s /q "%%D" >> "%LOG%" 2>&1
)
echo Windows temporary cleanup finished.
echo.

:: STEP 3 - Empty Recycle Bin
echo [3/7] Emptying Recycle Bin...
echo Emptying Recycle Bin... >> "%LOG%"
powershell -NoProfile -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue" >> "%LOG%" 2>&1
echo Recycle Bin cleanup attempted.
echo.

:: STEP 4 - Run Microsoft Malicious Software Removal Tool
echo [4/7] Starting Microsoft MRT...
echo Follow the instructions in the MRT window.
echo This tool may not be installed on every Windows version.
echo Starting MRT... >> "%LOG%"

if exist "%SystemRoot%\System32\MRT.exe" (
    start /wait "" "%SystemRoot%\System32\MRT.exe"
    echo MRT was launched. Check its results window. >> "%LOG%"
) else (
    echo MRT.exe was not found. >> "%LOG%"
    echo MRT was not found on this computer.
)
echo.

:: STEP 5 - Run Microsoft Defender FULL scan
echo [5/7] Running Microsoft Defender full scan...
echo This can take several hours on an old computer.
echo Do not close this window.
echo Defender full scan started... >> "%LOG%"

powershell -NoProfile -Command "try { Start-MpScan -ScanType FullScan -ErrorAction Stop; Write-Output 'Defender scan command completed.' } catch { Write-Output ('Defender scan error: ' + $_.Exception.Message); exit 1 }" >> "%LOG%" 2>&1

if errorlevel 1 (
    echo Defender scan could not be started successfully.
    echo Check whether Microsoft Defender is available and enabled.
    echo See the log for details.
) else (
    echo Defender scan command finished.
)
echo.

:: STEP 6 - Repair/check Windows system files
echo [6/7] Running System File Checker...
echo This may take a while.
echo SFC started... >> "%LOG%"
sfc /scannow >> "%LOG%" 2>&1
echo SFC command finished. Review the log for its result.
echo.

:: STEP 7 - Check Windows component health
echo [7/7] Checking Windows component health...
echo DISM RestoreHealth started... >> "%LOG%"
DISM /Online /Cleanup-Image /RestoreHealth >> "%LOG%" 2>&1
echo DISM command finished. Review the log for its result.
echo.

echo ==================================================
echo             MAINTENANCE FINISHED
echo ==================================================
echo.
echo Check the log file:
echo "%LOG%"
echo.
echo IMPORTANT:
echo A finished command does not always mean a repair succeeded.
echo Review the log and Windows Security for scan results.
echo.
echo Press any key to close this window.
echo Finished: %date% %time% >> "%LOG%"
pause >nul

endlocal
