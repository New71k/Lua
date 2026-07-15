local Library = {}
Library.__index = Library

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local TextService = game:GetService("TextService")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled

Library.Flags = {}
Library.Windows = {}
Library.Connections = {}
Library.Panels = {}
Library.CurrentTheme = "Dark"
Library.Loaded = false
Library.Unloaded = false
Library.Notifications = {}
Library.FolderName = "EnigmaConfig"
Library.Executed = false

local ThemeDefaults = {
    Dark = { Accent = Color3.fromRGB(50, 130, 246), AccentDark = Color3.fromRGB(35, 100, 200), Background = Color3.fromRGB(18, 18, 22), BackgroundSecondary = Color3.fromRGB(24, 24, 29), Sidebar = Color3.fromRGB(15, 15, 19), TopBar = Color3.fromRGB(13, 13, 17), Section = Color3.fromRGB(22, 22, 27), SectionBorder = Color3.fromRGB(34, 34, 40), Element = Color3.fromRGB(28, 28, 34), ElementHover = Color3.fromRGB(34, 34, 41), ElementBorder = Color3.fromRGB(40, 40, 47), Text = Color3.fromRGB(235, 235, 240), TextDark = Color3.fromRGB(150, 150, 160), TextDisabled = Color3.fromRGB(90, 90, 100), Divider = Color3.fromRGB(36, 36, 42), Success = Color3.fromRGB(60, 200, 120), Warning = Color3.fromRGB(240, 180, 60), Error = Color3.fromRGB(230, 70, 70), Font = Enum.Font.GothamMedium, FontBold = Enum.Font.GothamBold },
    Light = { Accent = Color3.fromRGB(45, 110, 230), AccentDark = Color3.fromRGB(30, 85, 190), Background = Color3.fromRGB(245, 245, 248), BackgroundSecondary = Color3.fromRGB(255, 255, 255), Sidebar = Color3.fromRGB(238, 238, 242), TopBar = Color3.fromRGB(250, 250, 252), Section = Color3.fromRGB(255, 255, 255), SectionBorder = Color3.fromRGB(225, 225, 230), Element = Color3.fromRGB(240, 240, 244), ElementHover = Color3.fromRGB(230, 230, 236), ElementBorder = Color3.fromRGB(220, 220, 226), Text = Color3.fromRGB(25, 25, 30), TextDark = Color3.fromRGB(110, 110, 120), TextDisabled = Color3.fromRGB(180, 180, 186), Divider = Color3.fromRGB(225, 225, 230), Success = Color3.fromRGB(40, 170, 100), Warning = Color3.fromRGB(210, 150, 40), Error = Color3.fromRGB(210, 60, 60), Font = Enum.Font.GothamMedium, FontBold = Enum.Font.GothamBold },
    Midnight = { Accent = Color3.fromRGB(90, 110, 255), AccentDark = Color3.fromRGB(65, 85, 220), Background = Color3.fromRGB(10, 10, 16), BackgroundSecondary = Color3.fromRGB(14, 14, 20), Sidebar = Color3.fromRGB(8, 8, 13), TopBar = Color3.fromRGB(7, 7, 11), Section = Color3.fromRGB(13, 13, 19), SectionBorder = Color3.fromRGB(24, 24, 32), Element = Color3.fromRGB(18, 18, 25), ElementHover = Color3.fromRGB(23, 23, 31), ElementBorder = Color3.fromRGB(28, 28, 36), Text = Color3.fromRGB(230, 230, 240), TextDark = Color3.fromRGB(130, 130, 150), TextDisabled = Color3.fromRGB(80, 80, 95), Divider = Color3.fromRGB(26, 26, 34), Success = Color3.fromRGB(60, 200, 120), Warning = Color3.fromRGB(240, 180, 60), Error = Color3.fromRGB(230, 70, 70), Font = Enum.Font.GothamMedium, FontBold = Enum.Font.GothamBold },
    Crimson = { Accent = Color3.fromRGB(220, 55, 70), AccentDark = Color3.fromRGB(180, 40, 55), Background = Color3.fromRGB(20, 15, 16), BackgroundSecondary = Color3.fromRGB(26, 19, 20), Sidebar = Color3.fromRGB(16, 12, 13), TopBar = Color3.fromRGB(14, 10, 11), Section = Color3.fromRGB(24, 17, 18), SectionBorder = Color3.fromRGB(38, 26, 28), Element = Color3.fromRGB(30, 21, 22), ElementHover = Color3.fromRGB(37, 26, 27), ElementBorder = Color3.fromRGB(44, 30, 32), Text = Color3.fromRGB(235, 230, 230), TextDark = Color3.fromRGB(160, 140, 140), TextDisabled = Color3.fromRGB(95, 80, 80), Divider = Color3.fromRGB(40, 27, 28), Success = Color3.fromRGB(60, 200, 120), Warning = Color3.fromRGB(240, 180, 60), Error = Color3.fromRGB(240, 90, 90), Font = Enum.Font.GothamMedium, FontBold = Enum.Font.GothamBold },
    Emerald = { Accent = Color3.fromRGB(45, 200, 130), AccentDark = Color3.fromRGB(30, 165, 105), Background = Color3.fromRGB(14, 18, 16), BackgroundSecondary = Color3.fromRGB(18, 24, 21), Sidebar = Color3.fromRGB(12, 15, 13), TopBar = Color3.fromRGB(10, 13, 12), Section = Color3.fromRGB(17, 22, 19), SectionBorder = Color3.fromRGB(28, 36, 31), Element = Color3.fromRGB(22, 28, 24), ElementHover = Color3.fromRGB(27, 34, 29), ElementBorder = Color3.fromRGB(32, 40, 34), Text = Color3.fromRGB(230, 238, 232), TextDark = Color3.fromRGB(140, 160, 148), TextDisabled = Color3.fromRGB(85, 100, 90), Divider = Color3.fromRGB(30, 38, 32), Success = Color3.fromRGB(60, 200, 120), Warning = Color3.fromRGB(240, 180, 60), Error = Color3.fromRGB(230, 70, 70), Font = Enum.Font.GothamMedium, FontBold = Enum.Font.GothamBold }
}

for name, data in pairs(ThemeDefaults) do Library.Themes[name] = data end

function Library:GetTheme() return Library.Themes[Library.CurrentTheme] end
function Library:SetTheme(name) if not Library.Themes[name] then return end Library.CurrentTheme = name Library:RefreshTheme() end
function Library:CreateTheme(name, data) local base = table.clone(Library.Themes.Dark) for k, v in pairs(data) do base[k] = v end Library.Themes[name] = base end

Library.ThemeInstances = {}
function Library:RefreshTheme() local theme = Library:GetTheme() for _, entry in ipairs(Library.ThemeInstances) do local inst, prop = entry[1], entry[2] if inst and inst.Parent and inst[prop] ~= nil then pcall(function() inst[prop] = theme[entry[3]] end) end end end
function Library:Tag(inst, prop, themeKey) table.insert(Library.ThemeInstances, {inst, prop, themeKey}) end

local Utility = {} Library.Utility = Utility
function Utility:Create(class, props, children) local inst = Instance.new(class) for prop, value in pairs(props or {}) do inst[prop] = value end for _, child in ipairs(children or {}) do child.Parent = inst end return inst end
function Utility:Tween(inst, props, duration, style, direction) duration = duration or 0.25 style = style or Enum.EasingStyle.Quint direction = direction or Enum.EasingDirection.Out local tween = TweenService:Create(inst, TweenInfo.new(duration, style, direction), props) tween:Play() return tween end
function Utility:Round(inst, radius) return Utility:Create("UICorner", {CornerRadius = UDim.new(0, radius or 6), Parent = inst}) end
function Utility:Stroke(inst, color, thickness, transparency) return Utility:Create("UIStroke", {Color = color or Color3.fromRGB(40,40,47), Thickness = thickness or 1, Transparency = transparency or 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = inst}) end
function Utility:Padding(inst, all, top, bottom, left, right) return Utility:Create("UIPadding", {PaddingTop = UDim.new(0, top or all or 0), PaddingBottom = UDim.new(0, bottom or all or 0), PaddingLeft = UDim.new(0, left or all or 0), PaddingRight = UDim.new(0, right or all or 0), Parent = inst}) end
function Utility:ListLayout(inst, direction, padding, alignment) return Utility:Create("UIListLayout", {FillDirection = direction or Enum.FillDirection.Vertical, Padding = UDim.new(0, padding or 6), HorizontalAlignment = alignment or Enum.HorizontalAlignment.Left, SortOrder = Enum.SortOrder.LayoutOrder, Parent = inst}) end
function Utility:Gradient(inst, colorSeq, rotation, transparencySeq) return Utility:Create("UIGradient", {Color = colorSeq, Rotation = rotation or 0, Transparency = transparencySeq or NumberSequence.new(0), Parent = inst}) end
function Utility:Ripple(button, color) button.MouseButton1Down:Connect(function() local ripple = Utility:Create("Frame", {Name = "Ripple", BackgroundColor3 = color or Color3.fromRGB(255,255,255), BackgroundTransparency = 0.75, BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(0, 0), Parent = button, ZIndex = button.ZIndex + 1}) Utility:Round(ripple, 100) Utility:Tween(ripple, {Size = UDim2.fromScale(2, 2), BackgroundTransparency = 1}, 0.5) task.delay(0.5, function() ripple:Destroy() end) end) end
function Utility:MakeDraggable(frame, dragHandle) dragHandle = dragHandle or frame local dragging = false local dragStart, startPos local function update(input) local delta = input.Position - dragStart local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) Utility:Tween(frame, {Position = newPos}, 0.08, Enum.EasingStyle.Sine) end dragHandle.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true dragStart = input.Position startPos = frame.Position input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end) dragHandle.InputChanged:Connect(function(input) if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then update(input) end end) end
function Utility:TextBounds(text, font, size) return TextService:GetTextSize(text, size, font, Vector2.new(1000, 1000)) end

local IconManager = {} Library.IconManager = IconManager
IconManager.Icons = setmetatable({}, {__index = function() return "rbxassetid://3926305904" end})
function IconManager:Get(name) return IconManager.Icons[name] end
function IconManager:Register(name, id) IconManager.Icons[name] = id end

local ICONS_V1 = { ["aperture"] = "rbxassetid://7733666258", ["bug"] = "rbxassetid://7733701545", ["chevrons-down-up"] = "rbxassetid://7733720483", ["clock-6"] = "rbxassetid://8997384977", ["egg"] = "rbxassetid://8997385940", ["external-link"] = "rbxassetid://7743866903", ["lightbulb-off"] = "rbxassetid://7733975123", ["file-check-2"] = "rbxassetid://7733779610", ["settings"] = "rbxassetid://7734053495", ["crown"] = "rbxassetid://7733765398", ["coins"] = "rbxassetid://7743866529", ["battery"] = "rbxassetid://7733674820", ["flashlight-off"] = "rbxassetid://7733798799", ["camera-off"] = "rbxassetid://7733919260", ["function-square"] = "rbxassetid://7733799682", ["mountain-snow"] = "rbxassetid://7743870286", ["gamepad"] = "rbxassetid://7733799901", ["gift"] = "rbxassetid://7733946818", ["globe"] = "rbxassetid://7733954760", ["option"] = "rbxassetid://7734021300", ["hand"] = "rbxassetid://7733955740", ["hard-hat"] = "rbxassetid://7733955850", ["hash"] = "rbxassetid://7733955906", ["server"] = "rbxassetid://7734053426", ["align-horizontal-space-around"] = "rbxassetid://8997381738", ["highlighter"] = "rbxassetid://7743868648", ["bike"] = "rbxassetid://7733678330", ["home"] = "rbxassetid://7733960981", ["image"] = "rbxassetid://7733964126", ["indent"] = "rbxassetid://7733964452", ["infinity"] = "rbxassetid://7733964640", ["inspect"] = "rbxassetid://7733964808", ["alert-triangle"] = "rbxassetid://7733658504", ["align-start-horizontal"] = "rbxassetid://8997381965", ["figma"] = "rbxassetid://7743867310", ["pin"] = "rbxassetid://8997386648", ["corner-up-right"] = "rbxassetid://7733764915", ["list-x"] = "rbxassetid://7743869517", ["monitor-off"] = "rbxassetid://7734000184", ["chevron-first"] = "rbxassetid://8997383275", ["package-search"] = "rbxassetid://8997386448", ["pencil"] = "rbxassetid://7734022107", ["cloud-fog"] = "rbxassetid://7733920317", ["grip-horizontal"] = "rbxassetid://7733955302", ["align-center-vertical"] = "rbxassetid://8997380737", ["outdent"] = "rbxassetid://7734021384", ["more-vertical"] = "rbxassetid://7734006187", ["package-plus"] = "rbxassetid://8997386355", ["bluetooth"] = "rbxassetid://7733687147", ["pen-tool"] = "rbxassetid://7734022041", ["person-standing"] = "rbxassetid://7743871002", ["tornado"] = "rbxassetid://7743873633", ["phone-incoming"] = "rbxassetid://7743871120", ["phone-off"] = "rbxassetid://7734029534", ["dribbble"] = "rbxassetid://7733770843", ["at-sign"] = "rbxassetid://7733673907", ["edit-2"] = "rbxassetid://7733771217", ["sheet"] = "rbxassetid://7743871876", ["tv"] = "rbxassetid://7743874674", ["headphones"] = "rbxassetid://7733956063", ["qr-code"] = "rbxassetid://7743871575", ["reply"] = "rbxassetid://7734051594", ["rewind"] = "rbxassetid://7734051670", ["bell-off"] = "rbxassetid://7733675107", ["file-check"] = "rbxassetid://7733779668", ["quote"] = "rbxassetid://7734045100", ["rotate-ccw"] = "rbxassetid://7734051861", ["library"] = "rbxassetid://7743869054", ["clock-1"] = "rbxassetid://8997383694", ["on-charge"] = "rbxassetid://7734021231", ["video-off"] = "rbxassetid://7743876466", ["save"] = "rbxassetid://7734052335", ["arrow-left-circle"] = "rbxassetid://7733673056", ["screen-share"] = "rbxassetid://7734052814", ["clock-3"] = "rbxassetid://8997384456", ["help-circle"] = "rbxassetid://7733956210", ["server-crash"] = "rbxassetid://7734053281", ["bluetooth-searching"] = "rbxassetid://7733914320", ["equal"] = "rbxassetid://7733771811", ["shield-close"] = "rbxassetid://7734056470", ["phone"] = "rbxassetid://7734032056", ["type"] = "rbxassetid://7743874740", ["file-x-2"] = "rbxassetid://7743867554", ["sidebar"] = "rbxassetid://7734058260", ["sigma"] = "rbxassetid://7734058345", ["smartphone-charging"] = "rbxassetid://7734058894", ["arrow-left"] = "rbxassetid://7733673136", ["framer"] = "rbxassetid://7733799486", ["currency"] = "rbxassetid://7733765592", ["star"] = "rbxassetid://7734068321", ["stretch-horizontal"] = "rbxassetid://8997387754", ["smile"] = "rbxassetid://7734059095", ["subscript"] = "rbxassetid://8997387937", ["sun"] = "rbxassetid://7734068495", ["switch-camera"] = "rbxassetid://7743872492", ["table"] = "rbxassetid://7734073253", ["tag"] = "rbxassetid://7734075797", ["cross"] = "rbxassetid://7733765224", ["gem"] = "rbxassetid://7733942651", ["link"] = "rbxassetid://7733978098", ["terminal"] = "rbxassetid://7743872929", ["thermometer-sun"] = "rbxassetid://7734084018", ["share-2"] = "rbxassetid://7734053595", ["timer-off"] = "rbxassetid://8997388325", ["megaphone"] = "rbxassetid://7733993049", ["timer-reset"] = "rbxassetid://7743873336", ["phone-forwarded"] = "rbxassetid://7734027345", ["unlock"] = "rbxassetid://7743875263", ["trello"] = "rbxassetid://7743873996", ["camera"] = "rbxassetid://7733708692", ["triangle"] = "rbxassetid://7743874367", ["truck"] = "rbxassetid://7743874482", ["file-output"] = "rbxassetid://7733788742", ["gamepad-2"] = "rbxassetid://7733799795", ["network"] = "rbxassetid://7734021047", ["users"] = "rbxassetid://7743876054", ["electricity-off"] = "rbxassetid://7733771563", ["book"] = "rbxassetid://7733914390", ["clock-9"] = "rbxassetid://8997385485", ["corner-down-left"] = "rbxassetid://7733764327", ["locate-fixed"] = "rbxassetid://7733992424", ["bar-chart"] = "rbxassetid://7733674319", ["shield-check"] = "rbxassetid://7734056411", ["signal-low"] = "rbxassetid://8997387189", ["reply-all"] = "rbxassetid://7734051524", ["zoom-in"] = "rbxassetid://7743878977", ["grip-vertical"] = "rbxassetid://7733955410", ["ticket"] = "rbxassetid://7734086558", ["smartphone"] = "rbxassetid://7734058979", ["arrow-big-right"] = "rbxassetid://7733671493", ["tv-2"] = "rbxassetid://7743874599", ["flashlight"] = "rbxassetid://7733798851", ["database"] = "rbxassetid://7743866778", ["plus-square"] = "rbxassetid://7734040369", ["align-justify"] = "rbxassetid://7733661326", ["clipboard-list"] = "rbxassetid://7733920117", ["github"] = "rbxassetid://7733954058", ["columns"] = "rbxassetid://7733757178", ["arrow-big-down"] = "rbxassetid://7733668653", ["cloud-off"] = "rbxassetid://7733745572", ["target"] = "rbxassetid://7743872758", ["skip-back"] = "rbxassetid://7734058404", ["x-circle"] = "rbxassetid://7743878496", ["clock-10"] = "rbxassetid://8997383876", ["align-right"] = "rbxassetid://7733663582", ["clock-5"] = "rbxassetid://8997384798", ["bell-plus"] = "rbxassetid://7733675181", ["battery-medium"] = "rbxassetid://7733674731", ["arrow-down"] = "rbxassetid://7733672933", ["inbox"] = "rbxassetid://7733964370", ["cast"] = "rbxassetid://7733919326", ["gift-card"] = "rbxassetid://7733945018", ["webcam"] = "rbxassetid://7743877896", ["folder-minus"] = "rbxassetid://7733799022", ["scan-line"] = "rbxassetid://8997386772", ["shovel"] = "rbxassetid://7734056878", ["download-cloud"] = "rbxassetid://7733770689", ["list-checks"] = "rbxassetid://7743869317", ["file-text"] = "rbxassetid://7733789088", ["codesandbox"] = "rbxassetid://7733752575", ["laptop-2"] = "rbxassetid://7733965313", ["podcast"] = "rbxassetid://7734042234", ["log-out"] = "rbxassetid://7733992677", ["thumbs-up"] = "rbxassetid://7743873212", ["timer"] = "rbxassetid://7743873443", ["text-cursor"] = "rbxassetid://8997388195", ["file-search"] = "rbxassetid://7733788966", ["thermometer"] = "rbxassetid://7734084149", ["bluetooth-off"] = "rbxassetid://7733914252", ["refresh-cw"] = "rbxassetid://7734051052", ["clipboard-check"] = "rbxassetid://7733919947", ["languages"] = "rbxassetid://7733965249", ["asterisk"] = "rbxassetid://7733673800", ["superscript"] = "rbxassetid://8997388036", ["user-check"] = "rbxassetid://7743875503", ["move-diagonal"] = "rbxassetid://7743870505", ["copy"] = "rbxassetid://7733764083", ["bot"] = "rbxassetid://7733916988", ["alarm-minus"] = "rbxassetid://7733656164", ["log-in"] = "rbxassetid://7733992604", ["maximize"] = "rbxassetid://7733992982", ["align-horizontal-space-between"] = "rbxassetid://8997381854", ["brush"] = "rbxassetid://7733701455", ["equal-not"] = "rbxassetid://7733771726", ["upload"] = "rbxassetid://7743875428", ["minus-circle"] = "rbxassetid://7733998053", ["graduation-cap"] = "rbxassetid://7733955058", ["edit-3"] = "rbxassetid://7733771361", ["check"] = "rbxassetid://7733715400", ["scissors"] = "rbxassetid://7734052570", ["info"] = "rbxassetid://7733964719", ["book-open"] = "rbxassetid://7733687281", ["divide-circle"] = "rbxassetid://7733769152", ["file"] = "rbxassetid://7733793319", ["clock-2"] = "rbxassetid://8997384295", ["corner-right-up"] = "rbxassetid://7733764680", ["clover"] = "rbxassetid://7733747233", ["expand"] = "rbxassetid://7733771982", ["gauge"] = "rbxassetid://7733799969", ["phone-outgoing"] = "rbxassetid://7743871253", ["shield-alert"] = "rbxassetid://7734056326", ["paperclip"] = "rbxassetid://7734021680", ["arrow-big-left"] = "rbxassetid://7733911731", ["album"] = "rbxassetid://7733658133", ["bookmark"] = "rbxassetid://7733692043", ["check-circle-2"] = "rbxassetid://7733710700", ["list-ordered"] = "rbxassetid://7743869411", ["delete"] = "rbxassetid://7733768142", ["axe"] = "rbxassetid://7733674079", ["radio"] = "rbxassetid://7743871662", ["octagon"] = "rbxassetid://7734021165", ["git-commit"] = "rbxassetid://7743868360", ["shirt"] = "rbxassetid://7734056672", ["corner-right-down"] = "rbxassetid://7733764605", ["trending-down"] = "rbxassetid://7743874143", ["airplay"] = "rbxassetid://7733655834", ["repeat"] = "rbxassetid://7734051454", ["layers"] = "rbxassetid://7743868936", ["chevron-right"] = "rbxassetid://7733717755", ["chevrons-right"] = "rbxassetid://7733919682", ["folder-plus"] = "rbxassetid://7733799092", ["alarm-check"] = "rbxassetid://7733655912", ["arrow-up-right"] = "rbxassetid://7733673646", ["user-plus"] = "rbxassetid://7743875759", ["file-minus"] = "rbxassetid://7733936115", ["cloud-drizzle"] = "rbxassetid://7733920226", ["stretch-vertical"] = "rbxassetid://8997387862", ["unlink"] = "rbxassetid://7743875149", ["wand"] = "rbxassetid://8997388430", ["regex"] = "rbxassetid://7734051188", ["command"] = "rbxassetid://7733924046", ["haze"] = "rbxassetid://7733955969", ["trash"] = "rbxassetid://7743873871", ["battery-full"] = "rbxassetid://7733674503", ["flag-triangle-left"] = "rbxassetid://7733798509", ["server-off"] = "rbxassetid://7734053361", ["loader-2"] = "rbxassetid://7733989869", ["monitor-speaker"] = "rbxassetid://7743869988", ["shuffle"] = "rbxassetid://7734057059", ["tablet"] = "rbxassetid://7743872620", ["cloud-moon"] = "rbxassetid://7733920519", ["clipboard-x"] = "rbxassetid://7733734668", ["pocket"] = "rbxassetid://7734042139", ["watch"] = "rbxassetid://7743877668", ["file-plus"] = "rbxassetid://7733788885", ["locate"] = "rbxassetid://7733992469", ["share"] = "rbxassetid://7734053697", ["thermometer-snowflake"] = "rbxassetid://7743873074", ["volume-1"] = "rbxassetid://7743877081", ["coffee"] = "rbxassetid://7733752630", ["cloud-hail"] = "rbxassetid://7733920444", ["alarm-clock-off"] = "rbxassetid://7733656003", ["pound-sterling"] = "rbxassetid://7734042354", ["tent"] = "rbxassetid://7734078943", ["toggle-left"] = "rbxassetid://7734091286", ["dollar-sign"] = "rbxassetid://7733770599", ["sunrise"] = "rbxassetid://7743872365", ["sunset"] = "rbxassetid://7734070982", ["code"] = "rbxassetid://7733749837", ["thumbs-down"] = "rbxassetid://7734084236", ["trending-up"] = "rbxassetid://7743874262", ["clock-12"] = "rbxassetid://8997384150", ["rocking-chair"] = "rbxassetid://7734051769", ["check-square"] = "rbxassetid://7733919526", ["cpu"] = "rbxassetid://7733765045", ["palette"] = "rbxassetid://7734021595", ["minimize-2"] = "rbxassetid://7733997870", ["cloud-sun"] = "rbxassetid://7733746880", ["copyleft"] = "rbxassetid://7733764196", ["archive"] = "rbxassetid://7733911621", ["building"] = "rbxassetid://7733701625", ["image-minus"] = "rbxassetid://7733963797", ["italic"] = "rbxassetid://7733964917", ["link-2-off"] = "rbxassetid://7733975283", ["sort-asc"] = "rbxassetid://7734060715", ["underline"] = "rbxassetid://7743874904", ["gitlab"] = "rbxassetid://7733954246", ["file-minus-2"] = "rbxassetid://7733936010", ["play-circle"] = "rbxassetid://7734037784", ["clock-8"] = "rbxassetid://8997385352", ["file-input"] = "rbxassetid://7733935917", ["beaker"] = "rbxassetid://7733674922", ["shopping-bag"] = "rbxassetid://7734056747", ["navigation"] = "rbxassetid://7734020989", ["moon"] = "rbxassetid://7743870134", ["glasses"] = "rbxassetid://7733954403", ["clipboard-copy"] = "rbxassetid://7733920037", ["feather"] = "rbxassetid://7733777166", ["skip-forward"] = "rbxassetid://7734058495", ["wind"] = "rbxassetid://7743878264", ["frown"] = "rbxassetid://7733799591", ["move-vertical"] = "rbxassetid://7743870608", ["umbrella"] = "rbxassetid://7743874820", ["package"] = "rbxassetid://7734021469", ["chevrons-up"] = "rbxassetid://7733723433", ["download"] = "rbxassetid://7733770755", ["eye"] = "rbxassetid://7733774602", ["files"] = "rbxassetid://7743867811", ["arrow-down-right"] = "rbxassetid://7733672831", ["code-2"] = "rbxassetid://7733920644", ["file-digit"] = "rbxassetid://7733935829", ["x-square"] = "rbxassetid://7743878737", ["clipboard"] = "rbxassetid://7733734762", ["maximize-2"] = "rbxassetid://7733992901", ["send"] = "rbxassetid://7734053039", ["alarm-clock"] = "rbxassetid://7733656100", ["sliders"] = "rbxassetid://7734058803", ["refresh-ccw"] = "rbxassetid://7734050715", ["music"] = "rbxassetid://7734020554", ["banknote"] = "rbxassetid://7733674153", ["hard-drive"] = "rbxassetid://7733955793", ["search"] = "rbxassetid://7734052925", ["layout-list"] = "rbxassetid://7733970442", ["edit"] = "rbxassetid://7733771472", ["contrast"] = "rbxassetid://7733764005", ["wifi"] = "rbxassetid://7743878148", ["ghost"] = "rbxassetid://7743868000", ["laptop"] = "rbxassetid://7733965386", ["clock-4"] = "rbxassetid://8997384603", ["layout-dashboard"] = "rbxassetid://7733970318", ["circle"] = "rbxassetid://7733919881", ["file-x"] = "rbxassetid://7733938136", ["award"] = "rbxassetid://7733673987", ["corner-left-down"] = "rbxassetid://7733764448", ["arrow-up-left"] = "rbxassetid://7733673539", ["globe-2"] = "rbxassetid://7733954611", ["compass"] = "rbxassetid://7733924216", ["git-branch"] = "rbxassetid://7733949149", ["vibrate"] = "rbxassetid://7743876302", ["pause-circle"] = "rbxassetid://7734021767", ["minus-square"] = "rbxassetid://7743869899", ["mic-off"] = "rbxassetid://7743869714", ["arrow-down-circle"] = "rbxassetid://7733671763", ["move-horizontal"] = "rbxassetid://7734016210", ["chrome"] = "rbxassetid://7733919783", ["radio-receiver"] = "rbxassetid://7734045155", ["shield"] = "rbxassetid://7734056608", ["image-plus"] = "rbxassetid://7733964016", ["more-horizontal"] = "rbxassetid://7734006080", ["divide"] = "rbxassetid://7733769365", ["view"] = "rbxassetid://7743876754", ["list"] = "rbxassetid://7743869612", ["printer"] = "rbxassetid://7734042580", ["corner-left-up"] = "rbxassetid://7733764536", ["meh"] = "rbxassetid://7733993147", ["copyright"] = "rbxassetid://7733764275", ["heart"] = "rbxassetid://7733956134", ["lock"] = "rbxassetid://7733992528", ["align-center"] = "rbxassetid://7733909776", ["signal-high"] = "rbxassetid://8997387110", ["upload-cloud"] = "rbxassetid://7743875358", ["arrow-up-circle"] = "rbxassetid://7733673466", ["git-branch-plus"] = "rbxassetid://7743868200", ["screen-share-off"] = "rbxassetid://7734052653", ["git-pull-request"] = "rbxassetid://7733952287", ["flag"] = "rbxassetid://7733798691", ["star-half"] = "rbxassetid://7734068258", ["minus"] = "rbxassetid://7734000129", ["mountain"] = "rbxassetid://7734008868", ["volume"] = "rbxassetid://7743877487", ["mouse-pointer-2"] = "rbxassetid://7734010405", ["indian-rupee"] = "rbxassetid://7733964536", ["speaker"] = "rbxassetid://7734063416", ["flame"] = "rbxassetid://7733798747", ["crop"] = "rbxassetid://7733765140", ["clock-11"] = "rbxassetid://8997384034", ["stop-circle"] = "rbxassetid://7734068379", ["power-off"] = "rbxassetid://7734042423", ["bell-minus"] = "rbxassetid://7733675028", ["undo"] = "rbxassetid://7743874974", ["link-2"] = "rbxassetid://7743869163", ["lightbulb"] = "rbxassetid://7733975185", ["shrink"] = "rbxassetid://7734056971", ["mail"] = "rbxassetid://7733992732", ["pause"] = "rbxassetid://7734021897", ["bold"] = "rbxassetid://7733687211", ["calendar"] = "rbxassetid://7733919198", ["x-octagon"] = "rbxassetid://7743878618", ["file-code"] = "rbxassetid://7733779730", ["life-buoy"] = "rbxassetid://7733973479", ["import"] = "rbxassetid://7733964240", ["video"] = "rbxassetid://7743876610", ["clock-7"] = "rbxassetid://8997385147", ["bell"] = "rbxassetid://7733911828", ["move-diagonal-2"] = "rbxassetid://7734013178", ["message-circle"] = "rbxassetid://7733993311", ["skull"] = "rbxassetid://7734058599", ["battery-charging"] = "rbxassetid://7733674402", ["ruler"] = "rbxassetid://7734052157", ["binary"] = "rbxassetid://7733678388", ["cloud-rain-wind"] = "rbxassetid://7733746456", ["briefcase"] = "rbxassetid://7733919017", ["terminal-square"] = "rbxassetid://7734079055", ["scale"] = "rbxassetid://7734052454", ["lasso"] = "rbxassetid://7733967892", ["piggy-bank"] = "rbxassetid://7734034513", ["battery-low"] = "rbxassetid://7733674589", ["arrow-up"] = "rbxassetid://7733673717", ["list-plus"] = "rbxassetid://7733984995", ["bookmark-plus"] = "rbxassetid://7734111084", ["box-select"] = "rbxassetid://7733696665", ["filter"] = "rbxassetid://7733798407", ["play"] = "rbxassetid://7743871480", ["calculator"] = "rbxassetid://7733919105", ["bell-ring"] = "rbxassetid://7733675275", ["plane"] = "rbxassetid://7734037723", ["plus-circle"] = "rbxassetid://7734040271", ["power"] = "rbxassetid://7734042493", ["phone-missed"] = "rbxassetid://7734029465", ["percent"] = "rbxassetid://7743870852", ["mouse-pointer"] = "rbxassetid://7743870392", ["box"] = "rbxassetid://7733917120", ["snowflake"] = "rbxassetid://7734059180", ["sort-desc"] = "rbxassetid://7743871973", ["flag-triangle-right"] = "rbxassetid://7733798634", ["bar-chart-2"] = "rbxassetid://7733674239", ["hand-metal"] = "rbxassetid://7733955664", ["map"] = "rbxassetid://7733992829", ["eye-off"] = "rbxassetid://7733774495", ["cloud-rain"] = "rbxassetid://7733746651", ["contact"] = "rbxassetid://7743866666", ["signal"] = "rbxassetid://8997387546", ["mouse-pointer-click"] = "rbxassetid://7734010488", ["sidebar-open"] = "rbxassetid://7734058165", ["pause-octagon"] = "rbxassetid://7734021827", ["user-minus"] = "rbxassetid://7743875629", ["cloud"] = "rbxassetid://7733746980", ["arrow-right-circle"] = "rbxassetid://7733673229", ["fast-forward"] = "rbxassetid://7743867090", ["volume-2"] = "rbxassetid://7743877250", ["grab"] = "rbxassetid://7733954884", ["arrow-right"] = "rbxassetid://7733673345", ["chevron-down"] = "rbxassetid://7733717447", ["volume-x"] = "rbxassetid://7743877381", ["cloud-snow"] = "rbxassetid://7733746798", ["car"] = "rbxassetid://7733708835", ["message-square"] = "rbxassetid://7733993369", ["repeat-1"] = "rbxassetid://7734051342", ["codepen"] = "rbxassetid://7733920768", ["voicemail"] = "rbxassetid://7743876916", ["shopping-cart"] = "rbxassetid://7734056813", ["corner-down-right"] = "rbxassetid://7733764385", ["layout-grid"] = "rbxassetid://7733970390", ["clock"] = "rbxassetid://7733734848", ["corner-up-left"] = "rbxassetid://7733764800", ["git-merge"] = "rbxassetid://7733952195", ["verified"] = "rbxassetid://7743876142", ["redo"] = "rbxassetid://7743871739", ["hexagon"] = "rbxassetid://7743868527", ["square"] = "rbxassetid://7743872181", ["chevrons-up-down"] = "rbxassetid://7733723321", ["bus"] = "rbxassetid://7733701715", ["file-plus-2"] = "rbxassetid://7733788816", ["alarm-plus"] = "rbxassetid://7733658066", ["divide-square"] = "rbxassetid://7733769261", ["pie-chart"] = "rbxassetid://7734034378", ["hammer"] = "rbxassetid://7733955511", ["history"] = "rbxassetid://7733960880", ["flask-round"] = "rbxassetid://7733798957", ["wifi-off"] = "rbxassetid://7743878056", ["zoom-out"] = "rbxassetid://7743879082", ["toggle-right"] = "rbxassetid://7743873539", ["monitor"] = "rbxassetid://7734002839", ["x"] = "rbxassetid://7743878857", ["user"] = "rbxassetid://7743875962", ["sprout"] = "rbxassetid://7743872071", ["move"] = "rbxassetid://7743870731", ["gavel"] = "rbxassetid://7733800044", ["forward"] = "rbxassetid://7733799371", ["sidebar-close"] = "rbxassetid://7734058092", ["electricity"] = "rbxassetid://7733771628", ["plus"] = "rbxassetid://7734042071", ["pipette"] = "rbxassetid://7743871384", ["cloud-lightning"] = "rbxassetid://7733741741", ["lasso-select"] = "rbxassetid://7743868832", ["phone-call"] = "rbxassetid://7734027264", ["droplet"] = "rbxassetid://7733770982", ["key"] = "rbxassetid://7733965118", ["map-pin"] = "rbxassetid://7733992789", ["navigation-2"] = "rbxassetid://7734020942", ["list-minus"] = "rbxassetid://7733980795", ["chevron-up"] = "rbxassetid://7733919605", ["no_entry"] = "rbxassetid://7734021118", ["arrow-big-up"] = "rbxassetid://7733671663", ["bookmark-minus"] = "rbxassetid://7733689754", ["activity"] = "rbxassetid://7733655755", ["grid"] = "rbxassetid://7733955179", ["user-x"] = "rbxassetid://7743875879", ["alert-circle"] = "rbxassetid://7733658271", ["menu"] = "rbxassetid://7733993211", ["form-input"] = "rbxassetid://7733799275", ["rss"] = "rbxassetid://7734052075", ["loader"] = "rbxassetid://7733992358", ["strikethrough"] = "rbxassetid://7734068425", ["mic"] = "rbxassetid://7743869805", ["landmark"] = "rbxassetid://7733965184", ["crosshair"] = "rbxassetid://7733765307", ["alert-octagon"] = "rbxassetid://7733658335", ["anchor"] = "rbxassetid://7733911490", ["chevron-left"] = "rbxassetid://7733717651", ["flask-conical"] = "rbxassetid://7733798901", ["wallet"] = "rbxassetid://7743877573", ["euro"] = "rbxassetid://7733771891", ["trash-2"] = "rbxassetid://7743873772", ["check-circle"] = "rbxassetid://7733919427", ["layout"] = "rbxassetid://7733970543", ["droplets"] = "rbxassetid://7733771078", ["rotate-cw"] = "rbxassetid://7734051957", ["minimize"] = "rbxassetid://7733997941", ["arrow-down-left"] = "rbxassetid://7733672282", ["image-off"] = "rbxassetid://7733963907", ["cloudy"] = "rbxassetid://7733747106", ["align-left"] = "rbxassetid://7733911357", ["film"] = "rbxassetid://7733942579", ["chevrons-down"] = "rbxassetid://7733720604", ["pointer"] = "rbxassetid://7734042307", ["folder"] = "rbxassetid://7733799185", ["chevrons-left"] = "rbxassetid://7733720701", ["shield-off"] = "rbxassetid://7734056540", ["wrench"] = "rbxassetid://7743878358" }
local ICONS_V2 = { ["accessibility"] = "rbxassetid://10709751939", ["activity"] = "rbxassetid://10709752035", ["air-vent"] = "rbxassetid://10709752131", ["airplay"] = "rbxassetid://10709752254", ["alarm-check"] = "rbxassetid://10709752405", ["alarm-clock"] = "rbxassetid://10709752630", ["alarm-clock-off"] = "rbxassetid://10709752508", ["alarm-minus"] = "rbxassetid://10709752732", ["alarm-plus"] = "rbxassetid://10709752825", ["album"] = "rbxassetid://10709752906", ["alert-circle"] = "rbxassetid://10709752996", ["alert-octagon"] = "rbxassetid://10709753064", ["alert-triangle"] = "rbxassetid://10709753149", ["align-center"] = "rbxassetid://10709753570", ["align-center-horizontal"] = "rbxassetid://10709753272", ["align-center-vertical"] = "rbxassetid://10709753421", ["align-end-horizontal"] = "rbxassetid://10709753692", ["align-end-vertical"] = "rbxassetid://10709753808", ["align-horizontal-distribute-center"] = "rbxassetid://10747779791", ["align-horizontal-distribute-end"] = "rbxassetid://10747784534", ["align-horizontal-distribute-start"] = "rbxassetid://10709754118", ["align-horizontal-justify-center"] = "rbxassetid://10709754204", ["align-horizontal-justify-end"] = "rbxassetid://10709754317", ["align-horizontal-justify-start"] = "rbxassetid://10709754436", ["align-horizontal-space-around"] = "rbxassetid://10709754590", ["align-horizontal-space-between"] = "rbxassetid://10709754749", ["align-justify"] = "rbxassetid://10709759610", ["align-left"] = "rbxassetid://10709759764", ["align-right"] = "rbxassetid://10709759895", ["align-start-horizontal"] = "rbxassetid://10709760051", ["align-start-vertical"] = "rbxassetid://10709760244", ["align-vertical-distribute-center"] = "rbxassetid://10709760351", ["align-vertical-distribute-end"] = "rbxassetid://10709760434", ["align-vertical-distribute-start"] = "rbxassetid://10709760612", ["align-vertical-justify-center"] = "rbxassetid://10709760814", ["align-vertical-justify-end"] = "rbxassetid://10709761003", ["align-vertical-justify-start"] = "rbxassetid://10709761176", ["align-vertical-space-around"] = "rbxassetid://10709761324", ["align-vertical-space-between"] = "rbxassetid://10709761434", ["anchor"] = "rbxassetid://10709761530", ["angry"] = "rbxassetid://10709761629", ["annoyed"] = "rbxassetid://10709761722", ["aperture"] = "rbxassetid://10709761813", ["apple"] = "rbxassetid://10709761889", ["archive"] = "rbxassetid://10709762233", ["archive-restore"] = "rbxassetid://10709762058", ["armchair"] = "rbxassetid://10709762327", ["arrow-big-down"] = "rbxassetid://10747796644", ["arrow-big-left"] = "rbxassetid://10709762574", ["arrow-big-right"] = "rbxassetid://10709762727", ["arrow-big-up"] = "rbxassetid://10709762879", ["arrow-down"] = "rbxassetid://10709767827", ["arrow-down-circle"] = "rbxassetid://10709763034", ["arrow-down-left"] = "rbxassetid://10709767656", ["arrow-down-right"] = "rbxassetid://10709767750", ["arrow-left"] = "rbxassetid://10709768114", ["arrow-left-circle"] = "rbxassetid://10709767936", ["arrow-left-right"] = "rbxassetid://10709768019", ["arrow-right"] = "rbxassetid://10709768347", ["arrow-right-circle"] = "rbxassetid://10709768226", ["arrow-up"] = "rbxassetid://10709768939", ["arrow-up-circle"] = "rbxassetid://10709768432", ["arrow-up-down"] = "rbxassetid://10709768538", ["arrow-up-left"] = "rbxassetid://10709768661", ["arrow-up-right"] = "rbxassetid://10709768787", ["asterisk"] = "rbxassetid://10709769095", ["at-sign"] = "rbxassetid://10709769286", ["award"] = "rbxassetid://10709769406", ["axe"] = "rbxassetid://10709769508", ["axis-3d"] = "rbxassetid://10709769598", ["baby"] = "rbxassetid://10709769732", ["backpack"] = "rbxassetid://10709769841", ["baggage-claim"] = "rbxassetid://10709769935", ["banana"] = "rbxassetid://10709770005", ["banknote"] = "rbxassetid://10709770178", ["bar-chart"] = "rbxassetid://10709773755", ["bar-chart-2"] = "rbxassetid://10709770317", ["bar-chart-3"] = "rbxassetid://10709770431", ["bar-chart-4"] = "rbxassetid://10709770560", ["bar-chart-horizontal"] = "rbxassetid://10709773669", ["barcode"] = "rbxassetid://10747360675", ["baseline"] = "rbxassetid://10709773863", ["bath"] = "rbxassetid://10709773963", ["battery"] = "rbxassetid://10709774640", ["battery-charging"] = "rbxassetid://10709774068", ["battery-full"] = "rbxassetid://10709774206", ["battery-low"] = "rbxassetid://10709774370", ["battery-medium"] = "rbxassetid://10709774513", ["beaker"] = "rbxassetid://10709774756", ["bed"] = "rbxassetid://10709775036", ["bed-double"] = "rbxassetid://10709774864", ["bed-single"] = "rbxassetid://10709774968", ["beer"] = "rbxassetid://10709775167", ["bell"] = "rbxassetid://10709775704", ["bell-minus"] = "rbxassetid://10709775241", ["bell-off"] = "rbxassetid://10709775320", ["bell-plus"] = "rbxassetid://10709775448", ["bell-ring"] = "rbxassetid://10709775560", ["bike"] = "rbxassetid://10709775894", ["binary"] = "rbxassetid://10709776050", ["bitcoin"] = "rbxassetid://10709776126", ["bluetooth"] = "rbxassetid://10709776655", ["bluetooth-connected"] = "rbxassetid://10709776240", ["bluetooth-off"] = "rbxassetid://10709776344", ["bluetooth-searching"] = "rbxassetid://10709776501", ["bold"] = "rbxassetid://10747813908", ["bomb"] = "rbxassetid://10709781460", ["bone"] = "rbxassetid://10709781605", ["book"] = "rbxassetid://10709781824", ["book-open"] = "rbxassetid://10709781717", ["bookmark"] = "rbxassetid://10709782154", ["bookmark-minus"] = "rbxassetid://10709781919", ["bookmark-plus"] = "rbxassetid://10709782044", ["bot"] = "rbxassetid://10709782230", ["box"] = "rbxassetid://10709782497", ["box-select"] = "rbxassetid://10709782342", ["boxes"] = "rbxassetid://10709782582", ["briefcase"] = "rbxassetid://10709782662", ["brush"] = "rbxassetid://10709782758", ["bug"] = "rbxassetid://10709782845", ["building"] = "rbxassetid://10709783051", ["building-2"] = "rbxassetid://10709782939", ["bus"] = "rbxassetid://10709783137", ["chevron-down"] = "rbxassetid://10709790948" }

local Icons = ICONS_V1
local function NormalizeVersion(v) v = tostring(v):lower() if v == "v2" then return "v2" end return "v1" end
function Library:SetIconsVersion(v) Icons = NormalizeVersion(v) == "v2" and ICONS_V2 or ICONS_V1 end
local function GetIcon(name) if not name or name == "" then return nil end local clean = name:lower():gsub("^lucide%-", "") return Icons[clean] end

local ScreenGui = Utility:Create("ScreenGui", {Name = "EnigmaUI_" .. HttpService:GenerateGUID(false), ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 999})
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
Library.ScreenGui = ScreenGui

local NotificationHolder = Utility:Create("Frame", {Name = "Notifications", BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -16, 1, -16), Size = UDim2.new(0, 320, 1, -32), Parent = ScreenGui})
Utility:ListLayout(NotificationHolder, Enum.FillDirection.Vertical, 8, Enum.HorizontalAlignment.Right).VerticalAlignment = Enum.VerticalAlignment.Bottom

function Library:Notify(config)
    local theme = Library:GetTheme()
    local title = config.Title or "Notification"
    local content = config.Content or ""
    local duration = config.Duration or 4
    local frame = Utility:Create("Frame", {Name = "Notification", BackgroundColor3 = theme.Section, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = NotificationHolder, LayoutOrder = -os.clock()})
    Utility:Round(frame, 8)
    Utility:Stroke(frame, theme.SectionBorder, 1)
    Utility:Padding(frame, 12)
    local accent = Utility:Create("Frame", {BackgroundColor3 = theme.Accent, Size = UDim2.new(0, 3, 1, 0), BorderSizePixel = 0, Parent = frame})
    Utility:Round(accent, 2)
    local titleLabel = Utility:Create("TextLabel", {Text = title, Font = theme.FontBold, TextSize = 15, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Size = UDim2.new(1, -8, 0, 18), Position = UDim2.new(0, 8, 0, 0), Parent = frame})
    local contentLabel = Utility:Create("TextLabel", {Text = content, Font = theme.Font, TextSize = 13, TextColor3 = theme.TextDark, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true, BackgroundTransparency = 1, Size = UDim2.new(1, -8, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Position = UDim2.new(0, 8, 0, 20), Parent = frame})
    frame.BackgroundTransparency = 0
    frame.Position = UDim2.new(1, 50, 0, 0)
    Utility:Tween(frame, {Position = UDim2.new(0,0,0,0)}, 0.35)
    task.delay(duration, function() if frame and frame.Parent then Utility:Tween(frame, {Position = UDim2.new(1, 50, 0, 0)}, 0.3) task.delay(0.3, function() if frame then frame:Destroy() end) end end)
    return frame
end

local Window = {} Window.__index = Window
local TabMethods = {} TabMethods.__index = TabMethods
local SectionMethods = {} SectionMethods.__index = SectionMethods

function Library:CreateWindow(config)
    local theme = Library:GetTheme()
    local self = setmetatable({}, Window)
    self.Title = config.Title or "Library"
    self.SubTitle = config.SubTitle or ""
    local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled
    local defaultSize = isMobile and UDim2.fromOffset(480, 380) or UDim2.fromOffset(680, 440)
    self.Size = config.Size or defaultSize
    self.Tabs = {}
    self.CurrentTab = nil
    self.Minimized = false
    self.ConfigFolder = config.ConfigFolder or "EnigmaConfig"
    self.SaveConfig = config.SaveConfig or false
    Library.FolderName = self.ConfigFolder
    
    local Main = Utility:Create("Frame", {Name = "Main", BackgroundColor3 = Color3.fromRGB(12, 12, 16), BackgroundTransparency = 0.04, Position = UDim2.new(0.5, -self.Size.X.Offset/2, 0.5, -self.Size.Y.Offset/2), Size = self.Size, ClipsDescendants = true, Parent = ScreenGui})
    Utility:Round(Main, 12)
    local blur = Utility:Create("Frame", {Name = "Blur", BackgroundColor3 = Color3.fromRGB(255,255,255), Size = UDim2.new(1,0,1,0), ZIndex = -1, BorderSizePixel = 0, Parent = Main})
    local blurCorner = Utility:Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = blur})
    local blurEffect = Utility:Create("BlurEffect", {Size = 16, Parent = blur})
    local gradient = Utility:Create("UIGradient", {Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(0,0,0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(60,60,60))}), Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.6), NumberSequenceKeypoint.new(1, 0.9)}), Parent = blur})
    Utility:Stroke(Main, Color3.fromRGB(40,40,45), 1)
    Library:Tag(Main, "BackgroundColor3", "Background")
    self.Main = Main

    local TopBar = Utility:Create("Frame", {Name = "TopBar", BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 44), Parent = Main})
    Utility:Round(TopBar, 12)
    local TitleLabel = Utility:Create("TextLabel", {Text = self.Title, Font = theme.FontBold, TextSize = isMobile and 16 or 20, TextColor3 = Color3.fromRGB(255,255,255), TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Position = UDim2.new(0, 16, 0, 4), Size = UDim2.new(0, 300, 0, 20), Parent = TopBar})
    Library:Tag(TitleLabel, "TextColor3", "Text")
    local SubTitleLabel = Utility:Create("TextLabel", {Text = self.SubTitle, Font = theme.Font, TextSize = 11, TextColor3 = Color3.fromRGB(200,200,200), BackgroundTransparency = 1, Position = UDim2.new(0, 16, 0, 24), Size = UDim2.new(0, 300, 0, 14), Parent = TopBar})
    Library:Tag(SubTitleLabel, "TextColor3", "TextDark")
    
    local function TopBarButton(icon, offsetX)
        local btn = Utility:Create("TextButton", {Text = "", BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 1, Size = UDim2.new(0, 26, 0, 26), Position = UDim2.new(1, offsetX, 0.5, -13), AutoButtonColor = false, Parent = TopBar})
        Utility:Round(btn, 8)
        local ic = Utility:Create("ImageLabel", {Image = icon or "rbxassetid://3926305904", BackgroundTransparency = 1, Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0.5, -7, 0.5, -7), ImageColor3 = Color3.fromRGB(180,180,180), Parent = btn})
        btn.MouseEnter:Connect(function() Utility:Tween(ic, {ImageColor3 = Color3.fromRGB(255,255,255)}, 0.15) end)
        btn.MouseLeave:Connect(function() Utility:Tween(ic, {ImageColor3 = Color3.fromRGB(180,180,180)}, 0.15) end)
        return btn, ic
    end
    
    local CloseBtn, CloseIcon = TopBarButton("rbxassetid://7072725342", -34)
    local MinimizeBtn, MinimizeIcon = TopBarButton("rbxassetid://7072719338", -66)

    local Body = Utility:Create("Frame", {Name = "Body", BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 44), Size = UDim2.new(1, 0, 1, -44), Parent = Main})
    local Sidebar = Utility:Create("Frame", {Name = "Sidebar", BackgroundColor3 = Color3.fromRGB(20, 20, 25), BackgroundTransparency = 0.1, Size = UDim2.new(0, isMobile and 0 or 150, 1, 0), Parent = Body})
    Library:Tag(Sidebar, "BackgroundColor3", "Sidebar")
    self.Sidebar = Sidebar
    
    local SearchBox = Utility:Create("Frame", {BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.95, Size = UDim2.new(1, -12, 0, 28), Position = UDim2.new(0, 6, 0, 6), Parent = Sidebar})
    Utility:Round(SearchBox, 6)
    local SearchInput = Utility:Create("TextBox", {PlaceholderText = "🔍 Buscar...", Text = "", Font = theme.Font, TextSize = 12, TextColor3 = Color3.fromRGB(255,255,255), PlaceholderColor3 = Color3.fromRGB(150,150,150), BackgroundTransparency = 1, Size = UDim2.new(1, -16, 1, 0), Position = UDim2.new(0, 8, 0, 0), ClearTextOnFocus = false, Parent = SearchBox})
    
    local TabListHolder = Utility:Create("ScrollingFrame", {Name = "TabList", BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 40), Size = UDim2.new(1, 0, 1, -40), ScrollBarThickness = 2, ScrollBarImageColor3 = Color3.fromRGB(80,80,80), CanvasSize = UDim2.new(0,0,0,0), AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = Sidebar})
    Utility:Padding(TabListHolder, 6)
    Utility:ListLayout(TabListHolder, Enum.FillDirection.Vertical, 2)
    self.TabListHolder = TabListHolder

    local ContentArea = Utility:Create("Frame", {Name = "ContentArea", BackgroundColor3 = Color3.fromRGB(16, 16, 20), BackgroundTransparency = 0.05, Position = UDim2.new(0, isMobile and 0 or 150, 0, 0), Size = UDim2.new(1, isMobile and 0 or -150, 1, 0), Parent = Body})
    Library:Tag(ContentArea, "BackgroundColor3", "BackgroundSecondary")
    self.ContentArea = ContentArea

    local TabContentHolder = Utility:Create("Frame", {Name = "TabContentHolder", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Parent = ContentArea})
    self.TabContentHolder = TabContentHolder

    Utility:MakeDraggable(Main, TopBar)

    CloseBtn.MouseButton1Click:Connect(function()
        Utility:Tween(Main, {Size = UDim2.new(Main.Size.X.Scale, Main.Size.X.Offset, 0, 0), BackgroundTransparency = 1}, 0.25)
        task.delay(0.25, function() Main.Visible = false end)
    end)

    MinimizeBtn.MouseButton1Click:Connect(function()
        self.Minimized = not self.Minimized
        if self.Minimized then
            Utility:Tween(Main, {Size = UDim2.new(Main.Size.X.Scale, Main.Size.X.Offset, 0, 44)}, 0.25)
        else
            Utility:Tween(Main, {Size = self.Size}, 0.25)
        end
    end)

    SearchInput:GetPropertyChangedSignal("Text"):Connect(function() self:SearchElements(SearchInput.Text) end)
    table.insert(Library.Windows, self)
    return self
end

function Window:SearchElements(query)
    query = query:lower()
    for _, tabData in pairs(self.Tabs) do
        for _, section in ipairs(tabData.Sections) do
            for _, el in ipairs(section.Elements) do
                if query == "" then el.Frame.Visible = true else local name = (el.Name or ""):lower() el.Frame.Visible = name:find(query, 1, true) ~= nil end
            end
        end
    end
end

function Window:Tab(config)
    local theme = Library:GetTheme()
    local name = config.Name or "Tab"
    local icon = config.Icon
    local TabButton = Utility:Create("TextButton", {Name = name, Text = "", BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 34), AutoButtonColor = false, Parent = self.TabListHolder})
    Utility:Round(TabButton, 6)
    local IconImg local xOffset = 10
    if icon then
        local finalIcon = GetIcon(icon) or icon
        IconImg = Utility:Create("ImageLabel", {Image = finalIcon, BackgroundTransparency = 1, Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, 10, 0.5, -8), ImageColor3 = Color3.fromRGB(180,180,180), Parent = TabButton})
        xOffset = 34
    end
    local TabLabel = Utility:Create("TextLabel", {Text = name, Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = Color3.fromRGB(180,180,180), TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Position = UDim2.new(0, xOffset, 0, 0), Size = UDim2.new(1, -xOffset - 6, 1, 0), Parent = TabButton})
    local Indicator = Utility:Create("Frame", {BackgroundColor3 = theme.Accent, Size = UDim2.new(0, 3, 0, 0), Position = UDim2.new(0, 0, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BorderSizePixel = 0, Parent = TabButton})
    Utility:Round(Indicator, 2)
    local TabPage = Utility:Create("ScrollingFrame", {Name = name .. "Page", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), ScrollBarThickness = 3, ScrollBarImageColor3 = theme.Accent, CanvasSize = UDim2.new(0,0,0,0), AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false, Parent = self.TabContentHolder})
    Utility:Padding(TabPage, 12)
    local ColumnLeft = Utility:Create("Frame", {Name = "ColumnLeft", BackgroundTransparency = 1, Size = UDim2.new(0.5, -6, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = TabPage})
    Utility:ListLayout(ColumnLeft, Enum.FillDirection.Vertical, 10)
    local ColumnRight = Utility:Create("Frame", {Name = "ColumnRight", BackgroundTransparency = 1, Position = UDim2.new(0.5, 6, 0, 0), Size = UDim2.new(0.5, -6, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = TabPage})
    Utility:ListLayout(ColumnRight, Enum.FillDirection.Vertical, 10)
    local tabData = {Name = name, Button = TabButton, Page = TabPage, Indicator = Indicator, Label = TabLabel, Icon = IconImg, Sections = {}, ColumnLeft = ColumnLeft, ColumnRight = ColumnRight}
    local windowSelf = self
    local function SelectTab()
        for _, t in pairs(windowSelf.Tabs) do
            t.Page.Visible = false
            Utility:Tween(t.Label, {TextColor3 = Color3.fromRGB(180,180,180)}, 0.15)
            if t.Icon then Utility:Tween(t.Icon, {ImageColor3 = Color3.fromRGB(180,180,180)}, 0.15) end
            Utility:Tween(t.Indicator, {Size = UDim2.new(0, 3, 0, 0)}, 0.15)
            Utility:Tween(t.Button, {BackgroundTransparency = 1}, 0.15)
        end
        TabPage.Visible = true
        Utility:Tween(TabLabel, {TextColor3 = Color3.fromRGB(255,255,255)}, 0.15)
        if IconImg then Utility:Tween(IconImg, {ImageColor3 = theme.Accent}, 0.15) end
        Utility:Tween(Indicator, {Size = UDim2.new(0, 3, 0, 20)}, 0.15)
        Utility:Tween(TabButton, {BackgroundTransparency = 0.92}, 0.15)
        windowSelf.CurrentTab = tabData
    end
    TabButton.MouseButton1Click:Connect(SelectTab)
    self.Tabs[name] = tabData
    if not self.CurrentTab then SelectTab() end
    return setmetatable({Data = tabData, Window = self}, {__index = TabMethods})
end

function TabMethods:Section(config)
    local theme = Library:GetTheme()
    local side = config.Side == "Right" and self.Data.ColumnRight or self.Data.ColumnLeft
    local title = config.Title or "Section"
    local SectionFrame = Utility:Create("Frame", {Name = title, BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = side})
    Utility:Round(SectionFrame, 8)
    local TitleLabel = Utility:Create("TextLabel", {Text = title, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.fromRGB(255,255,255), TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Size = UDim2.new(1, -20, 0, 24), Position = UDim2.new(0, 10, 0, 0), Parent = SectionFrame})
    Library:Tag(TitleLabel, "TextColor3", "Text")
    local Divider = Utility:Create("Frame", {BackgroundColor3 = Color3.fromRGB(60,60,65), BackgroundTransparency = 0.5, Size = UDim2.new(1, -20, 0, 1), Position = UDim2.new(0, 10, 0, 24), BorderSizePixel = 0, Parent = SectionFrame})
    Library:Tag(Divider, "BackgroundColor3", "Divider")
    local ElementHolder = Utility:Create("Frame", {Name = "Elements", BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 30), Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = SectionFrame})
    Utility:Padding(ElementHolder, 0, 6, 6, 8, 8)
    Utility:ListLayout(ElementHolder, Enum.FillDirection.Vertical, 6)
    local sectionData = {Frame = SectionFrame, ElementHolder = ElementHolder, Elements = {}}
    table.insert(self.Data.Sections, sectionData)
    return setmetatable({Data = sectionData, Tab = self}, {__index = SectionMethods})
end

function SectionMethods:Button(config)
    local theme = Library:GetTheme()
    local name = config.Name or "Button"
    local callback = config.Callback or function() end
    local Frame = Utility:Create("Frame", {Name = name, BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.95, Size = UDim2.new(1, 0, 0, 34), Parent = self.Data.ElementHolder})
    Utility:Round(Frame, 6)
    Utility:Stroke(Frame, Color3.fromRGB(60,60,65), 1)
    local Btn = Utility:Create("TextButton", {Text = "", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), AutoButtonColor = false, Parent = Frame})
    local Label = Utility:Create("TextLabel", {Text = name, Font = theme.Font, TextSize = 13, TextColor3 = Color3.fromRGB(235,235,240), BackgroundTransparency = 1, Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0), TextXAlignment = Enum.TextXAlignment.Left, Parent = Frame})
    Utility:Ripple(Btn, theme.Accent)
    Btn.MouseEnter:Connect(function() Utility:Tween(Frame, {BackgroundTransparency = 0.9}, 0.15) Utility:Tween(Frame.UIStroke, {Color = theme.Accent}, 0.15) end)
    Btn.MouseLeave:Connect(function() Utility:Tween(Frame, {BackgroundTransparency = 0.95}, 0.15) Utility:Tween(Frame.UIStroke, {Color = Color3.fromRGB(60,60,65)}, 0.15) end)
    Btn.MouseButton1Click:Connect(function() task.spawn(callback) end)
    table.insert(self.Data.Elements, {Frame = Frame, Name = name})
    local api = {}
    function api:Set(newName) Label.Text = newName end
    function api:Destroy() Frame:Destroy() end
    return api
end

function SectionMethods:Toggle(config)
    local theme = Library:GetTheme()
    local name = config.Name or "Toggle"
    local default = config.Default or false
    local flag = config.Flag
    local callback = config.Callback or function() end
    local Frame = Utility:Create("Frame", {Name = name, BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.95, Size = UDim2.new(1, 0, 0, 34), Parent = self.Data.ElementHolder})
    Utility:Round(Frame, 6)
    Utility:Stroke(Frame, Color3.fromRGB(60,60,65), 1)
    local Label = Utility:Create("TextLabel", {Text = name, Font = theme.Font, TextSize = 13, TextColor3 = Color3.fromRGB(235,235,240), BackgroundTransparency = 1, Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 10, 0, 0), TextXAlignment = Enum.TextXAlignment.Left, Parent = Frame})
    local Switch = Utility:Create("Frame", {BackgroundColor3 = default and theme.Accent or Color3.fromRGB(60,60,65), Size = UDim2.new(0, 36, 0, 18), Position = UDim2.new(1, -46, 0.5, -9), Parent = Frame})
    Utility:Round(Switch, 9)
    local Knob = Utility:Create("Frame", {BackgroundColor3 = Color3.fromRGB(255,255,255), Size = UDim2.new(0, 14, 0, 14), Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7), Parent = Switch})
    Utility:Round(Knob, 7)
    local Click = Utility:Create("TextButton", {Text = "", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Parent = Frame})
    local state = default
    local function setState(value, fromInit)
        state = value
        Utility:Tween(Switch, {BackgroundColor3 = state and theme.Accent or Color3.fromRGB(60,60,65)}, 0.2)
        Utility:Tween(Knob, {Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}, 0.2)
        if flag then Library.Flags[flag] = state end
        if not fromInit then task.spawn(callback, state) end
    end
    Click.MouseButton1Click:Connect(function() setState(not state) end)
    if flag then Library.Flags[flag] = state end
    table.insert(self.Data.Elements, {Frame = Frame, Name = name})
    local api = {}
    function api:Set(value) setState(value) end
    function api:Get() return state end
    function api:Destroy() Frame:Destroy() end
    return api
end

function SectionMethods:Slider(config)
    local theme = Library:GetTheme()
    local name = config.Name or "Slider"
    local min = config.Min or 0
    local max = config.Max or 100
    local default = config.Default or min
    local suffix = config.Suffix or ""
    local flag = config.Flag
    local callback = config.Callback or function() end
    local Frame = Utility:Create("Frame", {Name = name, BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.95, Size = UDim2.new(1, 0, 0, 44), Parent = self.Data.ElementHolder})
    Utility:Round(Frame, 6)
    Utility:Stroke(Frame, Color3.fromRGB(60,60,65), 1)
    Utility:Padding(Frame, 0, 6, 6, 10, 10)
    local Label = Utility:Create("TextLabel", {Text = name, Font = theme.Font, TextSize = 13, TextColor3 = Color3.fromRGB(235,235,240), BackgroundTransparency = 1, Size = UDim2.new(1, -40, 0, 14), TextXAlignment = Enum.TextXAlignment.Left, Parent = Frame})
    local ValueLabel = Utility:Create("TextLabel", {Text = tostring(default) .. suffix, Font = theme.Font, TextSize = 11, TextColor3 = Color3.fromRGB(180,180,180), BackgroundTransparency = 1, Size = UDim2.new(0, 50, 0, 14), Position = UDim2.new(1, -40, 0, 0), TextXAlignment = Enum.TextXAlignment.Right, Parent = Frame})
    local Track = Utility:Create("Frame", {BackgroundColor3 = Color3.fromRGB(40,40,45), Size = UDim2.new(1, 0, 0, 4), Position = UDim2.new(0, 0, 0, 20), Parent = Frame})
    Utility:Round(Track, 2)
    local Fill = Utility:Create("Frame", {BackgroundColor3 = theme.Accent, Size = UDim2.new((default - min) / (max - min), 0, 1, 0), Parent = Track})
    Utility:Round(Fill, 2)
    local Knob = Utility:Create("Frame", {BackgroundColor3 = Color3.fromRGB(255,255,255), AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0), Parent = Track})
    Utility:Round(Knob, 5)
    local dragging = false
    local value = default
    local function updateFromInput(inputPos)
        local relative = math.clamp((inputPos - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        value = min + (max - min) * relative
        Fill.Size = UDim2.new(relative, 0, 1, 0)
        Knob.Position = UDim2.new(relative, 0, 0.5, 0)
        ValueLabel.Text = tostring(value) .. suffix
        if flag then Library.Flags[flag] = value end
        task.spawn(callback, value)
    end
    Track.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true updateFromInput(input.Position.X) end end)
    UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateFromInput(input.Position.X) end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
    if flag then Library.Flags[flag] = default end
    table.insert(self.Data.Elements, {Frame = Frame, Name = name})
    local api = {}
    function api:Set(v) updateFromInput(Track.AbsolutePosition.X + math.clamp((v-min)/(max-min),0,1)*Track.AbsoluteSize.X) end
    function api:Get() return value end
    function api:Destroy() Frame:Destroy() end
    return api
end

function SectionMethods:Dropdown(config)
    local theme = Library:GetTheme()
    local name = config.Name or "Dropdown"
    local options = config.Options or {}
    local default = config.Default
    local flag = config.Flag
    local callback = config.Callback or function() end
    local Frame = Utility:Create("Frame", {Name = name, BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.95, Size = UDim2.new(1, 0, 0, 34), ClipsDescendants = false, ZIndex = 2, Parent = self.Data.ElementHolder})
    Utility:Round(Frame, 6)
    Utility:Stroke(Frame, Color3.fromRGB(60,60,65), 1)
    local Label = Utility:Create("TextLabel", {Text = name, Font = theme.Font, TextSize = 13, TextColor3 = Color3.fromRGB(235,235,240), BackgroundTransparency = 1, Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.new(0, 10, 0, 0), TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 2, Parent = Frame})
    local SelectedLabel = Utility:Create("TextLabel", {Text = default and tostring(default) or "Selecionar", Font = theme.Font, TextSize = 12, TextColor3 = Color3.fromRGB(180,180,180), BackgroundTransparency = 1, Size = UDim2.new(0.5, -30, 1, 0), Position = UDim2.new(0.5, 0, 0, 0), TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 2, Parent = Frame})
    local Arrow = Utility:Create("ImageLabel", {Image = "rbxassetid://7072706796", BackgroundTransparency = 1, Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(1, -22, 0.5, -6), ImageColor3 = Color3.fromRGB(180,180,180), ZIndex = 2, Parent = Frame})
    local Click = Utility:Create("TextButton", {Text = "", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), ZIndex = 3, Parent = Frame})
    local ListFrame = Utility:Create("Frame", {BackgroundColor3 = Color3.fromRGB(24, 24, 29), Position = UDim2.new(0, 0, 1, 4), Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Visible = false, ZIndex = 10, Parent = Frame})
    Utility:Round(ListFrame, 6)
    Utility:Stroke(ListFrame, Color3.fromRGB(60,60,65), 1)
    Utility:Padding(ListFrame, 4)
    Utility:ListLayout(ListFrame, Enum.FillDirection.Vertical, 2)
    local selected = default
    local optionButtons = {}
    local open = false
    local function toggleOpen() open = not open ListFrame.Visible = open Utility:Tween(Arrow, {Rotation = open and 180 or 0}, 0.15) end
    local function selectOption(opt)
        selected = opt
        SelectedLabel.Text = tostring(opt)
        toggleOpen()
        if flag then Library.Flags[flag] = selected end
        task.spawn(callback, selected)
        for optName, btn in pairs(optionButtons) do local isSelected = selected == optName Utility:Tween(btn, {BackgroundColor3 = isSelected and theme.Accent or Color3.fromRGB(255,255,255), BackgroundTransparency = isSelected and 0.8 or 0.95}, 0.15) end
    end
    Click.MouseButton1Click:Connect(toggleOpen)
    for _, opt in ipairs(options) do
        local OptBtn = Utility:Create("TextButton", {Text = tostring(opt), Font = theme.Font, TextSize = 12, TextColor3 = Color3.fromRGB(235,235,240), BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.95, Size = UDim2.new(1, 0, 0, 26), ZIndex = 11, AutoButtonColor = false, Parent = ListFrame})
        Utility:Round(OptBtn, 4)
        optionButtons[opt] = OptBtn
        OptBtn.MouseButton1Click:Connect(function() selectOption(opt) end)
    end
    if flag then Library.Flags[flag] = selected end
    table.insert(self.Data.Elements, {Frame = Frame, Name = name})
    local api = {}
    function api:Set(v) selectOption(v) end
    function api:Get() return selected end
    function api:Refresh(newOptions) for _, btn in pairs(optionButtons) do btn:Destroy() end optionButtons = {} for _, opt in ipairs(newOptions) do local OptBtn = Utility:Create("TextButton", {Text = tostring(opt), Font = theme.Font, TextSize = 12, TextColor3 = Color3.fromRGB(235,235,240), BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.95, Size = UDim2.new(1, 0, 0, 26), ZIndex = 11, AutoButtonColor = false, Parent = ListFrame}) Utility:Round(OptBtn, 4) optionButtons[opt] = OptBtn OptBtn.MouseButton1Click:Connect(function() selectOption(opt) end) end end
    function api:Destroy() Frame:Destroy() end
    return api
end

function SectionMethods:Textbox(config)
    local theme = Library:GetTheme()
    local name = config.Name or "Textbox"
    local placeholder = config.Placeholder or "..."
    local default = config.Default or ""
    local flag = config.Flag
    local callback = config.Callback or function() end
    local Frame = Utility:Create("Frame", {Name = name, BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.95, Size = UDim2.new(1, 0, 0, 34), Parent = self.Data.ElementHolder})
    Utility:Round(Frame, 6)
    Utility:Stroke(Frame, Color3.fromRGB(60,60,65), 1)
    local Label = Utility:Create("TextLabel", {Text = name, Font = theme.Font, TextSize = 13, TextColor3 = Color3.fromRGB(235,235,240), BackgroundTransparency = 1, Size = UDim2.new(0.4, 0, 1, 0), Position = UDim2.new(0, 10, 0, 0), TextXAlignment = Enum.TextXAlignment.Left, Parent = Frame})
    local Input = Utility:Create("TextBox", {Text = default, PlaceholderText = placeholder, Font = theme.Font, TextSize = 12, TextColor3 = Color3.fromRGB(235,235,240), PlaceholderColor3 = Color3.fromRGB(180,180,180), BackgroundTransparency = 1, Size = UDim2.new(0.6, -10, 1, 0), Position = UDim2.new(0.4, 10, 0, 0), TextXAlignment = Enum.TextXAlignment.Right, ClearTextOnFocus = false, Parent = Frame})
    Input.FocusLost:Connect(function() if flag then Library.Flags[flag] = Input.Text end task.spawn(callback, Input.Text) end)
    if flag then Library.Flags[flag] = default end
    table.insert(self.Data.Elements, {Frame = Frame, Name = name})
    local api = {}
    function api:Set(v) Input.Text = v if flag then Library.Flags[flag] = v end end
    function api:Get() return Input.Text end
    function api:Destroy() Frame:Destroy() end
    return api
end

function SectionMethods:Label(config)
    local theme = Library:GetTheme()
    local text = config.Text or "Label"
    local Frame = Utility:Create("Frame", {Name = "Label", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 18), Parent = self.Data.ElementHolder})
    local TextLbl = Utility:Create("TextLabel", {Text = text, Font = theme.Font, TextSize = 12, TextColor3 = Color3.fromRGB(180,180,180), BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), TextXAlignment = Enum.TextXAlignment.Left, Parent = Frame})
    table.insert(self.Data.Elements, {Frame = Frame, Name = text})
    local api = {}
    function api:Set(v) TextLbl.Text = v end
    function api:Destroy() Frame:Destroy() end
    return api
end

function SectionMethods:Paragraph(config)
    local theme = Library:GetTheme()
    local title = config.Title or "Paragraph"
    local content = config.Content or ""
    local Frame = Utility:Create("Frame", {Name = title, BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.95, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = self.Data.ElementHolder})
    Utility:Round(Frame, 6)
    Utility:Stroke(Frame, Color3.fromRGB(60,60,65), 1)
    Utility:Padding(Frame, 8)
    local TitleLbl = Utility:Create("TextLabel", {Text = title, Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Color3.fromRGB(235,235,240), BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 14), TextXAlignment = Enum.TextXAlignment.Left, Parent = Frame})
    local ContentLbl = Utility:Create("TextLabel", {Text = content, Font = theme.Font, TextSize = 12, TextColor3 = Color3.fromRGB(180,180,180), BackgroundTransparency = 1, TextWrapped = true, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Position = UDim2.new(0, 0, 0, 18), TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, Parent = Frame})
    table.insert(self.Data.Elements, {Frame = Frame, Name = title})
    local api = {}
    function api:Set(newContent) ContentLbl.Text = newContent end
    function api:Destroy() Frame:Destroy() end
    return api
end

function SectionMethods:Keybind(config)
    local theme = Library:GetTheme()
    local name = config.Name or "Keybind"
    local default = config.Default
    local flag = config.Flag
    local callback = config.Callback or function() end
    local changedCallback = config.Changed or function() end
    local Frame = Utility:Create("Frame", {Name = name, BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.95, Size = UDim2.new(1, 0, 0, 34), Parent = self.Data.ElementHolder})
    Utility:Round(Frame, 6)
    Utility:Stroke(Frame, Color3.fromRGB(60,60,65), 1)
    local Label = Utility:Create("TextLabel", {Text = name, Font = theme.Font, TextSize = 13, TextColor3 = Color3.fromRGB(235,235,240), BackgroundTransparency = 1, Size = UDim2.new(1, -90, 1, 0), Position = UDim2.new(0, 10, 0, 0), TextXAlignment = Enum.TextXAlignment.Left, Parent = Frame})
    local KeyButton = Utility:Create("TextButton", {Text = default and default.Name or "Nenhuma", Font = theme.Font, TextSize = 12, TextColor3 = Color3.fromRGB(180,180,180), BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.95, Size = UDim2.new(0, 80, 0, 22), Position = UDim2.new(1, -88, 0.5, -11), AutoButtonColor = false, Parent = Frame})
    Utility:Round(KeyButton, 4)
    local currentKey = default
    local listening = false
    KeyButton.MouseButton1Click:Connect(function() listening = true KeyButton.Text = "..." end)
    local conn = UserInputService.InputBegan:Connect(function(input, gpe)
        if listening then
            if input.UserInputType == Enum.UserInputType.Keyboard then currentKey = input.KeyCode KeyButton.Text = currentKey.Name listening = false if flag then Library.Flags[flag] = currentKey end task.spawn(changedCallback, currentKey) end
            return
        end
        if gpe then return end
        if currentKey and input.KeyCode == currentKey then task.spawn(callback) end
    end)
    table.insert(Library.Connections, conn)
    table.insert(self.Data.Elements, {Frame = Frame, Name = name})
    local api = {}
    function api:Set(keyCode) currentKey = keyCode KeyButton.Text = keyCode and keyCode.Name or "Nenhuma" if flag then Library.Flags[flag] = currentKey end end
    function api:Get() return currentKey end
    function api:Destroy() Frame:Destroy() end
    return api
end

function SectionMethods:ColorPicker(config)
    local theme = Library:GetTheme()
    local name = config.Name or "Color Picker"
    local default = config.Default or Color3.fromRGB(255,255,255)
    local flag = config.Flag
    local callback = config.Callback or function() end
    local Frame = Utility:Create("Frame", {Name = name, BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.95, Size = UDim2.new(1, 0, 0, 34), ClipsDescendants = false, ZIndex = 2, Parent = self.Data.ElementHolder})
    Utility:Round(Frame, 6)
    Utility:Stroke(Frame, Color3.fromRGB(60,60,65), 1)
    local Label = Utility:Create("TextLabel", {Text = name, Font = theme.Font, TextSize = 13, TextColor3 = Color3.fromRGB(235,235,240), BackgroundTransparency = 1, Size = UDim2.new(1, -50, 1, 0), Position = UDim2.new(0, 10, 0, 0), TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 2, Parent = Frame})
    local Preview = Utility:Create("TextButton", {Text = "", BackgroundColor3 = default, Size = UDim2.new(0, 30, 0, 20), Position = UDim2.new(1, -40, 0.5, -10), ZIndex = 2, AutoButtonColor = false, Parent = Frame})
    Utility:Round(Preview, 4)
    Utility:Stroke(Preview, Color3.fromRGB(60,60,65), 1)
    local Popup = Utility:Create("Frame", {BackgroundColor3 = Color3.fromRGB(24, 24, 29), Position = UDim2.new(1, 4, 0, 0), Size = UDim2.new(0, 200, 0, 210), Visible = false, ZIndex = 20, Parent = Frame})
    Utility:Round(Popup, 8)
    Utility:Stroke(Popup, Color3.fromRGB(60,60,65), 1)
    Utility:Padding(Popup, 10)
    local h, s, v = default:ToHSV()
    local SVBox = Utility:Create("ImageButton", {BackgroundColor3 = Color3.fromHSV(h, 1, 1), Size = UDim2.new(1, 0, 0, 120), ZIndex = 21, Parent = Popup})
    Utility:Round(SVBox, 6)
    Utility:Gradient(SVBox, ColorSequence.new(Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255)), 0, NumberSequence.new({NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1)}))
    local SVBlack = Utility:Create("Frame", {BackgroundColor3 = Color3.fromRGB(0,0,0), BackgroundTransparency = 1, Size = UDim2.new(1,0,1,0), ZIndex = 21, Parent = SVBox})
    Utility:Gradient(SVBlack, ColorSequence.new(Color3.fromRGB(0,0,0), Color3.fromRGB(0,0,0)), 90, NumberSequence.new({NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(1,0)}))
    local SVCursor = Utility:Create("Frame", {BackgroundColor3 = Color3.fromRGB(255,255,255), AnchorPoint = Vector2.new(0.5,0.5), Size = UDim2.new(0,8,0,8), Position = UDim2.new(s, 0, 1-v, 0), ZIndex = 22, Parent = SVBox})
    Utility:Round(SVCursor, 4)
    Utility:Stroke(SVCursor, Color3.fromRGB(0,0,0), 1)
    local HueBar = Utility:Create("Frame", {Size = UDim2.new(1, 0, 0, 18), Position = UDim2.new(0, 0, 0, 130), ZIndex = 21, Parent = Popup})
    Utility:Round(HueBar, 4)
    Utility:Gradient(HueBar, ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(0,1,1)), ColorSequenceKeypoint.new(0.17, Color3.fromHSV(0.17,1,1)), ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33,1,1)), ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5,1,1)), ColorSequenceKeypoint.new(0.67, Color3.fromHSV(0.67,1,1)), ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83,1,1)), ColorSequenceKeypoint.new(1, Color3.fromHSV(1,1,1))}))
    local HueButton = Utility:Create("TextButton", {Text = "", BackgroundTransparency = 1, Size = UDim2.new(1,0,1,0), ZIndex = 22, Parent = HueBar})
    local HueCursor = Utility:Create("Frame", {BackgroundColor3 = Color3.fromRGB(255,255,255), AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(0, 4, 1, 4), Position = UDim2.new(h, 0, 0.5, 0), ZIndex = 22, Parent = HueBar})
    local HexBox = Utility:Create("TextBox", {Text = string.format("#%02X%02X%02X", default.R*255, default.G*255, default.B*255), Font = theme.Font, TextSize = 12, TextColor3 = Color3.fromRGB(235,235,240), BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.95, Size = UDim2.new(1, 0, 0, 24), Position = UDim2.new(0, 0, 0, 156), ZIndex = 21, ClearTextOnFocus = false, Parent = Popup})
    Utility:Round(HexBox, 4)
    local currentColor = default
    local function updateColor() currentColor = Color3.fromHSV(h, s, v) SVBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1) Preview.BackgroundColor3 = currentColor HexBox.Text = string.format("#%02X%02X%02X", currentColor.R*255, currentColor.G*255, currentColor.B*255) if flag then Library.Flags[flag] = currentColor end task.spawn(callback, currentColor) end
    local draggingSV, draggingHue = false, false
    SVBox.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingSV = true end end)
    HueButton.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingHue = true end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingSV = false draggingHue = false end end)
    UserInputService.InputChanged:Connect(function(input) if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end if draggingSV then local relX = math.clamp((input.Position.X - SVBox.AbsolutePosition.X) / SVBox.AbsoluteSize.X, 0, 1) local relY = math.clamp((input.Position.Y - SVBox.AbsolutePosition.Y) / SVBox.AbsoluteSize.Y, 0, 1) s = relX v = 1 - relY SVCursor.Position = UDim2.new(relX, 0, relY, 0) updateColor() elseif draggingHue then local relX = math.clamp((input.Position.X - HueBar.AbsolutePosition.X) / HueBar.AbsoluteSize.X, 0, 1) h = relX HueCursor.Position = UDim2.new(relX, 0, 0.5, 0) updateColor() end end)
    HexBox.FocusLost:Connect(function() local hex = HexBox.Text:gsub("#", "") if #hex == 6 then local r = tonumber(hex:sub(1,2), 16) local g = tonumber(hex:sub(3,4), 16) local b = tonumber(hex:sub(5,6), 16) if r and g and b then local color = Color3.fromRGB(r, g, b) h, s, v = color:ToHSV() SVCursor.Position = UDim2.new(s, 0, 1-v, 0) HueCursor.Position = UDim2.new(h, 0, 0.5, 0) updateColor() end end end)
    local open = false
    Preview.MouseButton1Click:Connect(function() open = not open Popup.Visible = open end)
    if flag then Library.Flags[flag] = default end
    table.insert(self.Data.Elements, {Frame = Frame, Name = name})
    local api = {}
    function api:Set(color) h, s, v = color:ToHSV() SVCursor.Position = UDim2.new(s, 0, 1-v, 0) HueCursor.Position = UDim2.new(h, 0, 0.5, 0) updateColor() end
    function api:Get() return currentColor end
    function api:Destroy() Frame:Destroy() end
    return api
end

function SectionMethods:Divider() local Line = Utility:Create("Frame", {BackgroundColor3 = Color3.fromRGB(60,60,65), Size = UDim2.new(1, 0, 0, 1), Parent = self.Data.ElementHolder}) table.insert(self.Data.Elements, {Frame = Line, Name = "Divider"}) return {Destroy = function() Line:Destroy() end} end

function SectionMethods:AddFloatingPanel(config)
    local theme = Library:GetTheme()
    local name = config.Name or "Panel"
    local width = config.Width or 240
    local height = config.Height or 300
    local draggable = config.Draggable ~= false
    
    local Panel = Utility:Create("Frame", {Name = name, BackgroundColor3 = Color3.fromRGB(18, 18, 22), BackgroundTransparency = 0.1, Size = UDim2.new(0, width, 0, height), Position = UDim2.new(0, 10, 0, 10), Parent = self.Data.ElementHolder})
    Utility:Round(Panel, 12)
    Utility:Stroke(Panel, Color3.fromRGB(60,60,65), 1)
    Library:Tag(Panel, "BackgroundColor3", "BackgroundSecondary")
    
    local Header = Utility:Create("Frame", {BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 30), Parent = Panel})
    local Title = Utility:Create("TextLabel", {Text = name, Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Color3.fromRGB(235,235,240), BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(1, -20, 1, 0), TextXAlignment = Enum.TextXAlignment.Left, Parent = Header})
    Library:Tag(Title, "TextColor3", "Text")
    if draggable then Utility:MakeDraggable(Panel, Header) end
    
    local ListHolder = Utility:Create("ScrollingFrame", {BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 30), Size = UDim2.new(1, 0, 1, -30), ScrollBarThickness = 3, ScrollBarImageColor3 = Color3.fromRGB(80,80,80), CanvasSize = UDim2.new(0,0,0,0), AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = Panel})
    Utility:Padding(ListHolder, 6)
    Utility:ListLayout(ListHolder, Enum.FillDirection.Vertical, 4)
    
    local api = {}
    function api:AddRow(text, subtitle, status)
        local Row = Utility:Create("Frame", {BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.95, Size = UDim2.new(1, 0, 0, 32), Parent = ListHolder})
        Utility:Round(Row, 6)
        Utility:Stroke(Row, Color3.fromRGB(60,60,65), 1)
        local MainTxt = Utility:Create("TextLabel", {Text = text, Font = theme.Font, TextSize = 13, TextColor3 = Color3.fromRGB(235,235,240), BackgroundTransparency = 1, Position = UDim2.new(0, 8, 0, 0), Size = UDim2.new(1, -80, 0, 16), TextXAlignment = Enum.TextXAlignment.Left, Parent = Row})
        local SubTxt = Utility:Create("TextLabel", {Text = subtitle or "", Font = theme.Font, TextSize = 10, TextColor3 = Color3.fromRGB(150,150,160), BackgroundTransparency = 1, Position = UDim2.new(0, 8, 0, 16), Size = UDim2.new(1, -80, 0, 12), TextXAlignment = Enum.TextXAlignment.Left, Parent = Row})
        local StatusDot = Utility:Create("Frame", {BackgroundColor3 = status or Color3.fromRGB(0,255,0), Size = UDim2.new(0, 6, 0, 6), Position = UDim2.new(1, -12, 0.5, -3), BorderSizePixel = 0, Parent = Row})
        Utility:Round(StatusDot, 3)
    end
    function api:Clear() for _, child in ipairs(ListHolder:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end end
    function api:Destroy() Panel:Destroy() end
    return api
end

function SectionMethods:AddMinimizeToggle(config)
    local CoreGui = game:GetService("CoreGui")
    local UIS = game:GetService("UserInputService")
    local Camera = workspace.CurrentCamera
    local existing = CoreGui:FindFirstChild("EnigmaToggle")
    if existing then existing:Destroy() end
    
    config = config or {}
    local MARGIN = 10
    local BTN_W = 48
    local BTN_H = 48
    
    local function clampPos(x, y) local vp = Camera.ViewportSize return math.clamp(x, MARGIN, vp.X - BTN_W - MARGIN), math.clamp(y, MARGIN, vp.Y - BTN_H - MARGIN) end
    
    local MinimizeGUI = Utility:Create("ScreenGui", {Name = "EnigmaToggle", ResetOnSpawn = false, DisplayOrder = 999, IgnoreGuiInset = true})
    pcall(function() MinimizeGUI.Parent = CoreGui end)
    
    local ToggleButton = Utility:Create("ImageButton", {Size = UDim2.new(0, BTN_W, 0, BTN_H), Position = UDim2.new(0, 12, 0, 100), Image = "rbxassetid://18503887946", BackgroundColor3 = Color3.fromRGB(20, 20, 20), BackgroundTransparency = 0.15, BorderSizePixel = 0, ZIndex = 10, Parent = MinimizeGUI})
    Utility:Round(ToggleButton, UDim.new(0.18, 0))
    local UIStroke = Utility:Stroke(ToggleButton, Color3.fromRGB(70,70,70), 1.5)
    
    local dragging = false
    local dragMoved = false
    local lockedInput = nil
    local dragStartPos = Vector2.new(0, 0)
    local startBtnX = 0
    local startBtnY = 0
    
    local function moveTo(x, y) local cx, cy = clampPos(x, y) ToggleButton.Position = UDim2.new(0, cx, 0, cy) end
    
    ToggleButton.InputBegan:Connect(function(input) if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end if dragging then return end dragging = true dragMoved = false lockedInput = input dragStartPos = Vector2.new(input.Position.X, input.Position.Y) startBtnX = ToggleButton.Position.X.Offset startBtnY = ToggleButton.Position.Y.Offset end)
    UIS.InputChanged:Connect(function(input) if not dragging then return end if input ~= lockedInput then return end if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStartPos if delta.Magnitude > 4 then dragMoved = true end moveTo(startBtnX + delta.X, startBtnY + delta.Y) end)
    UIS.InputEnded:Connect(function(input) if input ~= lockedInput then return end dragging = false lockedInput = nil end)
    
    ToggleButton.Activated:Connect(function() if dragMoved then dragMoved = false return end Utility:Tween(ToggleButton, {Size = UDim2.new(0, BTN_W - 6, 0, BTN_H - 6)}, 0.08) task.delay(0.08, function() Utility:Tween(ToggleButton, {Size = UDim2.new(0, BTN_W, 0, BTN_H)}, 0.14) end)
        local mainWindow = Library.Windows[1]
        if mainWindow then
            mainWindow.Main.Visible = not mainWindow.Main.Visible
            if mainWindow.Main.Visible then
                mainWindow.Main.Position = UDim2.new(0.5, -mainWindow.Size.X.Offset/2, 0.5, -mainWindow.Size.Y.Offset/2)
                mainWindow.Main.AnchorPoint = Vector2.new(0, 0)
            end
        end
        Utility:Tween(ToggleButton, {BackgroundTransparency = mainWindow.Main.Visible and 0.15 or 0.55}, 0.2)
        Utility:Tween(UIStroke, {Transparency = mainWindow.Main.Visible and 0 or 0.6}, 0.2)
    end)
    
    local api = {}
    function api:SetImage(id) ToggleButton.Image = id end
    function api:Destroy() MinimizeGUI:Destroy() end
    return api
end

function Library:SaveConfig(fileName)
    fileName = fileName or "enigmaconfig"
    local ok, encoded = pcall(function() return HttpService:JSONEncode(Library.Flags) end)
    if ok and writefile then pcall(function() writefile(fileName .. ".json", encoded) end) return true end
    return false
end

function Library:LoadConfig(fileName)
    fileName = fileName or "enigmaconfig"
    if not (isfile and isfile(fileName .. ".json")) then return false end
    local ok, decoded = pcall(function() return HttpService:JSONDecode(readfile(fileName .. ".json")) end)
    if ok and decoded then for k, v in pairs(decoded) do Library.Flags[k] = v end return true end
    return false
end

function Library:Destroy()
    Library.Unloaded = true
    for _, conn in ipairs(Library.Connections) do pcall(function() conn:Disconnect() end) end
    Library.Connections = {}
    if ScreenGui then ScreenGui:Destroy() end
end

Library.Loaded = true
local Meta = {}
Meta.__index = Library
setmetatable(Library, Meta)

return Libraryfunction Library:GetTheme() return Library.Themes[Library.CurrentTheme] end
function Library:SetTheme(name) if not Library.Themes[name] then return end Library.CurrentTheme = name Library:RefreshTheme() end
function Library:CreateTheme(name, data) local base = table.clone(Library.Themes.Dark) for k, v in pairs(data) do base[k] = v end Library.Themes[name] = base end

Library.ThemeInstances = {}
function Library:RefreshTheme() local theme = Library:GetTheme() for _, entry in ipairs(Library.ThemeInstances) do local inst, prop = entry[1], entry[2] if inst and inst.Parent and inst[prop] ~= nil then pcall(function() inst[prop] = theme[entry[3]] end) end end end
function Library:Tag(inst, prop, themeKey) table.insert(Library.ThemeInstances, {inst, prop, themeKey}) end

local Utility = {} Library.Utility = Utility
function Utility:Create(class, props, children) local inst = Instance.new(class) for prop, value in pairs(props or {}) do inst[prop] = value end for _, child in ipairs(children or {}) do child.Parent = inst end return inst end
function Utility:Tween(inst, props, duration, style, direction) duration = duration or 0.25 style = style or Enum.EasingStyle.Quint direction = direction or Enum.EasingDirection.Out local tween = TweenService:Create(inst, TweenInfo.new(duration, style, direction), props) tween:Play() return tween end
function Utility:Round(inst, radius) return Utility:Create("UICorner", {CornerRadius = UDim.new(0, radius or 6), Parent = inst}) end
function Utility:Stroke(inst, color, thickness, transparency) return Utility:Create("UIStroke", {Color = color or Color3.fromRGB(40,40,47), Thickness = thickness or 1, Transparency = transparency or 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = inst}) end
function Utility:Padding(inst, all, top, bottom, left, right) return Utility:Create("UIPadding", {PaddingTop = UDim.new(0, top or all or 0), PaddingBottom = UDim.new(0, bottom or all or 0), PaddingLeft = UDim.new(0, left or all or 0), PaddingRight = UDim.new(0, right or all or 0), Parent = inst}) end
function Utility:ListLayout(inst, direction, padding, alignment) return Utility:Create("UIListLayout", {FillDirection = direction or Enum.FillDirection.Vertical, Padding = UDim.new(0, padding or 6), HorizontalAlignment = alignment or Enum.HorizontalAlignment.Left, SortOrder = Enum.SortOrder.LayoutOrder, Parent = inst}) end
function Utility:Gradient(inst, colorSeq, rotation, transparencySeq) return Utility:Create("UIGradient", {Color = colorSeq, Rotation = rotation or 0, Transparency = transparencySeq or NumberSequence.new(0), Parent = inst}) end
function Utility:Ripple(button, color) button.MouseButton1Down:Connect(function() local ripple = Utility:Create("Frame", {Name = "Ripple", BackgroundColor3 = color or Color3.fromRGB(255,255,255), BackgroundTransparency = 0.75, BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(0, 0), Parent = button, ZIndex = button.ZIndex + 1}) Utility:Round(ripple, 100) Utility:Tween(ripple, {Size = UDim2.fromScale(2, 2), BackgroundTransparency = 1}, 0.5) task.delay(0.5, function() ripple:Destroy() end) end) end
function Utility:MakeDraggable(frame, dragHandle) dragHandle = dragHandle or frame local dragging = false local dragStart, startPos local function update(input) local delta = input.Position - dragStart local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) Utility:Tween(frame, {Position = newPos}, 0.08, Enum.EasingStyle.Sine) end dragHandle.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true dragStart = input.Position startPos = frame.Position input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end) dragHandle.InputChanged:Connect(function(input) if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then update(input) end end) end
function Utility:TextBounds(text, font, size) return TextService:GetTextSize(text, size, font, Vector2.new(1000, 1000)) end

local IconManager = {} Library.IconManager = IconManager
IconManager.Icons = setmetatable({}, {__index = function() return "rbxassetid://3926305904" end})
function IconManager:Get(name) return IconManager.Icons[name] end
function IconManager:Register(name, id) IconManager.Icons[name] = id end

local ICONS_V1 = { ["aperture"] = "rbxassetid://7733666258", ["bug"] = "rbxassetid://7733701545", ["chevrons-down-up"] = "rbxassetid://7733720483", ["clock-6"] = "rbxassetid://8997384977", ["egg"] = "rbxassetid://8997385940", ["external-link"] = "rbxassetid://7743866903", ["lightbulb-off"] = "rbxassetid://7733975123", ["file-check-2"] = "rbxassetid://7733779610", ["settings"] = "rbxassetid://7734053495", ["crown"] = "rbxassetid://7733765398", ["coins"] = "rbxassetid://7743866529", ["battery"] = "rbxassetid://7733674820", ["flashlight-off"] = "rbxassetid://7733798799", ["camera-off"] = "rbxassetid://7733919260", ["function-square"] = "rbxassetid://7733799682", ["mountain-snow"] = "rbxassetid://7743870286", ["gamepad"] = "rbxassetid://7733799901", ["gift"] = "rbxassetid://7733946818", ["globe"] = "rbxassetid://7733954760", ["option"] = "rbxassetid://7734021300", ["hand"] = "rbxassetid://7733955740", ["hard-hat"] = "rbxassetid://7733955850", ["hash"] = "rbxassetid://7733955906", ["server"] = "rbxassetid://7734053426", ["align-horizontal-space-around"] = "rbxassetid://8997381738", ["highlighter"] = "rbxassetid://7743868648", ["bike"] = "rbxassetid://7733678330", ["home"] = "rbxassetid://7733960981", ["image"] = "rbxassetid://7733964126", ["indent"] = "rbxassetid://7733964452", ["infinity"] = "rbxassetid://7733964640", ["inspect"] = "rbxassetid://7733964808", ["alert-triangle"] = "rbxassetid://7733658504", ["align-start-horizontal"] = "rbxassetid://8997381965", ["figma"] = "rbxassetid://7743867310", ["pin"] = "rbxassetid://8997386648", ["corner-up-right"] = "rbxassetid://7733764915", ["list-x"] = "rbxassetid://7743869517", ["monitor-off"] = "rbxassetid://7734000184", ["chevron-first"] = "rbxassetid://8997383275", ["package-search"] = "rbxassetid://8997386448", ["pencil"] = "rbxassetid://7734022107", ["cloud-fog"] = "rbxassetid://7733920317", ["grip-horizontal"] = "rbxassetid://7733955302", ["align-center-vertical"] = "rbxassetid://8997380737", ["outdent"] = "rbxassetid://7734021384", ["more-vertical"] = "rbxassetid://7734006187", ["package-plus"] = "rbxassetid://8997386355", ["bluetooth"] = "rbxassetid://7733687147", ["pen-tool"] = "rbxassetid://7734022041", ["person-standing"] = "rbxassetid://7743871002", ["tornado"] = "rbxassetid://7743873633", ["phone-incoming"] = "rbxassetid://7743871120", ["phone-off"] = "rbxassetid://7734029534", ["dribbble"] = "rbxassetid://7733770843", ["at-sign"] = "rbxassetid://7733673907", ["edit-2"] = "rbxassetid://7733771217", ["sheet"] = "rbxassetid://7743871876", ["tv"] = "rbxassetid://7743874674", ["headphones"] = "rbxassetid://7733956063", ["qr-code"] = "rbxassetid://7743871575", ["reply"] = "rbxassetid://7734051594", ["rewind"] = "rbxassetid://7734051670", ["bell-off"] = "rbxassetid://7733675107", ["file-check"] = "rbxassetid://7733779668", ["quote"] = "rbxassetid://7734045100", ["rotate-ccw"] = "rbxassetid://7734051861", ["library"] = "rbxassetid://7743869054", ["clock-1"] = "rbxassetid://8997383694", ["on-charge"] = "rbxassetid://7734021231", ["video-off"] = "rbxassetid://7743876466", ["save"] = "rbxassetid://7734052335", ["arrow-left-circle"] = "rbxassetid://7733673056", ["screen-share"] = "rbxassetid://7734052814", ["clock-3"] = "rbxassetid://8997384456", ["help-circle"] = "rbxassetid://7733956210", ["server-crash"] = "rbxassetid://7734053281", ["bluetooth-searching"] = "rbxassetid://7733914320", ["equal"] = "rbxassetid://7733771811", ["shield-close"] = "rbxassetid://7734056470", ["phone"] = "rbxassetid://7734032056", ["type"] = "rbxassetid://7743874740", ["file-x-2"] = "rbxassetid://7743867554", ["sidebar"] = "rbxassetid://7734058260", ["sigma"] = "rbxassetid://7734058345", ["smartphone-charging"] = "rbxassetid://7734058894", ["arrow-left"] = "rbxassetid://7733673136", ["framer"] = "rbxassetid://7733799486", ["currency"] = "rbxassetid://7733765592", ["star"] = "rbxassetid://7734068321", ["stretch-horizontal"] = "rbxassetid://8997387754", ["smile"] = "rbxassetid://7734059095", ["subscript"] = "rbxassetid://8997387937", ["sun"] = "rbxassetid://7734068495", ["switch-camera"] = "rbxassetid://7743872492", ["table"] = "rbxassetid://7734073253", ["tag"] = "rbxassetid://7734075797", ["cross"] = "rbxassetid://7733765224", ["gem"] = "rbxassetid://7733942651", ["link"] = "rbxassetid://7733978098", ["terminal"] = "rbxassetid://7743872929", ["thermometer-sun"] = "rbxassetid://7734084018", ["share-2"] = "rbxassetid://7734053595", ["timer-off"] = "rbxassetid://8997388325", ["megaphone"] = "rbxassetid://7733993049", ["timer-reset"] = "rbxassetid://7743873336", ["phone-forwarded"] = "rbxassetid://7734027345", ["unlock"] = "rbxassetid://7743875263", ["trello"] = "rbxassetid://7743873996", ["camera"] = "rbxassetid://7733708692", ["triangle"] = "rbxassetid://7743874367", ["truck"] = "rbxassetid://7743874482", ["file-output"] = "rbxassetid://7733788742", ["gamepad-2"] = "rbxassetid://7733799795", ["network"] = "rbxassetid://7734021047", ["users"] = "rbxassetid://7743876054", ["electricity-off"] = "rbxassetid://7733771563", ["book"] = "rbxassetid://7733914390", ["clock-9"] = "rbxassetid://8997385485", ["corner-down-left"] = "rbxassetid://7733764327", ["locate-fixed"] = "rbxassetid://7733992424", ["bar-chart"] = "rbxassetid://7733674319", ["shield-check"] = "rbxassetid://7734056411", ["signal-low"] = "rbxassetid://8997387189", ["reply-all"] = "rbxassetid://7734051524", ["zoom-in"] = "rbxassetid://7743878977", ["grip-vertical"] = "rbxassetid://7733955410", ["ticket"] = "rbxassetid://7734086558", ["smartphone"] = "rbxassetid://7734058979", ["arrow-big-right"] = "rbxassetid://7733671493", ["tv-2"] = "rbxassetid://7743874599", ["flashlight"] = "rbxassetid://7733798851", ["database"] = "rbxassetid://7743866778", ["plus-square"] = "rbxassetid://7734040369", ["align-justify"] = "rbxassetid://7733661326", ["clipboard-list"] = "rbxassetid://7733920117", ["github"] = "rbxassetid://7733954058", ["columns"] = "rbxassetid://7733757178", ["arrow-big-down"] = "rbxassetid://7733668653", ["cloud-off"] = "rbxassetid://7733745572", ["target"] = "rbxassetid://7743872758", ["skip-back"] = "rbxassetid://7734058404", ["x-circle"] = "rbxassetid://7743878496", ["clock-10"] = "rbxassetid://8997383876", ["align-right"] = "rbxassetid://7733663582", ["clock-5"] = "rbxassetid://8997384798", ["bell-plus"] = "rbxassetid://7733675181", ["battery-medium"] = "rbxassetid://7733674731", ["arrow-down"] = "rbxassetid://7733672933", ["inbox"] = "rbxassetid://7733964370", ["cast"] = "rbxassetid://7733919326", ["gift-card"] = "rbxassetid://7733945018", ["webcam"] = "rbxassetid://7743877896", ["folder-minus"] = "rbxassetid://7733799022", ["scan-line"] = "rbxassetid://8997386772", ["shovel"] = "rbxassetid://7734056878", ["download-cloud"] = "rbxassetid://7733770689", ["list-checks"] = "rbxassetid://7743869317", ["file-text"] = "rbxassetid://7733789088", ["codesandbox"] = "rbxassetid://7733752575", ["laptop-2"] = "rbxassetid://7733965313", ["podcast"] = "rbxassetid://7734042234", ["log-out"] = "rbxassetid://7733992677", ["thumbs-up"] = "rbxassetid://7743873212", ["timer"] = "rbxassetid://7743873443", ["text-cursor"] = "rbxassetid://8997388195", ["file-search"] = "rbxassetid://7733788966", ["thermometer"] = "rbxassetid://7734084149", ["bluetooth-off"] = "rbxassetid://7733914252", ["refresh-cw"] = "rbxassetid://7734051052", ["clipboard-check"] = "rbxassetid://7733919947", ["languages"] = "rbxassetid://7733965249", ["asterisk"] = "rbxassetid://7733673800", ["superscript"] = "rbxassetid://8997388036", ["user-check"] = "rbxassetid://7743875503", ["move-diagonal"] = "rbxassetid://7743870505", ["copy"] = "rbxassetid://7733764083", ["bot"] = "rbxassetid://7733916988", ["alarm-minus"] = "rbxassetid://7733656164", ["log-in"] = "rbxassetid://7733992604", ["maximize"] = "rbxassetid://7733992982", ["align-horizontal-space-between"] = "rbxassetid://8997381854", ["brush"] = "rbxassetid://7733701455", ["equal-not"] = "rbxassetid://7733771726", ["upload"] = "rbxassetid://7743875428", ["minus-circle"] = "rbxassetid://7733998053", ["graduation-cap"] = "rbxassetid://7733955058", ["edit-3"] = "rbxassetid://7733771361", ["check"] = "rbxassetid://7733715400", ["scissors"] = "rbxassetid://7734052570", ["info"] = "rbxassetid://7733964719", ["book-open"] = "rbxassetid://7733687281", ["divide-circle"] = "rbxassetid://7733769152", ["file"] = "rbxassetid://7733793319", ["clock-2"] = "rbxassetid://8997384295", ["corner-right-up"] = "rbxassetid://7733764680", ["clover"] = "rbxassetid://7733747233", ["expand"] = "rbxassetid://7733771982", ["gauge"] = "rbxassetid://7733799969", ["phone-outgoing"] = "rbxassetid://7743871253", ["shield-alert"] = "rbxassetid://7734056326", ["paperclip"] = "rbxassetid://7734021680", ["arrow-big-left"] = "rbxassetid://7733911731", ["album"] = "rbxassetid://7733658133", ["bookmark"] = "rbxassetid://7733692043", ["check-circle-2"] = "rbxassetid://7733710700", ["list-ordered"] = "rbxassetid://7743869411", ["delete"] = "rbxassetid://7733768142", ["axe"] = "rbxassetid://7733674079", ["radio"] = "rbxassetid://7743871662", ["octagon"] = "rbxassetid://7734021165", ["git-commit"] = "rbxassetid://7743868360", ["shirt"] = "rbxassetid://7734056672", ["corner-right-down"] = "rbxassetid://7733764605", ["trending-down"] = "rbxassetid://7743874143", ["airplay"] = "rbxassetid://7733655834", ["repeat"] = "rbxassetid://7734051454", ["layers"] = "rbxassetid://7743868936", ["chevron-right"] = "rbxassetid://7733717755", ["chevrons-right"] = "rbxassetid://7733919682", ["folder-plus"] = "rbxassetid://7733799092", ["alarm-check"] = "rbxassetid://7733655912", ["arrow-up-right"] = "rbxassetid://7733673646", ["user-plus"] = "rbxassetid://7743875759", ["file-minus"] = "rbxassetid://7733936115", ["cloud-drizzle"] = "rbxassetid://7733920226", ["stretch-vertical"] = "rbxassetid://8997387862", ["unlink"] = "rbxassetid://7743875149", ["wand"] = "rbxassetid://8997388430", ["regex"] = "rbxassetid://7734051188", ["command"] = "rbxassetid://7733924046", ["haze"] = "rbxassetid://7733955969", ["trash"] = "rbxassetid://7743873871", ["battery-full"] = "rbxassetid://7733674503", ["flag-triangle-left"] = "rbxassetid://7733798509", ["server-off"] = "rbxassetid://7734053361", ["loader-2"] = "rbxassetid://7733989869", ["monitor-speaker"] = "rbxassetid://7743869988", ["shuffle"] = "rbxassetid://7734057059", ["tablet"] = "rbxassetid://7743872620", ["cloud-moon"] = "rbxassetid://7733920519", ["clipboard-x"] = "rbxassetid://7733734668", ["pocket"] = "rbxassetid://7734042139", ["watch"] = "rbxassetid://7743877668", ["file-plus"] = "rbxassetid://7733788885", ["locate"] = "rbxassetid://7733992469", ["share"] = "rbxassetid://7734053697", ["thermometer-snowflake"] = "rbxassetid://7743873074", ["volume-1"] = "rbxassetid://7743877081", ["coffee"] = "rbxassetid://7733752630", ["cloud-hail"] = "rbxassetid://7733920444", ["alarm-clock-off"] = "rbxassetid://7733656003", ["pound-sterling"] = "rbxassetid://7734042354", ["tent"] = "rbxassetid://7734078943", ["toggle-left"] = "rbxassetid://7734091286", ["dollar-sign"] = "rbxassetid://7733770599", ["sunrise"] = "rbxassetid://7743872365", ["sunset"] = "rbxassetid://7734070982", ["code"] = "rbxassetid://7733749837", ["thumbs-down"] = "rbxassetid://7734084236", ["trending-up"] = "rbxassetid://7743874262", ["clock-12"] = "rbxassetid://8997384150", ["rocking-chair"] = "rbxassetid://7734051769", ["check-square"] = "rbxassetid://7733919526", ["cpu"] = "rbxassetid://7733765045", ["palette"] = "rbxassetid://7734021595", ["minimize-2"] = "rbxassetid://7733997870", ["cloud-sun"] = "rbxassetid://7733746880", ["copyleft"] = "rbxassetid://7733764196", ["archive"] = "rbxassetid://7733911621", ["building"] = "rbxassetid://7733701625", ["image-minus"] = "rbxassetid://7733963797", ["italic"] = "rbxassetid://7733964917", ["link-2-off"] = "rbxassetid://7733975283", ["sort-asc"] = "rbxassetid://7734060715", ["underline"] = "rbxassetid://7743874904", ["gitlab"] = "rbxassetid://7733954246", ["file-minus-2"] = "rbxassetid://7733936010", ["play-circle"] = "rbxassetid://7734037784", ["clock-8"] = "rbxassetid://8997385352", ["file-input"] = "rbxassetid://7733935917", ["beaker"] = "rbxassetid://7733674922", ["shopping-bag"] = "rbxassetid://7734056747", ["navigation"] = "rbxassetid://7734020989", ["moon"] = "rbxassetid://7743870134", ["glasses"] = "rbxassetid://7733954403", ["clipboard-copy"] = "rbxassetid://7733920037", ["feather"] = "rbxassetid://7733777166", ["skip-forward"] = "rbxassetid://7734058495", ["wind"] = "rbxassetid://7743878264", ["frown"] = "rbxassetid://7733799591", ["move-vertical"] = "rbxassetid://7743870608", ["umbrella"] = "rbxassetid://7743874820", ["package"] = "rbxassetid://7734021469", ["chevrons-up"] = "rbxassetid://7733723433", ["download"] = "rbxassetid://7733770755", ["eye"] = "rbxassetid://7733774602", ["files"] = "rbxassetid://7743867811", ["arrow-down-right"] = "rbxassetid://7733672831", ["code-2"] = "rbxassetid://7733920644", ["file-digit"] = "rbxassetid://7733935829", ["x-square"] = "rbxassetid://7743878737", ["clipboard"] = "rbxassetid://7733734762", ["maximize-2"] = "rbxassetid://7733992901", ["send"] = "rbxassetid://7734053039", ["alarm-clock"] = "rbxassetid://7733656100", ["sliders"] = "rbxassetid://7734058803", ["refresh-ccw"] = "rbxassetid://7734050715", ["music"] = "rbxassetid://7734020554", ["banknote"] = "rbxassetid://7733674153", ["hard-drive"] = "rbxassetid://7733955793", ["search"] = "rbxassetid://7734052925", ["layout-list"] = "rbxassetid://7733970442", ["edit"] = "rbxassetid://7733771472", ["contrast"] = "rbxassetid://7733764005", ["wifi"] = "rbxassetid://7743878148", ["ghost"] = "rbxassetid://7743868000", ["laptop"] = "rbxassetid://7733965386", ["clock-4"] = "rbxassetid://8997384603", ["layout-dashboard"] = "rbxassetid://7733970318", ["circle"] = "rbxassetid://7733919881", ["file-x"] = "rbxassetid://7733938136", ["award"] = "rbxassetid://7733673987", ["corner-left-down"] = "rbxassetid://7733764448", ["arrow-up-left"] = "rbxassetid://7733673539", ["globe-2"] = "rbxassetid://7733954611", ["compass"] = "rbxassetid://7733924216", ["git-branch"] = "rbxassetid://7733949149", ["vibrate"] = "rbxassetid://7743876302", ["pause-circle"] = "rbxassetid://7734021767", ["minus-square"] = "rbxassetid://7743869899", ["mic-off"] = "rbxassetid://7743869714", ["arrow-down-circle"] = "rbxassetid://7733671763", ["move-horizontal"] = "rbxassetid://7734016210", ["chrome"] = "rbxassetid://7733919783", ["radio-receiver"] = "rbxassetid://7734045155", ["shield"] = "rbxassetid://7734056608", ["image-plus"] = "rbxassetid://7733964016", ["more-horizontal"] = "rbxassetid://7734006080", ["divide"] = "rbxassetid://7733769365", ["view"] = "rbxassetid://7743876754", ["list"] = "rbxassetid://7743869612", ["printer"] = "rbxassetid://7734042580", ["corner-left-up"] = "rbxassetid://7733764536", ["meh"] = "rbxassetid://7733993147", ["copyright"] = "rbxassetid://7733764275", ["heart"] = "rbxassetid://7733956134", ["lock"] = "rbxassetid://7733992528", ["align-center"] = "rbxassetid://7733909776", ["signal-high"] = "rbxassetid://8997387110", ["upload-cloud"] = "rbxassetid://7743875358", ["arrow-up-circle"] = "rbxassetid://7733673466", ["git-branch-plus"] = "rbxassetid://7743868200", ["screen-share-off"] = "rbxassetid://7734052653", ["git-pull-request"] = "rbxassetid://7733952287", ["flag"] = "rbxassetid://7733798691", ["star-half"] = "rbxassetid://7734068258", ["minus"] = "rbxassetid://7734000129", ["mountain"] = "rbxassetid://7734008868", ["volume"] = "rbxassetid://7743877487", ["mouse-pointer-2"] = "rbxassetid://7734010405", ["indian-rupee"] = "rbxassetid://7733964536", ["speaker"] = "rbxassetid://7734063416", ["flame"] = "rbxassetid://7733798747", ["crop"] = "rbxassetid://7733765140", ["clock-11"] = "rbxassetid://8997384034", ["stop-circle"] = "rbxassetid://7734068379", ["power-off"] = "rbxassetid://7734042423", ["bell-minus"] = "rbxassetid://7733675028", ["undo"] = "rbxassetid://7743874974", ["link-2"] = "rbxassetid://7743869163", ["lightbulb"] = "rbxassetid://7733975185", ["shrink"] = "rbxassetid://7734056971", ["mail"] = "rbxassetid://7733992732", ["pause"] = "rbxassetid://7734021897", ["bold"] = "rbxassetid://7733687211", ["calendar"] = "rbxassetid://7733919198", ["x-octagon"] = "rbxassetid://7743878618", ["file-code"] = "rbxassetid://7733779730", ["life-buoy"] = "rbxassetid://7733973479", ["import"] = "rbxassetid://7733964240", ["video"] = "rbxassetid://7743876610", ["clock-7"] = "rbxassetid://8997385147", ["bell"] = "rbxassetid://7733911828", ["move-diagonal-2"] = "rbxassetid://7734013178", ["message-circle"] = "rbxassetid://7733993311", ["skull"] = "rbxassetid://7734058599", ["battery-charging"] = "rbxassetid://7733674402", ["ruler"] = "rbxassetid://7734052157", ["binary"] = "rbxassetid://7733678388", ["cloud-rain-wind"] = "rbxassetid://7733746456", ["briefcase"] = "rbxassetid://7733919017", ["terminal-square"] = "rbxassetid://7734079055", ["scale"] = "rbxassetid://7734052454", ["lasso"] = "rbxassetid://7733967892", ["piggy-bank"] = "rbxassetid://7734034513", ["battery-low"] = "rbxassetid://7733674589", ["arrow-up"] = "rbxassetid://7733673717", ["list-plus"] = "rbxassetid://7733984995", ["bookmark-plus"] = "rbxassetid://7734111084", ["box-select"] = "rbxassetid://7733696665", ["filter"] = "rbxassetid://7733798407", ["play"] = "rbxassetid://7743871480", ["calculator"] = "rbxassetid://7733919105", ["bell-ring"] = "rbxassetid://7733675275", ["plane"] = "rbxassetid://7734037723", ["plus-circle"] = "rbxassetid://7734040271", ["power"] = "rbxassetid://7734042493", ["phone-missed"] = "rbxassetid://7734029465", ["percent"] = "rbxassetid://7743870852", ["mouse-pointer"] = "rbxassetid://7743870392", ["box"] = "rbxassetid://7733917120", ["snowflake"] = "rbxassetid://7734059180", ["sort-desc"] = "rbxassetid://7743871973", ["flag-triangle-right"] = "rbxassetid://7733798634", ["bar-chart-2"] = "rbxassetid://7733674239", ["hand-metal"] = "rbxassetid://7733955664", ["map"] = "rbxassetid://7733992829", ["eye-off"] = "rbxassetid://7733774495", ["cloud-rain"] = "rbxassetid://7733746651", ["contact"] = "rbxassetid://7743866666", ["signal"] = "rbxassetid://8997387546", ["mouse-pointer-click"] = "rbxassetid://7734010488", ["sidebar-open"] = "rbxassetid://7734058165", ["pause-octagon"] = "rbxassetid://7734021827", ["user-minus"] = "rbxassetid://7743875629", ["cloud"] = "rbxassetid://7733746980", ["arrow-right-circle"] = "rbxassetid://7733673229", ["fast-forward"] = "rbxassetid://7743867090", ["volume-2"] = "rbxassetid://7743877250", ["grab"] = "rbxassetid://7733954884", ["arrow-right"] = "rbxassetid://7733673345", ["chevron-down"] = "rbxassetid://7733717447", ["volume-x"] = "rbxassetid://7743877381", ["cloud-snow"] = "rbxassetid://7733746798", ["car"] = "rbxassetid://7733708835", ["message-square"] = "rbxassetid://7733993369", ["repeat-1"] = "rbxassetid://7734051342", ["codepen"] = "rbxassetid://7733920768", ["voicemail"] = "rbxassetid://7743876916", ["shopping-cart"] = "rbxassetid://7734056813", ["corner-down-right"] = "rbxassetid://7733764385", ["layout-grid"] = "rbxassetid://7733970390", ["clock"] = "rbxassetid://7733734848", ["corner-up-left"] = "rbxassetid://7733764800", ["git-merge"] = "rbxassetid://7733952195", ["verified"] = "rbxassetid://7743876142", ["redo"] = "rbxassetid://7743871739", ["hexagon"] = "rbxassetid://7743868527", ["square"] = "rbxassetid://7743872181", ["chevrons-up-down"] = "rbxassetid://7733723321", ["bus"] = "rbxassetid://7733701715", ["file-plus-2"] = "rbxassetid://7733788816", ["alarm-plus"] = "rbxassetid://7733658066", ["divide-square"] = "rbxassetid://7733769261", ["pie-chart"] = "rbxassetid://7734034378", ["hammer"] = "rbxassetid://7733955511", ["history"] = "rbxassetid://7733960880", ["flask-round"] = "rbxassetid://7733798957", ["wifi-off"] = "rbxassetid://7743878056", ["zoom-out"] = "rbxassetid://7743879082", ["toggle-right"] = "rbxassetid://7743873539", ["monitor"] = "rbxassetid://7734002839", ["x"] = "rbxassetid://7743878857", ["user"] = "rbxassetid://7743875962", ["sprout"] = "rbxassetid://7743872071", ["move"] = "rbxassetid://7743870731", ["gavel"] = "rbxassetid://7733800044", ["forward"] = "rbxassetid://7733799371", ["sidebar-close"] = "rbxassetid://7734058092", ["electricity"] = "rbxassetid://7733771628", ["plus"] = "rbxassetid://7734042071", ["pipette"] = "rbxassetid://7743871384", ["cloud-lightning"] = "rbxassetid://7733741741", ["lasso-select"] = "rbxassetid://7743868832", ["phone-call"] = "rbxassetid://7734027264", ["droplet"] = "rbxassetid://7733770982", ["key"] = "rbxassetid://7733965118", ["map-pin"] = "rbxassetid://7733992789", ["navigation-2"] = "rbxassetid://7734020942", ["list-minus"] = "rbxassetid://7733980795", ["chevron-up"] = "rbxassetid://7733919605", ["no_entry"] = "rbxassetid://7734021118", ["arrow-big-up"] = "rbxassetid://7733671663", ["bookmark-minus"] = "rbxassetid://7733689754", ["activity"] = "rbxassetid://7733655755", ["grid"] = "rbxassetid://7733955179", ["user-x"] = "rbxassetid://7743875879", ["alert-circle"] = "rbxassetid://7733658271", ["menu"] = "rbxassetid://7733993211", ["form-input"] = "rbxassetid://7733799275", ["rss"] = "rbxassetid://7734052075", ["loader"] = "rbxassetid://7733992358", ["strikethrough"] = "rbxassetid://7734068425", ["mic"] = "rbxassetid://7743869805", ["landmark"] = "rbxassetid://7733965184", ["crosshair"] = "rbxassetid://7733765307", ["alert-octagon"] = "rbxassetid://7733658335", ["anchor"] = "rbxassetid://7733911490", ["chevron-left"] = "rbxassetid://7733717651", ["flask-conical"] = "rbxassetid://7733798901", ["wallet"] = "rbxassetid://7743877573", ["euro"] = "rbxassetid://7733771891", ["trash-2"] = "rbxassetid://7743873772", ["check-circle"] = "rbxassetid://7733919427", ["layout"] = "rbxassetid://7733970543", ["droplets"] = "rbxassetid://7733771078", ["rotate-cw"] = "rbxassetid://7734051957", ["minimize"] = "rbxassetid://7733997941", ["arrow-down-left"] = "rbxassetid://7733672282", ["image-off"] = "rbxassetid://7733963907", ["cloudy"] = "rbxassetid://7733747106", ["align-left"] = "rbxassetid://7733911357", ["film"] = "rbxassetid://7733942579", ["chevrons-down"] = "rbxassetid://7733720604", ["pointer"] = "rbxassetid://7734042307", ["folder"] = "rbxassetid://7733799185", ["chevrons-left"] = "rbxassetid://7733720701", ["shield-off"] = "rbxassetid://7734056540", ["wrench"] = "rbxassetid://7743878358" }
local ICONS_V2 = { ["accessibility"] = "rbxassetid://10709751939", ["activity"] = "rbxassetid://10709752035", ["air-vent"] = "rbxassetid://10709752131", ["airplay"] = "rbxassetid://10709752254", ["alarm-check"] = "rbxassetid://10709752405", ["alarm-clock"] = "rbxassetid://10709752630", ["alarm-clock-off"] = "rbxassetid://10709752508", ["alarm-minus"] = "rbxassetid://10709752732", ["alarm-plus"] = "rbxassetid://10709752825", ["album"] = "rbxassetid://10709752906", ["alert-circle"] = "rbxassetid://10709752996", ["alert-octagon"] = "rbxassetid://10709753064", ["alert-triangle"] = "rbxassetid://10709753149", ["align-center"] = "rbxassetid://10709753570", ["align-center-horizontal"] = "rbxassetid://10709753272", ["align-center-vertical"] = "rbxassetid://10709753421", ["align-end-horizontal"] = "rbxassetid://10709753692", ["align-end-vertical"] = "rbxassetid://10709753808", ["align-horizontal-distribute-center"] = "rbxassetid://10747779791", ["align-horizontal-distribute-end"] = "rbxassetid://10747784534", ["align-horizontal-distribute-start"] = "rbxassetid://10709754118", ["align-horizontal-justify-center"] = "rbxassetid://10709754204", ["align-horizontal-justify-end"] = "rbxassetid://10709754317", ["align-horizontal-justify-start"] = "rbxassetid://10709754436", ["align-horizontal-space-around"] = "rbxassetid://10709754590", ["align-horizontal-space-between"] = "rbxassetid://10709754749", ["align-justify"] = "rbxassetid://10709759610", ["align-left"] = "rbxassetid://10709759764", ["align-right"] = "rbxassetid://10709759895", ["align-start-horizontal"] = "rbxassetid://10709760051", ["align-start-vertical"] = "rbxassetid://10709760244", ["align-vertical-distribute-center"] = "rbxassetid://10709760351", ["align-vertical-distribute-end"] = "rbxassetid://10709760434", ["align-vertical-distribute-start"] = "rbxassetid://10709760612", ["align-vertical-justify-center"] = "rbxassetid://10709760814", ["align-vertical-justify-end"] = "rbxassetid://10709761003", ["align-vertical-justify-start"] = "rbxassetid://10709761176", ["align-vertical-space-around"] = "rbxassetid://10709761324", ["align-vertical-space-between"] = "rbxassetid://10709761434", ["anchor"] = "rbxassetid://10709761530", ["angry"] = "rbxassetid://10709761629", ["annoyed"] = "rbxassetid://10709761722", ["aperture"] = "rbxassetid://10709761813", ["apple"] = "rbxassetid://10709761889", ["archive"] = "rbxassetid://10709762233", ["archive-restore"] = "rbxassetid://10709762058", ["armchair"] = "rbxassetid://10709762327", ["arrow-big-down"] = "rbxassetid://10747796644", ["arrow-big-left"] = "rbxassetid://10709762574", ["arrow-big-right"] = "rbxassetid://10709762727", ["arrow-big-up"] = "rbxassetid://10709762879", ["arrow-down"] = "rbxassetid://10709767827", ["arrow-down-circle"] = "rbxassetid://10709763034", ["arrow-down-left"] = "rbxassetid://10709767656", ["arrow-down-right"] = "rbxassetid://10709767750", ["arrow-left"] = "rbxassetid://10709768114", ["arrow-left-circle"] = "rbxassetid://10709767936", ["arrow-left-right"] = "rbxassetid://10709768019", ["arrow-right"] = "rbxassetid://10709768347", ["arrow-right-circle"] = "rbxassetid://10709768226", ["arrow-up"] = "rbxassetid://10709768939", ["arrow-up-circle"] = "rbxassetid://10709768432", ["arrow-up-down"] = "rbxassetid://10709768538", ["arrow-up-left"] = "rbxassetid://10709768661", ["arrow-up-right"] = "rbxassetid://10709768787", ["asterisk"] = "rbxassetid://10709769095", ["at-sign"] = "rbxassetid://10709769286", ["award"] = "rbxassetid://10709769406", ["axe"] = "rbxassetid://10709769508", ["axis-3d"] = "rbxassetid://10709769598", ["baby"] = "rbxassetid://10709769732", ["backpack"] = "rbxassetid://10709769841", ["baggage-claim"] = "rbxassetid://10709769935", ["banana"] = "rbxassetid://10709770005", ["banknote"] = "rbxassetid://10709770178", ["bar-chart"] = "rbxassetid://10709773755", ["bar-chart-2"] = "rbxassetid://10709770317", ["bar-chart-3"] = "rbxassetid://10709770431", ["bar-chart-4"] = "rbxassetid://10709770560", ["bar-chart-horizontal"] = "rbxassetid://10709773669", ["barcode"] = "rbxassetid://10747360675", ["baseline"] = "rbxassetid://10709773863", ["bath"] = "rbxassetid://10709773963", ["battery"] = "rbxassetid://10709774640", ["battery-charging"] = "rbxassetid://10709774068", ["battery-full"] = "rbxassetid://10709774206", ["battery-low"] = "rbxassetid://10709774370", ["battery-medium"] = "rbxassetid://10709774513", ["beaker"] = "rbxassetid://10709774756", ["bed"] = "rbxassetid://10709775036", ["bed-double"] = "rbxassetid://10709774864", ["bed-single"] = "rbxassetid://10709774968", ["beer"] = "rbxassetid://10709775167", ["bell"] = "rbxassetid://10709775704", ["bell-minus"] = "rbxassetid://10709775241", ["bell-off"] = "rbxassetid://10709775320", ["bell-plus"] = "rbxassetid://10709775448", ["bell-ring"] = "rbxassetid://10709775560", ["bike"] = "rbxassetid://10709775894", ["binary"] = "rbxassetid://10709776050", ["bitcoin"] = "rbxassetid://10709776126", ["bluetooth"] = "rbxassetid://10709776655", ["bluetooth-connected"] = "rbxassetid://10709776240", ["bluetooth-off"] = "rbxassetid://10709776344", ["bluetooth-searching"] = "rbxassetid://10709776501", ["bold"] = "rbxassetid://10747813908", ["bomb"] = "rbxassetid://10709781460", ["bone"] = "rbxassetid://10709781605", ["book"] = "rbxassetid://10709781824", ["book-open"] = "rbxassetid://10709781717", ["bookmark"] = "rbxassetid://10709782154", ["bookmark-minus"] = "rbxassetid://10709781919", ["bookmark-plus"] = "rbxassetid://10709782044", ["bot"] = "rbxassetid://10709782230", ["box"] = "rbxassetid://10709782497", ["box-select"] = "rbxassetid://10709782342", ["boxes"] = "rbxassetid://10709782582", ["briefcase"] = "rbxassetid://10709782662", ["brush"] = "rbxassetid://10709782758", ["bug"] = "rbxassetid://10709782845", ["building"] = "rbxassetid://10709783051", ["building-2"] = "rbxassetid://10709782939", ["bus"] = "rbxassetid://10709783137", ["chevron-down"] = "rbxassetid://10709790948" }

local Icons = ICONS_V1
local function NormalizeVersion(v) v = tostring(v):lower() if v == "v2" then return "v2" end return "v1" end
function Library:SetIconsVersion(v) Icons = NormalizeVersion(v) == "v2" and ICONS_V2 or ICONS_V1 end
local function GetIcon(name) if not name or name == "" then return nil end local clean = name:lower():gsub("^lucide%-", "") return Icons[clean] end

local ScreenGui = Utility:Create("ScreenGui", {Name = "EnigmaUI_" .. HttpService:GenerateGUID(false), ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 999})
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
Library.ScreenGui = ScreenGui

local NotificationHolder = Utility:Create("Frame", {Name = "Notifications", BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -16, 1, -16), Size = UDim2.new(0, 320, 1, -32), Parent = ScreenGui})
Utility:ListLayout(NotificationHolder, Enum.FillDirection.Vertical, 8, Enum.HorizontalAlignment.Right).VerticalAlignment = Enum.VerticalAlignment.Bottom

function Library:Notify(config)
	local theme = Library:GetTheme()
	local title = config.Title or "Notification"
	local content = config.Content or ""
	local duration = config.Duration or 4
	local frame = Utility:Create("Frame", {Name = "Notification", BackgroundColor3 = theme.Section, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = NotificationHolder, LayoutOrder = -os.clock()})
	Utility:Round(frame, 8)
	Utility:Stroke(frame, theme.SectionBorder, 1)
	Utility:Padding(frame, 12)
	local accent = Utility:Create("Frame", {BackgroundColor3 = theme.Accent, Size = UDim2.new(0, 3, 1, 0), BorderSizePixel = 0, Parent = frame})
	Utility:Round(accent, 2)
	local titleLabel = Utility:Create("TextLabel", {Text = title, Font = theme.FontBold, TextSize = 15, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Size = UDim2.new(1, -8, 0, 18), Position = UDim2.new(0, 8, 0, 0), Parent = frame})
	local contentLabel = Utility:Create("TextLabel", {Text = content, Font = theme.Font, TextSize = 13, TextColor3 = theme.TextDark, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true, BackgroundTransparency = 1, Size = UDim2.new(1, -8, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Position = UDim2.new(0, 8, 0, 20), Parent = frame})
	frame.BackgroundTransparency = 0
	frame.Position = UDim2.new(1, 50, 0, 0)
	Utility:Tween(frame, {Position = UDim2.new(0,0,0,0)}, 0.35)
	task.delay(duration, function() if frame and frame.Parent then Utility:Tween(frame, {Position = UDim2.new(1, 50, 0, 0)}, 0.3) task.delay(0.3, function() if frame then frame:Destroy() end) end end)
	return frame
end

local Window = {} Window.__index = Window
local TabMethods = {} TabMethods.__index = TabMethods
local SectionMethods = {} SectionMethods.__index = SectionMethods
local PanelMethods = {} PanelMethods.__index = PanelMethods

function Library:CreateWindow(config)
	local theme = Library:GetTheme()
	local self = setmetatable({}, Window)
	self.Title = config.Title or "Library"
	self.SubTitle = config.SubTitle or ""
	local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled
	local defaultSize = isMobile and UDim2.fromOffset(480, 380) or UDim2.fromOffset(680, 440)
	self.Size = config.Size or defaultSize
	self.Tabs = {}
	self.CurrentTab = nil
	self.Minimized = false
	
	local Main = Utility:Create("Frame", {Name = "Main", BackgroundColor3 = Color3.fromRGB(12, 12, 16), BackgroundTransparency = 0.04, Position = UDim2.new(0.5, -self.Size.X.Offset/2, 0.5, -self.Size.Y.Offset/2), Size = self.Size, ClipsDescendants = true, Parent = ScreenGui})
	Utility:Round(Main, 12)
	local blur = Utility:Create("Frame", {Name = "Blur", BackgroundColor3 = Color3.fromRGB(255,255,255), Size = UDim2.new(1,0,1,0), ZIndex = -1, BorderSizePixel = 0, Parent = Main})
	local blurCorner = Utility:Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = blur})
	local blurEffect = Utility:Create("BlurEffect", {Size = 16, Parent = blur})
	local gradient = Utility:Create("UIGradient", {Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(0,0,0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(60,60,60))}), Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.6), NumberSequenceKeypoint.new(1, 0.9)}), Parent = blur})
	Utility:Stroke(Main, Color3.fromRGB(40,40,45), 1)
	Library:Tag(Main, "BackgroundColor3", "Background")
	self.Main = Main

	local TopBar = Utility:Create("Frame", {Name = "TopBar", BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 44), Parent = Main})
	Utility:Round(TopBar, 12)
	local TitleLabel = Utility:Create("TextLabel", {Text = self.Title, Font = theme.FontBold, TextSize = isMobile and 16 or 20, TextColor3 = Color3.fromRGB(255,255,255), TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Position = UDim2.new(0, 16, 0, 4), Size = UDim2.new(0, 300, 0, 20), Parent = TopBar})
	Library:Tag(TitleLabel, "TextColor3", "Text")
	local SubTitleLabel = Utility:Create("TextLabel", {Text = self.SubTitle, Font = theme.Font, TextSize = 11, TextColor3 = Color3.fromRGB(200,200,200), BackgroundTransparency = 1, Position = UDim2.new(0, 16, 0, 24), Size = UDim2.new(0, 300, 0, 14), Parent = TopBar})
	Library:Tag(SubTitleLabel, "TextColor3", "TextDark")
	
	local function TopBarButton(icon, offsetX)
		local btn = Utility:Create("TextButton", {Text = "", BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 1, Size = UDim2.new(0, 26, 0, 26), Position = UDim2.new(1, offsetX, 0.5, -13), AutoButtonColor = false, Parent = TopBar})
		Utility:Round(btn, 8)
		local ic = Utility:Create("ImageLabel", {Image = icon or "rbxassetid://3926305904", BackgroundTransparency = 1, Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0.5, -7, 0.5, -7), ImageColor3 = Color3.fromRGB(180,180,180), Parent = btn})
		btn.MouseEnter:Connect(function() Utility:Tween(ic, {ImageColor3 = Color3.fromRGB(255,255,255)}, 0.15) end)
		btn.MouseLeave:Connect(function() Utility:Tween(ic, {ImageColor3 = Color3.fromRGB(180,180,180)}, 0.15) end)
		return btn, ic
	end
	
	local CloseBtn, CloseIcon = TopBarButton("rbxassetid://7072725342", -34)
	local MinimizeBtn, MinimizeIcon = TopBarButton("rbxassetid://7072719338", -66)

	local Body = Utility:Create("Frame", {Name = "Body", BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 44), Size = UDim2.new(1, 0, 1, -44), Parent = Main})
	local Sidebar = Utility:Create("Frame", {Name = "Sidebar", BackgroundColor3 = Color3.fromRGB(20, 20, 25), BackgroundTransparency = 0.1, Size = UDim2.new(0, isMobile and 0 or 150, 1, 0), Parent = Body})
	Library:Tag(Sidebar, "BackgroundColor3", "Sidebar")
	self.Sidebar = Sidebar
	
	local SearchBox = Utility:Create("Frame", {BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.95, Size = UDim2.new(1, -12, 0, 28), Position = UDim2.new(0, 6, 0, 6), Parent = Sidebar})
	Utility:Round(SearchBox, 6)
	local SearchInput = Utility:Create("TextBox", {PlaceholderText = "🔍 Buscar...", Text = "", Font = theme.Font, TextSize = 12, TextColor3 = Color3.fromRGB(255,255,255), PlaceholderColor3 = Color3.fromRGB(150,150,150), BackgroundTransparency = 1, Size = UDim2.new(1, -16, 1, 0), Position = UDim2.new(0, 8, 0, 0), ClearTextOnFocus = false, Parent = SearchBox})
	
	local TabListHolder = Utility:Create("ScrollingFrame", {Name = "TabList", BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 40), Size = UDim2.new(1, 0, 1, -40), ScrollBarThickness = 2, ScrollBarImageColor3 = Color3.fromRGB(80,80,80), CanvasSize = UDim2.new(0,0,0,0), AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = Sidebar})
	Utility:Padding(TabListHolder, 6)
	Utility:ListLayout(TabListHolder, Enum.FillDirection.Vertical, 2)
	self.TabListHolder = TabListHolder

	local ContentArea = Utility:Create("Frame", {Name = "ContentArea", BackgroundColor3 = Color3.fromRGB(16, 16, 20), BackgroundTransparency = 0.05, Position = UDim2.new(0, isMobile and 0 or 150, 0, 0), Size = UDim2.new(1, isMobile and 0 or -150, 1, 0), Parent = Body})
	Library:Tag(ContentArea, "BackgroundColor3", "BackgroundSecondary")
	self.ContentArea = ContentArea

	local TabContentHolder = Utility:Create("Frame", {Name = "TabContentHolder", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Parent = ContentArea})
	self.TabContentHolder = TabContentHolder

	Utility:MakeDraggable(Main, TopBar)

	CloseBtn.MouseButton1Click:Connect(function()
		Utility:Tween(Main, {Size = UDim2.new(Main.Size.X.Scale, Main.Size.X.Offset, 0, 0), BackgroundTransparency = 1}, 0.25)
		task.delay(0.25, function() Main.Visible = false end)
	end)

	MinimizeBtn.MouseButton1Click:Connect(function()
		self.Minimized = not self.Minimized
		if self.Minimized then
			Utility:Tween(Main, {Size = UDim2.new(Main.Size.X.Scale, Main.Size.X.Offset, 0, 44)}, 0.25)
		else
			Utility:Tween(Main, {Size = self.Size}, 0.25)
		end
	end)

	SearchInput:GetPropertyChangedSignal("Text"):Connect(function() self:SearchElements(SearchInput.Text) end)
	table.insert(Library.Windows, self)
	return self
end

function Window:SearchElements(query)
	query = query:lower()
	for _, tabData in pairs(self.Tabs) do
		for _, section in ipairs(tabData.Sections) do
			for _, el in ipairs(section.Elements) do
				if query == "" then el.Frame.Visible = true else local name = (el.Name or ""):lower() el.Frame.Visible = name:find(query, 1, true) ~= nil end
			end
		end
	end
end

function Window:Tab(config)
	local theme = Library:GetTheme()
	local name = config.Name or "Tab"
	local icon = config.Icon
	local TabButton = Utility:Create("TextButton", {Name = name, Text = "", BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 34), AutoButtonColor = false, Parent = self.TabListHolder})
	Utility:Round(TabButton, 6)
	local IconImg local xOffset = 10
	if icon then
		local finalIcon = GetIcon(icon) or icon
		IconImg = Utility:Create("ImageLabel", {Image = finalIcon, BackgroundTransparency = 1, Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, 10, 0.5, -8), ImageColor3 = Color3.fromRGB(180,180,180), Parent = TabButton})
		xOffset = 34
	end
	local TabLabel = Utility:Create("TextLabel", {Text = name, Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = Color3.fromRGB(180,180,180), TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Position = UDim2.new(0, xOffset, 0, 0), Size = UDim2.new(1, -xOffset - 6, 1, 0), Parent = TabButton})
	local Indicator = Utility:Create("Frame", {BackgroundColor3 = theme.Accent, Size = UDim2.new(0, 3, 0, 0), Position = UDim2.new(0, 0, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BorderSizePixel = 0, Parent = TabButton})
	Utility:Round(Indicator, 2)
	local TabPage = Utility:Create("ScrollingFrame", {Name = name .. "Page", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), ScrollBarThickness = 3, ScrollBarImageColor3 = theme.Accent, CanvasSize = UDim2.new(0,0,0,0), AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false, Parent = self.TabContentHolder})
	Utility:Padding(TabPage, 12)
	local ColumnLeft = Utility:Create("Frame", {Name = "ColumnLeft", BackgroundTransparency = 1, Size = UDim2.new(0.5, -6, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = TabPage})
	Utility:ListLayout(ColumnLeft, Enum.FillDirection.Vertical, 10)
	local ColumnRight = Utility:Create("Frame", {Name = "ColumnRight", BackgroundTransparency = 1, Position = UDim2.new(0.5, 6, 0, 0), Size = UDim2.new(0.5, -6, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = TabPage})
	Utility:ListLayout(ColumnRight, Enum.FillDirection.Vertical, 10)
	local tabData = {Name = name, Button = TabButton, Page = TabPage, Indicator = Indicator, Label = TabLabel, Icon = IconImg, Sections = {}, ColumnLeft = ColumnLeft, ColumnRight = ColumnRight}
	local windowSelf = self
	local function SelectTab()
		for _, t in pairs(windowSelf.Tabs) do
			t.Page.Visible = false
			Utility:Tween(t.Label, {TextColor3 = Color3.fromRGB(180,180,180)}, 0.15)
			if t.Icon then Utility:Tween(t.Icon, {ImageColor3 = Color3.fromRGB(180,180,180)}, 0.15) end
			Utility:Tween(t.Indicator, {Size = UDim2.new(0, 3, 0, 0)}, 0.15)
			Utility:Tween(t.Button, {BackgroundTransparency = 1}, 0.15)
		end
		TabPage.Visible = true
		Utility:Tween(TabLabel, {TextColor3 = Color3.fromRGB(255,255,255)}, 0.15)
		if IconImg then Utility:Tween(IconImg, {ImageColor3 = theme.Accent}, 0.15) end
		Utility:Tween(Indicator, {Size = UDim2.new(0, 3, 0, 20)}, 0.15)
		Utility:Tween(TabButton, {BackgroundTransparency = 0.92}, 0.15)
		windowSelf.CurrentTab = tabData
	end
	TabButton.MouseButton1Click:Connect(SelectTab)
	self.Tabs[name] = tabData
	if not self.CurrentTab then SelectTab() end
	return setmetatable({Data = tabData, Window = self}, {__index = TabMethods})
end

function TabMethods:Section(config)
	local theme = Library:GetTheme()
	local side = config.Side == "Right" and self.Data.ColumnRight or self.Data.ColumnLeft
	local title = config.Title or "Section"
	local SectionFrame = Utility:Create("Frame", {Name = title, BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = side})
	Utility:Round(SectionFrame, 8)
	local TitleLabel = Utility:Create("TextLabel", {Text = title, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.fromRGB(255,255,255), TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Size = UDim2.new(1, -20, 0, 24), Position = UDim2.new(0, 10, 0, 0), Parent = SectionFrame})
	Library:Tag(TitleLabel, "TextColor3", "Text")
	local Divider = Utility:Create("Frame", {BackgroundColor3 = Color3.fromRGB(60,60,65), BackgroundTransparency = 0.5, Size = UDim2.new(1, -20, 0, 1), Position = UDim2.new(0, 10, 0, 24), BorderSizePixel = 0, Parent = SectionFrame})
	Library:Tag(Divider, "BackgroundColor3", "Divider")
	local ElementHolder = Utility:Create("Frame", {Name = "Elements", BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 30), Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = SectionFrame})
	Utility:Padding(ElementHolder, 0, 6, 6, 8, 8)
	Utility:ListLayout(ElementHolder, Enum.FillDirection.Vertical, 6)
	local sectionData = {Frame = SectionFrame, ElementHolder = ElementHolder, Elements = {}}
	table.insert(self.Data.Sections, sectionData)
	return setmetatable({Data = sectionData, Tab = self}, {__index = SectionMethods})
end

function SectionMethods:Button(config)
	local theme = Library:GetTheme()
	local name = config.Name or "Button"
	local callback = config.Callback or function() end
	local Frame = Utility:Create("Frame", {Name = name, BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.95, Size = UDim2.new(1, 0, 0, 34), Parent = self.Data.ElementHolder})
	Utility:Round(Frame, 6)
	Utility:Stroke(Frame, Color3.fromRGB(60,60,65), 1)
	local Btn = Utility:Create("TextButton", {Text = "", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), AutoButtonColor = false, Parent = Frame})
	local Label = Utility:Create("TextLabel", {Text = name, Font = theme.Font, TextSize = 13, TextColor3 = Color3.fromRGB(235,235,240), BackgroundTransparency = 1, Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0), TextXAlignment = Enum.TextXAlignment.Left, Parent = Frame})
	Utility:Ripple(Btn, theme.Accent)
	Btn.MouseEnter:Connect(function() Utility:Tween(Frame, {BackgroundTransparency = 0.9}, 0.15) Utility:Tween(Frame.UIStroke, {Color = theme.Accent}, 0.15) end)
	Btn.MouseLeave:Connect(function() Utility:Tween(Frame, {BackgroundTransparency = 0.95}, 0.15) Utility:Tween(Frame.UIStroke, {Color = Color3.fromRGB(60,60,65)}, 0.15) end)
	Btn.MouseButton1Click:Connect(function() task.spawn(callback) end)
	table.insert(self.Data.Elements, {Frame = Frame, Name = name})
	local api = {}
	function api:Set(newName) Label.Text = newName end
	function api:Destroy() Frame:Destroy() end
	return api
end

function SectionMethods:Toggle(config)
	local theme = Library:GetTheme()
	local name = config.Name or "Toggle"
	local default = config.Default or false
	local flag = config.Flag
	local callback = config.Callback or function() end
	local Frame = Utility:Create("Frame", {Name = name, BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.95, Size = UDim2.new(1, 0, 0, 34), Parent = self.Data.ElementHolder})
	Utility:Round(Frame, 6)
	Utility:Stroke(Frame, Color3.fromRGB(60,60,65), 1)
	local Label = Utility:Create("TextLabel", {Text = name, Font = theme.Font, TextSize = 13, TextColor3 = Color3.fromRGB(235,235,240), BackgroundTransparency = 1, Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 10, 0, 0), TextXAlignment = Enum.TextXAlignment.Left, Parent = Frame})
	local Switch = Utility:Create("Frame", {BackgroundColor3 = default and theme.Accent or Color3.fromRGB(60,60,65), Size = UDim2.new(0, 36, 0, 18), Position = UDim2.new(1, -46, 0.5, -9), Parent = Frame})
	Utility:Round(Switch, 9)
	local Knob = Utility:Create("Frame", {BackgroundColor3 = Color3.fromRGB(255,255,255), Size = UDim2.new(0, 14, 0, 14), Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7), Parent = Switch})
	Utility:Round(Knob, 7)
	local Click = Utility:Create("TextButton", {Text = "", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Parent = Frame})
	local state = default
	local function setState(value, fromInit)
		state = value
		Utility:Tween(Switch, {BackgroundColor3 = state and theme.Accent or Color3.fromRGB(60,60,65)}, 0.2)
		Utility:Tween(Knob, {Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}, 0.2)
		if flag then Library.Flags[flag] = state end
		if not fromInit then task.spawn(callback, state) end
	end
	Click.MouseButton1Click:Connect(function() setState(not state) end)
	if flag then Library.Flags[flag] = state end
	table.insert(self.Data.Elements, {Frame = Frame, Name = name})
	local api = {}
	function api:Set(value) setState(value) end
	function api:Get() return state end
	function api:Destroy() Frame:Destroy() end
	return api
end

function SectionMethods:Slider(config)
	local theme = Library:GetTheme()
	local name = config.Name or "Slider"
	local min = config.Min or 0
	local max = config.Max or 100
	local default = config.Default or min
	local suffix = config.Suffix or ""
	local flag = config.Flag
	local callback = config.Callback or function() end
	local Frame = Utility:Create("Frame", {Name = name, BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.95, Size = UDim2.new(1, 0, 0, 44), Parent = self.Data.ElementHolder})
	Utility:Round(Frame, 6)
	Utility:Stroke(Frame, Color3.fromRGB(60,60,65), 1)
	Utility:Padding(Frame, 0, 6, 6, 10, 10)
	local Label = Utility:Create("TextLabel", {Text = name, Font = theme.Font, TextSize = 13, TextColor3 = Color3.fromRGB(235,235,240), BackgroundTransparency = 1, Size = UDim2.new(1, -40, 0, 14), TextXAlignment = Enum.TextXAlignment.Left, Parent = Frame})
	local ValueLabel = Utility:Create("TextLabel", {Text = tostring(default) .. suffix, Font = theme.Font, TextSize = 11, TextColor3 = Color3.fromRGB(180,180,180), BackgroundTransparency = 1, Size = UDim2.new(0, 50, 0, 14), Position = UDim2.new(1, -40, 0, 0), TextXAlignment = Enum.TextXAlignment.Right, Parent = Frame})
	local Track = Utility:Create("Frame", {BackgroundColor3 = Color3.fromRGB(40,40,45), Size = UDim2.new(1, 0, 0, 4), Position = UDim2.new(0, 0, 0, 20), Parent = Frame})
	Utility:Round(Track, 2)
	local Fill = Utility:Create("Frame", {BackgroundColor3 = theme.Accent, Size = UDim2.new((default - min) / (max - min), 0, 1, 0), Parent = Track})
	Utility:Round(Fill, 2)
	local Knob = Utility:Create("Frame", {BackgroundColor3 = Color3.fromRGB(255,255,255), AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0), Parent = Track})
	Utility:Round(Knob, 5)
	local dragging = false
	local value = default
	local function updateFromInput(inputPos)
		local relative = math.clamp((inputPos - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
		value = min + (max - min) * relative
		Fill.Size = UDim2.new(relative, 0, 1, 0)
		Knob.Position = UDim2.new(relative, 0, 0.5, 0)
		ValueLabel.Text = tostring(value) .. suffix
		if flag then Library.Flags[flag] = value end
		task.spawn(callback, value)
	end
	Track.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true updateFromInput(input.Position.X) end end)
	UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateFromInput(input.Position.X) end end)
	UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
	if flag then Library.Flags[flag] = default end
	table.insert(self.Data.Elements, {Frame = Frame, Name = name})
	local api = {}
	function api:Set(v) updateFromInput(Track.AbsolutePosition.X + math.clamp((v-min)/(max-min),0,1)*Track.AbsoluteSize.X) end
	function api:Get() return value end
	function api:Destroy() Frame:Destroy() end
	return api
end

function SectionMethods:Dropdown(config)
	local theme = Library:GetTheme()
	local name = config.Name or "Dropdown"
	local options = config.Options or {}
	local default = config.Default
	local flag = config.Flag
	local callback = config.Callback or function() end
	local Frame = Utility:Create("Frame", {Name = name, BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.95, Size = UDim2.new(1, 0, 0, 34), ClipsDescendants = false, ZIndex = 2, Parent = self.Data.ElementHolder})
	Utility:Round(Frame, 6)
	Utility:Stroke(Frame, Color3.fromRGB(60,60,65), 1)
	local Label = Utility:Create("TextLabel", {Text = name, Font = theme.Font, TextSize = 13, TextColor3 = Color3.fromRGB(235,235,240), BackgroundTransparency = 1, Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.new(0, 10, 0, 0), TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 2, Parent = Frame})
	local SelectedLabel = Utility:Create("TextLabel", {Text = default and tostring(default) or "Selecionar", Font = theme.Font, TextSize = 12, TextColor3 = Color3.fromRGB(180,180,180), BackgroundTransparency = 1, Size = UDim2.new(0.5, -30, 1, 0), Position = UDim2.new(0.5, 0, 0, 0), TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 2, Parent = Frame})
	local Arrow = Utility:Create("ImageLabel", {Image = "rbxassetid://7072706796", BackgroundTransparency = 1, Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(1, -22, 0.5, -6), ImageColor3 = Color3.fromRGB(180,180,180), ZIndex = 2, Parent = Frame})
	local Click = Utility:Create("TextButton", {Text = "", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), ZIndex = 3, Parent = Frame})
	local ListFrame = Utility:Create("Frame", {BackgroundColor3 = Color3.fromRGB(24, 24, 29), Position = UDim2.new(0, 0, 1, 4), Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Visible = false, ZIndex = 10, Parent = Frame})
	Utility:Round(ListFrame, 6)
	Utility:Stroke(ListFrame, Color3.fromRGB(60,60,65), 1)
	Utility:Padding(ListFrame, 4)
	Utility:ListLayout(ListFrame, Enum.FillDirection.Vertical, 2)
	local selected = default
	local optionButtons = {}
	local open = false
	local function toggleOpen() open = not open ListFrame.Visible = open Utility:Tween(Arrow, {Rotation = open and 180 or 0}, 0.15) end
	local function selectOption(opt)
		selected = opt
		SelectedLabel.Text = tostring(opt)
		toggleOpen()
		if flag then Library.Flags[flag] = selected end
		task.spawn(callback, selected)
		for optName, btn in pairs(optionButtons) do local isSelected = selected == optName Utility:Tween(btn, {BackgroundColor3 = isSelected and theme.Accent or Color3.fromRGB(255,255,255), BackgroundTransparency = isSelected and 0.8 or 0.95}, 0.15) end
	end
	Click.MouseButton1Click:Connect(toggleOpen)
	for _, opt in ipairs(options) do
		local OptBtn = Utility:Create("TextButton", {Text = tostring(opt), Font = theme.Font, TextSize = 12, TextColor3 = Color3.fromRGB(235,235,240), BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.95, Size = UDim2.new(1, 0, 0, 26), ZIndex = 11, AutoButtonColor = false, Parent = ListFrame})
		Utility:Round(OptBtn, 4)
		optionButtons[opt] = OptBtn
		OptBtn.MouseButton1Click:Connect(function() selectOption(opt) end)
	end
	if flag then Library.Flags[flag] = selected end
	table.insert(self.Data.Elements, {Frame = Frame, Name = name})
	local api = {}
	function api:Set(v) selectOption(v) end
	function api:Get() return selected end
	function api:Refresh(newOptions) for _, btn in pairs(optionButtons) do btn:Destroy() end optionButtons = {} for _, opt in ipairs(newOptions) do local OptBtn = Utility:Create("TextButton", {Text = tostring(opt), Font = theme.Font, TextSize = 12, TextColor3 = Color3.fromRGB(235,235,240), BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.95, Size = UDim2.new(1, 0, 0, 26), ZIndex = 11, AutoButtonColor = false, Parent = ListFrame}) Utility:Round(OptBtn, 4) optionButtons[opt] = OptBtn OptBtn.MouseButton1Click:Connect(function() selectOption(opt) end) end end
	function api:Destroy() Frame:Destroy() end
	return api
end

function SectionMethods:Textbox(config)
	local theme = Library:GetTheme()
	local name = config.Name or "Textbox"
	local placeholder = config.Placeholder or "..."
	local default = config.Default or ""
	local flag = config.Flag
	local callback = config.Callback or function() end
	local Frame = Utility:Create("Frame", {Name = name, BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.95, Size = UDim2.new(1, 0, 0, 34), Parent = self.Data.ElementHolder})
	Utility:Round(Frame, 6)
	Utility:Stroke(Frame, Color3.fromRGB(60,60,65), 1)
	local Label = Utility:Create("TextLabel", {Text = name, Font = theme.Font, TextSize = 13, TextColor3 = Color3.fromRGB(235,235,240), BackgroundTransparency = 1, Size = UDim2.new(0.4, 0, 1, 0), Position = UDim2.new(0, 10, 0, 0), TextXAlignment = Enum.TextXAlignment.Left, Parent = Frame})
	local Input = Utility:Create("TextBox", {Text = default, PlaceholderText = placeholder, Font = theme.Font, TextSize = 12, TextColor3 = Color3.fromRGB(235,235,240), PlaceholderColor3 = Color3.fromRGB(180,180,180), BackgroundTransparency = 1, Size = UDim2.new(0.6, -10, 1, 0), Position = UDim2.new(0.4, 10, 0, 0), TextXAlignment = Enum.TextXAlignment.Right, ClearTextOnFocus = false, Parent = Frame})
	Input.FocusLost:Connect(function() if flag then Library.Flags[flag] = Input.Text end task.spawn(callback, Input.Text) end)
	if flag then Library.Flags[flag] = default end
	table.insert(self.Data.Elements, {Frame = Frame, Name = name})
	local api = {}
	function api:Set(v) Input.Text = v if flag then Library.Flags[flag] = v end end
	function api:Get() return Input.Text end
	function api:Destroy() Frame:Destroy() end
	return api
end

function SectionMethods:Label(config)
	local theme = Library:GetTheme()
	local text = config.Text or "Label"
	local Frame = Utility:Create("Frame", {Name = "Label", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 18), Parent = self.Data.ElementHolder})
	local TextLbl = Utility:Create("TextLabel", {Text = text, Font = theme.Font, TextSize = 12, TextColor3 = Color3.fromRGB(180,180,180), BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), TextXAlignment = Enum.TextXAlignment.Left, Parent = Frame})
	table.insert(self.Data.Elements, {Frame = Frame, Name = text})
	local api = {}
	function api:Set(v) TextLbl.Text = v end
	function api:Destroy() Frame:Destroy() end
	return api
end

function SectionMethods:Paragraph(config)
	local theme = Library:GetTheme()
	local title = config.Title or "Paragraph"
	local content = config.Content or ""
	local Frame = Utility:Create("Frame", {Name = title, BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.95, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = self.Data.ElementHolder})
	Utility:Round(Frame, 6)
	Utility:Stroke(Frame, Color3.fromRGB(60,60,65), 1)
	Utility:Padding(Frame, 8)
	local TitleLbl = Utility:Create("TextLabel", {Text = title, Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Color3.fromRGB(235,235,240), BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 14), TextXAlignment = Enum.TextXAlignment.Left, Parent = Frame})
	local ContentLbl = Utility:Create("TextLabel", {Text = content, Font = theme.Font, TextSize = 12, TextColor3 = Color3.fromRGB(180,180,180), BackgroundTransparency = 1, TextWrapped = true, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Position = UDim2.new(0, 0, 0, 18), TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, Parent = Frame})
	table.insert(self.Data.Elements, {Frame = Frame, Name = title})
	local api = {}
	function api:Set(newContent) ContentLbl.Text = newContent end
	function api:Destroy() Frame:Destroy() end
	return api
end

function SectionMethods:Keybind(config)
	local theme = Library:GetTheme()
	local name = config.Name or "Keybind"
	local default = config.Default
	local flag = config.Flag
	local callback = config.Callback or function() end
	local changedCallback = config.Changed or function() end
	local Frame = Utility:Create("Frame", {Name = name, BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.95, Size = UDim2.new(1, 0, 0, 34), Parent = self.Data.ElementHolder})
	Utility:Round(Frame, 6)
	Utility:Stroke(Frame, Color3.fromRGB(60,60,65), 1)
	local Label = Utility:Create("TextLabel", {Text = name, Font = theme.Font, TextSize = 13, TextColor3 = Color3.fromRGB(235,235,240), BackgroundTransparency = 1, Size = UDim2.new(1, -90, 1, 0), Position = UDim2.new(0, 10, 0, 0), TextXAlignment = Enum.TextXAlignment.Left, Parent = Frame})
	local KeyButton = Utility:Create("TextButton", {Text = default and default.Name or "Nenhuma", Font = theme.Font, TextSize = 12, TextColor3 = Color3.fromRGB(180,180,180), BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.95, Size = UDim2.new(0, 80, 0, 22), Position = UDim2.new(1, -88, 0.5, -11), AutoButtonColor = false, Parent = Frame})
	Utility:Round(KeyButton, 4)
	local currentKey = default
	local listening = false
	KeyButton.MouseButton1Click:Connect(function() listening = true KeyButton.Text = "..." end)
	local conn = UserInputService.InputBegan:Connect(function(input, gpe)
		if listening then
			if input.UserInputType == Enum.UserInputType.Keyboard then currentKey = input.KeyCode KeyButton.Text = currentKey.Name listening = false if flag then Library.Flags[flag] = currentKey end task.spawn(changedCallback, currentKey) end
			return
		end
		if gpe then return end
		if currentKey and input.KeyCode == currentKey then task.spawn(callback) end
	end)
	table.insert(Library.Connections, conn)
	table.insert(self.Data.Elements, {Frame = Frame, Name = name})
	local api = {}
	function api:Set(keyCode) currentKey = keyCode KeyButton.Text = keyCode and keyCode.Name or "Nenhuma" if flag then Library.Flags[flag] = currentKey end end
	function api:Get() return currentKey end
	function api:Destroy() Frame:Destroy() end
	return api
end

function SectionMethods:ColorPicker(config)
	local theme = Library:GetTheme()
	local name = config.Name or "Color Picker"
	local default = config.Default or Color3.fromRGB(255,255,255)
	local flag = config.Flag
	local callback = config.Callback or function() end
	local Frame = Utility:Create("Frame", {Name = name, BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.95, Size = UDim2.new(1, 0, 0, 34), ClipsDescendants = false, ZIndex = 2, Parent = self.Data.ElementHolder})
	Utility:Round(Frame, 6)
	Utility:Stroke(Frame, Color3.fromRGB(60,60,65), 1)
	local Label = Utility:Create("TextLabel", {Text = name, Font = theme.Font, TextSize = 13, TextColor3 = Color3.fromRGB(235,235,240), BackgroundTransparency = 1, Size = UDim2.new(1, -50, 1, 0), Position = UDim2.new(0, 10, 0, 0), TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 2, Parent = Frame})
	local Preview = Utility:Create("TextButton", {Text = "", BackgroundColor3 = default, Size = UDim2.new(0, 30, 0, 20), Position = UDim2.new(1, -40, 0.5, -10), ZIndex = 2, AutoButtonColor = false, Parent = Frame})
	Utility:Round(Preview, 4)
	Utility:Stroke(Preview, Color3.fromRGB(60,60,65), 1)
	local Popup = Utility:Create("Frame", {BackgroundColor3 = Color3.fromRGB(24, 24, 29), Position = UDim2.new(1, 4, 0, 0), Size = UDim2.new(0, 200, 0, 210), Visible = false, ZIndex = 20, Parent = Frame})
	Utility:Round(Popup, 8)
	Utility:Stroke(Popup, Color3.fromRGB(60,60,65), 1)
	Utility:Padding(Popup, 10)
	local h, s, v = default:ToHSV()
	local SVBox = Utility:Create("ImageButton", {BackgroundColor3 = Color3.fromHSV(h, 1, 1), Size = UDim2.new(1, 0, 0, 120), ZIndex = 21, Parent = Popup})
	Utility:Round(SVBox, 6)
	Utility:Gradient(SVBox, ColorSequence.new(Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255)), 0, NumberSequence.new({NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1)}))
	local SVBlack = Utility:Create("Frame", {BackgroundColor3 = Color3.fromRGB(0,0,0), BackgroundTransparency = 1, Size = UDim2.new(1,0,1,0), ZIndex = 21, Parent = SVBox})
	Utility:Gradient(SVBlack, ColorSequence.new(Color3.fromRGB(0,0,0), Color3.fromRGB(0,0,0)), 90, NumberSequence.new({NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(1,0)}))
	local SVCursor = Utility:Create("Frame", {BackgroundColor3 = Color3.fromRGB(255,255,255), AnchorPoint = Vector2.new(0.5,0.5), Size = UDim2.new(0,8,0,8), Position = UDim2.new(s, 0, 1-v, 0), ZIndex = 22, Parent = SVBox})
	Utility:Round(SVCursor, 4)
	Utility:Stroke(SVCursor, Color3.fromRGB(0,0,0), 1)
	local HueBar = Utility:Create("Frame", {Size = UDim2.new(1, 0, 0, 18), Position = UDim2.new(0, 0, 0, 130), ZIndex = 21, Parent = Popup})
	Utility:Round(HueBar, 4)
	Utility:Gradient(HueBar, ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(0,1,1)), ColorSequenceKeypoint.new(0.17, Color3.fromHSV(0.17,1,1)), ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33,1,1)), ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5,1,1)), ColorSequenceKeypoint.new(0.67, Color3.fromHSV(0.67,1,1)), ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83,1,1)), ColorSequenceKeypoint.new(1, Color3.fromHSV(1,1,1))}))
	local HueButton = Utility:Create("TextButton", {Text = "", BackgroundTransparency = 1, Size = UDim2.new(1,0,1,0), ZIndex = 22, Parent = HueBar})
	local HueCursor = Utility:Create("Frame", {BackgroundColor3 = Color3.fromRGB(255,255,255), AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(0, 4, 1, 4), Position = UDim2.new(h, 0, 0.5, 0), ZIndex = 22, Parent = HueBar})
	local HexBox = Utility:Create("TextBox", {Text = string.format("#%02X%02X%02X", default.R*255, default.G*255, default.B*255), Font = theme.Font, TextSize = 12, TextColor3 = Color3.fromRGB(235,235,240), BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.95, Size = UDim2.new(1, 0, 0, 24), Position = UDim2.new(0, 0, 0, 156), ZIndex = 21, ClearTextOnFocus = false, Parent = Popup})
	Utility:Round(HexBox, 4)
	local currentColor = default
	local function updateColor() currentColor = Color3.fromHSV(h, s, v) SVBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1) Preview.BackgroundColor3 = currentColor HexBox.Text = string.format("#%02X%02X%02X", currentColor.R*255, currentColor.G*255, currentColor.B*255) if flag then Library.Flags[flag] = currentColor end task.spawn(callback, currentColor) end
	local draggingSV, draggingHue = false, false
	SVBox.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingSV = true end end)
	HueButton.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingHue = true end end)
	UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingSV = false draggingHue = false end end)
	UserInputService.InputChanged:Connect(function(input) if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end if draggingSV then local relX = math.clamp((input.Position.X - SVBox.AbsolutePosition.X) / SVBox.AbsoluteSize.X, 0, 1) local relY = math.clamp((input.Position.Y - SVBox.AbsolutePosition.Y) / SVBox.AbsoluteSize.Y, 0, 1) s = relX v = 1 - relY SVCursor.Position = UDim2.new(relX, 0, relY, 0) updateColor() elseif draggingHue then local relX = math.clamp((input.Position.X - HueBar.AbsolutePosition.X) / HueBar.AbsoluteSize.X, 0, 1) h = relX HueCursor.Position = UDim2.new(relX, 0, 0.5, 0) updateColor() end end)
	HexBox.FocusLost:Connect(function() local hex = HexBox.Text:gsub("#", "") if #hex == 6 then local r = tonumber(hex:sub(1,2), 16) local g = tonumber(hex:sub(3,4), 16) local b = tonumber(hex:sub(5,6), 16) if r and g and b then local color = Color3.fromRGB(r, g, b) h, s, v = color:ToHSV() SVCursor.Position = UDim2.new(s, 0, 1-v, 0) HueCursor.Position = UDim2.new(h, 0, 0.5, 0) updateColor() end end end)
	local open = false
	Preview.MouseButton1Click:Connect(function() open = not open Popup.Visible = open end)
	if flag then Library.Flags[flag] = default end
	table.insert(self.Data.Elements, {Frame = Frame, Name = name})
	local api = {}
	function api:Set(color) h, s, v = color:ToHSV() SVCursor.Position = UDim2.new(s, 0, 1-v, 0) HueCursor.Position = UDim2.new(h, 0, 0.5, 0) updateColor() end
	function api:Get() return currentColor end
	function api:Destroy() Frame:Destroy() end
	return api
end

function SectionMethods:Divider() local Line = Utility:Create("Frame", {BackgroundColor3 = Color3.fromRGB(60,60,65), Size = UDim2.new(1, 0, 0, 1), Parent = self.Data.ElementHolder}) table.insert(self.Data.Elements, {Frame = Line, Name = "Divider"}) return {Destroy = function() Line:Destroy() end} end

function SectionMethods:AddFloatingPanel(config)
	local theme = Library:GetTheme()
	local name = config.Name or "Panel"
	local width = config.Width or 240
	local height = config.Height or 300
	local draggable = config.Draggable ~= false
	
	local Panel = Utility:Create("Frame", {Name = name, BackgroundColor3 = Color3.fromRGB(18, 18, 22), BackgroundTransparency = 0.1, Size = UDim2.new(0, width, 0, height), Position = UDim2.new(0, 10, 0, 10), Parent = self.Data.ElementHolder})
	Utility:Round(Panel, 12)
	Utility:Stroke(Panel, Color3.fromRGB(60,60,65), 1)
	Library:Tag(Panel, "BackgroundColor3", "BackgroundSecondary")
	
	local Header = Utility:Create("Frame", {BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 30), Parent = Panel})
	local Title = Utility:Create("TextLabel", {Text = name, Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Color3.fromRGB(235,235,240), BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(1, -20, 1, 0), TextXAlignment = Enum.TextXAlignment.Left, Parent = Header})
	Library:Tag(Title, "TextColor3", "Text")
	if draggable then Utility:MakeDraggable(Panel, Header) end
	
	local ListHolder = Utility:Create("ScrollingFrame", {BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 30), Size = UDim2.new(1, 0, 1, -30), ScrollBarThickness = 3, ScrollBarImageColor3 = Color3.fromRGB(80,80,80), CanvasSize = UDim2.new(0,0,0,0), AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = Panel})
	Utility:Padding(ListHolder, 6)
	Utility:ListLayout(ListHolder, Enum.FillDirection.Vertical, 4)
	
	local api = {}
	function api:AddRow(text, subtitle, status)
		local Row = Utility:Create("Frame", {BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.95, Size = UDim2.new(1, 0, 0, 32), Parent = ListHolder})
		Utility:Round(Row, 6)
		Utility:Stroke(Row, Color3.fromRGB(60,60,65), 1)
		local MainTxt = Utility:Create("TextLabel", {Text = text, Font = theme.Font, TextSize = 13, TextColor3 = Color3.fromRGB(235,235,240), BackgroundTransparency = 1, Position = UDim2.new(0, 8, 0, 0), Size = UDim2.new(1, -80, 0, 16), TextXAlignment = Enum.TextXAlignment.Left, Parent = Row})
		local SubTxt = Utility:Create("TextLabel", {Text = subtitle or "", Font = theme.Font, TextSize = 10, TextColor3 = Color3.fromRGB(150,150,160), BackgroundTransparency = 1, Position = UDim2.new(0, 8, 0, 16), Size = UDim2.new(1, -80, 0, 12), TextXAlignment = Enum.TextXAlignment.Left, Parent = Row})
		local StatusDot = Utility:Create("Frame", {BackgroundColor3 = status or Color3.fromRGB(0,255,0), Size = UDim2.new(0, 6, 0, 6), Position = UDim2.new(1, -12, 0.5, -3), BorderSizePixel = 0, Parent = Row})
		Utility:Round(StatusDot, 3)
	end
	function api:Clear() for _, child in ipairs(ListHolder:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end end
	function api:Destroy() Panel:Destroy() end
	return api
end

local PanelMethods = {}
function PanelMethods:AddItem(text, subtitle, status) end

function SectionMethods:AddMinimizeToggle(config)
	local CoreGui = game:GetService("CoreGui")
	local UIS = game:GetService("UserInputService")
	local Camera = workspace.CurrentCamera
	local existing = CoreGui:FindFirstChild("EnigmaToggle")
	if existing then existing:Destroy() end
	
	config = config or {}
	local MARGIN = 10
	local BTN_W = 48
	local BTN_H = 48
	
	local function clampPos(x, y) local vp = Camera.ViewportSize return math.clamp(x, MARGIN, vp.X - BTN_W - MARGIN), math.clamp(y, MARGIN, vp.Y - BTN_H - MARGIN) end
	
	local MinimizeGUI = Utility:Create("ScreenGui", {Name = "EnigmaToggle", ResetOnSpawn = false, DisplayOrder = 999, IgnoreGuiInset = true})
	pcall(function() MinimizeGUI.Parent = CoreGui end)
	
	local ToggleButton = Utility:Create("ImageButton", {Size = UDim2.new(0, BTN_W, 0, BTN_H), Position = UDim2.new(0, 12, 0, 100), Image = "rbxassetid://18503887946", BackgroundColor3 = Color3.fromRGB(20, 20, 20), BackgroundTransparency = 0.15, BorderSizePixel = 0, ZIndex = 10, Parent = MinimizeGUI})
	Utility:Round(ToggleButton, UDim.new(0.18, 0))
	local UIStroke = Utility:Stroke(ToggleButton, Color3.fromRGB(70,70,70), 1.5)
	
	local dragging = false
	local dragMoved = false
	local lockedInput = nil
	local dragStartPos = Vector2.new(0, 0)
	local startBtnX = 0
	local startBtnY = 0
	
	local function moveTo(x, y) local cx, cy = clampPos(x, y) ToggleButton.Position = UDim2.new(0, cx, 0, cy) end
	
	ToggleButton.InputBegan:Connect(function(input) if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end if dragging then return end dragging = true dragMoved = false lockedInput = input dragStartPos = Vector2.new(input.Position.X, input.Position.Y) startBtnX = ToggleButton.Position.X.Offset startBtnY = ToggleButton.Position.Y.Offset end)
	UIS.InputChanged:Connect(function(input) if not dragging then return end if input ~= lockedInput then return end if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStartPos if delta.Magnitude > 4 then dragMoved = true end moveTo(startBtnX + delta.X, startBtnY + delta.Y) end)
	UIS.InputEnded:Connect(function(input) if input ~= lockedInput then return end dragging = false lockedInput = nil end)
	
	ToggleButton.Activated:Connect(function() if dragMoved then dragMoved = false return end Utility:Tween(ToggleButton, {Size = UDim2.new(0, BTN_W - 6, 0, BTN_H - 6)}, 0.08) task.delay(0.08, function() Utility:Tween(ToggleButton, {Size = UDim2.new(0, BTN_W, 0, BTN_H)}, 0.14) end)
		local mainWindow = Library.Windows[1]
		if mainWindow then
			mainWindow.Main.Visible = not mainWindow.Main.Visible
			if mainWindow.Main.Visible then
				mainWindow.Main.Position = UDim2.new(0.5, -mainWindow.Size.X.Offset/2, 0.5, -mainWindow.Size.Y.Offset/2)
				mainWindow.Main.AnchorPoint = Vector2.new(0, 0)
			end
		end
		Utility:Tween(ToggleButton, {BackgroundTransparency = mainWindow.Main.Visible and 0.15 or 0.55}, 0.2)
		Utility:Tween(UIStroke, {Transparency = mainWindow.Main.Visible and 0 or 0.6}, 0.2)
	end)
	
	local api = {}
	function api:SetImage(id) ToggleButton.Image = id end
	function api:Destroy() MinimizeGUI:Destroy() end
	return api
end

function Library:SaveConfig(fileName)
	fileName = fileName or "enigmaconfig"
	local ok, encoded = pcall(function() return HttpService:JSONEncode(Library.Flags) end)
	if ok and writefile then pcall(function() writefile(fileName .. ".json", encoded) end) return true end
	return false
end

function Library:LoadConfig(fileName)
	fileName = fileName or "enigmaconfig"
	if not (isfile and isfile(fileName .. ".json")) then return false end
	local ok, decoded = pcall(function() return HttpService:JSONDecode(readfile(fileName .. ".json")) end)
	if ok and decoded then for k, v in pairs(decoded) do Library.Flags[k] = v end return true end
	return false
end

function Library:Destroy()
	Library.Unloaded = true
	for _, conn in ipairs(Library.Connections) do pcall(function() conn:Disconnect() end) end
	Library.Connections = {}
	if ScreenGui then ScreenGui:Destroy() end
end

Library.Loaded = true
local Meta = {}
Meta.__index = Library
setmetatable(Library, Meta)

return Library		Element = Color3.fromRGB(28, 28, 34),
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

local IconManager = {}
Library.IconManager = IconManager

IconManager.Icons = setmetatable({}, {__index = function() return "rbxassetid://3926305904" end})

function IconManager:Get(name)
	return IconManager.Icons[name]
end

function IconManager:Register(name, id)
	IconManager.Icons[name] = id
end

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
