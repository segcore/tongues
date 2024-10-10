#!/usr/bin/env lua
while true do
    local slice = io.read(1024)
    if slice then
        if not io.write(slice) then
            io.stderr:write("Failed to write to standard output\n")
            os.exit(false)
        end
    else
        break
    end
end
