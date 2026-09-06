hl.config({
    input = {
        kb_layout  = "pl, ru", -- раскладки клавиатуры (переключение — см. kb_options ниже)
        kb_variant = "",
        kb_model   = "",
        kb_options = "grp:alt_shift_toggle", -- ALT+SHIFT переключает раскладку
        kb_rules   = "",

        follow_mouse = 1, -- фокус окна следует за курсором мыши

        sensitivity = 0, -- чувствительность мыши, от -1.0 до 1.0
        accel_profile = "flat",

        touchpad = {
            natural_scroll = false, -- true — "как на маке" (скролл наоборот)
        },
    },
})

-- Жест: 3 пальца горизонтально = переключение воркспейса
hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace"
})
