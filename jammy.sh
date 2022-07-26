# -------------------------------------------------------------
echo -e '\n\e[1;33mWelcome to jammy.sh v1.0...\n\e[0m'
# -------------------------------------------------------------

# ========== [ TWEAK ] ==========

echo -e '\n\e[1;33mTweaking...\n\e[0m'

gsettings set org.gnome.desktop.interface clock-format '12h'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-blue-dark'
gsettings set org.gnome.desktop.privacy remember-recent-files 'false'
gsettings set org.gnome.desktop.privacy remove-old-temp-files 'true'
gsettings set org.gnome.desktop.session idle-delay '0'
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'
gsettings set org.gnome.mutter center-new-windows 'true'
gsettings set org.gnome.nautilus.preferences show-delete-permanently 'true'
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'
gsettings set org.gnome.shell.extensions.dash-to-dock scroll-action 'cycle-windows'
gsettings set org.gnome.shell favorite-apps '["org.gnome.Terminal.desktop", "org.gnome.Nautilus.desktop", "com.github.Eloston.UngoogledChromium.desktop", "code.desktop"]'

tee -a "$HOME/.bashrc" > /dev/null << EOF
bind '"\e[15~":"history -cw\C-mclear\C-m"'
EOF
source .bashrc

# ========== [ PURGE ] ==========

echo -e '\n\e[1;33mPurging...\n\e[0m'

sudo apt autoremove --purge -y \
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
    vim-common \
    yelp

# ========== [ UPDATE ] ==========

echo -e '\n\e[1;33mUpdating...\n\e[0m'

wget https://packages.microsoft.com/keys/microsoft.asc -qO - | sudo gpg --dearmor -o /usr/share/keyrings/microsoft.gpg | sudo tee '/etc/apt/sources.list.d/vscode.list' > /dev/null <<< 'deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main'

sudo apt update
sudo apt full-upgrade -y

# ========== [ INSTALL ] ==========

echo -e '\n\e[1;33mInstallating...\n\e[0m'

sudo apt install -y \
    code \
    flatpak \
    git \
    nvidia-driver-515 \
    timeshift

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install -y --noninteractive flathub com.github.Eloston.UngoogledChromium

# ========== [ CONFIGURE ] ==========

echo -e '\n\e[1;33mConfiguring...\n\e[0m'

mkdir -p "$HOME/.var/app/com.github.Eloston.UngoogledChromium/config"
tee "$HOME/.var/app/com.github.Eloston.UngoogledChromium/config/chromium-flags.conf" > /dev/null << EOF
--force-dark-mode
--enable-features=WebUIDarkMode
EOF

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

# ========== [ HIDE ] ==========

echo -e '\n\e[1;33mHiding...\n\e[0m'

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

# ========== [ CLEAN ] ==========

echo -e '\n\e[1;33mCleaning...\n\e[0m'

sudo apt clean &> /dev/null
sudo apt autoclean &> /dev/null
sudo apt autoremove --purge -y &> /dev/null

# -----------------------------------------------------------------------------------------------
echo -e '\n\e[1;32mInstallation completed...\n\n\e[1;31mRebooting system in 10 seconds...\n\e[0m'
# -----------------------------------------------------------------------------------------------

sleep 10s
sudo reboot
