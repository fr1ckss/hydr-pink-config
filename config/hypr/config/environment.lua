-- Переменные окружения для всей графической сессии.

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- Специфично для NVIDIA — заставляет видео/акселерацию
-- и рендер курсора идти через нужный бэкенд, а не дефолтный.
-- Если на машине НЕ NVIDIA — эти три строки безвредны, но можно убрать.
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("NVD_BACKEND", "direct")

hl.config({
    cursor = {
        no_hardware_cursors = true, -- курсор рендерится софтверно, стабильнее на NVIDIA
    },
})
