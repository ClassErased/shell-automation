#!/bin/bash

# // TWEAK

# Make GNOME great again (better privacy)

gsettings set org.gnome.desktop.interface clock-format '12h'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-blue-dark'
gsettings set org.gnome.desktop.peripherals.mouse natural-scroll 'true'
gsettings set org.gnome.desktop.privacy hide-identity 'true'
gsettings set org.gnome.desktop.privacy old-files-age 'uint32 0'
gsettings set org.gnome.desktop.privacy recent-files-max-age '1'
gsettings set org.gnome.desktop.privacy remember-app-usage 'false'
gsettings set org.gnome.desktop.privacy remember-recent-files 'false'
gsettings set org.gnome.desktop.privacy remove-old-temp-files 'true'
gsettings set org.gnome.desktop.privacy remove-old-trash-files 'true'
gsettings set org.gnome.desktop.privacy report-technical-problems 'false'
gsettings set org.gnome.desktop.privacy show-full-name-in-top-bar 'false'
gsettings set org.gnome.desktop.session idle-delay '0'
gsettings set org.gnome.mutter center-new-windows 'true'
gsettings set org.gnome.nautilus.preferences show-create-link 'true'
gsettings set org.gnome.nautilus.preferences show-delete-permanently 'true'
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'
gsettings set org.gnome.shell.extensions.dash-to-dock scroll-action 'cycle-windows'
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts 'false'
gsettings set org.gnome.shell.extensions.ding show-home 'false'
gsettings set org.gnome.shell favorite-apps '["org.gnome.Terminal.desktop", "org.gnome.Nautilus.desktop", "google-chrome.desktop", "code.desktop"]'

# Change wallpaper (https://www.reddit.com/r/wallpaper/comments/s8ku2j/sunrise_2560x1440/)

wget 'https://i.redd.it/wphlh5f5xuc81.png' -P "$HOME/Pictures/Wallpapers"
gsettings set org.gnome.desktop.background picture-uri "file://$HOME/Pictures/Wallpapers/wphlh5f5xuc81.png"
gsettings set org.gnome.desktop.background picture-uri-dark "file://$HOME/Pictures/Wallpapers/wphlh5f5xuc81.png"

# Disable OS selection menu to increase boot up speed (not recommended for multiple OS)

sudo tee -a '/etc/default/grub' > /dev/null <<< 'GRUB_RECORDFAIL_TIMEOUT=0'
sudo update-grub

# Set F1-12 as default on Keychron keyboards (if detected)

if sudo lshw 2> /dev/null | grep -q Keychron
    then
        sudo tee '/etc/modprobe.d/hid_apple.conf' > /dev/null <<< 'options hid_apple fnmode=2'
        sudo update-initramfs -u -k all
fi

# Set F5 to clear terminal history and window
# Added "$HOME/.local/bin" to "$PATH"

tee -a "$HOME/.bashrc" > /dev/null << EOF
bind '"\e[15~":"history -cw\C-mclear\C-m"'
PATH=$PATH:$HOME/.local/bin
EOF
source "$HOME/.bashrc"

# // DEBLOAT

sudo apt autoremove --purge -y \
    apport \
    gedit \
    gnome-characters \
    gnome-font-viewer \
    gnome-logs \
    gnome-power-manager \
    gnome-startup-applications \
    gnome-system-monitor \
    libevdocument3-4 \
    nautilus-share \
    seahorse \
    snapd \
    ubuntu-report \
    vim-common \
    whoopsie \
    yelp

cp \
    '/usr/share/applications/im-config.desktop' \
    '/usr/share/applications/gnome-language-selector.desktop' \
    '/usr/share/applications/nm-connection-editor.desktop' \
    '/usr/share/applications/software-properties-drivers.desktop' \
    "$HOME/.local/share/applications"
tee -a \
    "$HOME/.local/share/applications/im-config.desktop" \
    "$HOME/.local/share/applications/gnome-language-selector.desktop" \
    "$HOME/.local/share/applications/nm-connection-editor.desktop" \
    "$HOME/.local/share/applications/software-properties-drivers.desktop" \
    <<< 'Hidden=true' > /dev/null

# // UPDATE

wget https://dl.google.com/linux/linux_signing_key.pub -qO - | sudo gpg --dearmor -o /usr/share/keyrings/google.gpg
sudo tee '/etc/apt/sources.list.d/google-chrome.list' > /dev/null <<< 'deb [arch=amd64 signed-by=/usr/share/keyrings/google.gpg] https://dl.google.com/linux/chrome/deb/ stable main'

wget https://packages.microsoft.com/keys/microsoft.asc -qO - | sudo gpg --dearmor -o /usr/share/keyrings/microsoft.gpg
sudo tee '/etc/apt/sources.list.d/vscode.list' > /dev/null <<< 'deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main'

sudo apt update
sudo apt full-upgrade -y

# // INSTALL

if [[ $(sudo lshw -C display 2> /dev/null | grep vendor) =~ NVIDIA ]];
    then
        sudo apt install -y nvidia-driver-515
fi

sudo apt install -y \
    curl \
    code \
    flatpak \
    git \
    google-chrome-stable \
    timeshift

sudo tee -a '/etc/sysctl.conf' > /dev/null <<< 'fs.inotify.max_user_watches = 524288'
sudo sysctl -p > /dev/null
mkdir -p "$HOME/.config/Code/User"
tee "$HOME/.config/Code/User/settings.json" > /dev/null << EOF
{
    "editor.acceptSuggestionOnEnter": "off",
    "editor.cursorBlinking": "phase",
    "editor.cursorWidth": 2,
    "editor.matchBrackets": "never",
    "editor.renderWhitespace": "all",
    "editor.smoothScrolling": true,
    "editor.wordBasedSuggestions": false,
    "explorer.confirmDelete": false,
    "explorer.confirmDragAndDrop": false,
    "extensions.closeExtensionDetailsOnViewChange": true,
    "extensions.ignoreRecommendations": true,
    "files.autoSave": "afterDelay",
    "files.enableTrash": false,
    "files.insertFinalNewline": true,
    "files.trimTrailingWhitespace": true,
    "git.enabled": false,
    "html.format.indentInnerHtml": true,
    "search.showLineNumbers": true,
    "security.workspace.trust.untrustedFiles": "open",
    "telemetry.telemetryLevel": "off",
    "terminal.integrated.cursorBlinking": true,
    "terminal.integrated.cursorStyle": "line",
    "terminal.integrated.cursorWidth": 2,
    "window.newWindowDimensions": "maximized",
    "window.titleBarStyle": "custom",
    "window.titleSeparator": " — ",
    "workbench.editor.scrollToSwitchTabs": true,
    "workbench.editor.untitled.hint": "hidden",
    "workbench.list.smoothScrolling": true,
    "workbench.startupEditor": "none",
}
EOF

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# // CLEAN

rm -rf .wget-hsts
sudo apt clean
sudo apt autoclean &> /dev/null
sudo apt autoremove --purge -y &> /dev/null

# // REBOOT

sudo reboot
