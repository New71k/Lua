local Library = {}
Library.__index = Library

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local TextService = game:GetService("TextService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled

Library.Flags = {}
Library.Windows = {}
Library.Connections = {}
Library.Themes = {}
Library.CurrentTheme = "Dark"
Library.Loaded = false
Library.Unloaded = false
Library.Notifications = {}
Library.OpenFrames = {}

--=====================================================================
-- THEME SYSTEM
--=====================================================================

local ThemeDefaults = {
	Dark = {
		Accent = Color3.fromRGB(50, 130, 246),
		AccentDark = Color3.fromRGB(35, 100, 200),
		Background = Color3.fromRGB(18, 18, 22),
		BackgroundSecondary = Color3.fromRGB(24, 24, 29),
		Sidebar = Color3.fromRGB(15, 15, 19),
		TopBar = Color3.fromRGB(13, 13, 17),
		Section = Color3.fromRGB(22, 22, 27),
		SectionBorder = Color3.fromRGB(34, 34, 40),
		Element = Color3.fromRGB(28, 28, 34),
		ElementHover = Color3.fromRGB(34, 34, 41),
		ElementBorder = Color3.fromRGB(40, 40, 47),
		Text = Color3.fromRGB(235, 235, 240),
		TextDark = Color3.fromRGB(150, 150, 160),
		TextDisabled = Color3.fromRGB(90, 90, 100),
		Divider = Color3.fromRGB(36, 36, 42),
		Success = Color3.fromRGB(60, 200, 120),
		Warning = Color3.fromRGB(240, 180, 60),
		Error = Color3.fromRGB(230, 70, 70),
		Font = Enum.Font.GothamMedium,
		FontBold = Enum.Font.GothamBold,
	},
	Light = {
		Accent = Color3.fromRGB(45, 110, 230),
		AccentDark = Color3.fromRGB(30, 85, 190),
		Background = Color3.fromRGB(245, 245, 248),
		BackgroundSecondary = Color3.fromRGB(255, 255, 255),
		Sidebar = Color3.fromRGB(238, 238, 242),
		TopBar = Color3.fromRGB(250, 250, 252),
		Section = Color3.fromRGB(255, 255, 255),
		SectionBorder = Color3.fromRGB(225, 225, 230),
		Element = Color3.fromRGB(240, 240, 244),
		ElementHover = Color3.fromRGB(230, 230, 236),
		ElementBorder = Color3.fromRGB(220, 220, 226),
		Text = Color3.fromRGB(25, 25, 30),
		TextDark = Color3.fromRGB(110, 110, 120),
		TextDisabled = Color3.fromRGB(180, 180, 186),
		Divider = Color3.fromRGB(225, 225, 230),
		Success = Color3.fromRGB(40, 170, 100),
		Warning = Color3.fromRGB(210, 150, 40),
		Error = Color3.fromRGB(210, 60, 60),
		Font = Enum.Font.GothamMedium,
		FontBold = Enum.Font.GothamBold,
	},
	Midnight = {
		Accent = Color3.fromRGB(90, 110, 255),
		AccentDark = Color3.fromRGB(65, 85, 220),
		Background = Color3.fromRGB(10, 10, 16),
		BackgroundSecondary = Color3.fromRGB(14, 14, 20),
		Sidebar = Color3.fromRGB(8, 8, 13),
		TopBar = Color3.fromRGB(7, 7, 11),
		Section = Color3.fromRGB(13, 13, 19),
		SectionBorder = Color3.fromRGB(24, 24, 32),
		Element = Color3.fromRGB(18, 18, 25),
		ElementHover = Color3.fromRGB(23, 23, 31),
		ElementBorder = Color3.fromRGB(28, 28, 36),
		Text = Color3.fromRGB(230, 230, 240),
		TextDark = Color3.fromRGB(130, 130, 150),
		TextDisabled = Color3.fromRGB(80, 80, 95),
		Divider = Color3.fromRGB(26, 26, 34),
		Success = Color3.fromRGB(60, 200, 120),
		Warning = Color3.fromRGB(240, 180, 60),
		Error = Color3.fromRGB(230, 70, 70),
		Font = Enum.Font.GothamMedium,
		FontBold = Enum.Font.GothamBold,
	},
	Crimson = {
		Accent = Color3.fromRGB(220, 55, 70),
		AccentDark = Color3.fromRGB(180, 40, 55),
		Background = Color3.fromRGB(20, 15, 16),
		BackgroundSecondary = Color3.fromRGB(26, 19, 20),
		Sidebar = Color3.fromRGB(16, 12, 13),
		TopBar = Color3.fromRGB(14, 10, 11),
		Section = Color3.fromRGB(24, 17, 18),
		SectionBorder = Color3.fromRGB(38, 26, 28),
		Element = Color3.fromRGB(30, 21, 22),
		ElementHover = Color3.fromRGB(37, 26, 27),
		ElementBorder = Color3.fromRGB(44, 30, 32),
		Text = Color3.fromRGB(235, 230, 230),
		TextDark = Color3.fromRGB(160, 140, 140),
		TextDisabled = Color3.fromRGB(95, 80, 80),
		Divider = Color3.fromRGB(40, 27, 28),
		Success = Color3.fromRGB(60, 200, 120),
		Warning = Color3.fromRGB(240, 180, 60),
		Error = Color3.fromRGB(240, 90, 90),
		Font = Enum.Font.GothamMedium,
		FontBold = Enum.Font.GothamBold,
	},
	Emerald = {
		Accent = Color3.fromRGB(45, 200, 130),
		AccentDark = Color3.fromRGB(30, 165, 105),
		Background = Color3.fromRGB(14, 18, 16),
		BackgroundSecondary = Color3.fromRGB(18, 24, 21),
		Sidebar = Color3.fromRGB(12, 15, 13),
		TopBar = Color3.fromRGB(10, 13, 12),
		Section = Color3.fromRGB(17, 22, 19),
		SectionBorder = Color3.fromRGB(28, 36, 31),
		Element = Color3.fromRGB(22, 28, 24),
		ElementHover = Color3.fromRGB(27, 34, 29),
		ElementBorder = Color3.fromRGB(32, 40, 34),
		Text = Color3.fromRGB(230, 238, 232),
		TextDark = Color3.fromRGB(140, 160, 148),
		TextDisabled = Color3.fromRGB(85, 100, 90),
		Divider = Color3.fromRGB(30, 38, 32),
		Success = Color3.fromRGB(60, 200, 120),
		Warning = Color3.fromRGB(240, 180, 60),
		Error = Color3.fromRGB(230, 70, 70),
		Font = Enum.Font.GothamMedium,
		FontBold = Enum.Font.GothamBold,
	},
}

for name, data in pairs(ThemeDefaults) do
	Library.Themes[name] = data
end

function Library:GetTheme()
	return Library.Themes[Library.CurrentTheme]
end

function Library:SetTheme(name)
	if not Library.Themes[name] then return end
	Library.CurrentTheme = name
	Library:RefreshTheme()
end

function Library:CreateTheme(name, data)
	local base = table.clone(Library.Themes.Dark)
	for k, v in pairs(data) do
		base[k] = v
	end
	Library.Themes[name] = base
end

Library.ThemeInstances = {}

function Library:RefreshTheme()
	local theme = Library:GetTheme()
	for _, entry in ipairs(Library.ThemeInstances) do
		local inst, prop = entry[1], entry[2]
		if inst and inst.Parent and inst[prop] ~= nil then
			pcall(function()
				inst[prop] = theme[entry[3]]
			end)
		end
	end
end

function Library:Tag(inst, prop, themeKey)
	table.insert(Library.ThemeInstances, {inst, prop, themeKey})
end

--=====================================================================
-- UTILITY
--=====================================================================

local Utility = {}
Library.Utility = Utility

function Utility:Create(class, props, children)
	local inst = Instance.new(class)
	for prop, value in pairs(props or {}) do
		inst[prop] = value
	end
	for _, child in ipairs(children or {}) do
		child.Parent = inst
	end
	return inst
end

function Utility:Tween(inst, props, duration, style, direction)
	duration = duration or 0.25
	style = style or Enum.EasingStyle.Quint
	direction = direction or Enum.EasingDirection.Out
	local tween = TweenService:Create(inst, TweenInfo.new(duration, style, direction), props)
	tween:Play()
	return tween
end

function Utility:Round(inst, radius)
	return Utility:Create("UICorner", {CornerRadius = UDim.new(0, radius or 6), Parent = inst})
end

function Utility:Stroke(inst, color, thickness, transparency)
	return Utility:Create("UIStroke", {
		Color = color or Color3.fromRGB(40,40,47),
		Thickness = thickness or 1,
		Transparency = transparency or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = inst,
	})
end

function Utility:Padding(inst, all, top, bottom, left, right)
	return Utility:Create("UIPadding", {
		PaddingTop = UDim.new(0, top or all or 0),
		PaddingBottom = UDim.new(0, bottom or all or 0),
		PaddingLeft = UDim.new(0, left or all or 0),
		PaddingRight = UDim.new(0, right or all or 0),
		Parent = inst,
	})
end

function Utility:ListLayout(inst, direction, padding, alignment)
	return Utility:Create("UIListLayout", {
		FillDirection = direction or Enum.FillDirection.Vertical,
		Padding = UDim.new(0, padding or 6),
		HorizontalAlignment = alignment or Enum.HorizontalAlignment.Left,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = inst,
	})
end

function Utility:Gradient(inst, colorSeq, rotation, transparencySeq)
	return Utility:Create("UIGradient", {
		Color = colorSeq,
		Rotation = rotation or 0,
		Transparency = transparencySeq or NumberSequence.new(0),
		Parent = inst,
	})
end

function Utility:Ripple(button, color)
	button.MouseButton1Down:Connect(function()
		local ripple = Utility:Create("Frame", {
			Name = "Ripple",
			BackgroundColor3 = color or Color3.fromRGB(255,255,255),
			BackgroundTransparency = 0.75,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(0, 0),
			Parent = button,
			ZIndex = button.ZIndex + 1,
		})
		Utility:Round(ripple, 100)
		Utility:Tween(ripple, {Size = UDim2.fromScale(2, 2), BackgroundTransparency = 1}, 0.5)
		task.delay(0.5, function()
			ripple:Destroy()
		end)
	end)
end

function Utility:MakeDraggable(frame, dragHandle)
	dragHandle = dragHandle or frame
	local dragging = false
	local dragStart, startPos

	local function update(input)
		local delta = input.Position - dragStart
		local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		Utility:Tween(frame, {Position = newPos}, 0.08, Enum.EasingStyle.Sine)
	end

	dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	dragHandle.InputChanged:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
			update(input)
		end
	end)
end

function Utility:TextBounds(text, font, size)
	return TextService:GetTextSize(text, size, font, Vector2.new(1000, 1000))
end

--=====================================================================
-- ICON MANAGER (Lucide-style using Roblox asset ids by name lookup table)
--=====================================================================

local IconManager = {}
Library.IconManager = IconManager

IconManager.Icons = setmetatable({}, {__index = function() return "rbxassetid://3926305904" end})

function IconManager:Get(name)
	return IconManager.Icons[name]
end

function IconManager:Register(name, id)
	IconManager.Icons[name] = id
end

--=====================================================================
-- NOTIFICATION SYSTEM
--=====================================================================

local ScreenGui = Utility:Create("ScreenGui", {
	Name = "UILibrary_" .. HttpService:GenerateGUID(false),
	ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	DisplayOrder = 999,
})

pcall(function()
	ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
	ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

Library.ScreenGui = ScreenGui

local NotificationHolder = Utility:Create("Frame", {
	Name = "Notifications",
	BackgroundTransparency = 1,
	AnchorPoint = Vector2.new(1, 1),
	Position = UDim2.new(1, -16, 1, -16),
	Size = UDim2.new(0, 320, 1, -32),
	Parent = ScreenGui,
})
Utility:ListLayout(NotificationHolder, Enum.FillDirection.Vertical, 8, Enum.HorizontalAlignment.Right).VerticalAlignment = Enum.VerticalAlignment.Bottom
NotificationHolder.ClipsDescendants = false

function Library:Notify(config)
	config = config or {}
	local theme = Library:GetTheme()
	local title = config.Title or "Notification"
	local content = config.Content or ""
	local duration = config.Duration or 4
	local icon = config.Icon

	local frame = Utility:Create("Frame", {
		Name = "Notification",
		BackgroundColor3 = theme.Section,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Parent = NotificationHolder,
		LayoutOrder = -os.clock(),
	})
	Utility:Round(frame, 8)
	local stroke = Utility:Stroke(frame, theme.SectionBorder, 1)
	Utility:Padding(frame, 12)

	local accent = Utility:Create("Frame", {
		BackgroundColor3 = theme.Accent,
		Size = UDim2.new(0, 3, 1, 0),
		BorderSizePixel = 0,
		Parent = frame,
	})
	Utility:Round(accent, 2)

	local titleLabel = Utility:Create("TextLabel", {
		Text = title,
		Font = theme.FontBold,
		TextSize = 15,
		TextColor3 = theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -8, 0, 18),
		Position = UDim2.new(0, 8, 0, 0),
		Parent = frame,
	})

	local contentLabel = Utility:Create("TextLabel", {
		Text = content,
		Font = theme.Font,
		TextSize = 13,
		TextColor3 = theme.TextDark,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextWrapped = true,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -8, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = UDim2.new(0, 8, 0, 20),
		Parent = frame,
	})

	frame.BackgroundTransparency = 0
	frame.Position = UDim2.new(1, 50, 0, 0)
	Utility:Tween(frame, {Position = UDim2.new(0,0,0,0)}, 0.35)

	task.delay(duration, function()
		if frame and frame.Parent then
			Utility:Tween(frame, {Position = UDim2.new(1, 50, 0, 0)}, 0.3)
			Utility:Tween(stroke, {Transparency = 1}, 0.3)
			task.delay(0.3, function()
				if frame then frame:Destroy() end
			end)
		end
	end)

	return frame
end

--=====================================================================
-- WINDOW
--=====================================================================

local Window = {}
Window.__index = Window

local TabMethods = {}
TabMethods.__index = TabMethods

local SectionMethods = {}
SectionMethods.__index = SectionMethods

function Library:CreateWindow(config)
	config = config or {}
	local theme = Library:GetTheme()

	local self = setmetatable({}, Window)
	self.Title = config.Title or "Library"
	self.SubTitle = config.SubTitle or ""
	self.Size = config.Size or UDim2.fromOffset(720, 470)
	self.Tabs = {}
	self.CurrentTab = nil
	self.Minimized = false

	local Main = Utility:Create("Frame", {
		Name = "Main",
		BackgroundColor3 = theme.Background,
		Position = UDim2.new(0.5, -self.Size.X.Offset/2, 0.5, -self.Size.Y.Offset/2),
		Size = self.Size,
		ClipsDescendants = true,
		Parent = ScreenGui,
	})
	Utility:Round(Main, 10)
	Utility:Stroke(Main, theme.SectionBorder, 1)
	Library:Tag(Main, "BackgroundColor3", "Background")
	self.Main = Main

	local TopBar = Utility:Create("Frame", {
		Name = "TopBar",
		BackgroundColor3 = theme.TopBar,
		Size = UDim2.new(1, 0, 0, 42),
		Parent = Main,
	})
	Utility:Round(TopBar, 10)
	Library:Tag(TopBar, "BackgroundColor3", "TopBar")

	local TopBarFix = Utility:Create("Frame", {
		BackgroundColor3 = theme.TopBar,
		Position = UDim2.new(0, 0, 1, -10),
		Size = UDim2.new(1, 0, 0, 10),
		BorderSizePixel = 0,
		Parent = TopBar,
	})
	Library:Tag(TopBarFix, "BackgroundColor3", "TopBar")

	Utility:Create("ImageLabel", {
		Image = config.Icon or "rbxassetid://3926305904",
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 22, 0, 22),
		Position = UDim2.new(0, 14, 0.5, -11),
		Parent = TopBar,
	})

	local TitleLabel = Utility:Create("TextLabel", {
		Text = self.Title,
		Font = theme.FontBold,
		TextSize = 15,
		TextColor3 = theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 44, 0, 6),
		Size = UDim2.new(0, 300, 0, 16),
		Parent = TopBar,
	})
	Library:Tag(TitleLabel, "TextColor3", "Text")

	local SubTitleLabel = Utility:Create("TextLabel", {
		Text = self.SubTitle,
		Font = theme.Font,
		TextSize = 11,
		TextColor3 = theme.TextDark,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 44, 0, 21),
		Size = UDim2.new(0, 300, 0, 14),
		Parent = TopBar,
	})
	Library:Tag(SubTitleLabel, "TextColor3", "TextDark")

	local function TopBarButton(icon, offsetX)
		local btn = Utility:Create("TextButton", {
			Text = "",
			BackgroundColor3 = theme.Element,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 28, 0, 28),
			Position = UDim2.new(1, offsetX, 0.5, -14),
			AutoButtonColor = false,
			Parent = TopBar,
		})
		Utility:Round(btn, 6)
		local ic = Utility:Create("ImageLabel", {
			Image = icon,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 14, 0, 14),
			Position = UDim2.new(0.5, -7, 0.5, -7),
			ImageColor3 = theme.TextDark,
			Parent = btn,
		})
		btn.MouseEnter:Connect(function()
			Utility:Tween(btn, {BackgroundTransparency = 0}, 0.15)
		end)
		btn.MouseLeave:Connect(function()
			Utility:Tween(btn, {BackgroundTransparency = 1}, 0.15)
		end)
		return btn, ic
	end

	local CloseBtn = TopBarButton("rbxassetid://3926305904", -36)
	local MinimizeBtn = TopBarButton("rbxassetid://3926305904", -68)

	local Body = Utility:Create("Frame", {
		Name = "Body",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 42),
		Size = UDim2.new(1, 0, 1, -42),
		Parent = Main,
	})

	local Sidebar = Utility:Create("Frame", {
		Name = "Sidebar",
		BackgroundColor3 = theme.Sidebar,
		Size = UDim2.new(0, 160, 1, 0),
		Parent = Body,
	})
	Library:Tag(Sidebar, "BackgroundColor3", "Sidebar")
	self.Sidebar = Sidebar

	local SearchBox = Utility:Create("Frame", {
		BackgroundColor3 = theme.Element,
		Size = UDim2.new(1, -16, 0, 30),
		Position = UDim2.new(0, 8, 0, 8),
		Parent = Sidebar,
	})
	Utility:Round(SearchBox, 6)
	Utility:Stroke(SearchBox, theme.ElementBorder, 1)
	local SearchInput = Utility:Create("TextBox", {
		PlaceholderText = "Pesquisar...",
		Text = "",
		Font = theme.Font,
		TextSize = 12,
		TextColor3 = theme.Text,
		PlaceholderColor3 = theme.TextDisabled,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -16, 1, 0),
		Position = UDim2.new(0, 8, 0, 0),
		ClearTextOnFocus = false,
		Parent = SearchBox,
	})
	self.SearchInput = SearchInput

	local TabListHolder = Utility:Create("ScrollingFrame", {
		Name = "TabList",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 46),
		Size = UDim2.new(1, 0, 1, -46),
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = theme.Accent,
		CanvasSize = UDim2.new(0,0,0,0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Parent = Sidebar,
	})
	Utility:Padding(TabListHolder, 6)
	Utility:ListLayout(TabListHolder, Enum.FillDirection.Vertical, 4)
	self.TabListHolder = TabListHolder

	local ContentArea = Utility:Create("Frame", {
		Name = "ContentArea",
		BackgroundColor3 = theme.BackgroundSecondary,
		Position = UDim2.new(0, 160, 0, 0),
		Size = UDim2.new(1, -160, 1, 0),
		Parent = Body,
	})
	Library:Tag(ContentArea, "BackgroundColor3", "BackgroundSecondary")
	self.ContentArea = ContentArea

	local TabContentHolder = Utility:Create("Frame", {
		Name = "TabContentHolder",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Parent = ContentArea,
	})
	self.TabContentHolder = TabContentHolder

	Utility:MakeDraggable(Main, TopBar)

	CloseBtn.MouseButton1Click:Connect(function()
		Utility:Tween(Main, {Size = UDim2.new(Main.Size.X.Scale, Main.Size.X.Offset, 0, 0)}, 0.25)
		task.delay(0.25, function()
			Main.Visible = false
		end)
	end)

	MinimizeBtn.MouseButton1Click:Connect(function()
		self.Minimized = not self.Minimized
		if self.Minimized then
			Utility:Tween(Main, {Size = UDim2.new(Main.Size.X.Scale, Main.Size.X.Offset, 0, 42)}, 0.25)
		else
			Utility:Tween(Main, {Size = self.Size}, 0.25)
		end
	end)

	SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
		self:SearchElements(SearchInput.Text)
	end)

	table.insert(Library.Windows, self)
	return self
end

function Window:SearchElements(query)
	query = query:lower()
	for _, tabData in pairs(self.Tabs) do
		for _, section in ipairs(tabData.Sections) do
			for _, el in ipairs(section.Elements) do
				if query == "" then
					el.Frame.Visible = true
				else
					local name = (el.Name or ""):lower()
					el.Frame.Visible = name:find(query, 1, true) ~= nil
				end
			end
		end
	end
end

function Window:Tab(config)
	config = config or {}
	local theme = Library:GetTheme()
	local name = config.Name or config.Title or "Tab"
	local icon = config.Icon

	local TabButton = Utility:Create("TextButton", {
		Name = name,
		Text = "",
		BackgroundColor3 = theme.Element,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 32),
		AutoButtonColor = false,
		Parent = self.TabListHolder,
	})
	Utility:Round(TabButton, 6)

	local IconImg
	local xOffset = 10
	if icon then
		IconImg = Utility:Create("ImageLabel", {
			Image = icon,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 15, 0, 15),
			Position = UDim2.new(0, 10, 0.5, -7.5),
			ImageColor3 = theme.TextDark,
			Parent = TabButton,
		})
		xOffset = 32
	end

	local TabLabel = Utility:Create("TextLabel", {
		Text = name,
		Font = theme.Font,
		TextSize = 13,
		TextColor3 = theme.TextDark,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, xOffset, 0, 0),
		Size = UDim2.new(1, -xOffset - 6, 1, 0),
		Parent = TabButton,
	})

	local Indicator = Utility:Create("Frame", {
		BackgroundColor3 = theme.Accent,
		Size = UDim2.new(0, 3, 0, 0),
		Position = UDim2.new(0, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BorderSizePixel = 0,
		Parent = TabButton,
	})
	Utility:Round(Indicator, 2)

	local TabPage = Utility:Create("ScrollingFrame", {
		Name = name .. "Page",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		ScrollBarThickness = 4,
		ScrollBarImageColor3 = theme.Accent,
		CanvasSize = UDim2.new(0,0,0,0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Visible = false,
		Parent = self.TabContentHolder,
	})
	Utility:Padding(TabPage, 16)

	local ColumnLeft = Utility:Create("Frame", {
		Name = "ColumnLeft",
		BackgroundTransparency = 1,
		Size = UDim2.new(0.5, -8, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = TabPage,
	})
	Utility:ListLayout(ColumnLeft, Enum.FillDirection.Vertical, 12)

	local ColumnRight = Utility:Create("Frame", {
		Name = "ColumnRight",
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 8, 0, 0),
		Size = UDim2.new(0.5, -8, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = TabPage,
	})
	Utility:ListLayout(ColumnRight, Enum.FillDirection.Vertical, 12)

	local tabData = {
		Name = name,
		Button = TabButton,
		Page = TabPage,
		Indicator = Indicator,
		Label = TabLabel,
		Icon = IconImg,
		Sections = {},
		ColumnLeft = ColumnLeft,
		ColumnRight = ColumnRight,
	}

	local windowSelf = self
	local function SelectTab()
		for _, t in pairs(windowSelf.Tabs) do
			t.Page.Visible = false
			Utility:Tween(t.Label, {TextColor3 = theme.TextDark}, 0.15)
			if t.Icon then Utility:Tween(t.Icon, {ImageColor3 = theme.TextDark}, 0.15) end
			Utility:Tween(t.Indicator, {Size = UDim2.new(0, 3, 0, 0)}, 0.15)
			Utility:Tween(t.Button, {BackgroundTransparency = 1}, 0.15)
		end
		TabPage.Visible = true
		Utility:Tween(TabLabel, {TextColor3 = theme.Text}, 0.15)
		if IconImg then Utility:Tween(IconImg, {ImageColor3 = theme.Accent}, 0.15) end
		Utility:Tween(Indicator, {Size = UDim2.new(0, 3, 0, 20)}, 0.15)
		Utility:Tween(TabButton, {BackgroundTransparency = 0.5}, 0.15)
		windowSelf.CurrentTab = tabData
	end

	TabButton.MouseButton1Click:Connect(SelectTab)

	self.Tabs[name] = tabData
	if not self.CurrentTab then
		SelectTab()
	end

	return setmetatable({Data = tabData, Window = self}, {__index = TabMethods})
end

function TabMethods:Section(config)
	config = config or {}
	local theme = Library:GetTheme()
	local side = config.Side == "Right" and self.Data.ColumnRight or self.Data.ColumnLeft
	local title = config.Title or config.Name or "Section"

	local SectionFrame = Utility:Create("Frame", {
		Name = title,
		BackgroundColor3 = theme.Section,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = side,
	})
	Utility:Round(SectionFrame, 8)
	Utility:Stroke(SectionFrame, theme.SectionBorder, 1)
	Library:Tag(SectionFrame, "BackgroundColor3", "Section")

	local TitleLabel = Utility:Create("TextLabel", {
		Text = title,
		Font = theme.FontBold,
		TextSize = 13,
		TextColor3 = theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -20, 0, 30),
		Position = UDim2.new(0, 12, 0, 0),
		Parent = SectionFrame,
	})
	Library:Tag(TitleLabel, "TextColor3", "Text")

	local Divider = Utility:Create("Frame", {
		BackgroundColor3 = theme.Divider,
		Size = UDim2.new(1, -24, 0, 1),
		Position = UDim2.new(0, 12, 0, 30),
		BorderSizePixel = 0,
		Parent = SectionFrame,
	})
	Library:Tag(Divider, "BackgroundColor3", "Divider")

	local ElementHolder = Utility:Create("Frame", {
		Name = "Elements",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 36),
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = SectionFrame,
	})
	Utility:Padding(ElementHolder, 0, 4, 10, 12, 12)
	Utility:ListLayout(ElementHolder, Enum.FillDirection.Vertical, 8)

	local sectionData = {Frame = SectionFrame, ElementHolder = ElementHolder, Elements = {}}
	table.insert(self.Data.Sections, sectionData)

	return setmetatable({Data = sectionData, Tab = self}, {__index = SectionMethods})
end

--=====================================================================
-- COMPONENT: BUTTON
--=====================================================================

function SectionMethods:Button(config)
	config = config or {}
	local theme = Library:GetTheme()
	local name = config.Name or config.Text or "Button"
	local callback = config.Callback or function() end

	local Frame = Utility:Create("Frame", {
		Name = name,
		BackgroundColor3 = theme.Element,
		Size = UDim2.new(1, 0, 0, 34),
		Parent = self.Data.ElementHolder,
	})
	Utility:Round(Frame, 6)
	local stroke = Utility:Stroke(Frame, theme.ElementBorder, 1)

	local Btn = Utility:Create("TextButton", {
		Text = "",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		AutoButtonColor = false,
		Parent = Frame,
	})

	local Label = Utility:Create("TextLabel", {
		Text = name,
		Font = theme.Font,
		TextSize = 13,
		TextColor3 = theme.Text,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -20, 1, 0),
		Position = UDim2.new(0, 10, 0, 0),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Frame,
	})

	Utility:Ripple(Btn, theme.Accent)

	Btn.MouseEnter:Connect(function()
		Utility:Tween(Frame, {BackgroundColor3 = theme.ElementHover}, 0.15)
		Utility:Tween(stroke, {Color = theme.Accent}, 0.15)
	end)
	Btn.MouseLeave:Connect(function()
		Utility:Tween(Frame, {BackgroundColor3 = theme.Element}, 0.15)
		Utility:Tween(stroke, {Color = theme.ElementBorder}, 0.15)
	end)
	Btn.MouseButton1Click:Connect(function()
		task.spawn(callback)
	end)

	local elementData = {Frame = Frame, Name = name}
	table.insert(self.Data.Elements, elementData)

	local api = {}
	function api:Set(newName)
		Label.Text = newName
	end
	function api:Destroy()
		Frame:Destroy()
	end
	return api
end

--=====================================================================
-- COMPONENT: TOGGLE
--=====================================================================

function SectionMethods:Toggle(config)
	config = config or {}
	local theme = Library:GetTheme()
	local name = config.Name or "Toggle"
	local default = config.Default or false
	local flag = config.Flag
	local callback = config.Callback or function() end

	local Frame = Utility:Create("Frame", {
		Name = name,
		BackgroundColor3 = theme.Element,
		Size = UDim2.new(1, 0, 0, 34),
		Parent = self.Data.ElementHolder,
	})
	Utility:Round(Frame, 6)
	Utility:Stroke(Frame, theme.ElementBorder, 1)

	local Label = Utility:Create("TextLabel", {
		Text = name,
		Font = theme.Font,
		TextSize = 13,
		TextColor3 = theme.Text,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -60, 1, 0),
		Position = UDim2.new(0, 10, 0, 0),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Frame,
	})

	local Switch = Utility:Create("Frame", {
		BackgroundColor3 = default and theme.Accent or theme.ElementBorder,
		Size = UDim2.new(0, 38, 0, 20),
		Position = UDim2.new(1, -48, 0.5, -10),
		Parent = Frame,
	})
	Utility:Round(Switch, 10)

	local Knob = Utility:Create("Frame", {
		BackgroundColor3 = Color3.fromRGB(255,255,255),
		Size = UDim2.new(0, 16, 0, 16),
		Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
		Parent = Switch,
	})
	Utility:Round(Knob, 8)

	local Click = Utility:Create("TextButton", {
		Text = "",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Parent = Frame,
	})

	local state = default

	local function setState(value, fromInit)
		state = value
		Utility:Tween(Switch, {BackgroundColor3 = state and theme.Accent or theme.ElementBorder}, 0.2)
		Utility:Tween(Knob, {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}, 0.2)
		if flag then
			Library.Flags[flag] = state
		end
		if not fromInit then
			task.spawn(callback, state)
		end
	end

	Click.MouseButton1Click:Connect(function()
		setState(not state)
	end)

	if flag then
		Library.Flags[flag] = state
	end

	local elementData = {Frame = Frame, Name = name}
	table.insert(self.Data.Elements, elementData)

	local api = {}
	function api:Set(value)
		setState(value)
	end
	function api:Get()
		return state
	end
	function api:Destroy()
		Frame:Destroy()
	end
	return api
end

--=====================================================================
-- COMPONENT: SLIDER
--=====================================================================

function SectionMethods:Slider(config)
	config = config or {}
	local theme = Library:GetTheme()
	local name = config.Name or "Slider"
	local min = config.Min or 0
	local max = config.Max or 100
	local default = config.Default or min
	local decimals = config.Decimals or 0
	local suffix = config.Suffix or ""
	local flag = config.Flag
	local callback = config.Callback or function() end

	local Frame = Utility:Create("Frame", {
		Name = name,
		BackgroundColor3 = theme.Element,
		Size = UDim2.new(1, 0, 0, 46),
		Parent = self.Data.ElementHolder,
	})
	Utility:Round(Frame, 6)
	Utility:Stroke(Frame, theme.ElementBorder, 1)
	Utility:Padding(Frame, 0, 8, 8, 10, 10)

	local Label = Utility:Create("TextLabel", {
		Text = name,
		Font = theme.Font,
		TextSize = 13,
		TextColor3 = theme.Text,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -50, 0, 16),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Frame,
	})

	local ValueLabel = Utility:Create("TextLabel", {
		Text = tostring(default) .. suffix,
		Font = theme.Font,
		TextSize = 12,
		TextColor3 = theme.TextDark,
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 50, 0, 16),
		Position = UDim2.new(1, -50, 0, 0),
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = Frame,
	})

	local Track = Utility:Create("Frame", {
		BackgroundColor3 = theme.ElementBorder,
		Size = UDim2.new(1, 0, 0, 6),
		Position = UDim2.new(0, 0, 0, 24),
		Parent = Frame,
	})
	Utility:Round(Track, 3)

	local Fill = Utility:Create("Frame", {
		BackgroundColor3 = theme.Accent,
		Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
		Parent = Track,
	})
	Utility:Round(Fill, 3)

	local Knob = Utility:Create("Frame", {
		BackgroundColor3 = Color3.fromRGB(255,255,255),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(0, 12, 0, 12),
		Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0),
		Parent = Track,
	})
	Utility:Round(Knob, 6)

	local dragging = false
	local value = default

	local function round(n)
		local mult = 10 ^ decimals
		return math.floor(n * mult + 0.5) / mult
	end

	local function updateFromInput(inputPos)
		local relative = math.clamp((inputPos - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
		value = round(min + (max - min) * relative)
		Fill.Size = UDim2.new(relative, 0, 1, 0)
		Knob.Position = UDim2.new(relative, 0, 0.5, 0)
		ValueLabel.Text = tostring(value) .. suffix
		if flag then Library.Flags[flag] = value end
		task.spawn(callback, value)
	end

	Track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			updateFromInput(input.Position.X)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateFromInput(input.Position.X)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	if flag then Library.Flags[flag] = default end

	local elementData = {Frame = Frame, Name = name}
	table.insert(self.Data.Elements, elementData)

	local api = {}
	function api:Set(v)
		local relative = math.clamp((v - min) / (max - min), 0, 1)
		updateFromInput(Track.AbsolutePosition.X + relative * Track.AbsoluteSize.X)
	end
	function api:Get()
		return value
	end
	function api:Destroy()
		Frame:Destroy()
	end
	return api
end

--=====================================================================
-- COMPONENT: DROPDOWN
--=====================================================================

function SectionMethods:Dropdown(config)
	config = config or {}
	local theme = Library:GetTheme()
	local name = config.Name or "Dropdown"
	local options = config.Options or {}
	local default = config.Default
	local multi = config.Multi or false
	local flag = config.Flag
	local callback = config.Callback or function() end

	local Frame = Utility:Create("Frame", {
		Name = name,
		BackgroundColor3 = theme.Element,
		Size = UDim2.new(1, 0, 0, 34),
		ClipsDescendants = false,
		ZIndex = 2,
		Parent = self.Data.ElementHolder,
	})
	Utility:Round(Frame, 6)
	Utility:Stroke(Frame, theme.ElementBorder, 1)

	local Label = Utility:Create("TextLabel", {
		Text = name,
		Font = theme.Font,
		TextSize = 13,
		TextColor3 = theme.Text,
		BackgroundTransparency = 1,
		Size = UDim2.new(0.5, 0, 1, 0),
		Position = UDim2.new(0, 10, 0, 0),
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 2,
		Parent = Frame,
	})

	local SelectedLabel = Utility:Create("TextLabel", {
		Text = default and tostring(default) or "Selecionar",
		Font = theme.Font,
		TextSize = 12,
		TextColor3 = theme.TextDark,
		BackgroundTransparency = 1,
		Size = UDim2.new(0.5, -30, 1, 0),
		Position = UDim2.new(0.5, 0, 0, 0),
		TextXAlignment = Enum.TextXAlignment.Right,
		ZIndex = 2,
		Parent = Frame,
	})

	local Arrow = Utility:Create("ImageLabel", {
		Image = "rbxassetid://3926305904",
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 12, 0, 12),
		Position = UDim2.new(1, -22, 0.5, -6),
		ImageColor3 = theme.TextDark,
		ZIndex = 2,
		Parent = Frame,
	})

	local Click = Utility:Create("TextButton", {
		Text = "",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = 3,
		Parent = Frame,
	})

	local ListFrame = Utility:Create("Frame", {
		BackgroundColor3 = theme.Section,
		Position = UDim2.new(0, 0, 1, 4),
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Visible = false,
		ZIndex = 10,
		Parent = Frame,
	})
	Utility:Round(ListFrame, 6)
	Utility:Stroke(ListFrame, theme.SectionBorder, 1)
	Utility:Padding(ListFrame, 4)
	Utility:ListLayout(ListFrame, Enum.FillDirection.Vertical, 2)

	local selected = multi and {} or default
	if multi and default then
		for _, v in ipairs(default) do selected[v] = true end
	end

	local optionButtons = {}

	local function updateSelectedLabel()
		if multi then
			local list = {}
			for k, v in pairs(selected) do
				if v then table.insert(list, k) end
			end
			SelectedLabel.Text = #list == 0 and "Nenhum" or table.concat(list, ", ")
		else
			SelectedLabel.Text = selected and tostring(selected) or "Selecionar"
		end
	end
	updateSelectedLabel()

	local open = false
	local function toggleOpen()
		open = not open
		ListFrame.Visible = open
		Utility:Tween(Arrow, {Rotation = open and 180 or 0}, 0.15)
	end

	Click.MouseButton1Click:Connect(toggleOpen)

	local function selectOption(opt)
		if multi then
			selected[opt] = not selected[opt]
			updateSelectedLabel()
			if flag then Library.Flags[flag] = selected end
			task.spawn(callback, selected)
		else
			selected = opt
			updateSelectedLabel()
			toggleOpen()
			if flag then Library.Flags[flag] = selected end
			task.spawn(callback, selected)
		end
		for optName, btn in pairs(optionButtons) do
			local isSelected = multi and selected[optName] or selected == optName
			Utility:Tween(btn, {BackgroundColor3 = isSelected and theme.Accent or theme.Element}, 0.15)
		end
	end

	for _, opt in ipairs(options) do
		local OptBtn = Utility:Create("TextButton", {
			Text = tostring(opt),
			Font = theme.Font,
			TextSize = 12,
			TextColor3 = theme.Text,
			BackgroundColor3 = theme.Element,
			Size = UDim2.new(1, 0, 0, 26),
			ZIndex = 11,
			AutoButtonColor = false,
			Parent = ListFrame,
		})
		Utility:Round(OptBtn, 4)
		optionButtons[opt] = OptBtn
		OptBtn.MouseButton1Click:Connect(function()
			selectOption(opt)
		end)
	end

	if flag then Library.Flags[flag] = selected end

	local elementData = {Frame = Frame, Name = name}
	table.insert(self.Data.Elements, elementData)

	local api = {}
	function api:Set(v)
		selectOption(v)
	end
	function api:Get()
		return selected
	end
	function api:Refresh(newOptions)
		for _, btn in pairs(optionButtons) do btn:Destroy() end
		optionButtons = {}
		for _, opt in ipairs(newOptions) do
			local OptBtn = Utility:Create("TextButton", {
				Text = tostring(opt),
				Font = theme.Font,
				TextSize = 12,
				TextColor3 = theme.Text,
				BackgroundColor3 = theme.Element,
				Size = UDim2.new(1, 0, 0, 26),
				ZIndex = 11,
				AutoButtonColor = false,
				Parent = ListFrame,
			})
			Utility:Round(OptBtn, 4)
			optionButtons[opt] = OptBtn
			OptBtn.MouseButton1Click:Connect(function()
				selectOption(opt)
			end)
		end
	end
	function api:Destroy()
		Frame:Destroy()
	end
	return api
end

--=====================================================================
-- COMPONENT: TEXTBOX
--=====================================================================

function SectionMethods:Textbox(config)
	config = config or {}
	local theme = Library:GetTheme()
	local name = config.Name or "Textbox"
	local placeholder = config.Placeholder or "..."
	local default = config.Default or ""
	local numericOnly = config.Numeric or false
	local flag = config.Flag
	local callback = config.Callback or function() end

	local Frame = Utility:Create("Frame", {
		Name = name,
		BackgroundColor3 = theme.Element,
		Size = UDim2.new(1, 0, 0, 34),
		Parent = self.Data.ElementHolder,
	})
	Utility:Round(Frame, 6)
	Utility:Stroke(Frame, theme.ElementBorder, 1)

	local Label = Utility:Create("TextLabel", {
		Text = name,
		Font = theme.Font,
		TextSize = 13,
		TextColor3 = theme.Text,
		BackgroundTransparency = 1,
		Size = UDim2.new(0.4, 0, 1, 0),
		Position = UDim2.new(0, 10, 0, 0),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Frame,
	})

	local Input = Utility:Create("TextBox", {
		Text = default,
		PlaceholderText = placeholder,
		Font = theme.Font,
		TextSize = 12,
		TextColor3 = theme.Text,
		PlaceholderColor3 = theme.TextDisabled,
		BackgroundTransparency = 1,
		Size = UDim2.new(0.6, -20, 1, 0),
		Position = UDim2.new(0.4, 10, 0, 0),
		TextXAlignment = Enum.TextXAlignment.Right,
		ClearTextOnFocus = false,
		Parent = Frame,
	})

	Input:GetPropertyChangedSignal("Text"):Connect(function()
		if numericOnly then
			local filtered = Input.Text:gsub("[^%d%.%-]", "")
			if filtered ~= Input.Text then
				Input.Text = filtered
			end
		end
	end)

	Input.FocusLost:Connect(function(enterPressed)
		if flag then Library.Flags[flag] = Input.Text end
		task.spawn(callback, Input.Text, enterPressed)
	end)

	if flag then Library.Flags[flag] = default end

	local elementData = {Frame = Frame, Name = name}
	table.insert(self.Data.Elements, elementData)

	local api = {}
	function api:Set(v)
		Input.Text = v
		if flag then Library.Flags[flag] = v end
	end
	function api:Get()
		return Input.Text
	end
	function api:Destroy()
		Frame:Destroy()
	end
	return api
end

--=====================================================================
-- COMPONENT: LABEL
--=====================================================================

function SectionMethods:Label(config)
	config = config or {}
	local theme = Library:GetTheme()
	local text = config.Text or config.Name or "Label"

	local Frame = Utility:Create("Frame", {
		Name = "Label",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 20),
		Parent = self.Data.ElementHolder,
	})

	local TextLbl = Utility:Create("TextLabel", {
		Text = text,
		Font = theme.Font,
		TextSize = 13,
		TextColor3 = theme.TextDark,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Frame,
	})

	local elementData = {Frame = Frame, Name = text}
	table.insert(self.Data.Elements, elementData)

	local api = {}
	function api:Set(v)
		TextLbl.Text = v
	end
	function api:Destroy()
		Frame:Destroy()
	end
	return api
end

--=====================================================================
-- COMPONENT: PARAGRAPH
--=====================================================================

function SectionMethods:Paragraph(config)
	config = config or {}
	local theme = Library:GetTheme()
	local title = config.Title or "Paragraph"
	local content = config.Content or ""

	local Frame = Utility:Create("Frame", {
		Name = title,
		BackgroundColor3 = theme.Element,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = self.Data.ElementHolder,
	})
	Utility:Round(Frame, 6)
	Utility:Stroke(Frame, theme.ElementBorder, 1)
	Utility:Padding(Frame, 10)

	local TitleLbl = Utility:Create("TextLabel", {
		Text = title,
		Font = theme.FontBold,
		TextSize = 13,
		TextColor3 = theme.Text,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 16),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Frame,
	})

	local ContentLbl = Utility:Create("TextLabel", {
		Text = content,
		Font = theme.Font,
		TextSize = 12,
		TextColor3 = theme.TextDark,
		BackgroundTransparency = 1,
		TextWrapped = true,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = UDim2.new(0, 0, 0, 20),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		Parent = Frame,
	})

	local elementData = {Frame = Frame, Name = title}
	table.insert(self.Data.Elements, elementData)

	local api = {}
	function api:Set(newContent)
		ContentLbl.Text = newContent
	end
	function api:Destroy()
		Frame:Destroy()
	end
	return api
end

--=====================================================================
-- COMPONENT: KEYBIND (Bind)
--=====================================================================

function SectionMethods:Keybind(config)
	config = config or {}
	local theme = Library:GetTheme()
	local name = config.Name or "Keybind"
	local default = config.Default
	local flag = config.Flag
	local callback = config.Callback or function() end
	local changedCallback = config.Changed or function() end

	local Frame = Utility:Create("Frame", {
		Name = name,
		BackgroundColor3 = theme.Element,
		Size = UDim2.new(1, 0, 0, 34),
		Parent = self.Data.ElementHolder,
	})
	Utility:Round(Frame, 6)
	Utility:Stroke(Frame, theme.ElementBorder, 1)

	local Label = Utility:Create("TextLabel", {
		Text = name,
		Font = theme.Font,
		TextSize = 13,
		TextColor3 = theme.Text,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -90, 1, 0),
		Position = UDim2.new(0, 10, 0, 0),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Frame,
	})

	local KeyButton = Utility:Create("TextButton", {
		Text = default and default.Name or "Nenhuma",
		Font = theme.Font,
		TextSize = 12,
		TextColor3 = theme.TextDark,
		BackgroundColor3 = theme.ElementHover,
		Size = UDim2.new(0, 80, 0, 22),
		Position = UDim2.new(1, -88, 0.5, -11),
		AutoButtonColor = false,
		Parent = Frame,
	})
	Utility:Round(KeyButton, 4)

	local currentKey = default
	local listening = false

	KeyButton.MouseButton1Click:Connect(function()
		listening = true
		KeyButton.Text = "..."
	end)

	local conn = UserInputService.InputBegan:Connect(function(input, gpe)
		if listening then
			if input.UserInputType == Enum.UserInputType.Keyboard then
				currentKey = input.KeyCode
				KeyButton.Text = currentKey.Name
				listening = false
				if flag then Library.Flags[flag] = currentKey end
				task.spawn(changedCallback, currentKey)
			end
			return
		end
		if gpe then return end
		if currentKey and input.KeyCode == currentKey then
			task.spawn(callback)
		end
	end)
	table.insert(Library.Connections, conn)

	local elementData = {Frame = Frame, Name = name}
	table.insert(self.Data.Elements, elementData)

	local api = {}
	function api:Set(keyCode)
		currentKey = keyCode
		KeyButton.Text = keyCode and keyCode.Name or "Nenhuma"
		if flag then Library.Flags[flag] = currentKey end
	end
	function api:Get()
		return currentKey
	end
	function api:Destroy()
		Frame:Destroy()
	end
	return api
end

--=====================================================================
-- COMPONENT: COLORPICKER
--=====================================================================

function SectionMethods:ColorPicker(config)
	config = config or {}
	local theme = Library:GetTheme()
	local name = config.Name or "Color Picker"
	local default = config.Default or Color3.fromRGB(255, 255, 255)
	local flag = config.Flag
	local callback = config.Callback or function() end

	local Frame = Utility:Create("Frame", {
		Name = name,
		BackgroundColor3 = theme.Element,
		Size = UDim2.new(1, 0, 0, 34),
		ClipsDescendants = false,
		ZIndex = 2,
		Parent = self.Data.ElementHolder,
	})
	Utility:Round(Frame, 6)
	Utility:Stroke(Frame, theme.ElementBorder, 1)

	local Label = Utility:Create("TextLabel", {
		Text = name,
		Font = theme.Font,
		TextSize = 13,
		TextColor3 = theme.Text,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -50, 1, 0),
		Position = UDim2.new(0, 10, 0, 0),
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 2,
		Parent = Frame,
	})

	local Preview = Utility:Create("TextButton", {
		Text = "",
		BackgroundColor3 = default,
		Size = UDim2.new(0, 30, 0, 20),
		Position = UDim2.new(1, -40, 0.5, -10),
		ZIndex = 2,
		AutoButtonColor = false,
		Parent = Frame,
	})
	Utility:Round(Preview, 4)
	Utility:Stroke(Preview, theme.ElementBorder, 1)

	local Popup = Utility:Create("Frame", {
		BackgroundColor3 = theme.Section,
		Position = UDim2.new(1, 4, 0, 0),
		Size = UDim2.new(0, 200, 0, 210),
		Visible = false,
		ZIndex = 20,
		Parent = Frame,
	})
	Utility:Round(Popup, 8)
	Utility:Stroke(Popup, theme.SectionBorder, 1)
	Utility:Padding(Popup, 10)

	local h, s, v = default:ToHSV()

	local SVBox = Utility:Create("ImageButton", {
		BackgroundColor3 = Color3.fromHSV(h, 1, 1),
		Size = UDim2.new(1, 0, 0, 120),
		ZIndex = 21,
		Parent = Popup,
	})
	Utility:Round(SVBox, 6)
	Utility:Gradient(SVBox, ColorSequence.new(Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255)), 0, NumberSequence.new({
		NumberSequenceKeypoint.new(0,0),
		NumberSequenceKeypoint.new(1,1),
	}))
	local SVBlack = Utility:Create("Frame", {
		BackgroundColor3 = Color3.fromRGB(0,0,0),
		BackgroundTransparency = 1,
		Size = UDim2.new(1,0,1,0),
		ZIndex = 21,
		Parent = SVBox,
	})
	Utility:Gradient(SVBlack, ColorSequence.new(Color3.fromRGB(0,0,0), Color3.fromRGB(0,0,0)), 90, NumberSequence.new({
		NumberSequenceKeypoint.new(0,1),
		NumberSequenceKeypoint.new(1,0),
	}))

	local SVCursor = Utility:Create("Frame", {
		BackgroundColor3 = Color3.fromRGB(255,255,255),
		AnchorPoint = Vector2.new(0.5,0.5),
		Size = UDim2.new(0,8,0,8),
		Position = UDim2.new(s, 0, 1-v, 0),
		ZIndex = 22,
		Parent = SVBox,
	})
	Utility:Round(SVCursor, 4)
	Utility:Stroke(SVCursor, Color3.fromRGB(0,0,0), 1)

	local HueBar = Utility:Create("Frame", {
		Size = UDim2.new(1, 0, 0, 18),
		Position = UDim2.new(0, 0, 0, 130),
		ZIndex = 21,
		Parent = Popup,
	})
	Utility:Round(HueBar, 4)
	Utility:Gradient(HueBar, ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromHSV(0,1,1)),
		ColorSequenceKeypoint.new(0.17, Color3.fromHSV(0.17,1,1)),
		ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33,1,1)),
		ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5,1,1)),
		ColorSequenceKeypoint.new(0.67, Color3.fromHSV(0.67,1,1)),
		ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83,1,1)),
		ColorSequenceKeypoint.new(1, Color3.fromHSV(1,1,1)),
	}))
	local HueButton = Utility:Create("TextButton", {
		Text = "",
		BackgroundTransparency = 1,
		Size = UDim2.new(1,0,1,0),
		ZIndex = 22,
		Parent = HueBar,
	})
	local HueCursor = Utility:Create("Frame", {
		BackgroundColor3 = Color3.fromRGB(255,255,255),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(0, 4, 1, 4),
		Position = UDim2.new(h, 0, 0.5, 0),
		ZIndex = 22,
		Parent = HueBar,
	})

	local HexBox = Utility:Create("TextBox", {
		Text = string.format("#%02X%02X%02X", default.R*255, default.G*255, default.B*255),
		Font = theme.Font,
		TextSize = 12,
		TextColor3 = theme.Text,
		BackgroundColor3 = theme.ElementHover,
		Size = UDim2.new(1, 0, 0, 24),
		Position = UDim2.new(0, 0, 0, 156),
		ZIndex = 21,
		ClearTextOnFocus = false,
		Parent = Popup,
	})
	Utility:Round(HexBox, 4)

	local currentColor = default

	local function updateColor()
		currentColor = Color3.fromHSV(h, s, v)
		SVBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
		Preview.BackgroundColor3 = currentColor
		HexBox.Text = string.format("#%02X%02X%02X", currentColor.R*255, currentColor.G*255, currentColor.B*255)
		if flag then Library.Flags[flag] = currentColor end
		task.spawn(callback, currentColor)
	end

	local draggingSV, draggingHue = false, false

	SVBox.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingSV = true
		end
	end)
	HueButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingHue = true
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingSV = false
			draggingHue = false
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
		if draggingSV then
			local relX = math.clamp((input.Position.X - SVBox.AbsolutePosition.X) / SVBox.AbsoluteSize.X, 0, 1)
			local relY = math.clamp((input.Position.Y - SVBox.AbsolutePosition.Y) / SVBox.AbsoluteSize.Y, 0, 1)
			s = relX
			v = 1 - relY
			SVCursor.Position = UDim2.new(relX, 0, relY, 0)
			updateColor()
		elseif draggingHue then
			local relX = math.clamp((input.Position.X - HueBar.AbsolutePosition.X) / HueBar.AbsoluteSize.X, 0, 1)
			h = relX
			HueCursor.Position = UDim2.new(relX, 0, 0.5, 0)
			updateColor()
		end
	end)

	HexBox.FocusLost:Connect(function()
		local hex = HexBox.Text:gsub("#", "")
		if #hex == 6 then
			local r = tonumber(hex:sub(1,2), 16)
			local g = tonumber(hex:sub(3,4), 16)
			local b = tonumber(hex:sub(5,6), 16)
			if r and g and b then
				local color = Color3.fromRGB(r, g, b)
				h, s, v = color:ToHSV()
				SVCursor.Position = UDim2.new(s, 0, 1-v, 0)
				HueCursor.Position = UDim2.new(h, 0, 0.5, 0)
				updateColor()
			end
		end
	end)

	local open = false
	Preview.MouseButton1Click:Connect(function()
		open = not open
		Popup.Visible = open
	end)

	if flag then Library.Flags[flag] = default end

	local elementData = {Frame = Frame, Name = name}
	table.insert(self.Data.Elements, elementData)

	local api = {}
	function api:Set(color)
		h, s, v = color:ToHSV()
		SVCursor.Position = UDim2.new(s, 0, 1-v, 0)
		HueCursor.Position = UDim2.new(h, 0, 0.5, 0)
		updateColor()
	end
	function api:Get()
		return currentColor
	end
	function api:Destroy()
		Frame:Destroy()
	end
	return api
end

--=====================================================================
-- COMPONENT: DIVIDER
--=====================================================================

function SectionMethods:Divider()
	local theme = Library:GetTheme()
	local Line = Utility:Create("Frame", {
		BackgroundColor3 = theme.Divider,
		Size = UDim2.new(1, 0, 0, 1),
		Parent = self.Data.ElementHolder,
	})
	Library:Tag(Line, "BackgroundColor3", "Divider")
	local elementData = {Frame = Line, Name = "Divider"}
	table.insert(self.Data.Elements, elementData)
	return {Destroy = function() Line:Destroy() end}
end

--=====================================================================
-- CONFIG / FLAGS PERSISTENCE
--=====================================================================

function Library:SaveConfig(fileName)
	fileName = fileName or "libraryconfig"
	local ok, encoded = pcall(function()
		return HttpService:JSONEncode(Library.Flags)
	end)
	if ok and writefile then
		pcall(function()
			writefile(fileName .. ".json", encoded)
		end)
		return true
	end
	return false
end

function Library:LoadConfig(fileName)
	fileName = fileName or "libraryconfig"
	if not (isfile and isfile(fileName .. ".json")) then return false end
	local ok, decoded = pcall(function()
		return HttpService:JSONDecode(readfile(fileName .. ".json"))
	end)
	if ok and decoded then
		for k, v in pairs(decoded) do
			Library.Flags[k] = v
		end
		return true
	end
	return false
end

--=====================================================================
-- DESTROY / UNLOAD
--=====================================================================

function Library:Destroy()
	Library.Unloaded = true
	for _, conn in ipairs(Library.Connections) do
		pcall(function() conn:Disconnect() end)
	end
	Library.Connections = {}
	if ScreenGui then
		ScreenGui:Destroy()
	end
end

Library.Loaded = true

return Library
