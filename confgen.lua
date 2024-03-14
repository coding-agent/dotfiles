cg.addPath(".config")
cg.addPath("scripts")
cg.addFile(".gtkrc-2.0")

cg.opt = require "cg_opts"

cg.onDone(function(errors)
    if errors then
        print "ERRORS DURING CONFGEN"
    else
        print "updating gsettings"
        cg.opt.system("gsettings set org.gnome.desktop.interface icon-theme " .. cg.opt.icon_theme)
        cg.opt.system("gsettings set org.gnome.desktop.interface gtk-theme " .. cg.opt.gtk_theme)
        cg.opt.system("gsettings set org.gnome.desktop.interface cursor-theme " .. cg.opt.cursor.theme)
        cg.opt.system("gsettings set org.gnome.desktop.interface cursor-size " .. cg.opt.cursor.size)
        cg.opt.system('gsettings set org.gnome.desktop.interface font-name "' .. cg.opt.font_term .. " " ..cg.opt.font_size)
        if cg.opt.compositor == "river" then
            cg.opt.system('gsettings set org.gnome.desktop.interface text-scaling-factor 1.5')
            cg.opt.system 'gsettings set org.gnome.desktop.wm.preferences button-layout ""'
        else
            cg.opt.system "gsettings reset org.gnome.desktop.wm.preferences button-layout"
        end
        cg.opt.system('export GTK_THEME="'.. cg.opt.gtk_theme ..'"')
    end

    -- builds the zig scripts
    local cmd = "ls -l " .. cg.opt.scripts_folder .. " | grep '^d' | awk '{print $9}'"
    local handle = io.popen(cmd)
    for folder in handle:lines() do
        local abs_path = cg.opt.scripts_folder .. folder
        cg.opt.buildZigScript(abs_path)
    end
    handle:close()
end)

cg.opt.system = function(cmd)
    local handle = io.popen(cmd)
    if handle == nil then
        error("Failed to spawn process" .. cmd)
    end
    local data, _ = handle:read("*a"):gsub("%s$", "")
    return data
end

cg.opt.buildZigScript = function(path)
    local build_path = path .. "/build.zig"
    local cmd = "zig build --build-file " .. build_path .. " -Doptimize=ReleaseFast -p ~/.local/"

    local handle = io.popen(cmd)
    if handle == nil then
        error("Failed to spawn process" .. cmd)
    end
    local result = handle:read("*a")
    local success, _, _ = handle:close()
    if success then
        print("built successfully")
    else
        print("build failed: " .. result)
    end
end


cg.opt.setCurrentWaylandCompositor = function(comp)
    cg.opt.wayland_compositor = comp
end

