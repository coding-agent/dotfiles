local lfs = require("lfs")

local function listDirectories()
    local path = "scripts/"
    local currDir = lfs.currentdir()
    local dirList = {}

    for entry in lfs.dir(path) do
        if entry ~= "." and entry ~= ".." then
            local absPath = currDir .. "/" .. path .. "/" .. entry
            local mode = lfs.attributes(absPath, "mode")
            if mode == "directory" then
                table.insert(dirList, absPath)
            end
        end
    end

    return dirList
end

local function buildZigScripts(dirs)
    for _, dir in pairs(dirs) do
        local zig_module = dir:match("[^" .. package.config:sub(1, 1) .. "]+/?$")

        lfs.chdir(dir)
        local success, _, _ = os.execute("zig build -Doptimize=ReleaseFast -p ~/.local/ > /dev/null 2>&1 &")
        if success then
            print("\27[34m" .. zig_module .. "\27[0m" .. " built successfully successfully")
        else
            print("\27[34m" .. zig_module .. "\27[0m" .. " failed to build!")
        end
    end
end

os.execute("river")

buildZigScripts(listDirectories())
