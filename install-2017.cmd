@echo off
	
set VsVersion=2017
set VsVersionAlt=15
if exist "%ProgramFiles(x86)%" set "MsBuildRootDir="%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Enterprise\Common7\IDE\VC\VCTargets""

echo %MsBuildRootDir%
	
set "MsBuildCppDir="%MsBuildRootDir%\Platforms""

echo.
echo.============================================================
echo. Installing into Visual Studio %VsVersion%
echo.============================================================
echo.

set CppVersion=Emscripten

if exist "%MsBuildCppDir%\%CppVersion%\Microsoft.Cpp.%CppVersion%.props" (
	echo. "%CppVersion%" Cpp MsBuild toolset already exists. Removing old version.
	rmdir "%MsBuildCppDir%\%CppVersion%" /s /q
	if exist "%MsBuildCppDir%\%CppVersion%\Microsoft.Cpp.%CppVersion%.props" (
		echo. Failed to remove directory!
		goto cleanup
	)
	echo.
)

if not exist "%MsBuildCppDir%\%CppVersion%" mkdir "%MsBuildCppDir%\%CppVersion%"

echo. Installing %CppVersion% MSBuild files...
cd /d %~dp0
xcopy "MSBuild\%CppVersion%\*.*" "%MsBuildCppDir%\%CppVersion%" /E /Q
if %CppVersion%==Emscripten xcopy "Bin\%VsVersionAlt%.0\*.dll" "%MsBuildCppDir%\%CppVersion%" /E /Q

if errorlevel 1 (
	echo. Problem with copying!
	Pause
	goto cleanup
)

:complete
echo.
echo.Done! You will need to close and re-open existing instances of Visual Studio.
Pause

:cleanup