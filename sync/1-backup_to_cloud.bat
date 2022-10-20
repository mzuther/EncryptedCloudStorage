@ECHO Backup: %computername% -^> OneDrive
@ECHO.
@SET /P confirm="Do you want to backup to cloud storage (y/N)? "
@IF /I "%confirm%" NEQ "y" EXIT 1

@ECHO.
@ECHO.
@ECHO [NonCloud]
@ECHO.

@..\rclone\rclone.exe sync --progress NonCloud: OneCrypt:/Non-Cloud/ --exclude-from ".\exclude_files.txt"

@ECHO.
@ECHO.
@ECHO [Downloads]
@ECHO.

@..\rclone\rclone.exe sync --progress Downloads: OneCrypt:/Downloads/ --exclude-from ".\exclude_files.txt"

@ECHO.
@ECHO.

@PAUSE
