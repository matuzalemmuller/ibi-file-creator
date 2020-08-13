# ibi file creator
*Hosted at [GitHub](https://github.com/matuzalemmuller/ibi-file-creator) and mirrored to [GitLab](https://gitlab.com/matuzalemmuller/ibi-file-creator).*

## Description

Script to be used to create test files in WD's ibi device.
Program will create files in `ìbi/test` folder and also delete and modify some of the files from that folder.

## Usage

1. Install ibi's Mac app: https://ibi.sandisk.com/apps
2. Log into the app using an account that has only **one** ibi associated.
3. Log into the app. The ibi will be displayed in the desktop.
4. Download `script.sh` and give it execution permissions:
```
chmod +x script.sh
```
5. Run the script to create test files in the `ibi/test` folder.
```
./script.sh <file_size_KB> <files_created> <files_deleted> <files_modified> 
```

* `<file_size_KB>` is the size of the files that will be created, in KB. Default value is `5000` (which is 5MB).
* `<files_created>` is the number of files that will be created. Default value is `5`.
* `<files_deleted>` is the number of files that will be deleted. Default value is `1`.
* `<files_modified>` is the number of files that will be modified. Default value is `2`.
