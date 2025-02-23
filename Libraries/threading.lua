local HttpService = game:GetService("HttpService")
local http = loadstring(import"http")()
local currentThreadId = 0
local module = {}
local threads = {}
local function c(p)
	local n = Instance.new(p[1], p[2])
	for i, v in next, p do
		if not tonumber(i) then
			n[i] = v
		end
	end
	return n
end

function module.new(code)
	currentThreadId = currentThreadId + 1
	local func = loadstring(code)
	local env = {}
	env.import = function(name)
		local response = HttpService:RequestAsync{
			Url = "https://console-7.lisphm.repl.co",
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json"
			},
			Body = HttpService:JSONEncode{
				command = "getFile",
				value = "SDK/"..name..".lua",
			}
		}
		if not (response and response.Body) then return end
		local code = HttpService:JSONDecode(response.Body)[1]
		return code
	end
	env._thread = {
		Id = currentThreadId,
		Container = c{"Frame", Name = currentThreadId, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), ZIndex = currentThreadId+10},
		Connections = {}
	}
	env._thread.Connect = function(event, func)
		table.insert(env._thread.Connections, event:Connect(func))
	end
	setmetatable(env, {__index = getfenv(0)})
	setfenv(func, env)
	local thread = coroutine.create(func)
	coroutine.resume(thread)
	threads[tostring(env._thread.Id)] = env._thread
	env._thread.Connect(env._thread.Container.AncestryChanged, function()
		for _, v in next, env._thread.Connections do
			v:Disconnect()
		end
		coroutine.close(thread)
		return
	end)
	return env._thread
end

return module
