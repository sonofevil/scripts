@echo off

echo:
echo Usage: linktree.bat [sourcepath] [targetpath]
echo:
echo Creates a copy of [sourcepath]'s directory structure 
echo at [targetpath] but with symbolic links to files.
echo:
echo Example: linktree.bat "C:/SteamLibrary/steamapps/common/GameName" "C:/Modded Games/GameNameCopy"
echo:

if "%1"=="" exit /b
if "%2"=="" echo No target specified. && exit /b

cd /d "%~1"
if ERRORLEVEL 1 echo Not a valid source directory. && exit /b
set "targetDir=%~2"
IF %targetDir:~-1%==\ SET targetDir=%targetDir:~0,-1%

setlocal enableextensions
setlocal enabledelayedexpansion
for /R . %%f in (*) do (
  set absoPath=%%f
  set relaPath=!absoPath:%CD%\=!
  set linkPath=%targetDir%\!relaPath!
  mkdir "!linkpath!\.."
  mklink "!linkPath!" "!absoPath!"
)
