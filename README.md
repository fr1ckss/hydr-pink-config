# Hyprland dotfiles

Личный конфиг Hyprland: Lua-конфиг, [k4](https://github.com/k4ditano/k4) как панель,
розовая тема SDDM на базе [amitpadhan525/sddm-themes](https://github.com/amitpadhan525/sddm-themes)
(Nebula, перекрашенная под розовый), Catppuccin Mocha (акцент Pink) для GTK/Qt/иконок/курсора.

Проверено на EndeavourOS (Arch-based) с NVIDIA. Должно работать на любом
Arch-based дистрибутиве с минимальными правками.

## Установка

```bash
git clone <URL-этого-репозитория>
cd hypr-dotfiles
./install.sh
```

Скрипт ставит пакеты (pacman + AUR через yay), копирует Lua-конфиги в
`~/.config/hypr`, ставит и активирует SDDM с розовой темой.

**После установки руками:**

1. Перезагрузиться, в SDDM выбрать сессию Hyprland.
2. Открой `~/.config/hypr/config/monitors.lua` — единственный файл, который
   почти гарантированно нужно поправить под конкретную машину (имена
   мониторов через `hyprctl monitors`).
3. `nwg-look` → Theme: `Catppuccin-Mocha-Standard-Pink-Dark`, Icon Theme: `Papirus-Dark`.
4. `kvantummanager` → выбрать `Catppuccin-Mocha-Pink`.
5. `qt6ct` → Style: `kvantum`, Icon theme: `Papirus-Dark`.
6. Скопировать свою картинку в `~/Pictures/Wallpapers/`, `waypaper` (`SUPER+W`) чтобы выбрать.
7. Если используешь `windowrules.lua` → `music-screensaver` — положи свой
   `~/.config/start_screensaver.sh`, он не входит в репозиторий.
8. Если включён Secure Boot — выключи в BIOS/UEFI (Arch-based GRUB им не подписан).

## Структура

```
config/hypr/
├── hyprland.lua              — точка входа, только require()
└── config/
    ├── monitors.lua          — МАШИНОЗАВИСИМЫЙ, правь в первую очередь
    ├── environment.lua       — переменные окружения, NVIDIA-страховка
    ├── appearance.lua        — отступы, рамки, блюр, анимации
    ├── layouts.lua           — dwindle/master/scrolling
    ├── input.lua             — клавиатура (pl,ru), тачпад, жесты
    ├── programs.lua          — терминал/файлменеджер/браузер/меню
    ├── keybinds.lua          — все хоткеи (свои + функции k4)
    ├── windowrules.lua       — правила для окон
    ├── k4-autostart.lua      — запуск панели k4
    └── wallpaper-autostart.lua — восстановление обоев через waypaper

sddm-nebula-pink/             — SDDM-тема (форк Nebula, перекрашен в розовый)
install.sh                    — установщик под Arch-based системы
```

## Горячие клавиши (основное)

| Клавиши | Действие |
|---|---|
| `SUPER + Q` | Терминал (ghostty) |
| `SUPER + E` | Файлменеджер (yazi в терминале) |
| `SUPER + X` | Браузер (zen-browser) |
| `SUPER + C` | Закрыть окно |
| `SUPER + Space` | Лаунчер k4 |
| `SUPER + SHIFT + Space` | Приложения панели k4 |
| `SUPER + V` | Буфер обмена k4 |
| `SUPER + W` | waypaper (переключить обои) |
| `SUPER + [0-9]` | Переключить стол |
| `SUPER + SHIFT + A/D` | Стол влево/вправо |
| `SUPER + A/D` | Перекинуть окно на другой монитор |
| `SUPER + , / .` | Переключить фокус на другой монитор |
| `SUPER + SHIFT + S` | Скриншот региона в буфер |
| `SUPER + M` | Выход из сессии (через uwsm) |

Полный список — в `config/hypr/config/keybinds.lua`, там же комментарии
про то, что уже занято под функции k4.
