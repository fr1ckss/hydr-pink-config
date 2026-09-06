-- Игнорировать запросы "развернуть на весь экран" от всех приложений
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- Фикс багов с перетаскиванием у XWayland-окон (старые X11-приложения)
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- Куда ставить окно hyprland-run (утилита запуска команд)
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})

-- Привязываем скринсейвер-окно ко второму монитору (если он есть).
-- Если на машине только один монитор (eDP-1) — просто закомментируй эти две штуки.
hl.window_rule({
    name = "music-screensaver",
    match = {
        class = "^music-screensaver$"
    },
    monitor = "eDP-1",
    fullscreen = true,
})

-- ВАЖНО: этот скрипт (~/.config/start_screensaver.sh) — личный, не входит
-- в этот репозиторий. Скопируй его сюда сам, иначе автозапуск ниже просто
-- ничего не найдёт и молча ничего не сделает.
hl.on("hyprland.start", function()
    hl.exec_cmd("ghostty --class=music-screensaver -e " .. os.getenv("HOME") .. "/.config/start_screensaver.sh")
end)
