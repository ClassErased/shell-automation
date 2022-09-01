# // MAKE GNOME (AND PRIVACY) GREAT AGAIN

gsettings set org.gnome.desktop.interface clock-format '12h'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-blue-dark'
gsettings set org.gnome.desktop.peripherals.mouse natural-scroll 'true'
gsettings set org.gnome.desktop.privacy remember-recent-files 'false'
gsettings set org.gnome.desktop.privacy remove-old-temp-files 'true'
gsettings set org.gnome.desktop.session idle-delay '0'
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'
gsettings set org.gnome.mutter center-new-windows 'true'
gsettings set org.gnome.nautilus.preferences show-delete-permanently 'true'
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size '32'
gsettings set org.gnome.shell.extensions.dash-to-dock scroll-action 'cycle-windows'
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts 'false'
gsettings set org.gnome.shell.extensions.dash-to-dock show-trash 'false'
gsettings set org.gnome.shell.extensions.ding show-home 'false'

# // DISABLE OS SELECTION

sudo tee -a '/etc/default/grub' > /dev/null << EOF
GRUB_RECORDFAIL_TIMEOUT=0
EOF
sudo update-grub

# // ADD PADDING TO TERMINAL WINDOW

tee -a "$HOME/.config/gtk-3.0/gtk.css" > /dev/null << EOF
VteTerminal,
TerminalScreen,
vte-terminal {
    padding: 10px;
    -VteTerminal-inner-border: 10px;
}
EOF

# // F5 TO CLEAR TERMINAL HISTORY AND WINDOW (FOR OCD REMEDY)

tee -a "$HOME/.bashrc" > /dev/null << EOF
bind '"\e[15~":"history -cw\C-mclear\C-m"'
export PATH=$PATH:$HOME/.local/bin
EOF
source .bashrc

# // F1-12 AS DEFAULT ON KEYCHRON KEYBOARDS (IF DETECTED)

if [[ $(sudo lshw 2> /dev/null | grep Keychron) ]]; then
sudo tee '/etc/modprobe.d/hid_apple.conf' > /dev/null << EOF
options hid_apple fnmode=2
EOF
sudo update-initramfs -u -k all
fi

# // PURGE

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

# // UPDATE

sudo apt-get update > /dev/null
sudo apt full-upgrade -y

# // INSTALL NVIDIA DRIVER (IF DETECTED)

if [[ $(sudo lshw -C display 2> /dev/null | grep vendor) =~ NVIDIA ]]; then
    sudo apt install -y nvidia-driver-515
fi

# // INSTALL RECOMMENDED APPS

sudo apt install -y \
    curl \
    git \
    timeshift

# // INSTALL FLATPAK

sudo apt install -y flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# // INSTALL GOOGLE CHROME

wget https://dl.google.com/linux/linux_signing_key.pub -qO - | sudo gpg --dearmor -o /usr/share/keyrings/google.gpg | sudo tee '/etc/apt/sources.list.d/google-chrome.list' > /dev/null <<< 'deb [arch=amd64 signed-by=/usr/share/keyrings/google.gpg] https://dl.google.com/linux/chrome/deb/ stable main' 
sudo apt-get update > /dev/null
sudo apt install -y google-chrome-stable

# // INSTALL UNGOOGLED CHROMIUM (FOR BETTER PRIVACY)

# flatpak install -y --noninteractive flathub com.github.Eloston.UngoogledChromium
# mkdir -p "$HOME/.var/app/com.github.Eloston.UngoogledChromium/config"
# tee "$HOME/.var/app/com.github.Eloston.UngoogledChromium/config/chromium-flags.conf" > /dev/null << EOF
# --force-dark-mode
# --enable-features=WebUIDarkMode
# EOF

# // INSTALL VISUAL STUDIO CODE

wget https://packages.microsoft.com/keys/microsoft.asc -qO - | sudo gpg --dearmor -o /usr/share/keyrings/microsoft.gpg | sudo tee '/etc/apt/sources.list.d/vscode.list' > /dev/null <<< 'deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main'
sudo apt-get update > /dev/null
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

# // HIDE

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

# // CLEAN

sudo apt clean &> /dev/null
sudo apt autoclean &> /dev/null
sudo apt autoremove --purge -y &> /dev/null

# // REBOOT

echo -e '\n\e[1;32m// INSTALLATION COMPLETED...\e[0m\n\n\e[1;31m// REBOOTING SYSTEM IN 10 SECONDS...\e[0m\n'
sleep 10s
sudo reboot
