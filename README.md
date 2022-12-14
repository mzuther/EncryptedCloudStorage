# Save encrypted data on cloud storage using rclone

## Introduction

This document describes a setup to synchronize secret data to cloud storage in a way that the cloud provider does not have access to the original files. All files in a local folder (`C:\Non-Cloud`) are read, encrypted on the fly, and stored to a folder that is synchronized by a cloud storage client application such as OneDrive (`C:\Users\<USER>\OneDrive\Personal Data\OneCrypt`). Restoring and decrypting files works analogously.

The cloud storage client application will undertake the actual synchronization, but will never see the decrypted files. Encryption keys are stored on the local system - but please take care that the folder they reside in is not inadvertently stored in the cloud!

With a little effort, this setup can also be modified to synchronize to the cloud directly without using a client application.

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

### Install rclone

1. clone this repository to a folder on your OneDrive
2. download [rclone](https://rclone.org/downloads/)
3. extract the ZIP archive and move its contents into the folder `.\rclone`
4. reading rclone's excellent [manual](https://rclone.org/docs/) can't hurt :-)

### Configuration (on every machine)

1. add an alias to the unencrypted source folder (technically, this is not necessary, but helps to prevent backing up the wrong location):

```ps1
$ .\rclone\rclone.exe config
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

2. if you also want to sync your `Downloads` folder, add a second alias (change `<USER>` to your user name):

```ps1
$ .\rclone\rclone.exe config
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

3. add encrypted remote folder, in this case OneDrive (change `<USER>` to your user name):

```ps1
$ .\rclone\rclone.exe config
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

4. create a (possibly empty) file `exclude_files.txt` in the `.\sync` folder - see the file `./sync/exclude_files.txt.orig` for some recommended exclusions

## Usage

Note: the scripts in this section will also synchronize your `Downloads` folder. So you have to either set it up as described above or change the scripts.

### Backup to cloud storage (encrypt)

Run the Windows batch script [sync/1-backup_to_cloud.bat](sync/1-backup_to_cloud.bat).

### Restore from cloud storage (decrypt)

Run the Windows batch script [sync/2-restore_from_cloud.bat](sync/2-restore_from_cloud.bat).

### Check differences

Run the Windows batch script [sync/3-check_differences.bat](sync/3-check_differences.bat).

### Upgrade rclone to latest version

```ps1
.\rclone\rclone.exe selfupdate
```
