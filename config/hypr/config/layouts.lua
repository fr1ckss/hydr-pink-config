-- dwindle — окна режутся пополам по очереди (как в i3/bspwm)
hl.config({
    dwindle = {
        preserve_split = true,
    },
})

-- master — одно большое окно + стопка остальных сбоку
hl.config({
    master = {
        new_status = "master",
    },
})

-- scrolling — экспериментальный "бесконечный холст" (как в niri)
hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})

hl.config({
    misc = {
        force_default_wallpaper = -1,    -- -1/0/1 — про дефолтные обои-мандаринки Hyprland
        disable_hyprland_logo   = false, -- true — убрать фирменный логотип с фона
    },
})
