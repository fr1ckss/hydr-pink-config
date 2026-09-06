-- ============================================================
-- LOOK AND FEEL
-- general    — отступы между окнами, толщина и цвет рамки, layout
-- decoration — скругления, тени, блюр, прозрачность
-- animations — включены ли анимации вообще (сами анимации ниже)
-- ============================================================
hl.config({
    general = {
        gaps_in  = 3,   -- отступ МЕЖДУ окнами
        gaps_out = 5,  -- отступ от окон до края экрана

        border_size = 2,

        col = {
            -- градиент рамки активного окна: розовый (Catppuccin-style)
            active_border   = { colors = {"rgba(ff2d95ee)", "rgba(c837abee)"}, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        resize_on_border = false, -- ресайз окна кликом по рамке (без mainMod)
        allow_tearing    = false,

        layout = "dwindle", -- алгоритм тайлинга: dwindle (бинарное дерево) или master
    },

    decoration = {
        rounding       = 5, -- скругление углов окон, в пикселях
        rounding_power = 2,

        active_opacity   = 1.0, -- прозрачность активного окна (1.0 = непрозрачно)
        inactive_opacity = 0.95,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled  = true,
            size     = 8,      -- радиус блюра под полупрозрачными окнами/панелями
            passes   = 3,      -- больше passes = мягче блюр, но дороже по GPU
            new_optimizations = true,
            xray = false,
        },
    },

    animations = {
        enabled = true, -- общий рубильник анимаций
    },
})

-- Кривые анимации — задают "характер" движения (плавно/резко/с пружиной)
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 238.1191, dampening = 24.21279333 })

-- Какая кривая/скорость применяется к каждому типу события.
hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })
