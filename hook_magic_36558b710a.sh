#!/bin/sh

# Densha de Go! Plug & Play chimes patching script

USB_ROOT="/mnt"

error_exit() {
    # Blink the door light to indicate an error
    echo timer > /sys/class/leds/led2/trigger
    echo 100 > /sys/class/leds/led2/delay_on
    echo 100 > /sys/class/leds/led2/delay_off
    exit 1
}

{

# Stop Densha de Go! game app
/etc/init.d/S99dgtype3 stop

# Light the door light to indicate we're running
echo -n none > /sys/class/leds/led2/trigger
echo 1 > /sys/class/leds/led2/brightness

# Check if we need to create a backup
if [ -f "${USB_ROOT}/backup_required" ]; then
    # We're actually going to create a full factory install package that if you
    # decided to delete the game entirely for some reason, you can just add the
    # factory install flag to the drive and plug it in to reinstall.

    # Tar up the game
    cd /root
    if ! tar -c dgf Data/ | gzip -c > "${USB_ROOT}/dgtyp3zzzz.tar.gz"; then
        error_exit
    fi
    # Generate MD5 sum of the tarball
    cd "${USB_ROOT}"
    md5sum dgtyp3zzzz.tar.gz > dgtyp3zzzz.tar.gz.md5
    # Generate MD5 sum of the installed files (per factory install script)
    echo `(find /root/Data/ /root/dgf -type f -exec md5sum {} \;) | awk '{print $1}' | env LC_ALL=C sort | md5sum` > installed.md5
    # Remove backup flag if successful
    rm "${USB_ROOT}/backup_required"
fi

# Remount with write access
mount -o remount,rw /

if [ -f "${USB_ROOT}/revert" ]; then
    # Revert changes flag detected, restore original file and delete chimes
    cd /root
    if [ ! -f dgf.orig ]; then
        echo "Original dgf executable not found, cannot revert."
        error_exit
    fi
    mv dgf.orig dgf
    rm -rf Data/cddata/dengo
    rm "${USB_ROOT}/revert"
    poweroff
    exit
fi

# Copy over the chimes
# But first, let's make sure we actually have files to copy over
if ! ls "${USB_ROOT}/Chime"/*.vag > /dev/null; then
    echo 'Please copy the chimes from your Densha de Go! Final installation before using on your Densha de Go! Plug & Play.'
    error_exit
fi

# Also, make sure (at least one) chime is correct
if ! sha1sum -c "${USB_ROOT}/223_1.vag.sha1"; then
    echo 'Please make sure the chimes are from the installation as described in the README.'
    error_exit
fi

# Make chimes directory
mkdir -p /root/Data/cddata/dengo/Chime

# Copy the files
if ! cp "${USB_ROOT}/Chime"/*.vag /root/Data/cddata/dengo/Chime/; then
    error_exit
fi

# Do patching
# Copy bspatch to /tmp and apply execute permission
cp "${USB_ROOT}/bin/bspatch" /tmp/bspatch
chmod +x /tmp/bspatch

cd /root

# Check that the game executable is the expected version
if ! sha1sum -c "${USB_ROOT}/dgf.sha1"; then
    echo "Game executable SHA1 hash mismatch, this version may not be supported or the game has already been patched."
    error_exit
fi

# Patch the game executable
if ! LD_LIBRARY_PATH="${USB_ROOT}/bin" /tmp/bspatch dgf dgf_patched "${USB_ROOT}/dgf.patch"; then
    echo "Error patching"
    error_exit
fi

# Check that the patched executable is valid
if ! sha1sum -c "${USB_ROOT}/dgf_patched.sha1"; then
    echo "Patching appears to have produced incorrect file."
    rm dgf_patched
    rm -rf Data/cddata/dengo
    error_exit
fi

# Move files into place
mv dgf dgf.orig
mv dgf_patched dgf
chmod 555 dgf
chmod 444 /root/Data/cddata/dengo/Chime/*
chown 1000:1000 dgf
chown -R 1000:1000 /root/Data/cddata/dengo

# We're done, shutdown
poweroff

} > "${USB_ROOT}/log.txt" 2>&1
