local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local UI = {}
UI.__index = UI

local function create(class, props)
    local obj = Instance.new(class)
    for k,v in pairs(props or {}) do
        if k ~= "Parent" then
            obj[k] = v
        end
    end
    if props.Parent then
        obj.Parent = props.Parent
    end
    return obj
end

function UI.new(config)
    local self = setmetatable({}, UI)
    config = config or {}
    
    self.tabs = {}
    self.activeTab = nil
    self.detailView = nil
    
    local gui = create("ScreenGui", {
        Name = "CobaltUI",
        Parent = gethui and gethui() or CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    local main = create("Frame", {
        Name = "Main",
        Parent = gui,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 800, 0, 550),
        BackgroundColor3 = Color3.fromRGB(16, 16, 20),
        BorderSizePixel = 0
    })
    
    create("UICorner", {
        Parent = main,
        CornerRadius = UDim.new(0, 8)
    })
    
    local topbar = create("Frame", {
        Name = "Topbar",
        Parent = main,
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = Color3.fromRGB(20, 20, 24),
        BorderSizePixel = 0
    })
    
    create("UICorner", {
        Parent = topbar,
        CornerRadius = UDim.new(0, 8)
    })
    
    create("Frame", {
        Parent = topbar,
        Position = UDim2.new(0, 0, 1, -8),
        Size = UDim2.new(1, 0, 0, 8),
        BackgroundColor3 = Color3.fromRGB(20, 20, 24),
        BorderSizePixel = 0
    })
    
    create("TextLabel", {
        Name = "Title",
        Parent = topbar,
        Position = UDim2.new(0, 16, 0, 0),
        Size = UDim2.new(0, 200, 1, 0),
        BackgroundTransparency = 1,
        Text = "Cobalt",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBold
    })
    
    local close = create("TextButton", {
        Name = "Close",
        Parent = topbar,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -12, 0.5, 0),
        Size = UDim2.new(0, 20, 0, 20),
        BackgroundTransparency = 1,
        Text = "×",
        TextColor3 = Color3.fromRGB(180, 180, 190),
        TextSize = 20,
        Font = Enum.Font.GothamBold
    })
    
    close.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)
    
    close.MouseEnter:Connect(function()
        close.TextColor3 = Color3.fromRGB(255, 70, 70)
    end)
    
    close.MouseLeave:Connect(function()
        close.TextColor3 = Color3.fromRGB(180, 180, 190)
    end)
    
    local sidebar = create("Frame", {
        Name = "Sidebar",
        Parent = main,
        Position = UDim2.new(0, 0, 0, 36),
        Size = UDim2.new(0, 180, 1, -36),
        BackgroundColor3 = Color3.fromRGB(20, 20, 24),
        BorderSizePixel = 0
    })
    
    create("Frame", {
        Parent = sidebar,
        Position = UDim2.new(0, 0, 1, -8),
        Size = UDim2.new(1, 0, 0, 8),
        BackgroundColor3 = Color3.fromRGB(20, 20, 24),
        BorderSizePixel = 0
    })
    
    local tabContainer = create("ScrollingFrame", {
        Name = "Tabs",
        Parent = sidebar,
        Position = UDim2.new(0, 0, 0, 8),
        Size = UDim2.new(1, 0, 1, -8),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    })
    
    create("UIListLayout", {
        Parent = tabContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2)
    })
    
    create("UIPadding", {
        Parent = tabContainer,
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingTop = UDim.new(0, 4)
    })
    
    local content = create("Frame", {
        Name = "Content",
        Parent = main,
        Position = UDim2.new(0, 180, 0, 36),
        Size = UDim2.new(1, -180, 1, -36),
        BackgroundColor3 = Color3.fromRGB(16, 16, 20),
        BorderSizePixel = 0
    })
    
    local listPanel = create("Frame", {
        Name = "List",
        Parent = content,
        Position = UDim2.new(0, 12, 0, 12),
        Size = UDim2.new(1, -24, 1, -24),
        BackgroundColor3 = Color3.fromRGB(20, 20, 24),
        BorderSizePixel = 0
    })
    
    create("UICorner", {
        Parent = listPanel,
        CornerRadius = UDim.new(0, 6)
    })
    
    local listHeader = create("Frame", {
        Name = "Header",
        Parent = listPanel,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Color3.fromRGB(24, 24, 28),
        BorderSizePixel = 0
    })
    
    create("UICorner", {
        Parent = listHeader,
        CornerRadius = UDim.new(0, 6)
    })
    
    create("Frame", {
        Parent = listHeader,
        Position = UDim2.new(0, 0, 1, -6),
        Size = UDim2.new(1, 0, 0, 6),
        BackgroundColor3 = Color3.fromRGB(24, 24, 28),
        BorderSizePixel = 0
    })
    
    local directionSwitch = create("Frame", {
        Name = "DirectionSwitch",
        Parent = listHeader,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 200, 0, 28),
        BackgroundColor3 = Color3.fromRGB(18, 18, 22),
        BorderSizePixel = 0
    })
    
    create("UICorner", {
        Parent = directionSwitch,
        CornerRadius = UDim.new(0, 5)
    })
    
    local outgoingBtn = create("TextButton", {
        Name = "Outgoing",
        Parent = directionSwitch,
        Position = UDim2.new(0, 2, 0, 2),
        Size = UDim2.new(0.5, -2, 1, -4),
        BackgroundColor3 = Color3.fromRGB(90, 60, 180),
        BorderSizePixel = 0,
        Text = "Outgoing",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 11,
        Font = Enum.Font.GothamMedium
    })
    
    create("UICorner", {
        Parent = outgoingBtn,
        CornerRadius = UDim.new(0, 4)
    })
    
    local incomingBtn = create("TextButton", {
        Name = "Incoming",
        Parent = directionSwitch,
        Position = UDim2.new(0.5, 0, 0, 2),
        Size = UDim2.new(0.5, -2, 1, -4),
        BackgroundColor3 = Color3.fromRGB(28, 28, 32),
        BorderSizePixel = 0,
        Text = "Incoming",
        TextColor3 = Color3.fromRGB(140, 140, 150),
        TextSize = 11,
        Font = Enum.Font.GothamMedium
    })
    
    create("UICorner", {
        Parent = incomingBtn,
        CornerRadius = UDim.new(0, 4)
    })
    
    self.directionSwitch = {
        outgoing = outgoingBtn,
        incoming = incomingBtn,
        current = "outgoing"
    }
    
    outgoingBtn.MouseButton1Click:Connect(function()
        if self.directionSwitch.current == "outgoing" then return end
        self.directionSwitch.current = "outgoing"
        outgoingBtn.BackgroundColor3 = Color3.fromRGB(90, 60, 180)
        outgoingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        incomingBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
        incomingBtn.TextColor3 = Color3.fromRGB(140, 140, 150)
        if self.onDirectionChange then
            self.onDirectionChange("outgoing")
        end
    end)
    
    incomingBtn.MouseButton1Click:Connect(function()
        if self.directionSwitch.current == "incoming" then return end
        self.directionSwitch.current = "incoming"
        incomingBtn.BackgroundColor3 = Color3.fromRGB(90, 60, 180)
        incomingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        outgoingBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
        outgoingBtn.TextColor3 = Color3.fromRGB(140, 140, 150)
        if self.onDirectionChange then
            self.onDirectionChange("incoming")
        end
    end)
    
    local listScroll = create("ScrollingFrame", {
        Name = "Scroll",
        Parent = listPanel,
        Position = UDim2.new(0, 0, 0, 40),
        Size = UDim2.new(1, 0, 1, -40),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Color3.fromRGB(50, 50, 60),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    })
    
    create("UIListLayout", {
        Parent = listScroll,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 1)
    })
    
    create("UIPadding", {
        Parent = listScroll,
        PaddingLeft = UDim.new(0, 6),
        PaddingRight = UDim.new(0, 6),
        PaddingTop = UDim.new(0, 6),
        PaddingBottom = UDim.new(0, 6)
    })
    
    local dragStart, startPos
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragStart = nil
                end
            end)
        end
    end)
    
    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragStart then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    self.gui = gui
    self.main = main
    self.tabContainer = tabContainer
    self.listScroll = listScroll
    self.content = content
    self.directionSwitch = nil
    self.onDirectionChange = nil
    
    local tabs = {
        {id="RemoteSpy", name="Remote Spy", icon="rbxassetid://3926305904", rect=Vector2.new(324,364), size=Vector2.new(36,36)},
        {id="ScriptExplorer", name="Script Explorer", icon="rbxassetid://3926305904", rect=Vector2.new(324,4), size=Vector2.new(36,36)},
        {id="FunctionExplorer", name="Function Explorer", icon="rbxassetid://3926305904", rect=Vector2.new(404,364), size=Vector2.new(36,36)},
        {id="ThreadExplorer", name="Thread Explorer", icon="rbxassetid://3926307971", rect=Vector2.new(404,4), size=Vector2.new(36,36)},
        {id="InstanceExplorer", name="Instance Explorer", icon="rbxassetid://3926305904", rect=Vector2.new(764,324), size=Vector2.new(36,36)},
        {id="GCExplorer", name="GC Explorer", icon="rbxassetid://3926305904", rect=Vector2.new(644,364), size=Vector2.new(36,36)},
        {id="ActorExplorer", name="Actor Explorer", icon="rbxassetid://3926305904", rect=Vector2.new(564,364), size=Vector2.new(36,36)},
        {id="Logs", name="Logs", icon="rbxassetid://3926305904", rect=Vector2.new(524,324), size=Vector2.new(36,36)},
        {id="Settings", name="Settings", icon="rbxassetid://3926305904", rect=Vector2.new(844,324), size=Vector2.new(36,36)}
    }
    
    for i, tabData in ipairs(tabs) do
        self:CreateTab(tabData, i)
    end
    
    return self
end

function UI:CreateTab(data, order)
    local btn = create("TextButton", {
        Name = data.id,
        Parent = self.tabContainer,
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = Color3.fromRGB(24, 24, 28),
        BorderSizePixel = 0,
        Text = "",
        LayoutOrder = order,
        AutoButtonColor = false
    })
    
    create("UICorner", {
        Parent = btn,
        CornerRadius = UDim.new(0, 5)
    })
    
    local icon = create("ImageLabel", {
        Name = "Icon",
        Parent = btn,
        Position = UDim2.new(0, 10, 0.5, -9),
        Size = UDim2.new(0, 18, 0, 18),
        BackgroundTransparency = 1,
        Image = data.icon,
        ImageRectOffset = data.rect,
        ImageRectSize = data.size,
        ImageColor3 = Color3.fromRGB(130, 130, 140)
    })
    
    local label = create("TextLabel", {
        Name = "Label",
        Parent = btn,
        Position = UDim2.new(0, 36, 0, 0),
        Size = UDim2.new(1, -44, 1, 0),
        BackgroundTransparency = 1,
        Text = data.name,
        TextColor3 = Color3.fromRGB(130, 130, 140),
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham
    })
    
    local badge = create("TextLabel", {
        Name = "Badge",
        Parent = btn,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -8, 0.5, 0),
        Size = UDim2.new(0, 0, 0, 16),
        BackgroundColor3 = Color3.fromRGB(32, 32, 38),
        Text = "",
        TextColor3 = Color3.fromRGB(110, 110, 120),
        TextSize = 10,
        Font = Enum.Font.GothamMedium,
        Visible = false,
        AutomaticSize = Enum.AutomaticSize.X
    })
    
    create("UICorner", {
        Parent = badge,
        CornerRadius = UDim.new(0, 3)
    })
    
    create("UIPadding", {
        Parent = badge,
        PaddingLeft = UDim.new(0, 6),
        PaddingRight = UDim.new(0, 6)
    })
    
    btn.MouseButton1Click:Connect(function()
        self:SelectTab(data.id)
    end)
    
    btn.MouseEnter:Connect(function()
        if self.activeTab ~= data.id then
            btn.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if self.activeTab ~= data.id then
            btn.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
        end
    end)
    
    self.tabs[data.id] = {
        button = btn,
        icon = icon,
        label = label,
        badge = badge,
        items = {}
    }
end

function UI:SelectTab(id)
    if not self.tabs[id] then return end
    
    for tabId, tab in pairs(self.tabs) do
        if tabId == id then
            tab.button.BackgroundColor3 = Color3.fromRGB(90, 60, 180)
            tab.icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
            tab.label.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            tab.button.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
            tab.icon.ImageColor3 = Color3.fromRGB(130, 130, 140)
            tab.label.TextColor3 = Color3.fromRGB(130, 130, 140)
        end
    end
    
    self.activeTab = id
    self.detailView = nil
    
    if id == "RemoteSpy" and self.directionSwitch then
        self.directionSwitch.outgoing.Visible = true
        self.directionSwitch.incoming.Visible = true
    elseif self.directionSwitch then
        self.directionSwitch.outgoing.Visible = false
        self.directionSwitch.incoming.Visible = false
    end
    
    self:RenderList(id)
end

function UI:Add(tabId, item)
    if not self.tabs[tabId] then return end
    
    table.insert(self.tabs[tabId].items, item)
    local count = #self.tabs[tabId].items
    self.tabs[tabId].badge.Text = tostring(count)
    self.tabs[tabId].badge.Visible = count > 0
    
    if self.activeTab == tabId then
        self:RenderList(tabId)
    end
end

function UI:RenderList(tabId)
    for _, child in pairs(self.listScroll:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end
    
    create("UIListLayout", {
        Parent = self.listScroll,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 1)
    })
    
    create("UIPadding", {
        Parent = self.listScroll,
        PaddingLeft = UDim.new(0, 6),
        PaddingRight = UDim.new(0, 6),
        PaddingTop = UDim.new(0, 6),
        PaddingBottom = UDim.new(0, 6)
    })
    
    local tab = self.tabs[tabId]
    if not tab then return end
    
    if tabId == "RemoteSpy" and self.directionSwitch then
        local direction = self.directionSwitch.current
        for i, item in ipairs(tab.items) do
            if item.direction == direction or direction == "all" then
                self:CreateListItem(item, i)
            end
        end
    else
        for i, item in ipairs(tab.items) do
            self:CreateListItem(item, i)
        end
    end
end

function UI:CreateListItem(item, order)
    local itemFrame = create("Frame", {
        Name = tostring(item.name or item.path or "Item"),
        Parent = self.listScroll,
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = Color3.fromRGB(24, 24, 28),
        BorderSizePixel = 0,
        LayoutOrder = order
    })
    
    create("UICorner", {
        Parent = itemFrame,
        CornerRadius = UDim.new(0, 4)
    })
    
    local indicator = create("Frame", {
        Name = "Indicator",
        Parent = itemFrame,
        Size = UDim2.new(0, 3, 1, 0),
        BackgroundColor3 = Color3.fromRGB(90, 60, 180),
        BorderSizePixel = 0
    })
    
    create("UICorner", {
        Parent = indicator,
        CornerRadius = UDim.new(0, 1)
    })
    
    local title = create("TextLabel", {
        Name = "Title",
        Parent = itemFrame,
        Position = UDim2.new(0, 12, 0, 6),
        Size = UDim2.new(1, -16, 0, 16),
        BackgroundTransparency = 1,
        Text = tostring(item.name or item.path or "Unknown"),
        TextColor3 = Color3.fromRGB(220, 220, 230),
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamMedium,
        TextTruncate = Enum.TextTruncate.AtEnd
    })
    
    local subtitle = create("TextLabel", {
        Name = "Subtitle",
        Parent = itemFrame,
        Position = UDim2.new(0, 12, 0, 24),
        Size = UDim2.new(1, -16, 0, 12),
        BackgroundTransparency = 1,
        Text = tostring(item.method or item.type or item.source or ""),
        TextColor3 = Color3.fromRGB(110, 110, 120),
        TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham,
        TextTruncate = Enum.TextTruncate.AtEnd
    })
    
    local btn = create("TextButton", {
        Parent = itemFrame,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = ""
    })
    
    btn.MouseButton1Click:Connect(function()
        self:OpenDetailView(item)
    end)
    
    btn.MouseEnter:Connect(function()
        itemFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 30)
    end)
    
    btn.MouseLeave:Connect(function()
        itemFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
    end)
end

function UI:OpenDetailView(item)
    if not item then return end
    
    self.detailView = item
    self:RenderDetailView()
end

function UI:RenderDetailView()
    if not self.detailView then return end
    
    for _, child in pairs(self.content:GetChildren()) do
        child:Destroy()
    end
    
    local detailPanel = create("Frame", {
        Name = "DetailView",
        Parent = self.content,
        Position = UDim2.new(0, 12, 0, 12),
        Size = UDim2.new(1, -24, 1, -24),
        BackgroundColor3 = Color3.fromRGB(20, 20, 24),
        BorderSizePixel = 0
    })
    
    create("UICorner", {
        Parent = detailPanel,
        CornerRadius = UDim.new(0, 6)
    })
    
    local header = create("Frame", {
        Name = "Header",
        Parent = detailPanel,
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Color3.fromRGB(24, 24, 28),
        BorderSizePixel = 0
    })
    
    create("UICorner", {
        Parent = header,
        CornerRadius = UDim.new(0, 6)
    })
    
    create("Frame", {
        Parent = header,
        Position = UDim2.new(0, 0, 1, -6),
        Size = UDim2.new(1, 0, 0, 6),
        BackgroundColor3 = Color3.fromRGB(24, 24, 28),
        BorderSizePixel = 0
    })
    
    local back = create("TextButton", {
        Name = "Back",
        Parent = header,
        Position = UDim2.new(0, 12, 0.5, -15),
        Size = UDim2.new(0, 30, 0, 30),
        BackgroundColor3 = Color3.fromRGB(28, 28, 32),
        BorderSizePixel = 0,
        Text = "←",
        TextColor3 = Color3.fromRGB(200, 200, 210),
        TextSize = 16,
        Font = Enum.Font.GothamBold
    })
    
    create("UICorner", {
        Parent = back,
        CornerRadius = UDim.new(0, 4)
    })
    
    back.MouseButton1Click:Connect(function()
        self:SelectTab(self.activeTab)
    end)
    
    back.MouseEnter:Connect(function()
        back.BackgroundColor3 = Color3.fromRGB(32, 32, 36)
    end)
    
    back.MouseLeave:Connect(function()
        back.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
    end)
    
    create("TextLabel", {
        Name = "Title",
        Parent = header,
        Position = UDim2.new(0, 50, 0, 0),
        Size = UDim2.new(1, -50, 1, 0),
        BackgroundTransparency = 1,
        Text = tostring(self.detailView.name or self.detailView.path or "Details"),
        TextColor3 = Color3.fromRGB(240, 240, 245),
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBold
    })
    
    local scroll = create("ScrollingFrame", {
        Name = "Scroll",
        Parent = detailPanel,
        Position = UDim2.new(0, 0, 0, 50),
        Size = UDim2.new(1, 0, 1, -50),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Color3.fromRGB(50, 50, 60),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    })
    
    local scrollContent = create("Frame", {
        Name = "Content",
        Parent = scroll,
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y
    })
    
    create("UIListLayout", {
        Parent = scrollContent,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8)
    })
    
    create("UIPadding", {
        Parent = scrollContent,
        PaddingLeft = UDim.new(0, 16),
        PaddingRight = UDim.new(0, 16),
        PaddingTop = UDim.new(0, 16),
        PaddingBottom = UDim.new(0, 16)
    })
    
    self:PopulateDetails(scrollContent)
end

function UI:PopulateDetails(parent)
    local item = self.detailView
    
    if item.args and #item.args > 0 then
        self:CreateSection(parent, "Arguments", function(content)
            for i, arg in ipairs(item.args) do
                self:AddProperty(content, "Arg " .. i, tostring(arg))
            end
        end, 1)
    end
    
    if item.callstack and #item.callstack > 0 then
        self:CreateSection(parent, "Call Stack", function(content)
            for i, frame in ipairs(item.callstack) do
                self:AddProperty(content, "#" .. i, frame.source .. ":" .. frame.line)
            end
        end, 2)
    end
    
    if item.origin then
        self:CreateSection(parent, "Origin", function(content)
            if item.origin.script then
                self:AddProperty(content, "Script", item.origin.name or "Unknown")
            end
            if item.origin.path then
                self:AddProperty(content, "Path", item.origin.path)
            end
            if item.origin.hash then
                self:AddProperty(content, "Hash", item.origin.hash)
            end
        end, 3)
    end
    
    if item.origin and item.origin.decompiled then
        self:CreateSection(parent, "Decompiled Source", function(content)
            self:AddCodeBlock(content, item.origin.decompiled)
        end, 4)
    end
    
    if item.constants and #item.constants > 0 then
        self:CreateSection(parent, "Constants", function(content)
            for i, const in ipairs(item.constants) do
                self:AddProperty(content, "#" .. i, tostring(const))
            end
        end, 5)
    end
    
    if item.upvalues and #item.upvalues > 0 then
        self:CreateSection(parent, "Upvalues", function(content)
            for i, upval in ipairs(item.upvalues) do
                self:AddProperty(content, "#" .. i, tostring(upval))
            end
        end, 6)
    end
    
    if item.protos and #item.protos > 0 then
        self:CreateSection(parent, "Prototypes", function(content)
            for i, proto in ipairs(item.protos) do
                self:AddProperty(content, "#" .. i, proto.name or "Prototype")
            end
        end, 7)
    end
end

function UI:CreateSection(parent, name, populateFunc, order)
    local section = create("Frame", {
        Name = name,
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = order
    })
    
    local header = create("TextButton", {
        Name = "Header",
        Parent = section,
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = Color3.fromRGB(24, 24, 28),
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false
    })
    
    create("UICorner", {
        Parent = header,
        CornerRadius = UDim.new(0, 5)
    })
    
    local arrow = create("TextLabel", {
        Name = "Arrow",
        Parent = header,
        Position = UDim2.new(0, 12, 0, 0),
        Size = UDim2.new(0, 20, 1, 0),
        BackgroundTransparency = 1,
        Text = "▶",
        TextColor3 = Color3.fromRGB(130, 130, 140),
        TextSize = 10,
        Font = Enum.Font.Gotham
    })
    
    local label = create("TextLabel", {
        Name = "Label",
        Parent = header,
        Position = UDim2.new(0, 36, 0, 0),
        Size = UDim2.new(1, -36, 1, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Color3.fromRGB(200, 200, 210),
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamMedium
    })
    
    local content = create("Frame", {
        Name = "Content",
        Parent = section,
        Position = UDim2.new(0, 0, 0, 40),
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y,
        Visible = false
    })
    
    create("UIListLayout", {
        Parent = content,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 6)
    })
    
    create("UIPadding", {
        Parent = content,
        PaddingLeft = UDim.new(0, 12),
        PaddingTop = UDim.new(0, 4),
        PaddingBottom = UDim.new(0, 4)
    })
    
    header.MouseButton1Click:Connect(function()
        content.Visible = not content.Visible
        arrow.Text = content.Visible and "▼" or "▶"
    end)
    
    if populateFunc then
        populateFunc(content)
    end
end

function UI:AddProperty(parent, key, value)
    local row = create("Frame", {
        Name = key,
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y
    })
    
    create("TextLabel", {
        Name = "Key",
        Parent = row,
        Size = UDim2.new(0, 100, 0, 18),
        BackgroundTransparency = 1,
        Text = key,
        TextColor3 = Color3.fromRGB(130, 130, 140),
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham
    })
    
    create("TextLabel", {
        Name = "Value",
        Parent = row,
        Position = UDim2.new(0, 105, 0, 0),
        Size = UDim2.new(1, -105, 0, 18),
        BackgroundTransparency = 1,
        Text = value,
        TextColor3 = Color3.fromRGB(200, 200, 210),
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham,
        TextWrapped = true,
        AutomaticSize = Enum.AutomaticSize.Y
    })
end

function UI:AddCodeBlock(parent, code)
    local codeFrame = create("Frame", {
        Name = "CodeBlock",
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 200),
        BackgroundColor3 = Color3.fromRGB(18, 18, 22),
        BorderSizePixel = 0
    })
    
    create("UICorner", {
        Parent = codeFrame,
        CornerRadius = UDim.new(0, 4)
    })
    
    local codeScroll = create("ScrollingFrame", {
        Parent = codeFrame,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Color3.fromRGB(50, 50, 60),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    })
    
    create("TextLabel", {
        Name = "Code",
        Parent = codeScroll,
        Size = UDim2.new(1, -16, 0, 0),
        Position = UDim2.new(0, 8, 0, 8),
        BackgroundTransparency = 1,
        Text = code,
        TextColor3 = Color3.fromRGB(200, 200, 210),
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        Font = Enum.Font.Code,
        TextWrapped = true,
        AutomaticSize = Enum.AutomaticSize.Y
    })
end

function UI:Clear(tabId)
    if not self.tabs[tabId] then return end
    self.tabs[tabId].items = {}
    self.tabs[tabId].badge.Text = ""
    self.tabs[tabId].badge.Visible = false
    if self.activeTab == tabId then
        self:RenderList(tabId)
    end
end

function UI:SetDirectionChangeCallback(callback)
    self.onDirectionChange = callback
end

function UI:Destroy()
    if self.gui then
        self.gui:Destroy()
    end
end

return UI
