@ECHO Looking for differences ...

@ECHO.
@ECHO.
@ECHO [NonCloud]
@ECHO.

@..\rclone\rclone.exe check --download NonCloud: OneCrypt:/Non-Cloud/ --exclude-from ".\exclude_files.txt"

@ECHO.
@ECHO.
@ECHO [Downloads]
@ECHO.

@..\rclone\rclone.exe check --download Downloads: OneCrypt:/Downloads/ --exclude-from ".\exclude_files.txt"

@ECHO.
@ECHO.

@PAUSE
