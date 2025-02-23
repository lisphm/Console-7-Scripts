local function c(p)
	local n = Instance.new(p[1], p[2])
	for i, v in next, p do
		if not tonumber(i) then
			n[i] = v
		end
	end
	return n
end

local http = loadstring(import"http")()
local lavender = loadstring(import"lavender")()
local fs = loadstring(import"fs")()

local background = c{"ImageLabel", _thread.Container, Name = "Background", Size = UDim2.new(1, 0, 1, 0), Image = "rbxassetid://1974708910", ScaleType = Enum.ScaleType.Crop}
local window = lavender:CreateDefaultWindow(true, true)
local sizex, sizey = 600, 440
window.Size = UDim2.new(0, sizex, 0, sizey)
window.Position = UDim2.new(0, console.resx/2-sizex/2, 0, console.resy/2-sizey/2)
window.ZIndex = 2
window.Parent = c{"Frame", _thread.Container, Name = "Windows", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), ZIndex = 2}
window.Canvas.TitleBar.Buttons.Maximize:Destroy()
window.Canvas.TitleBar.Buttons.Minimize:Destroy()
window.Canvas.TitleBar.Title.Label.Text = "DetOS Setup"
local windowBackground = c{"Frame", window.Canvas, BackgroundColor3 = Color3.fromRGB(88, 64, 100), BorderSizePixel = 0, Size = UDim2.new(1, 0, 1, 0), ZIndex = 0}
local install = c{"TextButton", window.Canvas, Text = "Install", AnchorPoint = Vector2.new(.5, .5), BackgroundColor3 = Color3.fromRGB(50, 50, 50), Position = UDim2.new(.5, 0, .5, -16), Size = UDim2.new(0, 128, 0, 36), ZIndex = 2, Font = Enum.Font.SourceSans, TextColor3 = Color3.new(1, 1, 1), TextSize = 24}
local install_corner = c{"UICorner", install, CornerRadius = UDim.new(0, 8)}
local install_stroke = c{"UIStroke", install, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Color = Color3.new(.5, .5, .5), Transparency = .5}
local installShadow = window.Shadow:Clone() installShadow.Position = UDim2.new(.5, 0, .5, -14) installShadow.Size = UDim2.new(0, 144, 0, 52) installShadow.SliceScale = .16 installShadow.Parent = window.Canvas
local disclaimer = c{"TextLabel", window.Canvas, AnchorPoint = Vector2.new(.5, .5), BackgroundTransparency = 1, Position = UDim2.new(.5, 0, 1, -50), Size = UDim2.new(0, 200, 0, 50), Font = Enum.Font.SourceSans, Text = "Installing will clear all data on the drive. When installed, we will automatically boot.", TextSize = 14, TextColor3 = Color3.new(1, 1, 1)}
local cursor = lavender:NewCursor()

_thread.Connect(console.remote.OnServerEvent, function(sender, command, ...)
	if command == "ButtonInput" then
		local event, button = ...
		if event == "MouseButton1Click" then
			if button == window.Canvas.TitleBar.Buttons.Close then
				local popup = lavender:CreateDefaultPopup()
				popup.Canvas.Info.Text = "Are you sure you want to exit setup?"
				popup.Canvas.TitleBar.Title.Label.Text = window.Canvas.TitleBar.Title.Label.Text
				popup.Parent = _thread.Container.Windows
				local exit = lavender:CreateDefaultButton()
				exit.Position = UDim2.new(.5, -53, 1, -35)
				exit.TextLabel.Text = "Exit"
				exit.Parent = popup.Canvas
				local cancel = lavender:CreateDefaultButton()
				cancel.Position = UDim2.new(.5, 53, 1, -35)
				cancel.TextLabel.Text = "Cancel"
				cancel.Parent = popup.Canvas
				_thread.Connect(console.remote.OnServerEvent, function(sender, command, ...)
					if command == "ButtonInput" and popup.Parent then
						local event, button = ...
						if event == "MouseButton1Up" then
							if button == exit then
								console.commands.kill(tostring(_thread.Id))
							elseif button == cancel or button == popup.Canvas.TitleBar.Buttons.Close then
								lavender:CloseWindow(popup)
							end
						end
					end
				end)
			elseif button == install then
				fs.write("boot\\os3boot.lua", [[
				local threading = loadstring(import"threading")()
local http = loadstring(import"http")()

local code = http.request("getFile", "OS3/main.lua")

local thread = threading.new(code)
thread.Container.Parent = console.screen
				]])
			end
		end
	end
end)