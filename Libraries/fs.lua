local HttpService = game:GetService("HttpService")
local http = loadstring(import"http")()
local module = {}

function module.read(path)
	local splitPath = string.split(path,"\\")
	local drive = http.request("fs.get", splitPath[1])
	local data = nil
	local current = drive.c
	if not drive.c then return end
	for depth = 2, #splitPath do
		local key = splitPath[depth]
		
		if not current[key] then break end
		if depth == #splitPath then break end
		
		current = current[key].c
	end
	return data
end

function module.write(path, data)
	local splitPath = string.split(path,"\\")
	local drive = http.request("fs.get", splitPath[1])
	local current = drive.c
	if not drive.c then
		drive = {
			p = {},
			t = "",
			d = {},

			c = {},
		}
		current = drive.c
	end
	for depth = 2, #splitPath do
		local key = splitPath[depth]
		if not current[key] then
			current[key] = {
				p = {},
				t = depth == #splitPath and string.split(key, ".")[#string.split(key, ".")] or  "",
				d = {},
				
				c = {},
			}
		end
		if depth == #splitPath then 
			current[key].d = data
		end
		current = current[key].c
	end
	http.request("fs.set", {splitPath[1], drive})
end

function module.remove(path)
	local splitPath = string.split(path,"\\")
	local drive = http.request("fs.get", splitPath[1])
	local current = drive.c
	if not drive.c then return end
	for depth = 2, #splitPath do
		local key = splitPath[depth]
		if not current[key] then break end
		if depth == #splitPath then
			current[key] = nil
			break
		end
		current = current[key].c
	end
	return
end

return module
