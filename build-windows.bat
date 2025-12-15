@echo off
REM Build script for Windows users using WSL (Windows Subsystem for Linux)
REM 使用 WSL 为 Windows 用户构建 IPK 包

echo =====================================
echo Building luci-app-srun IPK package
echo Using WSL (Windows Subsystem for Linux)
echo =====================================
echo.

REM Check if WSL is installed
wsl --status >nul 2>&1
if errorlevel 1 (
    echo ERROR: WSL is not installed or not available
    echo.
    echo Please install WSL first:
    echo 1. Open PowerShell as Administrator
    echo 2. Run: wsl --install
    echo 3. Restart your computer
    echo 4. Run this script again
    echo.
    pause
    exit /b 1
)

echo WSL detected, running build script...
echo.

REM Convert Windows path to WSL path and run build.sh
for /f "delims=" %%i in ('wsl wslpath "%CD%"') do set WSL_PATH=%%i
wsl bash -c "cd '%WSL_PATH%' && chmod +x build.sh && ./build.sh"

if errorlevel 1 (
    echo.
    echo Build failed!
    pause
    exit /b 1
)

echo.
echo =====================================
echo Build completed successfully!
echo =====================================
echo.
echo The IPK package is located in the bin\ folder
echo.
dir /b bin\*.ipk 2>nul
echo.
echo Next steps:
echo 1. Copy the IPK file to your OpenWrt router
echo 2. Install it using: opkg install /tmp/luci-app-srun_*.ipk
echo.
echo For detailed instructions, see BUILD.md or INSTALL_CN.md
echo.
pause
