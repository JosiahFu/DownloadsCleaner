@echo off

title Cleaning Downloads

cd %USERPROFILE%\Downloads

rem Make a vbs file to retrieve the date of one week ago
echo wscript.echo CStr(month(date() - 6)) ^& "/" ^& CStr(day(date() - 6)) ^& "/" ^& CStr(year(date() - 6)) ^& " 12:00 AM" > time.vbs
for /f "delims=," %%a in ('cscript //nologo time.vbs') do set lastweek=%%a
del time.vbs

if not exist Images md Images
if not exist Installers md Installers
if not exist Documents md Documents
if not exist Archives md Archives
if not exist Media md Media
if not exist Code md Code

set image=0
set installer=0
set document=0
set archive=0
set media=0
set code=0
set default=0
set total=0

for %%i in ("*") do (
  if /I "%%~ti" leq "%lastweek%" (
    if not "%%i"=="cleanup.bat" (
      set /A total=total+1
      call :%%~xi "%%i" 2>nul 
      rem sends the file to the "switch" statement below
      if ERRORLEVEL 1 call :default "%%i" 
      rem if the extension does not match then send it to default
    )
  )
)

if %total%==0 (
  echo No files to archive.
  timeout /T 5 >nul
) else (
  echo.
  echo SUMMARY:
  echo %image% images
  echo %installer% installers
  echo %document% documents
  echo %archive% archives
  echo %media% media
  echo %code% code
  echo %default% other
  pause
)

rem quits so it doesn't go to the "switch" statement
exit /B

rem hacky switch statement using CALL

:.png
:.jpg
:.JPG
:.jpeg
:.gif
:.ico
:.svg
echo Moved %1 to Images
move /-Y %1 Images
set /A image=image+1
goto :EOF

:.exe
:.msi
:.iso
echo Moved %1 to Installers
move /-Y %1 Installers
set /A installer=installer+1
goto :EOF

:.txt
:.log
:.pdf
:.docx
:.doc
:.pptx
:.ppt
:.xlsx
:.xls
echo Moved %1 to Documents
move /-Y %1 Documents
set /A document=document+1
goto :EOF

:.rar
:.zip
echo Moved %1 to Archives
move /-Y %1 Archives
set /A archive=archive+1
goto :EOF

:.mp3
:.wav
:.ogg
:.mp4
:.m4a
:.mov
:.webm
echo Moved %1 to Media
move /-Y %1 Media
set /A media=media+1
goto :EOF

:.py
:.json
:.java
:.jar
:.html
:.ipynb
:.bat
echo Moved %1 to Code
move /-Y %1 Code
set /A code=code+1
goto :EOF

:default
ver > nul 
rem set ERRORLEVEL back to 0
set /A default=default+1
set /A total=total-1
goto :EOF