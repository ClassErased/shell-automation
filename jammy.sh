#!/bin/bash

# Make GNOME great again (better privacy and mimic macOS, a little)
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
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'
gsettings set org.gnome.mutter center-new-windows 'true'
gsettings set org.gnome.nautilus.preferences show-create-link 'true'
gsettings set org.gnome.nautilus.preferences show-delete-permanently 'true'
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size '40'
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height 'false'
gsettings set org.gnome.shell.extensions.dash-to-dock scroll-action 'cycle-windows'
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts 'false'
gsettings set org.gnome.shell.extensions.ding show-home 'false'
gsettings set org.gnome.shell favorite-apps '[
    "org.gnome.FileRoller.desktop",
    "org.gnome.Calculator.desktop",
    "org.gnome.DiskUtility.desktop",
    "org.gnome.Nautilus.desktop",
    "google-chrome.desktop",
    "org.gnome.eog.desktop",
    "nvidia-settings.desktop",
    "gnome-control-center.desktop",
    "software-properties-gtk.desktop",
    "update-manager.desktop",
    "org.gnome.Terminal.desktop",
    "timeshift-gtk.desktop",
    "code.desktop"
]'

# Add padding to terminal window
tee -a "$HOME/.config/gtk-3.0/gtk.css" > /dev/null << EOF
VteTerminal,
TerminalScreen,
vte-terminal {
    padding: 10px;
    -VteTerminal-inner-border: 10px;
}
EOF

# Increase boot up speed by disabling os selection menu (not recommended for dual boot)
sudo tee -a '/etc/default/grub' > /dev/null <<< $'\nGRUB_RECORDFAIL_TIMEOUT=0'
sudo update-grub

# Set F1-12 as default on Keychron keyboards (if detected)
if [[ $(sudo lshw 2> /dev/null | grep Keychron) ]]; then
    sudo tee '/etc/modprobe.d/hid_apple.conf' > /dev/null <<< 'options hid_apple fnmode=2'
    sudo update-initramfs -u -k all
fi

# Purge
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

# Update
sudo apt update
sudo apt full-upgrade -y

# Nvidia driver (if detected)
if [[ $(sudo lshw -C display 2> /dev/null | grep vendor) =~ NVIDIA ]]; then
    sudo apt install -y nvidia-driver-515
fi

# Recommended apps
sudo apt install -y \
    curl \
    git \
    timeshift

# Flatpak
sudo apt install -y flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Google Chrome
wget https://dl.google.com/linux/linux_signing_key.pub -qO - | sudo gpg --dearmor -o /usr/share/keyrings/google.gpg
sudo tee '/etc/apt/sources.list.d/google-chrome.list' > /dev/null <<< 'deb [arch=amd64 signed-by=/usr/share/keyrings/google.gpg] https://dl.google.com/linux/chrome/deb/ stable main'
sudo apt update
sudo apt install -y google-chrome-stable

# Ungoogled Chromium (better privacy)
# flatpak install -y --noninteractive flathub com.github.Eloston.UngoogledChromium
# mkdir -p "$HOME/.var/app/com.github.Eloston.UngoogledChromium/config"
# tee "$HOME/.var/app/com.github.Eloston.UngoogledChromium/config/chromium-flags.conf" > /dev/null << EOF
# --force-dark-mode
# --enable-features=WebUIDarkMode
# EOF

# Visual Studio Code
wget https://packages.microsoft.com/keys/microsoft.asc -qO - | sudo gpg --dearmor -o /usr/share/keyrings/microsoft.gpg
sudo tee '/etc/apt/sources.list.d/vscode.list' > /dev/null <<< 'deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main'
sudo apt update
sudo apt install -y code
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

# Clean
rm -rf .wget-hsts
sudo apt clean
sudo apt autoclean &> /dev/null
sudo apt autoremove --purge -y &> /dev/null

# Hide
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

# Reboot
sudo reboot
