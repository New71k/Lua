--[[
    SharkMenu Aesthetic UI Library for Roblox
    Inspirado no visual premium do Shark Menu do FiveM.
    Design Escuro, Efeitos de Transparência, Detalhes em Azul Neon, Animações Suaves.
    Arquitetura: Modular-simulada (Single File Distribution)
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService") -- Para sistema de configurações

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- [ Configurações Globais & Tema ] --
local Library = {
    Version = "2.0.0",
    Flags = {},
    Connections = {},
    Config = {}, -- Armazenamento de configurações
    Notifications = {}, -- Armazenamento de notificações ativas
    Theme = {
        Background = Color3.fromRGB(10, 10, 15), -- Fundo extremamente escuro
        TopBar = Color3.fromRGB(20, 20, 30),
        Sidebar = Color3.fromRGB(15, 15, 25),
        ElementPanel = Color3.fromRGB(25, 25, 40),
        Accent = Color3.fromRGB(0, 191, 255), -- Azul Neon (Shark style)
        Text = Color3.fromRGB(240, 240, 240),
        TextMuted = Color3.fromRGB(150, 150, 150),
        Border = Color3.fromRGB(40, 40, 60), -- Bordas finas e brilhantes
        Hover = Color3.fromRGB(35, 35, 55),
        CornerRadius = UDim.new(0, 4), -- Cantos levemente arredondados
        Font = Enum.Font.GothamMedium,
        TransparentBackground = 0.8, -- Efeito de transparência do menu
    }
}

-- [ Utilitários ] --
local function Create(class, properties)
    local instance = Instance.new(class)
    for k, v in pairs(properties) do
        if k ~= "Parent" then
            instance[k] = v
        end
    end
    if properties.Parent then instance.Parent = properties.Parent end
    return instance
end

local function Tween(instance, properties, duration, style, direction)
    local tweenInfo = TweenInfo.new(duration or 0.2, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

local function MakeDraggable(topbarobject, object)
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil

    local function Update(input)
        local Delta = input.Position - DragStart
        local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        Tween(object, {Position = pos}, 0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    end

    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end)
end

-- [ Sistema de Notificações (Toast) ] --
local NotificationContainer = Create("ScreenGui", {
    Name = "SharkMenu_Notifications",
    Parent = CoreGui,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    ResetOnSpawn = false
})

local function CreateNotification(options)
    local Title = options.Title or "Notificação"
    local Content = options.Content or ""
    local Duration = options.Duration or 5

    local NotificationFrame = Create("Frame", {
        Name = "Notification",
        Parent = NotificationContainer,
        BackgroundColor3 = Library.Theme.TopBar,
        BackgroundTransparency = Library.Theme.TransparentBackground,
        Position = UDim2.new(1, -310, 1, -(#Library.Notifications * 70) - 70), -- Posiciona no canto inferior direito
        Size = UDim2.new(0, 300, 0, 60),
        ClipsDescendants = true
    })
    Create("UICorner", {Parent = NotificationFrame, CornerRadius = Library.Theme.CornerRadius})
    Create("UIStroke", {Parent = NotificationFrame, Color = Library.Theme.Border, Thickness = 1})

    local Line = Create("Frame", {
        Parent = NotificationFrame,
        BackgroundColor3 = Library.Theme.Accent,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 3, 1, 0),
        BorderSizePixel = 0
    })

    local PTitle = Create("TextLabel", {
        Parent = NotificationFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 8),
        Size = UDim2.new(1, -20, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = Title,
        TextColor3 = Library.Theme.Accent,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local PText = Create("TextLabel", {
        Parent = NotificationFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 28),
        Size = UDim2.new(1, -20, 0, 25),
        Font = Library.Theme.Font,
        Text = Content,
        TextColor3 = Library.Theme.Text,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        TextYAlignment = Enum.TextYAlignment.Top
    })

    -- Animação de entrada
    Tween(NotificationFrame, {Position = UDim2.new(1, -310, 1, -(#Library.Notifications * 70) - 70)}, 0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    table.insert(Library.Notifications, NotificationFrame)

    -- Animação de barra de tempo
    local ProgressBar = Create("Frame", {
        Parent = NotificationFrame,
        BackgroundColor3 = Library.Theme.Accent,
        Position = UDim2.new(0, 0, 1, -2),
        Size = UDim2.new(1, 0, 0, 2),
        BorderSizePixel = 0
    })
    Tween(ProgressBar, {Size = UDim2.new(0, 0, 0, 2)}, Duration, Enum.EasingStyle.Linear).Completed:Connect(function()
        -- Animação de saída
        Tween(NotificationFrame, {Position = UDim2.new(1, 10, 1, -(#Library.Notifications * 70) - 70)}, 0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In).Completed:Connect(function()
            NotificationFrame:Destroy()
            table.remove(Library.Notifications, table.find(Library.Notifications, NotificationFrame))
        end)
    end)
end

function Library:Notify(options)
    CreateNotification(options)
end

-- [ Sistema de Janelas ] --
function Library:CreateWindow(options)
    local WindowOptions = {
        Name = options.Name or "SharkMenu Premium",
        Version = options.Version or "1.0.0",
        SaveConfig = options.SaveConfig or false,
        ConfigFolder = options.ConfigFolder or "SharkMenuConfig"
    }

    -- Procura GUI antiga para evitar duplicatas
    for _, gui in pairs(CoreGui:GetChildren()) do
        if gui.Name == "SharkMenu_PremiumUI" then gui:Destroy() end
    end

    local ScreenGui = Create("ScreenGui", {
        Name = "SharkMenu_PremiumUI",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })

    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        BackgroundColor3 = Library.Theme.Background,
        Position = UDim2.new(0.5, -400, 0.5, -275),
        Size = UDim2.new(0, 800, 0, 550),
        ClipsDescendants = false,
        BackgroundTransparency = 1, -- Para animação de entrada
    })
    Create("UICorner", {Parent = MainFrame, CornerRadius = Library.Theme.CornerRadius})
    local MainStroke = Create("UIStroke", {Parent = MainFrame, Color = Library.Theme.Border, Thickness = 1})

    -- Drop Shadow
    local Shadow = Create("ImageLabel", {
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -15, 0, -15),
        Size = UDim2.new(1, 30, 1, 30),
        ZIndex = -1,
        Image = "rbxassetid://1316045217",
        ImageColor3 = Color3.new(0,0,0),
        ImageTransparency = 0.4,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 118, 118)
    })

    -- Barra Superior (TopBar)
    local TopBar = Create("Frame", {
        Parent = MainFrame,
        BackgroundColor3 = Library.Theme.TopBar,
        Size = UDim2.new(1, 0, 0, 40),
        BorderSizePixel = 0
    })
    Create("UICorner", {Parent = TopBar, CornerRadius = Library.Theme.CornerRadius})
    MakeDraggable(TopBar, MainFrame) -- Permite arrastar a janela pela TopBar

    local TitleLabel = Create("TextLabel", {
        Parent = TopBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(1, -30, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = WindowOptions.Name .. " - v" .. WindowOptions.Version,
        TextColor3 = Library.Theme.Accent,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Botões de controle da TopBar (Minimizar, Fechar)
    local CloseBtn = Create("TextButton", {
        Parent = TopBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -35, 0.5, -12),
        Size = UDim2.new(0, 25, 0, 25),
        Font = Enum.Font.GothamBold,
        Text = "✕",
        TextColor3 = Library.Theme.TextMuted,
        TextSize = 14,
        AutoButtonColor = false
    })
    Create("UICorner", {Parent = CloseBtn, CornerRadius = UDim.new(1, 0)})
    CloseBtn.MouseEnter:Connect(function() Tween(CloseBtn, {TextColor3 = Color3.fromRGB(255, 100, 100)}, 0.1) end)
    CloseBtn.MouseLeave:Connect(function() Tween(CloseBtn, {TextColor3 = Library.Theme.TextMuted}, 0.1) end)
    CloseBtn.MouseButton1Click:Connect(function()
        -- Animação de fechamento
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = MainFrame.Position + UDim2.new(0, 400, 0, 275)}, 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In).Completed:Connect(function()
            ScreenGui:Destroy()
        end)
    end)

    local MinimizeBtn = Create("TextButton", {
        Parent = TopBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -65, 0.5, -12),
        Size = UDim2.new(0, 25, 0, 25),
        Font = Enum.Font.GothamBold,
        Text = "−",
        TextColor3 = Library.Theme.TextMuted,
        TextSize = 18,
        AutoButtonColor = false
    })
    Create("UICorner", {Parent = MinimizeBtn, CornerRadius = UDim.new(1, 0)})
    MinimizeBtn.MouseEnter:Connect(function() Tween(MinimizeBtn, {TextColor3 = Library.Theme.Accent}, 0.1) end)
    MinimizeBtn.MouseLeave:Connect(function() Tween(MinimizeBtn, {TextColor3 = Library.Theme.TextMuted}, 0.1) end)
    MinimizeBtn.MouseButton1Click:Connect(function()
        -- Animação de minimizar/maximizar
        if MainFrame.ClipsDescendants then
            MainFrame.ClipsDescendants = false
            Tween(MainFrame, {Size = UDim2.new(0, 800, 0, 550)}, 0.3)
            Tween(Shadow, {ImageTransparency = 0.4}, 0.3)
        else
            MainFrame.ClipsDescendants = true
            Tween(MainFrame, {Size = UDim2.new(0, 800, 0, 40)}, 0.3)
            Tween(Shadow, {ImageTransparency = 1}, 0.3)
        end
    end)

    local Sidebar = Create("Frame", {
        Name = "Sidebar",
        Parent = MainFrame,
        BackgroundColor3 = Library.Theme.Sidebar,
        Position = UDim2.new(0, 0, 0, 40),
        Size = UDim2.new(0, 200, 1, -40),
        BorderSizePixel = 0
    })
    Create("UICorner", {Parent = Sidebar, CornerRadius = Library.Theme.CornerRadius})

    local TabContainer = Create("ScrollingFrame", {
        Name = "TabContainer",
        Parent = Sidebar,
        Active = true,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 10),
        Size = UDim2.new(1, 0, 1, -20),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 0
    })
    Create("UIListLayout", {
        Parent = TabContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        HorizontalAlignment = Enum.HorizontalAlignment.Center
    })

    local ContentContainer = Create("Frame", {
        Name = "ContentContainer",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 205, 0, 50),
        Size = UDim2.new(1, -215, 1, -60)
    })

    local Window = {
        CurrentTab = nil,
        Tabs = {},
        MainFrame = MainFrame,
        ScreenGui = ScreenGui,
        Shadow = Shadow
    }

    -- [ Elemento: TAB ] --
    function Window:CreateTab(options)
        local tabName = options.Name or "Aba"
        local icon = options.Icon or "rbxassetid://6031091000" -- Ícone padrão

        local TabBtn = Create("TextButton", {
            Name = tabName,
            Parent = TabContainer,
            BackgroundColor3 = Library.Theme.Sidebar,
            Size = UDim2.new(1, -20, 0, 40),
            Font = Library.Theme.Font,
            Text = "",
            TextColor3 = Library.Theme.TextMuted,
            TextSize = 14,
            AutoButtonColor = false
        })
        Create("UICorner", {Parent = TabBtn, CornerRadius = UDim.new(0, 4)})

        local IconLabel = Create("ImageLabel", {
            Parent = TabBtn,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0.5, -10),
            Size = UDim2.new(0, 20, 0, 20),
            Image = icon,
            ImageColor3 = Library.Theme.TextMuted
        })

        local TitleLabel = Create("TextLabel", {
            Parent = TabBtn,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 40, 0, 0),
            Size = UDim2.new(1, -45, 1, 0),
            Font = Library.Theme.Font,
            Text = tabName,
            TextColor3 = Library.Theme.TextMuted,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        -- Indicador lateral azul
        local Indicator = Create("Frame", {
            Parent = TabBtn,
            BackgroundColor3 = Library.Theme.Accent,
            Position = UDim2.new(0, -3, 0.5, -10),
            Size = UDim2.new(0, 3, 0, 20),
            BackgroundTransparency = 1
        })
        Create("UICorner", {Parent = Indicator, CornerRadius = UDim.new(0, 2)})

        local TabContent = Create("ScrollingFrame", {
            Name = tabName.."_Content",
            Parent = ContentContainer,
            Active = true,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Library.Theme.Border,
            Visible = false
        })
        local ContentLayout = Create("UIListLayout", {
            Parent = TabContent,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8),
            HorizontalAlignment = Enum.HorizontalAlignment.Center
        })

        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
        end)

        TabBtn.MouseEnter:Connect(function()
            if Window.CurrentTab ~= tabName then
                Tween(TabBtn, {BackgroundColor3 = Library.Theme.Hover}, 0.1)
                Tween(TitleLabel, {TextColor3 = Library.Theme.Text}, 0.1)
                Tween(IconLabel, {ImageColor3 = Library.Theme.Text}, 0.1)
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if Window.CurrentTab ~= tabName then
                Tween(TabBtn, {BackgroundColor3 = Library.Theme.Sidebar}, 0.1)
                Tween(TitleLabel, {TextColor3 = Library.Theme.TextMuted}, 0.1)
                Tween(IconLabel, {ImageColor3 = Library.Theme.TextMuted}, 0.1)
            end
        end)
        TabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(Window.Tabs) do
                t.Content.Visible = false
                Tween(t.Btn, {BackgroundColor3 = Library.Theme.Sidebar}, 0.2)
                Tween(t.Title, {TextColor3 = Library.Theme.TextMuted}, 0.2)
                Tween(t.Icon, {ImageColor3 = Library.Theme.TextMuted}, 0.2)
                Tween(t.Indicator, {BackgroundTransparency = 1}, 0.2)
            end
            Window.CurrentTab = tabName
            TabContent.Visible = true
            Tween(TabBtn, {BackgroundColor3 = Library.Theme.ElementPanel}, 0.2)
            Tween(TitleLabel, {TextColor3 = Library.Theme.Accent}, 0.2)
            Tween(IconLabel, {ImageColor3 = Library.Theme.Accent}, 0.2)
            Tween(Indicator, {BackgroundTransparency = 0}, 0.2)
        end)

        local TabElements = {}
        Window.Tabs[tabName] = {Btn = TabBtn, Content = TabContent, Indicator = Indicator, Title = TitleLabel, Icon = IconLabel}

        -- [ Elemento: SECTION ] --
        function TabElements:CreateSection(sectionName)
            local SectionLabel = Create("TextLabel", {
                Parent = TabContent,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -20, 0, 30),
                Font = Enum.Font.GothamBold,
                Text = "  " .. sectionName:upper(),
                TextColor3 = Library.Theme.Accent,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                LayoutOrder = ContentLayout.AbsoluteContentSize.Y
            })
            Create("Frame", {
                Parent = SectionLabel,
                BackgroundColor3 = Library.Theme.Border,
                Position = UDim2.new(0, 10, 1, -5),
                Size = UDim2.new(1, -20, 0, 1),
                BorderSizePixel = 0
            })
        end

        -- [ Elemento: PARAGRAPH ] --
        function TabElements:CreateParagraph(options)
            local Title = options.Title or "Parágrafo"
            local Content = options.Content or ""

            local PFrame = Create("Frame", {
                Parent = TabContent,
                BackgroundColor3 = Library.Theme.ElementPanel,
                Size = UDim2.new(1, -20, 0, 0), -- Altura dinâmica
                LayoutOrder = ContentLayout.AbsoluteContentSize.Y
            })
            Create("UICorner", {Parent = PFrame, CornerRadius = Library.Theme.CornerRadius})
            Create("UIStroke", {Parent = PFrame, Color = Library.Theme.Border, Thickness = 1})

            local PTitle = Create("TextLabel", {
                Parent = PFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 8),
                Size = UDim2.new(1, -20, 0, 16),
                Font = Enum.Font.GothamBold,
                Text = Title,
                TextColor3 = Library.Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local PText = Create("TextLabel", {
                Parent = PFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 26),
                Size = UDim2.new(1, -20, 0, 0),
                Font = Library.Theme.Font,
                Text = Content,
                TextColor3 = Library.Theme.TextMuted,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                TextYAlignment = Enum.TextYAlignment.Top
            })
            
            PText.Size = UDim2.new(1, -20, 0, PText.TextBounds.Y + 5)
            PFrame.Size = UDim2.new(1, -20, 0, 35 + PText.TextBounds.Y)

            local ParagraphObj = {}
            function ParagraphObj:Set(newOptions)
                if newOptions.Title then PTitle.Text = newOptions.Title end
                if newOptions.Content then 
                    PText.Text = newOptions.Content
                    PText.Size = UDim2.new(1, -20, 0, PText.TextBounds.Y + 5)
                    PFrame.Size = UDim2.new(1, -20, 0, 35 + PText.TextBounds.Y)
                end
            end
            return ParagraphObj
        end

        -- [ Elemento: BUTTON ] --
        function TabElements:CreateButton(options)
            local Name = options.Name or "Botão"
            local Callback = options.Callback or function() end

            local BtnFrame = Create("TextButton", {
                Parent = TabContent,
                BackgroundColor3 = Library.Theme.ElementPanel,
                Size = UDim2.new(1, -20, 0, 40),
                AutoButtonColor = false,
                Text = "",
                LayoutOrder = ContentLayout.AbsoluteContentSize.Y
            })
            Create("UICorner", {Parent = BtnFrame, CornerRadius = Library.Theme.CornerRadius})
            local Stroke = Create("UIStroke", {Parent = BtnFrame, Color = Library.Theme.Border, Thickness = 1})

            local TitleLabel = Create("TextLabel", {
                Parent = BtnFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -20, 1, 0),
                Font = Enum.Font.GothamBold,
                Text = Name,
                TextColor3 = Library.Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local Icon = Create("ImageLabel", {
                Parent = BtnFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -30, 0.5, -10),
                Size = UDim2.new(0, 20, 0, 20),
                Image = "rbxassetid://6031094667", -- Ícone de seta
                ImageColor3 = Library.Theme.TextMuted
            })

            BtnFrame.MouseEnter:Connect(function()
                Tween(BtnFrame, {BackgroundColor3 = Library.Theme.Hover}, 0.1)
                Tween(Stroke, {Color = Library.Theme.Accent}, 0.1)
            end)
            BtnFrame.MouseLeave:Connect(function()
                Tween(BtnFrame, {BackgroundColor3 = Library.Theme.ElementPanel}, 0.1)
                Tween(Stroke, {Color = Library.Theme.Border}, 0.1)
            end)
            BtnFrame.MouseButton1Click:Connect(function()
                -- Efeito de clique
                Tween(BtnFrame, {Size = UDim2.new(1, -24, 0, 38)}, 0.1).Completed:Connect(function()
                    Tween(BtnFrame, {Size = UDim2.new(1, -20, 0, 40)}, 0.1)
                end)
                pcall(Callback)
            end)
        end

        -- [ Elemento: TOGGLE ] --
        function TabElements:CreateToggle(options)
            local Name = options.Name or "Toggle"
            local Default = options.CurrentValue or false
            local Flag = options.Flag or tostring(math.random())
            local Callback = options.Callback or function() end

            Library.Flags[Flag] = Default

            local ToggleFrame = Create("TextButton", {
                Parent = TabContent,
                BackgroundColor3 = Library.Theme.ElementPanel,
                Size = UDim2.new(1, -20, 0, 40),
                AutoButtonColor = false,
                Text = "",
                LayoutOrder = ContentLayout.AbsoluteContentSize.Y
            })
            Create("UICorner", {Parent = ToggleFrame, CornerRadius = Library.Theme.CornerRadius})
            local Stroke = Create("UIStroke", {Parent = ToggleFrame, Color = Library.Theme.Border, Thickness = 1})

            local TitleLabel = Create("TextLabel", {
                Parent = ToggleFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -70, 1, 0),
                Font = Library.Theme.Font,
                Text = Name,
                TextColor3 = Library.Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local Switch = Create("Frame", {
                Parent = ToggleFrame,
                BackgroundColor3 = Default and Library.Theme.Accent or Library.Theme.Border,
                Position = UDim2.new(1, -45, 0.5, -10),
                Size = UDim2.new(0, 36, 0, 20)
            })
            Create("UICorner", {Parent = Switch, CornerRadius = UDim.new(1, 0)})

            local Indicator = Create("Frame", {
                Parent = Switch,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Position = UDim2.new(0, Default and 18 or 2, 0.5, -8),
                Size = UDim2.new(0, 16, 0, 16)
            })
            Create("UICorner", {Parent = Indicator, CornerRadius = UDim.new(1, 0)})

            local function UpdateToggle(state)
                Library.Flags[Flag] = state
                if state then
                    Tween(Switch, {BackgroundColor3 = Library.Theme.Accent}, 0.2)
                    Tween(Indicator, {Position = UDim2.new(0, 18, 0.5, -8)}, 0.2)
                else
                    Tween(Switch, {BackgroundColor3 = Library.Theme.Border}, 0.2)
                    Tween(Indicator, {Position = UDim2.new(0, 2, 0.5, -8)}, 0.2)
                end
                pcall(Callback, state)
            end

            ToggleFrame.MouseButton1Click:Connect(function()
                UpdateToggle(not Library.Flags[Flag])
            end)

            ToggleFrame.MouseEnter:Connect(function()
                Tween(ToggleFrame, {BackgroundColor3 = Library.Theme.Hover}, 0.1)
                Tween(Stroke, {Color = Library.Theme.Accent}, 0.1)
            end)
            ToggleFrame.MouseLeave:Connect(function()
                Tween(ToggleFrame, {BackgroundColor3 = Library.Theme.ElementPanel}, 0.1)
                Tween(Stroke, {Color = Library.Theme.Border}, 0.1)
            end)

            local ToggleObj = {}
            function ToggleObj:Set(state)
                UpdateToggle(state)
            end
            return ToggleObj
        end

        -- [ Elemento: SLIDER ] --
        function TabElements:CreateSlider(options)
            local Name = options.Name or "Slider"
            local Min = options.Range[1] or 0
            local Max = options.Range[2] or 100
            local Increment = options.Increment or 1
            local Default = options.CurrentValue or Min
            local Suffix = options.Suffix or ""
            local Flag = options.Flag or tostring(math.random())
            local Callback = options.Callback or function() end

            Library.Flags[Flag] = Default

            local SliderFrame = Create("Frame", {
                Parent = TabContent,
                BackgroundColor3 = Library.Theme.ElementPanel,
                Size = UDim2.new(1, -20, 0, 55),
                LayoutOrder = ContentLayout.AbsoluteContentSize.Y
            })
            Create("UICorner", {Parent = SliderFrame, CornerRadius = Library.Theme.CornerRadius})
            local Stroke = Create("UIStroke", {Parent = SliderFrame, Color = Library.Theme.Border, Thickness = 1})

            local TitleLabel = Create("TextLabel", {
                Parent = SliderFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 10),
                Size = UDim2.new(1, -60, 0, 16),
                Font = Library.Theme.Font,
                Text = Name,
                TextColor3 = Library.Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local ValueLabel = Create("TextLabel", {
                Parent = SliderFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -60, 0, 10),
                Size = UDim2.new(0, 50, 0, 16),
                Font = Enum.Font.GothamBold,
                Text = tostring(Default)..Suffix,
                TextColor3 = Library.Theme.Accent,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Right
            })

            local SliderBar = Create("TextButton", {
                Parent = SliderFrame,
                BackgroundColor3 = Library.Theme.Border,
                Position = UDim2.new(0, 10, 0, 35),
                Size = UDim2.new(1, -20, 0, 6),
                Text = "",
                AutoButtonColor = false
            })
            Create("UICorner", {Parent = SliderBar, CornerRadius = UDim.new(1, 0)})

            local SliderFill = Create("Frame", {
                Parent = SliderBar,
                BackgroundColor3 = Library.Theme.Accent,
                Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
            })
            Create("UICorner", {Parent = SliderFill, CornerRadius = UDim.new(1, 0)})

            local Sliding = false

            local function UpdateSlider(input)
                local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                local value = math.floor((pos * (Max - Min) / Increment) + 0.5) * Increment + Min
                value = math.clamp(value, Min, Max)
                
                Tween(SliderFill, {Size = UDim2.new((value - Min) / (Max - Min), 0, 1, 0)}, 0.1)
                ValueLabel.Text = tostring(value)..Suffix
                Library.Flags[Flag] = value
                pcall(Callback, value)
            end

            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Sliding = true
                    UpdateSlider(input)
                end
            end)
            SliderBar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then Sliding = false end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if Sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then UpdateSlider(input) end
            end)

            SliderFrame.MouseEnter:Connect(function()
                Tween(Stroke, {Color = Library.Theme.Accent}, 0.1)
            end)
            SliderFrame.MouseLeave:Connect(function()
                Tween(Stroke, {Color = Library.Theme.Border}, 0.1)
            end)

            local SliderObj = {}
            function SliderObj:Set(val)
                val = math.clamp(val, Min, Max)
                Tween(SliderFill, {Size = UDim2.new((val - Min) / (Max - Min), 0, 1, 0)}, 0.1)
                ValueLabel.Text = tostring(val)..Suffix
                Library.Flags[Flag] = val
                pcall(Callback, val)
            end
            return SliderObj
        end

        -- [ Elemento: DROPDOWN (Novo) ] --
        function TabElements:CreateDropdown(options)
            local Name = options.Name or "Dropdown"
            local Options = options.Options or {"A", "B", "C"}
            local Default = options.CurrentValue or Options[1]
            local Flag = options.Flag or tostring(math.random())
            local Callback = options.Callback or function() end

            Library.Flags[Flag] = Default

            local DFrame = Create("Frame", {
                Parent = TabContent,
                BackgroundColor3 = Library.Theme.ElementPanel,
                Size = UDim2.new(1, -20, 0, 40),
                ClipsDescendants = true,
                LayoutOrder = ContentLayout.AbsoluteContentSize.Y
            })
            Create("UICorner", {Parent = DFrame, CornerRadius = Library.Theme.CornerRadius})
            local Stroke = Create("UIStroke", {Parent = DFrame, Color = Library.Theme.Border, Thickness = 1})

            local DMain = Create("TextButton", {
                Parent = DFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 40),
                AutoButtonColor = false,
                Text = ""
            })

            local TitleLabel = Create("TextLabel", {
                Parent = DMain,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -70, 1, 0),
                Font = Library.Theme.Font,
                Text = Name .. ": " .. Default,
                TextColor3 = Library.Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local Icon = Create("ImageLabel", {
                Parent = DMain,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -30, 0.5, -10),
                Size = UDim2.new(0, 20, 0, 20),
                Image = "rbxassetid://6031091000", -- Ícone de seta (expansão)
                ImageColor3 = Library.Theme.TextMuted,
                Rotation = 0
            })

            local OptionContainer = Create("ScrollingFrame", {
                Parent = DFrame,
                Active = true,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 40),
                Size = UDim2.new(1, 0, 0, 120),
                CanvasSize = UDim2.new(0, 0, 0, 0),
                ScrollBarThickness = 3,
                ScrollBarImageColor3 = Library.Theme.Border
            })
            local DLayout = Create("UIListLayout", {
                Parent = OptionContainer,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 2),
                HorizontalAlignment = Enum.HorizontalAlignment.Center
            })
            DLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                OptionContainer.CanvasSize = UDim2.new(0, 0, 0, DLayout.AbsoluteContentSize.Y)
            end)

            local Opened = false

            local function UpdateDropdown(choice)
                TitleLabel.Text = Name .. ": " .. choice
                Library.Flags[Flag] = choice
                pcall(Callback, choice choice)
            end

            for i, option in ipairs(Options) do
                local OBtn = Create("TextButton", {
                    Parent = OptionContainer,
                    BackgroundColor3 = Library.Theme.ElementPanel,
                    Size = UDim2.new(1, -10, 0, 30),
                    Font = Library.Theme.Font,
                    Text = "  " .. option,
                    TextColor3 = option == Default and Library.Theme.Accent or Library.Theme.Text,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AutoButtonColor = false
                })
                Create("UICorner", {Parent = OBtn, CornerRadius = UDim.new(0, 3)})

                OBtn.MouseEnter:Connect(function()
                    if Library.Flags[Flag] ~= option then
                        Tween(OBtn, {BackgroundColor3 = Library.Theme.Hover}, 0.1)
                    end
                end)
                OBtn.MouseLeave:Connect(function()
                    Tween(OBtn, {BackgroundColor3 = Library.Theme.ElementPanel}, 0.1)
                end)
                OBtn.MouseButton1Click:Connect(function()
                    UpdateDropdown(option)
                    -- Fechar dropdown e atualizar cor dos textos
                    for _, obtn in pairs(OptionContainer:GetChildren()) do
                        if obtn:IsA("TextButton") then
                            Tween(obtn, {TextColor3 = Library.Theme.Text}, 0.1)
                        end
                    end
                    Tween(OBtn, {TextColor3 = Library.Theme.Accent}, 0.1)
                    Tween(DFrame, {Size = UDim2.new(1, -20, 0, 40)}, 0.2)
                    Tween(Icon, {Rotation = 0}, 0.2)
                    Opened = false
                end)
            end

            DMain.MouseButton1Click:Connect(function()
                if Opened then
                    Tween(DFrame, {Size = UDim2.new(1, -20, 0, 40)}, 0.2)
                    Tween(Icon, {Rotation = 0}, 0.2)
                else
                    Tween(DFrame, {Size = UDim2.new(1, -20, 0, DLayout.AbsoluteContentSize.Y + 50)}, 0.2)
                    Tween(Icon, {Rotation = 180}, 0.2)
                end
                Opened = not Opened
            end)

            DFrame.MouseEnter:Connect(function()
                Tween(Stroke, {Color = Library.Theme.Accent}, 0.1)
            end)
            DFrame.MouseLeave:Connect(function()
                Tween(Stroke, {Color = Library.Theme.Border}, 0.1)
            end)

            local DropdownObj = {}
            function DropdownObj:Set(option)
                UpdateDropdown(option)
            end
            return DropdownObj
        end

        -- [ Elemento: TEXTBOX (Novo) ] --
        function TabElements:CreateTextbox(options)
            local Name = options.Name or "Textbox"
            local Default = options.CurrentValue or ""
            local Placeholder = options.Placeholder or "Digite aqui..."
            local Flag = options.Flag or tostring(math.random())
            local Callback = options.Callback or function() end

            Library.Flags[Flag] = Default

            local TFrame = Create("Frame", {
                Parent = TabContent,
                BackgroundColor3 = Library.Theme.ElementPanel,
                Size = UDim2.new(1, -20, 0, 40),
                LayoutOrder = ContentLayout.AbsoluteContentSize.Y
            })
            Create("UICorner", {Parent = TFrame, CornerRadius = Library.Theme.CornerRadius})
            local Stroke = Create("UIStroke", {Parent = TFrame, Color = Library.Theme.Border, Thickness = 1})

            local TitleLabel = Create("TextLabel", {
                Parent = TFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -120, 1, 0),
                Font = Library.Theme.Font,
                Text = Name,
                TextColor3 = Library.Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local TInput = Create("TextBox", {
                Parent = TFrame,
                BackgroundColor3 = Library.Theme.TopBar,
                Position = UDim2.new(1, -110, 0.5, -12),
                Size = UDim2.new(0, 100, 0, 24),
                Font = Library.Theme.Font,
                Text = Default,
                PlaceholderText = Placeholder,
                TextColor3 = Library.Theme.Accent,
                PlaceholderColor3 = Library.Theme.TextMuted,
                TextSize = 12,
                ClipsDescendants = true,
                ClearTextOnFocus = false
            })
            Create("UICorner", {Parent = TInput, CornerRadius = UDim.new(0, 3)})
            Create("UIStroke", {Parent = TInput, Color = Library.Theme.Border, Thickness = 1})

            TInput.FocusLost:Connect(function()
                local text = TInput.Text
                Library.Flags[Flag] = text
                pcall(Callback, text)
            end)

            TFrame.MouseEnter:Connect(function()
                Tween(Stroke, {Color = Library.Theme.Accent}, 0.1)
            end)
            TFrame.MouseLeave:Connect(function()
                Tween(Stroke, {Color = Library.Theme.Border}, 0.1)
            end)

            local TextboxObj = {}
            function TextboxObj:Set(text)
                TInput.Text = text
                Library.Flags[Flag] = text
                pcall(Callback, text)
            end
            return TextboxObj
        end

        -- [ Elemento: KEYBIND (Novo) ] --
        function TabElements:CreateKeybind(options)
            local Name = options.Name or "Keybind"
            local Default = options.CurrentKeybind or Enum.KeyCode.F11
            local Flag = options.Flag or tostring(math.random())
            local Callback = options.Callback or function() end

            Library.Flags[Flag] = Default.Name

            local KFrame = Create("Frame", {
                Parent = TabContent,
                BackgroundColor3 = Library.Theme.ElementPanel,
                Size = UDim2.new(1, -20, 0, 40),
                LayoutOrder = ContentLayout.AbsoluteContentSize.Y
            })
            Create("UICorner", {Parent = KFrame, CornerRadius = Library.Theme.CornerRadius})
            local Stroke = Create("UIStroke", {Parent = KFrame, Color = Library.Theme.Border, Thickness = 1})

            local TitleLabel = Create("TextLabel", {
                Parent = KFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -120, 1, 0),
                Font = Library.Theme.Font,
                Text = Name,
                TextColor3 = Library.Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local KBtn = Create("TextButton", {
                Parent = KFrame,
                BackgroundColor3 = Library.Theme.TopBar,
                Position = UDim2.new(1, -85, 0.5, -12),
                Size = UDim2.new(0, 75, 0, 24),
                Font = Enum.Font.GothamBold,
                Text = Default.Name,
                TextColor3 = Library.Theme.Accent,
                TextSize = 12,
                AutoButtonColor = false
            })
            Create("UICorner", {Parent = KBtn, CornerRadius = UDim.new(0, 3)})
            Create("UIStroke", {Parent = KBtn, Color = Library.Theme.Border, Thickness = 1})

            local Pressing = false

            KBtn.MouseButton1Click:Connect(function()
                KBtn.Text = "..."
                KBtn.TextColor3 = Library.Theme.TextMuted
                Pressing = true
            end)

            UserInputService.InputBegan:Connect(function(input, processed)
                if not processed and Pressing then
                    if input.UserInputType == Enum.UserInputType.Keyboard or input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.MouseButton3 then
                        local keyName = input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode.Name or input.UserInputType.Name
                        KBtn.Text = keyName
                        KBtn.TextColor3 = Library.Theme.Accent
                        Library.Flags[Flag] = keyName
                        pcall(Callback, input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode or input.UserInputType)
                        Pressing = false
                    end
                end
            end)

            KFrame.MouseEnter:Connect(function()
                Tween(Stroke, {Color = Library.Theme.Accent}, 0.1)
            end)
            KFrame.MouseLeave:Connect(function()
                Tween(Stroke, {Color = Library.Theme.Border}, 0.1)
            end)

            local KeybindObj = {}
            function KeybindObj:Set(key)
                KBtn.Text = key.Name
                Library.Flags[Flag] = key.Name
                pcall(Callback, key)
            end
            return KeybindObj
        end

        -- [ Elemento: COLORPICKER (Novo) ] --
        function TabElements:CreateColorPicker(options)
            local Name = options.Name or "Color Picker"
            local Default = options.CurrentValue or Color3.fromRGB(255, 0, 0)
            local Flag = options.Flag or tostring(math.random())
            local Callback = options.Callback or function() end

            Library.Flags[Flag] = Default

            local CFrame = Create("Frame", {
                Parent = TabContent,
                BackgroundColor3 = Library.Theme.ElementPanel,
                Size = UDim2.new(1, -20, 0, 40),
                ClipsDescendants = true,
                LayoutOrder = ContentLayout.AbsoluteContentSize.Y
            })
            Create("UICorner", {Parent = CFrame, CornerRadius = Library.Theme.CornerRadius})
            local Stroke = Create("UIStroke", {Parent = CFrame, Color = Library.Theme.Border, Thickness = 1})

            local TitleLabel = Create("TextLabel", {
                Parent = CFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -50, 0, 40),
                Font = Library.Theme.Font,
                Text = Name,
                TextColor3 = Library.Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local ColorView = Create("TextButton", {
                Parent = CFrame,
                BackgroundColor3 = Default,
                Position = UDim2.new(1, -40, 0, 10),
                Size = UDim2.new(0, 30, 0, 20),
                Text = "",
                AutoButtonColor = false
            })
            Create("UICorner", {Parent = ColorView, CornerRadius = UDim.new(0, 3)})
            Create("UIStroke", {Parent = ColorView, Color = Library.Theme.Border, Thickness = 1})

            local PickerFrame = Create("Frame", {
                Parent = CFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 40),
                Size = UDim2.new(1, -20, 0, 120),
                ClipsDescendants = true
            })
            
            -- Placeholder para os sliders HSV/RGB que você pode adicionar
            Create("TextLabel", {
                Parent = PickerFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Library.Theme.Font,
                Text = "Sliders de Cor (HSV/RGB) aqui...",
                TextColor3 = Library.Theme.TextMuted,
                TextSize = 12
            })

            local Opened = false

            local function UpdateColorPicker(color)
                ColorView.BackgroundColor3 = color
                Library.Flags[Flag] = color
                pcall(Callback, color)
            end

            ColorView.MouseButton1Click:Connect(function()
                if Opened then
                    Tween(CFrame, {Size = UDim2.new(1, -20, 0, 40)}, 0.2)
                else
                    Tween(CFrame, {Size = UDim2.new(1, -20, 0, 160)}, 0.2)
                end
                Opened = not Opened
            end)

            -- Você precisará implementar a lógica real para carregar os sliders HSV e atualizar a cor.
            -- Esta base fornece a estrutura e o callback.

            CFrame.MouseEnter:Connect(function()
                Tween(Stroke, {Color = Library.Theme.Accent}, 0.1)
            end)
            CFrame.MouseLeave:Connect(function()
                Tween(Stroke, {Color = Library.Theme.Border}, 0.1)
            end)

            local ColorPickerObj = {}
            function ColorPickerObj:Set(color)
                UpdateColorPicker(color)
            end
            return ColorPickerObj
        end

        return TabElements
    end

    -- [ Loader / Inicialização ] --
    function Window:Init()
        ScreenGui.Enabled = true
        -- Animação de entrada suave
        MainFrame.Position = UDim2.new(0.5, -400, 0.5, -200)
        MainFrame.BackgroundTransparency = 1
        Shadow.ImageTransparency = 1
        MainStroke.Transparency = 1
        TopBar.BackgroundTransparency = 1
        Sidebar.BackgroundTransparency = 1

        for _, child in ipairs(MainFrame:GetDescendants()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then child.TextTransparency = 1 end
            if child:IsA("Frame") and child.Name ~= "MainFrame" and child.Name ~= "Shadow" then child.BackgroundTransparency = 1 end
        end

        Tween(MainFrame, {Position = UDim2.new(0.5, -400, 0.5, -275), BackgroundTransparency = Library.Theme.TransparentBackground}, 0.5, Enum.EasingStyle.Quint)
        Tween(Shadow, {ImageTransparency = 0.4}, 0.5)
        Tween(MainStroke, {Transparency = 0}, 0.5)
        Tween(TopBar, {BackgroundTransparency = Library.Theme.TransparentBackground}, 0.5)
        Tween(Sidebar, {BackgroundTransparency = Library.Theme.TransparentBackground}, 0.5)

        task.delay(0.3, function()
            for _, child in ipairs(MainFrame:GetDescendants()) do
                if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then 
                    Tween(child, {TextTransparency = 0}, 0.3)
                elseif child:IsA("Frame") and child.Name ~= "Indicator" and child.Name ~= "Line" then 
                    -- Recupera transparência baseada no tema
                    Tween(child, {BackgroundTransparency = 0}, 0.3)
                elseif child:IsA("Frame") and child.Name == "Line" then
                     Tween(child, {BackgroundTransparency = 0}, 0.3)
                end
            end
            -- Seleciona a primeira aba automaticamente
            local firstTab = MainFrame.ContentContainer:FindFirstChild("_Content")
            if firstTab then firstTab.Visible = true end
        end)
    end

    return Window
end

return Library
