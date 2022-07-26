# jammy.sh

A bash script to automate some fun stuff that were missing from the default Ubuntu 22.04 LTS minimal installation.

## How to use this script?

1. Download Ubuntu 22.04 LTS (Jammy Jellyfish) from https://ubuntu.com/download/desktop
2. Select minimal installation only.
3. Run the script on your terminal:

    `wget https://github.com/sudoxey/jammy.sh/releases/download/v1.0/jammy.sh -qO - | bash`

## What this script does?

### TWEAK:

- Set the clock format to 12 hours.
- Set the color scheme to dark.
- Set the gtk theme to Yaru-blue-dark.
- Do not remember recent files.
- Remove old temporary files automatically.
- Swap the window button to the left side to mimic MacOS.
- Center new windows by default.
- Set dock's click action to minimize/restore.
- Set dock's scroll action to cycle-windows.
- Set dock's favourite apps to Terminal, Nautilus, UngoogledChromium, Visual Studio Code.
- Set F5 keys to clear the terminal window.

### PURGE:

- Remove gedit, gnome-characters, gnome-font-viewer, gnome-logs, gnome-power-manager, gnome-startup-applications, gnome-system-monitor, libevdocument3-4
  nautilus-share, seahorse, snapd, vim-common, yelp
 
### UPDATE:

- Install Microsoft's GPG key and Visual Studio Code repository.
 - Update and upgrade the system.
 
### INSTALL:

- Install code, flatpak, git, nvidia-driver-515, timeshift, ungoogled chromium
 
### CONFIGURE:

- Configure dark theme for Ungoogled Chromium and some tweaks for Code.
 
### HIDE:

- Hide im-config, gnome-language-selector, nm-connection-editor, software-properties-drivers.
 
### CLEAN:

- Clean some residuals.
 
### REBOOT:

- Reboot the system after successfull installation.
- Press CTRL+C to cancel reboot if you need to review the installation log.
