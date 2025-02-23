local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local function c(p)
	local n = Instance.new(p[1], p[2])
	for i, v in next, p do
		if not tonumber(i) then
			n[i] = v
		end
	end
	return n
end

local module = {}

function module:CreateTitleBar()
	local main = c{"TextButton", nil, AnchorPoint = Vector2.new(0, 1), Name = "TitleBar", AutoButtonColor = false, BackgroundColor3 = Color3.fromRGB(50, 50, 50), BackgroundTransparency = .1, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 24), Text = ""}

	local buttons = c{"Frame", main, Name = "Buttons", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0)}
	local buttons_list = c{"UIListLayout", buttons, FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right, SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Top}

	local title = buttons:Clone() title.Name = "Title" title.Parent = main
	title.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left

	local close = c{"TextButton", buttons, Name = "Close", BackgroundTransparency = 1, LayoutOrder = 2, Size = UDim2.new(0, main.Size.Y.Offset, 0, main.Size.Y.Offset), Text = ""}
	local close_image = c{"ImageLabel", close, AnchorPoint = Vector2.new(.5, .5), BackgroundColor3 = Color3.fromRGB(255, 100, 100), Position = UDim2.new(.5, 0, .5, 0), Size = UDim2.new(.4, 0, .4, 0), Image = "rbxassetid://12001637527", ImageTransparency = .8}
	local close_image_corner = c{"UICorner", close_image, CornerRadius = UDim.new(1, 0)}
	local maximize = close:Clone() maximize.Name = "Maximize" maximize.LayoutOrder = 1 maximize.ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 100, 100) maximize.Parent = buttons
	local minimize = close:Clone() minimize.Name = "Minimize" minimize.LayoutOrder = 0 minimize.ImageLabel.BackgroundColor3 = Color3.fromRGB(100, 255, 100) minimize.Parent = buttons

	local icon = c{"ImageLabel", title, Name = "Icon", BackgroundTransparency = 1, Size = UDim2.new(0, 24, 1, 0), Image = "rbxassetid://7564789770"}
	local label = c{"TextLabel", title, Name = "Label", BackgroundTransparency = 1, LayoutOrder = 1, Size = UDim2.new(1, 0, 1, 0), Font = Enum.Font.SourceSans, Text = "Placeholder", TextColor3 = Color3.new(1, 1, 1), TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left}
	local label_padding = c{"UIPadding", label, PaddingLeft = UDim.new(0, 8)}

	return main
end

function module:AnimateTitleBar(titlebar)
	_thread.Connect(console.remote.OnServerEvent, function(sender, command, ...)
		if command ~= "ButtonInput" then return end
		local event, button = ...
		if not button:IsDescendantOf(titlebar) then return end
		if event == "MouseEnter" then
			button.ImageLabel.Size = UDim2.new(.6, 0, .6, 0)
		elseif event == "MouseLeave" then
			button.ImageLabel:TweenSize(UDim2.new(.4, 0, .4, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Linear, .2, true, nil)
		end
	end)
end

function module:AnimateWindowFadeIn(window)
	coroutine.wrap(function()
		local t = 0
		local startTime = tick()
		local currentTime = tick()
		local animationTime = .2
		while t < 1 do
			currentTime = tick()
			t = (currentTime-startTime)/animationTime
			local m = t^.5
			if window:FindFirstChild("UIStroke") then window.UIStroke.Transparency = 1-.5*m end
			if window:FindFirstChild("Shadow") then window.Shadow.ImageTransparency = 1-.2*m end
			if window:FindFirstChild("Canvas") then window.Canvas.GroupTransparency = 1-m end
			RunService.Heartbeat:Wait()
		end
	end)()
end

function module:CloseWindow(window)
	coroutine.wrap(function()
		local t = 1
		local startTime = tick()
		local currentTime = tick()
		local animationTime = .2
		while t > 0 do
			currentTime = tick()
			t = (startTime-currentTime)/animationTime+1
			local m = t^2
			if window:FindFirstChild("UIStroke") then window.UIStroke.Transparency = 1-.5*m end
			if window:FindFirstChild("Shadow") then window.Shadow.ImageTransparency = 1-.2*m end
			if window:FindFirstChild("Canvas") then window.Canvas.GroupTransparency = 1-m end
			RunService.Heartbeat:Wait()
		end
		window:Destroy()
	end)()
end

function module:CreateDefaultWindow(animateWindowFadeIn, animateTitleBar)
	local window = c{"Frame", nil, Name = "Window", BackgroundTransparency = 1, Position = UDim2.new(0, 100, 0, 100), Size = UDim2.new(0, 480, 0, 400)}
	local window_corner = c{"UICorner", window, CornerRadius = UDim.new(0, 10)}
	local window_stroke = c{"UIStroke", window, Color = Color3.new(.5, .5, .5), Transparency = .5}
	local shadow = c{"ImageLabel", window, Name = "Shadow", AnchorPoint = Vector2.new(.5, .5), BackgroundTransparency = 1, Position = UDim2.new(.5, 0, .5, 8), Size = UDim2.new(1, 64, 1, 64), ZIndex = 0, Image = "rbxassetid://11417265717", ImageTransparency = .8, ImageColor3 = Color3.new(), ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(100, 100, 100, 100), SliceScale = .4}
	local canvas = c{"CanvasGroup", window, Name = "Canvas", BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(1, 0, 1, 0), ZIndex = 2}
	local canvas_corner = window_corner:Clone() canvas_corner.Parent = canvas
	local titlebar = self:CreateTitleBar()
	titlebar.Parent = window.Canvas
	titlebar.ZIndex = 3
	local canvas_padding = c{"UIPadding", canvas, PaddingTop = UDim.new(0, titlebar.Size.Y.Offset)}

	if animateTitleBar then
		self:AnimateTitleBar(titlebar)
	end
	if animateWindowFadeIn then
		self:AnimateWindowFadeIn(window)
	end
	local dragging = false
	local dragOffset = Vector2.new()
	_thread.Connect(console.remote.OnServerEvent, function(sender, command, ...)
		if titlebar:GetAttribute("LockedPosition") then return end
		if command == "ButtonInput" then
			local event, button = ...
			if button ~= titlebar then return end
			if event == "MouseButton1Down" then
				dragging = true
				dragOffset = Vector2.new(console.mousePosition.X-window.Position.X.Offset, console.mousePosition.Y-window.Position.Y.Offset)
			elseif event == "MouseButton1Up" then
				dragging = false
				window.Position = UDim2.new(0, window.Position.X.Offset, 0, math.max(window.Position.Y.Offset, 0))
			end
		elseif command == "MouseInput" then
			local event = ...
			if event == "Button1Up" then
				dragging = false
				window.Position = UDim2.new(0, window.Position.X.Offset, 0, math.max(window.Position.Y.Offset, 0))
			elseif event == "Move" and dragging then
				window.Position = UDim2.new(0, console.mousePosition.X-dragOffset.X, 0, console.mousePosition.Y-dragOffset.Y)
			end
		end
	end)

	return window
end

function module:CreateDefaultButton()
	local main = c{"TextButton", AnchorPoint = Vector2.new(.5, 0), BackgroundTransparency = 1, Size = UDim2.new(0, 96, 0, 24), Text = ""}
	local shadow = c{"ImageLabel", main, AnchorPoint = Vector2.new(.5, .5), BackgroundTransparency = 1, Position = UDim2.new(.5, 0, .5, 1), Size = UDim2.new(1, 8, 1, 8), Image = "rbxassetid://11417265717", ImageColor3 = Color3.new(), ImageTransparency = .8, SliceCenter = Rect.new(100, 100, 100, 100), SliceScale = .08}
	local textlabel = c{"TextLabel", main, BackgroundColor3 = Color3.fromRGB(50, 50, 50), Size = UDim2.new(1, 0, 1, 0), ZIndex = 2, Font = Enum.Font.SourceSans, Text = "Placeholder", TextSize = 14, TextColor3 = Color3.new(1, 1, 1)}
	local textlabel_corner = c{"UICorner", textlabel, CornerRadius = UDim.new(0, 4)}
	local textlabel_stroke = c{"UIStroke", textlabel, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Color = Color3.new(.5, .5, .5), Transparency = .5}
	return main
end

function module:CreateDefaultPopup()
	local window = self:CreateDefaultWindow(true, true)
	window.Position = UDim2.new(0, 200, 0, 200)
	window.Size = UDim2.new(0, 300, 0, 130)
	window.ZIndex = 2
	window.Canvas.TitleBar.Buttons.Maximize:Destroy()
	window.Canvas.TitleBar.Buttons.Minimize:Destroy()
	local background = c{"Frame", window.Canvas, Name = "Background", BackgroundColor3 = Color3.fromRGB(50, 50, 50), BorderSizePixel = 0, Size = UDim2.new(1, 0, 1, 0), ZIndex = 0}
	local icon = c{"ImageLabel", window.Canvas, Name = "Icon", BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 10), Size = UDim2.new(0, 50, 0, 50), Image = "rbxassetid://10023033893"}
	local icon_corner = c{"UICorner", icon, CornerRadius = UDim.new(0, 4)}
	local info = c{"TextLabel", window.Canvas, Name = "Info", BackgroundTransparency = 1, Position = UDim2.new(0, 70, 0, 10), Size = UDim2.new(1, -80, 0, 50), Font = Enum.Font.SourceSans, Text = "Lorem ipsum?", TextSize = 14, TextColor3 = Color3.new(1, 1, 1), TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top}
	return window
end

function module:NewCursor()
	if self.CurrentCursor then self.CurrentCursor:Destroy() end
	local cursor = c{"ImageLabel", _thread.Container, AnchorPoint = Vector2.new(.5, .5), Name = "Cursor", BackgroundTransparency = 1, Size = UDim2.new(0, 50, 0, 50), Image = "rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png", ZIndex = 1e9}
	module.CurrentCursor = cursor
	_thread.Connect(console.remote.OnServerEvent, function(sender, command, ...)
		if command == "MouseInput" then
			cursor.Position = UDim2.new(0, console.mousePosition.X, 0, console.mousePosition.Y)
		end
	end)
	return cursor
end

function module:ChangeCursorImage(image)
	if not self.CurrentCursor then return end
	self.CurrentCursor.Image = image
end

return module
