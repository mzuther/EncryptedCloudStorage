@ECHO Restore: OneDrive -^> %computername%
@ECHO.
@SET /P confirm="Do you want to restore from cloud storage (y/N)? "
@IF /I "%confirm%" NEQ "y" EXIT 1

@ECHO.
@ECHO.
@ECHO [NonCloud]
@ECHO.

@..\rclone\rclone.exe sync --progress OneCrypt:/Non-Cloud/ NonCloud: --exclude-from ".\exclude_files.txt"

@ECHO.
@ECHO.
@ECHO [Downloads]
@ECHO.

@..\rclone\rclone.exe sync --progress OneCrypt:/Downloads/ Downloads: --exclude-from ".\exclude_files.txt"

@ECHO.
@ECHO.

@PAUSE
