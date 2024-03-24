local RunService = game:GetService("RunService")
local function uiDecode(json)
	local success, data = pcall(function()
		return game:GetService("HttpService"):JSONDecode(json)
	end)

	local function set(object, parent)
		if not object.ClassName then return end
		local n = Instance.new(object.ClassName)
		for prop, value in next, object do
			if prop ~= "Children" and prop ~= "ClassName" then
				if type(value) == "table" then
					local t = value[1]
					if t == "Color" then
						n[prop] = Color3.fromRGB(value[2], value[3], value[4])
					elseif t == "Vector2" then
						n[prop] = Vector2.new(value[2], value[3])
					elseif t == "Enum" then
						n[prop] = Enum[value[2]][value[3]]
					elseif t == "UDim2" then
						n[prop] = UDim2.new(value[2], value[3], value[4], value[5])
					elseif t == "UDim" then
						n[prop] = UDim.new(value[2], value[3])
					elseif t == "ColorSeq" then
						n[prop] = ColorSequence.new(
							(function()
								local tab = {}
								for i, arr in next, value do
									if i ~= 1 then
										if arr[1] == "CSK" then
											table.insert(tab, ColorSequenceKeypoint.new(arr[2], Color3.fromRGB(arr[3][2], arr[3][3], arr[3][4])))
										end
									end 
								end
								return tab
							end)()
						)
					end
				else
					n[prop] = value
				end
			end
		end
		for _, child in next, object.Children do
			local newObject = set(child, n)
		end
		n.Parent = parent
		return n
	end

	if type(data) == "table" then
		local output = {}
		for _, object in next, data do
			local newObject = set(object)
			table.insert(output, newObject)
		end
		return output
	else
		print(data)
	end
	return
end

local uiTable = uiDecode('[{"Children":[{"Active":false,"Selectable":false,"ZIndex":2,"Archivable":true,"Size":["UDim2",1,0,0,24],"Children":[],"TextXAlignment":["Enum","TextXAlignment","Left"],"ClipsDescendants":false,"BorderColor3":["Color",27,42,53],"Text":"Basic UI","TextSize":24,"Font":["Enum","Font","SourceSansItalic"],"Name":"Title","ClassName":"TextLabel","TextColor3":["Color",255,255,255],"BorderSizePixel":0,"BackgroundColor3":["Color",0,0,0]},{"ScaleType":["Enum","ScaleType","Crop"],"BorderSizePixel":0,"ClipsDescendants":false,"BorderColor3":["Color",27,42,53],"SliceCenter":["Rect",0,0,[0,0],[0,0]],"Active":false,"Selectable":false,"Children":[],"Image":"rbxassetid://2499785599","Name":"Background","ClassName":"ImageLabel","Size":["UDim2",1,0,1,0],"Archivable":true,"BackgroundColor3":["Color",0,0,0]},{"Active":false,"Selectable":false,"Archivable":true,"Size":["UDim2",0.5,0,0.5,0],"ClassName":"TextLabel","TextXAlignment":["Enum","TextXAlignment","Left"],"ClipsDescendants":false,"Text":"Label","TextSize":12,"TextColor3":["Color",255,255,255],"BorderSizePixel":0,"Font":["Enum","Font","RobotoMono"],"Name":"Command","Position":["UDim2",0,0,0.5,0],"BackgroundTransparency":0.20000000298023225,"TextYAlignment":["Enum","TextYAlignment","Bottom"],"Children":[],"BackgroundColor3":["Color",0,0,0]},{"Children":[{"VerticalAlignment":["Enum","VerticalAlignment","Bottom"],"FillDirection":["Enum","FillDirection","Horizontal"],"HorizontalAlignment":["Enum","HorizontalAlignment","Right"],"ClassName":"UIListLayout","SortOrder":["Enum","SortOrder","LayoutOrder"],"Name":"UIListLayout","Children":[],"Archivable":true},{"Visible":false,"ClipsDescendants":false,"Selectable":false,"LayoutOrder":3,"Children":[],"Active":false,"BorderColor3":["Color",27,42,53],"Name":"Placeholder","ClassName":"Frame","BorderSizePixel":0,"Size":["UDim2",0.00800000037997961,0,1,0],"Archivable":true,"BackgroundColor3":["Color",255,255,255]},{"PaddingRight":["UDim",0.019999999552965165,0],"PaddingTop":["UDim",0.019999999552965165,0],"Name":"UIPadding","ClassName":"UIPadding","PaddingBottom":["UDim",0.019999999552965165,0],"PaddingLeft":["UDim",0.019999999552965165,0],"Archivable":true,"Children":[]}],"Active":false,"Selectable":false,"Name":"FPS","ClipsDescendants":false,"BorderColor3":["Color",27,42,53],"Size":["UDim2",0.6000000238418579,0,0.5,-24],"BorderSizePixel":0,"BackgroundTransparency":0.20000000298023225,"ClassName":"Frame","Position":["UDim2",0,0,0,24],"ZIndex":2,"Archivable":true,"BackgroundColor3":["Color",0,26,50]},{"Children":[{"VerticalAlignment":["Enum","VerticalAlignment","Bottom"],"FillDirection":["Enum","FillDirection","Horizontal"],"HorizontalAlignment":["Enum","HorizontalAlignment","Right"],"ClassName":"UIListLayout","SortOrder":["Enum","SortOrder","LayoutOrder"],"Name":"UIListLayout","Children":[],"Archivable":true},{"Visible":false,"ClipsDescendants":false,"Selectable":false,"LayoutOrder":3,"Children":[],"Active":false,"BorderColor3":["Color",27,42,53],"Name":"Placeholder","ClassName":"Frame","BorderSizePixel":0,"Size":["UDim2",0.00800000037997961,0,1,0],"Archivable":true,"BackgroundColor3":["Color",255,255,255]},{"PaddingRight":["UDim",0.019999999552965165,0],"PaddingTop":["UDim",0.019999999552965165,0],"Name":"UIPadding","ClassName":"UIPadding","PaddingBottom":["UDim",0.019999999552965165,0],"PaddingLeft":["UDim",0.019999999552965165,0],"Archivable":true,"Children":[]}],"Active":false,"Selectable":false,"Name":"RAM","ClipsDescendants":false,"BorderColor3":["Color",27,42,53],"Size":["UDim2",0.5,0,0.5,0],"BorderSizePixel":0,"BackgroundTransparency":0.20000000298023225,"ClassName":"Frame","Position":["UDim2",0.5,0,0.5,0],"ZIndex":2,"Archivable":true,"BackgroundColor3":["Color",43,27,53]},{"TextWrapped":true,"Active":false,"Selectable":false,"Children":[],"ZIndex":3,"Archivable":true,"Size":["UDim2",0.5,0,0,24],"TextXAlignment":["Enum","TextXAlignment","Left"],"ClipsDescendants":false,"BorderColor3":["Color",27,42,53],"Text":"Server FPS","TextSize":18,"ClassName":"TextLabel","TextColor3":["Color",255,255,255],"Font":["Enum","Font","RobotoMono"],"BackgroundTransparency":1,"Position":["UDim2",0,0,0,24],"Name":"FPSTitle","TextYAlignment":["Enum","TextYAlignment","Top"],"BackgroundColor3":["Color",255,255,255]},{"TextWrapped":true,"Active":false,"Selectable":false,"Children":[],"ZIndex":3,"Archivable":true,"Size":["UDim2",0.5,0,0,24],"TextXAlignment":["Enum","TextXAlignment","Left"],"ClipsDescendants":false,"BorderColor3":["Color",27,42,53],"Text":"Server Memory","TextSize":18,"ClassName":"TextLabel","TextColor3":["Color",255,255,255],"Font":["Enum","Font","RobotoMono"],"BackgroundTransparency":1,"Position":["UDim2",0.5,0,0.5,0],"Name":"RAMTitle","TextYAlignment":["Enum","TextYAlignment","Top"],"BackgroundColor3":["Color",255,255,255]},{"Active":false,"Selectable":false,"Name":"Stats","TextXAlignment":["Enum","TextXAlignment","Left"],"Archivable":true,"Size":["UDim2",0.4000000059604645,0,0.5,-24],"TextSize":18,"ClipsDescendants":false,"BorderColor3":["Color",27,42,53],"Text":"Label","BorderSizePixel":0,"TextColor3":["Color",255,255,255],"Position":["UDim2",0.6000000238418579,0,0,24],"Font":["Enum","Font","RobotoMono"],"BackgroundTransparency":0.20000000298023225,"ClassName":"TextLabel","Children":[],"TextYAlignment":["Enum","TextYAlignment","Top"],"BackgroundColor3":["Color",0,0,0]}],"Active":false,"BorderColor3":["Color",27,42,53],"ClipsDescendants":false,"Size":["UDim2",1,0,1,0],"Selectable":false,"Name":"Basic UI","ClassName":"Frame","Archivable":true,"BackgroundColor3":["Color",255,255,255]}]')
local ui = uiTable[1]
ui.Parent = _thread.Container
local versionName = "Cherry"
local version = "0.4.1"
local versionImage = "rbxassetid://13415357068"
ui.Background.Image = versionImage
ui.Title.Text = versionName.." UI"

local barPool = {}
local t = 0
local mt = 0
local fpsCount = 240
do
	local gradient = Instance.new("UIGradient", ui.FPS.Placeholder)
	gradient.Transparency = NumberSequence.new{
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(.05, .8),
		NumberSequenceKeypoint.new(1, 1)
	}
	gradient.Rotation = 90
	local clone = gradient:Clone()
	clone.Parent = ui.RAM.Placeholder
end
local memCount = 600
local memScaleMax = 1
local memScaleMin = 1
local oldFuzzy = 100
local gradientSize = .02
local memCooldown = false

local function updateFPS(dt)
	t = t + 1
	ui.FPSTitle.Text = "Server Speed ("..(math.round(1/dt*10)/10).." FPS)"
	local new = barPool[1]
	if not new then
		new = ui.FPS.Placeholder:Clone()
	else
		table.remove(barPool, 1)
	end
	new.Name = t
	new.LayoutOrder = t
	new.BackgroundColor3 = Color3.fromHSV(math.clamp(1/dt/60*.3,0,.3), 1, 1)
	new.Size = UDim2.new(1/fpsCount, 0, math.min(1/dt/60,1)*.8, 0)
	new.Visible = true
	new.Parent = ui.FPS
	if #ui.FPS:GetChildren() > fpsCount+3 then
		table.insert(barPool, ui.FPS[tostring(t-fpsCount)])
	end
end
local function updateMem()
	mt = mt + 1
	memCooldown = true
	local new = barPool[1]
	if not new then
		new = ui.RAM.Placeholder:Clone()
	else
		table.remove(barPool, 1)
	end
	local mem = game.Stats:GetTotalMemoryUsageMb()
	ui.RAMTitle.Text = "Server Memory ("..(math.round(mem*100)/100).." MB)"
	local newFuzzy = math.round(mem/10)*10
	if newFuzzy ~= oldFuzzy then
		oldFuzzy = newFuzzy
		memScaleMax = newFuzzy*1.1
		memScaleMin = newFuzzy*.8
		coroutine.wrap(function()
			for _, v in next, ui.RAM:GetChildren() do
				if mt%60 == 0 then wait() end
				local mem = v:GetAttribute("mem")
				if not mem then continue end
				v.Size = UDim2.new(1/memCount, 0, math.clamp((mem-memScaleMin)/(memScaleMax-memScaleMin),0,1)*.8, 0)
			end
		end)()
	end
	new.Name = mt
	new.LayoutOrder = mt
	new.Size = UDim2.new(1/memCount, 0, math.clamp((mem-memScaleMin)/(memScaleMax-memScaleMin),0,1)*.8, 0)
	new.Visible = true
	new.BackgroundColor3 = Color3.fromHex("c97dff")
	new:SetAttribute("mem", mem)
	new.Parent = ui.RAM
	if #ui.RAM:GetChildren() > memCount+3 then
		table.insert(barPool, ui.RAM[tostring(mt-memCount)])
	end
	wait(.5)
	memCooldown = false
end

_thread.Connect(RunService.Heartbeat, function(dt)
	updateFPS(dt)
	if not memCooldown then
		updateMem()
	end
	local threadLength = 0
	for _, v in next, console.threads do
		threadLength = threadLength + 1
	end
	ui.Stats.Text =     "Uptime           :  "..math.floor(workspace.DistributedGameTime/3600)..":"..string.format("%02i", math.floor((workspace.DistributedGameTime/60)%60))..":"..string.format("%02i", math.floor(workspace.DistributedGameTime%60))..""
	ui.Stats.Text ..= "\nPlayers          :  "..#game.Players:GetPlayers().."/"..game.Players.MaxPlayers
	ui.Stats.Text ..= "\nInstances        :  "..(game.Stats.InstanceCount)
	ui.Stats.Text ..= "\n"
	ui.Stats.Text ..= "\nConsole Threads  :  "..threadLength
end)
_thread.Connect(console.screen.ConsoleText:GetPropertyChangedSignal("Text"), function()
	ui.Command.Text = console.text
end)
console.log('Basic UI Loaded. Version '..version..' "'..versionName..'"')
ui.Command.Text = console.text
