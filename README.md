# eac-docker

Exact Audio Copy (EAC) in Docker


## Description

This is a modified fork of https://github.com/attilabogar/docker-eac.

This project can be used to simultaneously transfer Audio CD's using [Exact
Audio Copy](http://exactaudiocopy.de/) in a docker environment on a Linux
system w/ multiple CD-ROM drives. The modifications are about being able to use the metadata plugins.

The original project used different directories (wine prefixes) to install EAC.
That means that each instance had its own registry, its own EAC database and its own settings.
This removes that separation, using a single registry and single EAC database. This can cause problems, see Usage.

## Requirements

  - Linux computer w/ one or more CD-ROM drives and internet access
  - docker
  - docker-compose
  - access to `/dev/sr*` block devices
  - VNC client (tigerVNC recommended)

## Setup

  - `eac.rc` settings for eac-docker (see example file `eac.rc.example`)
  - `drives.txt` CD-ROM static drive mapping (see example file `drives.txt.example`)
  - Clone this repository to your Linux system.

### drives.txt

Create `drives.txt`.  The format of this file is one line per CD-ROM in a
format `<drivename> <drivemapping>`. You cannot use spaces in the drivename.
You have to use the `/dev/disk/by-id/XXXXXXXXXX` links for `<drivemapping>`. IDE drives will not work. 
You can use `cdrecord dev=/dev/disk/by-id/XXXXXXXX --checkdrive` to find the name(s) of your drive(s).
An example configuration file is provided
as `drives.txt.example`. To find the available CD-ROM drives run `ls -l
/dev/disk/by-id/`

Keeping CD-ROM mapping in `drives.txt` keeps the drive mapping consistent, even
if `/dev/sr*` block device numbering order changes.

### eac.rc

Now customise `eac.rc`, edit and set
  - `SHARE` - the directory to map as `/data` in the containers. This is where you should save your rips.
  - `SCREEN_WIDTH` - VNC screen width (1920 by default)
  - `SCREEN_HEIGHT` - VNC screen height (1080 by default)

### eac.exe + common folder
Download EAC from http://exactaudiocopy.de, rename it to eac.exe and copy it inside the eac-docker/common/eac/ folder.
The common folder is very crucial. It should not be edited nor moved. Inside common/wine is where EAC and the registry are going to be installed.
Inside common/profiles is an included profile set-up for FLAC rips. See Usage on how to load it into EAC.
  
### WINE/EAC Setup

This part is only needed once for the first time for one container. You only run this once in one container, no matter how many drives you have.

  - Make sure docker is running on your host. `systemctl start docker`
  - Open terminal on the host in the eac-docker folder and run: `sh eac.sh`
  - After the stack is up and ~15 seconds have elapsed, open your VNC client and connect to 127.0.0.1:11.
  This is where your first container is. If you have more than 1 drive, the rest of the containers are at 127.0.0.1:12, 127.0.0.1:13 etc.
  You just need one container for now so access 127.0.0.1:11.

  - Right click on the black background inside the VNC screen and click `Terminal`.
  - Inside the terminal, execute the included script: `/script.sh`.
  This will first pull up `winecfg`, then install winetricks, install dotnet20, dotnet40 and vcrun2008 and finally install EAC.
  - Don't install mono or gecko.
  - When `winecfg` opens, select the Drives menu, click Add, `D:` and click OK. Next edit the path to `/cdrom`, click Show Advanced and select `Type: CD-ROM`. Click OK.
  - Then the script continues its job. You will have to interact with the installations, just check `Accept...` on all and install. Once you get to the EAC installation, in the final step UNCHECK `Run Eac` and click finish. Now EAC is installed for all your containers and drives!

## Usage

You can now access your containers through your VNC application and begin ripping. To run EAC, right click on the black background inside the VNC environment and click `Exact Audio Copy`.
I suggest you load the included FLAC profile. Open EAC Options, Profile, Load Profile, navigate up to `drive_c`, then go to `users/user/Application Data/EAC/Profiles and select included_flac_profile.cfg`.

Next, set up your Drive Options.

Finally, you can start ripping. Save your rips to `/data`. They will be available for you in the directory you set as `SHARE` in `eac.rc`.

There have been some issues when running `Detect Gaps` and `Create Cue Sheet` simultaneously on 2 or more containers.
I suggest you run these processes one at a time but then you can rip simultaneously without any problems.

When you are done ripping, simply press enter in the terminal you ran `sh eac.sh` on the host and the containers will go down.
Next time you want to rip, simply run `sh eac.sh` again inside the eac-docker folder and access the containers through VNC.
There is no need for any setup, you might just have to load again the included or your own EAC profile.

## LICENSE

    MIT License

    Copyright (c) 2019 Attila Bogár

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.

**NOTE**: This software depends on other packages that may be licensed under
different open source licenses.
