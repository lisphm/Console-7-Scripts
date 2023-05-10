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

local uiTable = uiDecode('[{"Children":[{"Active":false,"Selectable":false,"Children":[],"ZIndex":2,"Archivable":true,"Size":["UDim2",1,0,0,24],"TextXAlignment":["Enum","TextXAlignment","Left"],"ClipsDescendants":false,"BorderColor3":["Color",27,42,53],"Text":"Sky UI","TextSize":24,"Name":"Title","TextColor3":["Color",255,255,255],"Font":["Enum","Font","SourceSansItalic"],"BackgroundTransparency":0.5,"ClassName":"TextLabel","BorderSizePixel":0,"BackgroundColor3":["Color",0,0,0]},{"BorderSizePixel":0,"ClipsDescendants":false,"BorderColor3":["Color",27,42,53],"SliceCenter":["Rect",0,0,[0,0],[0,0]],"Active":false,"Selectable":false,"Children":[],"Image":"rbxassetid://600832720","Name":"Background","ClassName":"ImageLabel","Size":["UDim2",1,0,1,0],"Archivable":true,"BackgroundColor3":["Color",0,0,0]},{"Active":false,"Selectable":false,"Name":"Command","TextXAlignment":["Enum","TextXAlignment","Left"],"Archivable":true,"Size":["UDim2",0.5,0,0.5,0],"TextSize":12,"ClipsDescendants":false,"BorderColor3":["Color",27,42,53],"Text":"Label","BorderSizePixel":0,"TextColor3":["Color",255,255,255],"Position":["UDim2",0,0,0.5,0],"Font":["Enum","Font","RobotoMono"],"BackgroundTransparency":0.5,"ClassName":"TextLabel","Children":[],"TextYAlignment":["Enum","TextYAlignment","Bottom"],"BackgroundColor3":["Color",0,0,0]}],"Active":false,"BorderColor3":["Color",27,42,53],"ClipsDescendants":false,"Size":["UDim2",1,0,1,0],"Selectable":false,"Name":"Sky UI","ClassName":"Frame","Archivable":true,"BackgroundColor3":["Color",255,255,255]}]')
local ui = uiTable[1]
ui.Parent = console.screen
ui.Command.Text = console.text

console.screen.ConsoleText:GetPropertyChangedSignal("Text"):Connect(function()
    ui.Command.Text = console.text
end)