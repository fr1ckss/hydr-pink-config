-- Только запуск панели k4. Хоткеи — в keybinds.lua, под твоим контролем.
-- os.getenv("HOME") вместо зашитого пути — работает под любым пользователем.
local raiz = os.getenv("HOME") .. "/.config/quickshell/k4"

hl.on("hyprland.start", function()
    hl.exec_cmd(raiz .. "/arrancar --no-duplicate -d")
end)
