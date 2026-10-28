--[=[
	Spectra.wtf UI Library
	Inspirado no visual da Obsidian | Desenvolvido para Roblox Luau
]=]

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Spectra = {}
Spectra.__index = Spectra

-- Tema padrão (Obsidian Theme)
Spectra.Theme = {
	Background = Color3.fromRGB(18, 18, 20),
	Surface = Color3.fromRGB(24, 24, 27),
	SurfaceHover = Color3.fromRGB(32, 32, 36),
	Element = Color3.fromRGB(30, 30, 35),
	ElementHover = Color3.fromRGB(40, 40, 48),
	Accent = Color3.fromRGB(124, 58, 237), -- Violeta Obsidian
	AccentHover = Color3.fromRGB(139, 92, 246),
	TextPrimary = Color3.fromRGB(244, 244, 245),
	TextSecondary = Color3.fromRGB(161, 161, 170),
	Border = Color3.fromRGB(39, 39, 42),
	Divider = Color3.fromRGB(35, 35, 39),
	Transparency = 0.05,
	Font = Enum.Font.GothamMedium,
	FontBold = Enum.Font.GothamBold,
}

local function tween(object, info, goals)
	local tw = TweenService:Create(object, TweenInfo.new(info.Time or 0.2, info.Style or Enum.EasingStyle.Quad, info.Direction or Enum.EasingDirection.Out), goals)
	tw:Play()
	return tw
end

local function create(className, properties)
	local instance = Instance.new(className)
	for k, v in pairs(properties) do
		instance[k] = v
	end
	return instance
end

-- Sistema de Notificações Global
local NotificationHolder = create("ScreenGui", {
	Name = "SpectraNotifications",
	Parent = RunService:IsStudio() and PlayerGui or CoreGui,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	IgnoreGuiInset = true,
})

local NotifLayout = create("UIListLayout", {
	Parent = create("Frame", {
		Name = "Holder",
		Parent = NotificationHolder,
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -320, 1, -20),
		Size = UDim2.new(0, 300, 0, 0),
		AnchorPoint = Vector2.new(0, 1),
	}),
	SortOrder = Enum.SortOrder.LayoutOrder,
	VerticalAlignment = Enum.VerticalAlignment.Bottom,
	Padding = UDim.new(0, 8),
})

function Spectra:Notify(config)
	config = config or {}
	local title = config.Title or "Notificação"
	local content = config.Content or ""
	local duration = config.Duration or 3
	local icon = config.Icon or "rbxassetid://96535159972301"

	local notif = create("Frame", {
		Parent = NotifLayout.Parent,
		BackgroundColor3 = Spectra.Theme.Surface,
		BackgroundTransparency = 0.1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 60),
		ClipsDescendants = true,
	})

	create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = notif })
	create("UIStroke", { Color = Spectra.Theme.Border, Thickness = 1, Parent = notif })

	local accentBar = create("Frame", {
		Parent = notif,
		BackgroundColor3 = Spectra.Theme.Accent,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 4, 1, 0),
	})

	local iconImg = create("ImageLabel", {
		Parent = notif,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 14, 0, 10),
		Size = UDim2.new(0, 20, 0, 20),
		Image = icon,
		ImageColor3 = Spectra.Theme.TextPrimary,
	})

	local titleLbl = create("TextLabel", {
		Parent = notif,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 44, 0, 10),
		Size = UDim2.new(1, -54, 0, 20),
		Font = Spectra.Theme.FontBold,
		Text = title,
		TextColor3 = Spectra.Theme.TextPrimary,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
	})

	local descLbl = create("TextLabel", {
		Parent = notif,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 44, 0, 30),
		Size = UDim2.new(1, -54, 0, 20),
		Font = Spectra.Theme.Font,
		Text = content,
		TextColor3 = Spectra.Theme.TextSecondary,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
	})

	notif.Position = UDim2.new(1, 40, 0, 0)
	tween(notif, { Time = 0.3, Style = Enum.EasingStyle.Back, Direction = Enum.EasingDirection.Out }, { Position = UDim2.new(0, 0, 0, 0) })

	task.delay(duration, function()
		if notif and notif.Parent then
			tween(notif, { Time = 0.2, Style = Enum.EasingStyle.Quad, Direction = Enum.EasingDirection.In }, { Position = UDim2.new(1, 40, 0, 0) })
			task.wait(0.2)
			notif:Destroy()
		end
	end)
end

-- Janela Principal (Window)
function Spectra:CreateWindow(config)
	config = config or {}
	local title = config.Title or "Spectra.wtf"
	local description = config.Description or "Interface Moderna"
	local image = config.Image or "rbxassetid://96535159972301"
	local tabOrientation = config.TabOrientation or "Left" -- Left, Right, Top, Bottom

	local screenGui = create("ScreenGui", {
		Name = "SpectraUI",
		Parent = RunService:IsStudio() and PlayerGui or CoreGui,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
	})

	local mainFrame = create("Frame", {
		Name = "MainFrame",
		Parent = screenGui,
		BackgroundColor3 = Spectra.Theme.Background,
		BackgroundTransparency = Spectra.Theme.Transparency,
		BorderSizePixel = 0,
		Position = UDim2.new(0.5, -310, 0.5, -200),
		Size = UDim2.new(0, 620, 0, 420),
		ClipsDescendants = true,
	})

	create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = mainFrame })
	create("UIStroke", { Color = Spectra.Theme.Border, Thickness = 1, Parent = mainFrame })

	-- Arrastar Janela
	local dragging, dragInput, dragStart, startPos
	mainFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = mainFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	RunService.RenderStepped:Connect(function()
		if dragging and dragInput then
			local delta = dragInput.Position - dragStart
			mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	-- Top Bar / Header
	local topBar = create("Frame", {
		Parent = mainFrame,
		BackgroundColor3 = Spectra.Theme.Surface,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 45),
	})

	create("UIStroke", { Color = Spectra.Theme.Border, Thickness = 1, Parent = topBar })

	local iconImg = create("ImageLabel", {
		Parent = topBar,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 12, 0, 10),
		Size = UDim2.new(0, 24, 0, 24),
		Image = image,
		ImageColor3 = Spectra.Theme.Accent,
	})

	create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = iconImg })

	local titleLbl = create("TextLabel", {
		Parent = topBar,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 46, 0, 6),
		Size = UDim2.new(0, 300, 0, 18),
		Font = Spectra.Theme.FontBold,
		Text = title,
		TextColor3 = Spectra.Theme.TextPrimary,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
	})

	local descLbl = create("TextLabel", {
		Parent = topBar,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 46, 0, 22),
		Size = UDim2.new(0, 300, 0, 16),
		Font = Spectra.Theme.Font,
		Text = description,
		TextColor3 = Spectra.Theme.TextSecondary,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left,
	})

	local closeBtn = create("TextButton", {
		Parent = topBar,
		BackgroundColor3 = Spectra.Theme.Element,
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -38, 0, 10),
		Size = UDim2.new(0, 26, 0, 26),
		Font = Spectra.Theme.FontBold,
		Text = "×",
		TextColor3 = Spectra.Theme.TextSecondary,
		TextSize = 18,
	})

	create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = closeBtn })

	closeBtn.MouseButton1Click:Connect(function()
		tween(mainFrame, { Time = 0.2 }, { Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1 })
		task.wait(0.2)
		screenGui:Destroy()
	end)

	closeBtn.MouseEnter:Connect(function()
		tween(closeBtn, { Time = 0.1 }, { BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(255, 100, 100) })
	end)
	closeBtn.MouseLeave:Connect(function()
		tween(closeBtn, { Time = 0.1 }, { BackgroundTransparency = 1, TextColor3 = Spectra.Theme.TextSecondary })
	end)

	-- Container de Abas e Conteúdo
	local container = create("Frame", {
		Parent = mainFrame,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 45),
		Size = UDim2.new(1, 0, 1, -45),
	})

	local tabListSize = 140
	local tabListFrame = create("ScrollingFrame", {
		Parent = container,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = Spectra.Theme.Accent,
	})

	local contentFrame = create("Frame", {
		Parent = container,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	})

	-- Posicionamento baseado na orientação das abas
	if tabOrientation == "Left" then
		tabListFrame.Position = UDim2.new(0, 8, 0, 8)
		tabListFrame.Size = UDim2.new(0, tabListSize, 1, -16)
		contentFrame.Position = UDim2.new(0, tabListSize + 16, 0, 8)
		contentFrame.Size = UDim2.new(1, -tabListSize - 24, 1, -16)
	elseif tabOrientation == "Right" then
		contentFrame.Position = UDim2.new(0, 8, 0, 8)
		contentFrame.Size = UDim2.new(1, -tabListSize - 24, 1, -16)
		tabListFrame.Position = UDim2.new(1, -tabListSize - 8, 0, 8)
		tabListFrame.Size = UDim2.new(0, tabListSize, 1, -16)
	elseif tabOrientation == "Top" then
		tabListFrame.Position = UDim2.new(0, 8, 0, 8)
		tabListFrame.Size = UDim2.new(1, -16, 0, 36)
		contentFrame.Position = UDim2.new(0, 8, 0, 52)
		contentFrame.Size = UDim2.new(1, -16, 1, -60)
	elseif tabOrientation == "Bottom" then
		contentFrame.Position = UDim2.new(0, 8, 0, 8)
		contentFrame.Size = UDim2.new(1, -16, 1, -60)
		tabListFrame.Position = UDim2.new(0, 8, 1, -44)
		tabListFrame.Size = UDim2.new(1, -16, 0, 36)
	end

	local tabListLayout = create("UIListLayout", {
		Parent = tabListFrame,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 4),
		FillDirection = (tabOrientation == "Top" or tabOrientation == "Bottom") and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical,
	})

	local WindowObj = {
		Gui = screenGui,
		Main = mainFrame,
		TabList = tabListFrame,
		ContentContainer = contentFrame,
		Tabs = {},
		FirstTab = true,
	}

	function WindowObj:Tab(tabConfig)
		tabConfig = tabConfig or {}
		local name = tabConfig.Name or "Tab"
		local icon = tabConfig.Icon or "rbxassetid://96535159972301"

		local tabBtn = create("TextButton", {
			Parent = WindowObj.TabList,
			BackgroundColor3 = Spectra.Theme.Surface,
			BackgroundTransparency = 1,
			Size = (tabOrientation == "Top" or tabOrientation == "Bottom") and UDim2.new(0, 110, 1, 0) or UDim2.new(1, 0, 0, 34),
			Font = Spectra.Theme.Font,
			Text = "   " .. name,
			TextColor3 = Spectra.Theme.TextSecondary,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = tabBtn })

		local tabIcon = create("ImageLabel", {
			Parent = tabBtn,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 10, 0.5, -8),
			Size = UDim2.new(0, 16, 0, 16),
			Image = icon,
			ImageColor3 = Spectra.Theme.TextSecondary,
		})

		local page = create("ScrollingFrame", {
			Parent = WindowObj.ContentContainer,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			ScrollBarThickness = 2,
			ScrollBarImageColor3 = Spectra.Theme.Accent,
			Visible = false,
		})

		create("UIListLayout", {
			Parent = page,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 8),
		})

		create("UIPadding", {
			Parent = page,
			PaddingRight = UDim.new(0, 6),
			PaddingBottom = UDim.new(0, 10),
		})

		local function selectTab()
			for _, t in pairs(WindowObj.Tabs) do
				t.Button.BackgroundTransparency = 1
				t.Button.TextColor3 = Spectra.Theme.TextSecondary
				t.Icon.ImageColor3 = Spectra.Theme.TextSecondary
				t.Page.Visible = false
			end
			tabBtn.BackgroundTransparency = 0.5
			tabBtn.BackgroundColor3 = Spectra.Theme.SurfaceHover
			tabBtn.TextColor3 = Spectra.Theme.TextPrimary
			tabIcon.ImageColor3 = Spectra.Theme.Accent
			page.Visible = true
		end

		if WindowObj.FirstTab then
			WindowObj.FirstTab = false
			selectTab()
		end

		tabBtn.MouseButton1Click:Connect(selectTab)

		table.insert(WindowObj.Tabs, { Button = tabBtn, Icon = tabIcon, Page = page })

		local TabObj = { Page = page }

		-- Componentes da Tab
		function TabObj:Section(title)
			local sec = create("TextLabel", {
				Parent = page,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 24),
				Font = Spectra.Theme.FontBold,
				Text = title:upper(),
				TextColor3 = Spectra.Theme.Accent,
				TextSize = 11,
				TextXAlignment = Enum.TextXAlignment.Left,
			})
			return sec
		end

		function TabObj:Divider()
			local div = create("Frame", {
				Parent = page,
				BackgroundColor3 = Spectra.Theme.Divider,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 1),
			})
			return div
		end

		function TabObj:Label(text)
			local lbl = create("TextLabel", {
				Parent = page,
				BackgroundColor3 = Spectra.Theme.Surface,
				BackgroundTransparency = 0.5,
				Size = UDim2.new(1, 0, 0, 32),
				Font = Spectra.Theme.Font,
				Text = "  " .. text,
				TextColor3 = Spectra.Theme.TextPrimary,
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Left,
			})
			create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = lbl })
			create("UIStroke", { Color = Spectra.Theme.Border, Thickness = 1, Parent = lbl })

			local api = {}
			function api:Set(newText)
				lbl.Text = "  " .. newText
			end
			return api
		end

		function TabObj:Button(config)
			config = config or {}
			local name = config.Name or "Botão"
			local callback = config.Callback or function() end

			local btn = create("TextButton", {
				Parent = page,
				BackgroundColor3 = Spectra.Theme.Surface,
				Size = UDim2.new(1, 0, 0, 36),
				AutoButtonColor = false,
				Font = Spectra.Theme.Font,
				Text = "  " .. name,
				TextColor3 = Spectra.Theme.TextPrimary,
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Left,
			})
			create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
			create("UIStroke", { Color = Spectra.Theme.Border, Thickness = 1, Parent = btn })

			btn.MouseButton1Click:Connect(function()
				tween(btn, { Time = 0.1 }, { BackgroundColor3 = Spectra.Theme.AccentHover })
				task.wait(0.1)
				tween(btn, { Time = 0.1 }, { BackgroundColor3 = Spectra.Theme.Surface })
				pcall(callback)
			end)
		end

		function TabObj:Toggle(config)
			config = config or {}
			local name = config.Name or "Toggle"
			local default = config.Default or false
			local callback = config.Callback or function() end

			local state = default

			local tgl = create("TextButton", {
				Parent = page,
				BackgroundColor3 = Spectra.Theme.Surface,
				Size = UDim2.new(1, 0, 0, 36),
				AutoButtonColor = false,
				Font = Spectra.Theme.Font,
				Text = "  " .. name,
				TextColor3 = Spectra.Theme.TextPrimary,
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Left,
			})
			create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = tgl })
			create("UIStroke", { Color = Spectra.Theme.Border, Thickness = 1, Parent = tgl })

			local box = create("Frame", {
				Parent = tgl,
				BackgroundColor3 = state and Spectra.Theme.Accent or Spectra.Theme.Element,
				Position = UDim2.new(1, -40, 0.5, -10),
				Size = UDim2.new(0, 30, 0, 20),
			})
			create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = box })

			local indicator = create("Frame", {
				Parent = box,
				BackgroundColor3 = Spectra.Theme.TextPrimary,
				Position = state and UDim2.new(1, -18, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
				Size = UDim2.new(0, 14, 0, 14),
			})
			create("UICorner", { CornerRadius = UDim.new(0, 3), Parent = indicator })

			local function update(anim)
				if anim then
					tween(box, { Time = 0.2 }, { BackgroundColor3 = state and Spectra.Theme.Accent or Spectra.Theme.Element })
					tween(indicator, { Time = 0.2 }, { Position = state and UDim2.new(1, -18, 0.5, -7) or UDim2.new(0, 2, 0.5, -7) })
				else
					box.BackgroundColor3 = state and Spectra.Theme.Accent or Spectra.Theme.Element
					indicator.Position = state and UDim2.new(1, -18, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
				end
			end

			tgl.MouseButton1Click:Connect(function()
				state = not state
				update(true)
				pcall(callback, state)
			end)

			local api = {}
			function api:Set(newState)
				state = newState
				update(true)
				pcall(callback, state)
			end
			return api
		end

		function TabObj:Slider(config)
			config = config or {}
			local name = config.Name or "Slider"
			local min = config.Min or 0
			local max = config.Max or 100
			local default = config.Default or min
			local callback = config.Callback or function() end

			local value = default

			local sl = create("Frame", {
				Parent = page,
				BackgroundColor3 = Spectra.Theme.Surface,
				Size = UDim2.new(1, 0, 0, 50),
			})
			create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = sl })
			create("UIStroke", { Color = Spectra.Theme.Border, Thickness = 1, Parent = sl })

			local titleLbl = create("TextLabel", {
				Parent = sl,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 12, 0, 8),
				Size = UDim2.new(1, -24, 0, 16),
				Font = Spectra.Theme.Font,
				Text = name,
				TextColor3 = Spectra.Theme.TextPrimary,
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Left,
			})

			local valLbl = create("TextLabel", {
				Parent = sl,
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -100, 0, 8),
				Size = UDim2.new(0, 88, 0, 16),
				Font = Spectra.Theme.FontBold,
				Text = tostring(value),
				TextColor3 = Spectra.Theme.Accent,
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Right,
			})

			local sliderBar = create("Frame", {
				Parent = sl,
				BackgroundColor3 = Spectra.Theme.Element,
				Position = UDim2.new(0, 12, 0, 32),
				Size = UDim2.new(1, -24, 0, 6),
			})
			create("UICorner", { CornerRadius = UDim.new(0, 3), Parent = sliderBar })

			local fill = create("Frame", {
				Parent = sliderBar,
				BackgroundColor3 = Spectra.Theme.Accent,
				Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
			})
			create("UICorner", { CornerRadius = UDim.new(0, 3), Parent = fill })

			local dragging = false
			local function updateSlider(input)
				local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
				value = math.floor(min + ((max - min) * pos))
				fill.Size = UDim2.new(pos, 0, 1, 0)
				valLbl.Text = tostring(value)
				pcall(callback, value)
			end

			sliderBar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = true
					updateSlider(input)
				end
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = false
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					updateSlider(input)
				end
			end)

			local api = {}
			function api:Set(newValue)
				value = math.clamp(newValue, min, max)
				local pos = (value - min) / (max - min)
				fill.Size = UDim2.new(pos, 0, 1, 0)
				valLbl.Text = tostring(value)
				pcall(callback, value)
			end
			return api
		end

		function TabObj:Dropdown(config)
			config = config or {}
			local name = config.Name or "Dropdown"
			local options = config.Options or {}
			local default = config.Default or options[1]
			local multi = config.Multi or false
			local callback = config.Callback or function() end

			local selected = multi and (type(default) == "table" and default or {}) or default
			local isOpen = false

			local drop = create("Frame", {
				Parent = page,
				BackgroundColor3 = Spectra.Theme.Surface,
				Size = UDim2.new(1, 0, 0, 38),
				ClipsDescendants = true,
			})
			create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = drop })
			create("UIStroke", { Color = Spectra.Theme.Border, Thickness = 1, Parent = drop })

			local btn = create("TextButton", {
				Parent = drop,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 38),
				Font = Spectra.Theme.Font,
				Text = "  " .. name,
				TextColor3 = Spectra.Theme.TextPrimary,
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Left,
			})

			local currentText = create("TextLabel", {
				Parent = drop,
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -160, 0, 0),
				Size = UDim2.new(0, 145, 0, 38),
				Font = Spectra.Theme.Font,
				Text = multi ? "Selecionados..." : tostring(selected),
				TextColor3 = Spectra.Theme.Accent,
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Right,
			})

			local listContainer = create("ScrollingFrame", {
				Parent = drop,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 8, 0, 42),
				Size = UDim2.new(1, -16, 0, 120),
				ScrollBarThickness = 2,
				ScrollBarImageColor3 = Spectra.Theme.Accent,
				Visible = false,
			})

			create("UIListLayout", {
				Parent = listContainer,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 4),
			})

			local function refreshList()
				for _, child in pairs(listContainer:GetChildren()) do
					if child:IsA("TextButton") then child:Destroy() end
				end

				for _, opt in pairs(options) do
					local optBtn = create("TextButton", {
						Parent = listContainer,
						BackgroundColor3 = Spectra.Theme.Element,
						Size = UDim2.new(1, 0, 0, 30),
						Font = Spectra.Theme.Font,
						Text = "  " .. tostring(opt),
						TextColor3 = Spectra.Theme.TextPrimary,
						TextSize = 12,
						TextXAlignment = Enum.TextXAlignment.Left,
					})
					create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = optBtn })

					optBtn.MouseButton1Click:Connect(function()
						if multi then
							local idx = table.find(selected, opt)
							if idx then
								table.remove(selected, idx)
								optBtn.BackgroundColor3 = Spectra.Theme.Element
							else
								table.insert(selected, opt)
								optBtn.BackgroundColor3 = Spectra.Theme.Accent
							end
							currentText.Text = #selected .. " selecionados"
							pcall(callback, selected)
						else
							selected = opt
							currentText.Text = tostring(selected)
							isOpen = false
							tween(drop, { Time = 0.2 }, { Size = UDim2.new(1, 0, 0, 38) })
							listContainer.Visible = false
							pcall(callback, selected)
						end
					end)
				end
				listContainer.CanvasSize = UDim2.new(0, 0, 0, #options * 34)
			end

			refreshList()

			btn.MouseButton1Click:Connect(function()
				isOpen = not isOpen
				if isOpen then
					listContainer.Visible = true
					tween(drop, { Time = 0.2 }, { Size = UDim2.new(1, 0, 0, 170) })
				else
					tween(drop, { Time = 0.2 }, { Size = UDim2.new(1, 0, 0, 38) })
					task.wait(0.2)
					listContainer.Visible = false
				end
			end)
		end

		function TabObj:Viewport(config)
			config = config or {}
			local model = config.Model

			local vpFrame = create("Frame", {
				Parent = page,
				BackgroundColor3 = Spectra.Theme.Surface,
				Size = UDim2.new(1, 0, 0, 180),
			})
			create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = vpFrame })
			create("UIStroke", { Color = Spectra.Theme.Border, Thickness = 1, Parent = vpFrame })

			local vp = create("ViewportFrame", {
				Parent = vpFrame,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
			})

			local cam = create("Camera", { Parent = vp })
			vp.CurrentCamera = cam

			if model then
				model = model:Clone()
				model.Parent = vp
				local cf, size = model:GetBoundingBox()
				cam.CFrame = CFrame.new(cf.Position + Vector3.new(0, 2, size.Magnitude * 1.5), cf.Position)
			end
		end

		return TabObj
	end

	return WindowObj
end

return Spectra
