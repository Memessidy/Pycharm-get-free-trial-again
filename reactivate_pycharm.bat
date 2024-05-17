@echo off
setlocal

set "key=HKEY_CURRENT_USER\Software\JavaSoft\Prefs"
set "my_dir=%USERPROFILE%\AppData\Roaming\JetBrains"

set "file1=%my_dir%\PermanentDeviceId"
set "file2=%my_dir%\PermanentUserId"
set "pycharm_dir="

REM Find pycharm dir
for /d %%i in ("%my_dir%\*PyCharm*") do (
    set "pycharm_dir=%%i"
    goto :Found
)

:Found

set "file3=%pycharm_dir%\pycharm.key"
set "all_successful=1"
reg query "%key%" >nul 2>&1

if %errorlevel% equ 0 (
    echo The registry key exists. Deleting...
    reg delete "%key%" /f
    if %errorlevel% equ 0 (
        echo The registry key was successfully deleted.
    ) else (
        echo Failed to delete the registry key.
        set "all_successful=0"
    )
) else (
    echo The registry key does not exist.
)

call :DeleteFile "%file1%"
if %errorlevel% neq 0 set "all_successful=0"
call :DeleteFile "%file2%"
if %errorlevel% neq 0 set "all_successful=0"
call :DeleteFile "%file3%"
if %errorlevel% neq 0 set "all_successful=0"

if %all_successful% equ 1 (
    echo reactivate successfully
) else (
    echo Some operations failed
)

pause

endlocal
exit /b

:DeleteFile
if exist "%~1" (
    echo File %~1 exists. Deleting...
    del "%~1%"
    if exist "%~1" (
        echo Failed to delete %~1.
        exit /b 1
    ) else (
        echo %~1 was successfully deleted.
        exit /b 0
    )
) else (
    echo %~1 does not exist.
    exit /b 0
)

