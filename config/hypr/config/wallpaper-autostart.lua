-- Восстанавливает последние выбранные в waypaper обои при входе в сессию
hl.on("hyprland.start", function()
    hl.exec_cmd("waypaper --restore")
end)
