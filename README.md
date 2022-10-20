# Save encrypted data on cloud storage using rclone

## General notes

- save all passwords and salts in a password safe such as [KeePass](https://keepass.info/)!
- when setting up rclone, you usually do not have to edit the advanced configuration
- do not quote the remote path (in the configuration)

### Windows / OneCloud

- save some time by setting the target folder (`OneCrypt` in my case) on OneCloud to "Always keep on this device"
- when you rename files in a Git repository and only change the case (`file.TXT` → `File.txt`):
  - try to avoid this, the case-insensitivity of Windows / OneDrive is a pain
  - do not rename files using File Explorer, Visual Studio Code etc., otherwise you'll get strange Git results
  - rename with `git mv` instead

## Setup

1. download [rclone](https://rclone.org/downloads/)
2. extract the ZIP archive to a folder on your OneDrive
3. reading rclone's excellent [manual](https://rclone.org/docs/) can't hurt :-)

## Configuration (on every machine)

1. add an alias to the unencrypted source, for example the directory `C:\Non-Cloud` (technically, this is not necessary, but helps to prevent backing up the wrong location):

```ps1
$ ./rclone.exe config
```

```plain
No remotes found, make a new one?
n) New remote
s) Set configuration password
q) Quit config
n/s/q> n

name> NonCloud

Storage> alias

remote> C:\Non-Cloud
```

2. if you also want to sync your `Downloads` folder, do this (change `<USER>` to your user name):

```ps1
$ ./rclone.exe config
```

```plain
e) Edit existing remote
n) New remote
d) Delete remote
r) Rename remote
c) Copy remote
s) Set configuration password
q) Quit config
e/n/d/r/c/s/q> n

name> Downloads

Storage> alias

remote> C:\Users\<USER>\Downloads
```

3. add encrypted remote, in this case OneDrive (change `<USER>` to your user name):

```ps1
$ ./rclone.exe config
```

```plain
e) Edit existing remote
n) New remote
d) Delete remote
r) Rename remote
c) Copy remote
s) Set configuration password
q) Quit config
e/n/d/r/c/s/q> n

name> OneCrypt

Storage> crypt

nounc>

remote> C:\Users\<USER>\OneDrive\Personal Data\OneCrypt

filename_encryption> off

directory_name_encryption> true

Password or pass phrase for encryption.
y) Yes, type in my own password
g) Generate random password
y/g> g
Bits> 128

Password or pass phrase for salt.
y) Yes, type in my own password
g) Generate random password
y/g/n> g
Bits> 128
```

4. create a (possibly empty) file `exclude_files.txt` in rclone's directory; I recommend excluding the following files:

```plain
.~*
.$*
[Dd]esktop.ini
**/.git/objects/info/commit-graph
```

## Backup to cloud (encrypt)

Create a Windows batch script called `1-backup_to_cloud.bat` in your rclone folder:

```ps1
@ECHO Backup: %computername% -^> OneDrive
@ECHO.
@SET /P confirm="Do you want to backup to cloud (y/N)? "
@IF /I "%confirm%" NEQ "y" EXIT 1

@ECHO.
@ECHO.
@ECHO [NonCloud]
@ECHO.

@.\rclone.exe sync --progress NonCloud: OneCrypt:/Non-Cloud/ --exclude-from ".\exclude_files.txt"

@ECHO.
@ECHO.
@ECHO [Downloads]
@ECHO.

@.\rclone.exe sync --progress Downloads: OneCrypt:/Downloads/ --exclude-from ".\exclude_files.txt"

@ECHO.
@ECHO.

@PAUSE
```

## Restore from cloud (decrypt)

Create a Windows batch script called `2-restore_from_cloud.bat` in your rclone folder:

```ps1
@ECHO Restore: OneDrive -^> %computername%
@ECHO.
@SET /P confirm="Do you want to restore from cloud (y/N)? "
@IF /I "%confirm%" NEQ "y" EXIT 1

@ECHO.
@ECHO.
@ECHO [NonCloud]
@ECHO.

@.\rclone.exe sync --progress OneCrypt:/Non-Cloud/ NonCloud: --exclude-from ".\exclude_files.txt"

@ECHO.
@ECHO.
@ECHO [Downloads]
@ECHO.

@.\rclone.exe sync --progress OneCrypt:/Downloads/ Downloads: --exclude-from ".\exclude_files.txt"

@ECHO.
@ECHO.

@PAUSE
```

## Check differences

Create a Windows batch script called `3-check_differences.bat` in your rclone folder:

```ps1
@ECHO Looking for differences ...

@ECHO.
@ECHO.
@ECHO [NonCloud]
@ECHO.

@.\rclone.exe check --download NonCloud: OneCrypt:/Non-Cloud/ --exclude-from ".\exclude_files.txt"

@ECHO.
@ECHO.
@ECHO [Downloads]
@ECHO.

@.\rclone.exe check --download Downloads: OneCrypt:/Downloads/ --exclude-from ".\exclude_files.txt"

@ECHO.
@ECHO.

@PAUSE
```

## Upgrade rclone to latest version

```ps1
.\rclone selfupdate
```
