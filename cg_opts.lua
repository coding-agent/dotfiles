local opts = {}

opts.font = "HeavyData Nerd Font"
opts.font_term = "Iosevka NFM"
opts.font_size = "12"

opts.gtk_theme = "Breeze-Dark"
opts.icon_theme = "Surn-Arch-Blue"

opts.scripts_folder = os.getenv("HOME") .. "/scripts"

opts.cursor = {
    theme = "darkbolt-cursor",
    size = 24,
}

opts.wallpaper = os.getenv("HOME") .. "/dev/wallpapers/aqua.png"

return opts
