
:: CJD Function to change to JohnnyDecimal folder

:: This function depends on the root folder being structured 
:: as per the International JD Standardisation Commitee Regulations 
:: Set the Root Directory Variable %ROOTDIR%

@echo off
set rootdir="C:\Users\jonathanh\Documents"
set jdref=%1

for /f "delims=. tokens=1,2" %%1  in ('echo %jdref%') do set tbref=%%1 && set leafref=%%2

pushd %rootdir%

echo %jdref% |FindStr /R "^1"
if %errorlevel% EQU 0 goto :level1

echo %jdref% |FindStr /R "^2"
if %errorlevel% EQU 0 goto :level2

echo %jdref% |FindStr /R "^3"
if %errorlevel% EQU 0 goto :level3

echo %jdref% |FindStr /R "^4"
if %errorlevel% EQU 0 goto :level4

echo %jdref% |FindStr /R "^5"
if %errorlevel% EQU 0 goto :level5

echo %jdref% |FindStr /R "^6"
if %errorlevel% EQU 0 goto :level6

echo %jdref% |FindStr /R "^7"
if %errorlevel% EQU 0 goto :level7

echo %jdref% |FindStr /R "^8"
if %errorlevel% EQU 0 goto :level8

echo %jdref% |FindStr /R "^9"
if %errorlevel% EQU 0 goto :level9

:level1
pushd 1*
goto :finalsteps

:level2
pushd 2*
goto :finalsteps

:level3
pushd 3*
goto :finalsteps

:level4
pushd 4*
goto :finalsteps

:level5
pushd 5*
goto :finalsteps

:level6
pushd 6*
goto :finalsteps

:level7
pushd 7*
goto :finalsteps

:level8
pushd 8*
goto :finalsteps

:level9
pushd 9*

:finalsteps
pushd %tbref%*
pushd %jdref%*






