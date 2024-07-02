local opt = {}

opt.default_editor = "nvim"

opt.font = "HeavyData Nerd Font"
opt.font_term = "Hurmit Nerd Font"
opt.font_size = "12"

opt.gtk_theme = "Breeze-Dark"
opt.icon_theme = "Surn-Arch-Blue"

opt.scripts_folder = os.getenv("HOME") .. "/scripts"

opt.cursor = {
    theme = "darkbolt-cursor",
    size = 24,
}

opt.wallpapers_path = os.getenv("HOME") .. "/dev/wallpapers"
opt.wallpaper = opt.wallpapers_path .. "/zig.gif"

opt.term = {
    font = "Hurmit Nerd Font",
    alpha = 0.8,
    foreground = "bbbbbb",
    background = "090a18",
    regular0 = "090a18",
    regular1 = "f4fa8c",
    regular2 = "f4fa8c",
    regular3 = "bfa51a",
    regular4 = "4ab2d7",
    regular5 = "f4fa8c",
    regular6 = "f4fa8c",
    regular7 = "bfa51a",
    bright0 = "2b1329",
    bright1 = "faff75",
    bright2 = "60ba80",
    bright3 = "de9b1d",
    bright4 = "8ba7ea",
    bright5 = "f4fa8c",
    bright6 = "f4fa8c",
    bright7 = "bfa51a",
    selection_foreground = "ffffff",
    selection_background = "4C637A",
    urls = "43EDC9",
    cursor_foreground = "000000",
    cursor_background = "ccccff",
    border_focused = "1080ee",
    border_unfocused = "595959"
}

return opt
