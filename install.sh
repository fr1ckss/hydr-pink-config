#!/usr/bin/env bash
# Установщик Hyprland + k4 + SDDM-тема + GTK/Qt-тема под Arch-based дистрибутивы
# (EndeavourOS, Arch, CachyOS и т.п.). Проверено на EndeavourOS + NVIDIA.
#
# Использование:
#   git clone <этот репозиторий>
#   cd hypr-dotfiles
#   ./install.sh
#
# Скрипт СПРАШИВАЕТ перед каждым потенциально разрушительным шагом
# (перезапись существующих конфигов) и ничего не делает молча.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HYPR_CONFIG_DIR="$HOME/.config/hypr"

echo "=================================================="
echo " Hyprland + k4 + SDDM (pink) — установка"
echo "=================================================="

confirm() {
    read -r -p "$1 [y/N] " reply
    [[ "$reply" =~ ^[Yy]$ ]]
}

if ! command -v pacman &>/dev/null; then
    echo "Это не Arch-based система (нет pacman). Скрипт рассчитан на Arch/EndeavourOS/CachyOS и т.п."
    exit 1
fi

# ---------------------------------------------------------
# 1. AUR-хелпер
# ---------------------------------------------------------
if ! command -v yay &>/dev/null; then
    if confirm "yay (AUR-хелпер) не найден. Поставить?"; then
        sudo pacman -S --needed --noconfirm git base-devel
        tmpdir=$(mktemp -d)
        git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
        (cd "$tmpdir/yay" && makepkg -si --noconfirm)
        rm -rf "$tmpdir"
    else
        echo "Без yay AUR-пакеты (waypaper, papirus-folders-catppuccin-git, k4-темы) ставить не получится. Прерываю."
        exit 1
    fi
fi

# ---------------------------------------------------------
# 2. Пакеты из официальных репозиториев
# ---------------------------------------------------------
echo
echo "-- Официальные пакеты --"
sudo pacman -S --needed --noconfirm \
    hyprland hypridle hyprlock hyprpaper hyprshot waybar \
    xdg-desktop-portal-hyprland hyprpolkitagent uwsm \
    ghostty yazi \
    sddm qt6-svg qt6-multimedia \
    papirus-icon-theme kvantum qt6ct qt5ct \
    grim slurp wl-clipboard playerctl brightnessctl

# ---------------------------------------------------------
# 3. NVIDIA (опционально — спрашиваем, т.к. на школьном ноуте
#    может быть другая видеокарта)
# ---------------------------------------------------------
if lspci | grep -qi nvidia; then
    if confirm "Обнаружена NVIDIA. Поставить nvidia-open-dkms и настроить kernel-параметр?"; then
        sudo pacman -S --needed --noconfirm nvidia-open-dkms nvidia-utils lib32-nvidia-utils egl-wayland

        if ! grep -q "nvidia-drm.modeset=1" /etc/default/grub 2>/dev/null; then
            echo "Добавь вручную 'nvidia-drm.modeset=1' в GRUB_CMDLINE_LINUX_DEFAULT в /etc/default/grub,"
            echo "затем: sudo grub-mkconfig -o /boot/grub/grub.cfg"
        fi

        # initramfs: определяем dracut или mkinitcpio
        if pacman -Q dracut &>/dev/null; then
            echo 'add_drivers+=" nvidia nvidia_modeset nvidia_uvm nvidia_drm "' | sudo tee /etc/dracut.conf.d/nvidia.conf >/dev/null
            sudo dracut-rebuild 2>/dev/null || sudo dracut --regenerate-all --force
        elif pacman -Q mkinitcpio &>/dev/null; then
            sudo sed -i 's/^MODULES=(\(.*\))/MODULES=(\1 nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
            sudo mkinitcpio -P
        fi
    fi
else
    echo "NVIDIA не обнаружена — пропускаю этот шаг (конфиг всё равно безвреден для AMD/Intel)."
fi

# ---------------------------------------------------------
# 4. AUR-пакеты
# ---------------------------------------------------------
echo
echo "-- AUR-пакеты --"
yay -S --needed --noconfirm \
    waypaper \
    papirus-folders-catppuccin-git \
    catppuccin-gtk-theme-mocha \
    catppuccin-cursors-mocha \
    kvantum-theme-catppuccin-git \
    zen-browser-bin \
    nwg-look

papirus-folders -C cat-mocha-pink --theme Papirus-Dark || true

# ---------------------------------------------------------
# 5. Quickshell + k4
# ---------------------------------------------------------
echo
echo "-- Quickshell + k4 --"
sudo pacman -S --needed --noconfirm quickshell
curl -fsSL https://raw.githubusercontent.com/k4ditano/k4/main/instalar | sh

# ---------------------------------------------------------
# 6. Конфиги Hyprland
# ---------------------------------------------------------
echo
echo "-- Конфиги Hyprland --"
if [ -d "$HYPR_CONFIG_DIR" ]; then
    backup="$HOME/.config/hypr.bak-$(date +%s)"
    echo "Существующий ~/.config/hypr найден, бэкаплю в $backup"
    cp -r "$HYPR_CONFIG_DIR" "$backup"
fi
mkdir -p "$HYPR_CONFIG_DIR"
cp -r "$REPO_DIR/config/hypr/"* "$HYPR_CONFIG_DIR/"

echo "ВАЖНО: открой ~/.config/hypr/config/monitors.lua и проверь/поправь"
echo "имена мониторов под hyprctl monitors ЭТОЙ машины (см. комментарии в файле)."

# ---------------------------------------------------------
# 7. SDDM + розовая тема Nebula
# ---------------------------------------------------------
echo
echo "-- SDDM --"
sudo mkdir -p /usr/share/sddm/themes
sudo cp -r "$REPO_DIR/sddm-nebula-pink" /usr/share/sddm/themes/nebula-pink
sudo mkdir -p /etc/sddm.conf.d
printf '[Theme]\nCurrent=nebula-pink\n' | sudo tee /etc/sddm.conf.d/theme.conf >/dev/null
sudo systemctl enable sddm

if ! systemctl get-default | grep -q graphical; then
    sudo systemctl set-default graphical.target
fi

echo
echo "=================================================="
echo " Готово. Что сделать руками после этого:"
echo " 1. Перезагрузиться, выбрать Hyprland в SDDM."
echo " 2. nwg-look — выставить Catppuccin-Mocha-Standard-Pink-Dark + Papirus-Dark"
echo " 3. kvantummanager — выбрать Catppuccin-Mocha-Pink"
echo " 4. qt6ct — Style: kvantum, Icon theme: Papirus-Dark"
echo " 5. Скопировать свою картинку в ~/Pictures/Wallpapers и открыть waypaper (SUPER+W)"
echo " 6. Скопировать свой ~/.config/start_screensaver.sh, если он используется"
echo "    (см. комментарий в config/hypr/config/windowrules.lua)"
echo " 7. Если Secure Boot включён — выключить в BIOS/UEFI (GRUB на Arch не подписан)"
echo "=================================================="
