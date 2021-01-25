Densha de Go! Plug & Play Chime Patcher
=======================================

This patch restores the original station jingles, musical horn, and limited
express passenger announcement jingles in Densha de Go! Plug & Play.

Requirements
------------
You need to have a PC installation of Densha de Go! Final to copy some chime
files from, and Densha de Go! Plug & Play Ver.1.13. In addition to those, you
will also need a USB flash drive and a powered USB OTG hub. Please have at
least 3GB free on the USB flash drive for a backup.

The USB OTG hub I use can be found [here](https://www.amazon.ca/gp/product/B07BDJN76M).

Usage
-----
1. From your Densha de Go! Final installation, copy all files in
   `cddata\dengo\Chime` to the `Chime` folder here.
2. Prepare a USB drive by formatting it to FAT32. Please search online if you
   need instructions on how to do this.
3. Copy all of the files in this repository (including the `Chime` folder you
   just put some files into) into the root of your USB drive. Eject the USB
   drive from your computer after it is finished copying.
4. Plug the USB drive into your USB OTG hub, then plug the hub into the micro
   USB port on the back of your Densha de Go! Plug & Play. Plug the power
   cable for your USB OTG hub into the hub and a USB power adapter.
5. Turn on your Densha de Go! Plug & Play.
6. The patching script will stop the game app and make a backup of your game
   files, then patch the game executable and copy over the chimes. While this
   is in progress, the door light will light. When it is complete, the unit
   will shut down and you can unplug the USB hub and plug in a regular USB
   power cable. If there is an error during processing, the door light will
   flash. If an error occurs, you can find a log at `log.txt` on the USB drive.
7. If the patching was successful, you should now be able to hear the original
   station jingles, musical horns, and limited express passenger announcment
   jingles.

Note: depending on the speed of your USB drive, the backup stage may take a
long time. Expect it to take 30-60 minutes to complete. Once it has been
completed, you can rerun the patching process without going through backup
again if necessary. Please safekeep the backup files: `dgtyp3zzzz.tar.gz`,
`dgtyp3zzzz.tar.gz.md5`, and `installed.md5`.
