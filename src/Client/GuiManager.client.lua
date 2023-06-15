--[[
    GuiManager.client.lua
    Created for the 2020 Winter Roblox Game Jam
    Handles the game UI system
]]--

--[[ 
    Setting up local variables
]]--
local Player = game:GetService("Players").LocalPlayer
local Character = nil
Player.CharacterAdded:Connect(function(char) --Keep track of character
    Character = char
end)
local CurrentCamera = workspace.CurrentCamera
local Currency = Player:WaitForChild("Currency")
local CandyCanes = Currency.CandyCane
local Inventory = Player:WaitForChild("Inventory")
local SleighFolder = Inventory.OwnedSleigh
local PresentsFolder = Inventory.Presents
local RunService = game:GetService("RunService")
local TweenService = game:GetService('TweenService')
local Info = TweenInfo.new(3,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,0,false,0)
local Gui = Player:WaitForChild("PlayerGui",math.huge)
local InventoryGui = Gui:WaitForChild("InventoryGui")
local InventoryFrame = InventoryGui.InventoryFrame
local InventoryButton = InventoryGui.InventoryButton
local WhiteBorder = InventoryFrame.WhiteBorder
local BlueBorder = WhiteBorder.BlueBorder
local DecorFrame = BlueBorder.DecorFrame
local PresentsFrame = BlueBorder.PresentsFrame
local RightArrow = WhiteBorder.ArrowRight
local LeftArrow = WhiteBorder.ArrowLeft
local FrameCounter = WhiteBorder.FrameNumber
local Tabs = BlueBorder:GetChildren()
local TabText = WhiteBorder.Cloud.TabText
local TabNames = {"Pets","Decorations","Presents"}

local CurrencyGui = Gui.CurrencyGui
local CurrencyFrame = CurrencyGui.CurrencyFrame
local CurrencyImage = CurrencyFrame.CurrencyImage
local TextAmount = CurrencyImage.Amount

local Signs = workspace.Signs

local Open = false
local InProgress = false
local TabChangeInProgress = false
local Change = nil
local BeamBool = false


--[[
    Main part of the script, setups up event connections and changes UI for the player that is joining
]]--
InventoryFrame.Position = UDim2.new(1,0,0.5,0)

InventoryButton.MouseButton1Click:Connect(function() --Inventory UI event
        if not Open and not InProgress then
            InventoryFrame.Visible = true
            Open = true
            InventoryFrame:TweenPosition(
                UDim2.new(0,0,0.5,0),
                Enum.EasingDirection.InOut,
                Enum.EasingStyle.Sine,
                1,
                true
            )
        elseif Open and not InProgress then
            Open = false
            local tween = TweenService:Create(InventoryFrame,TweenInfo.new(1),{Position = UDim2.new(1,0,0.5,0)})
            tween:Play()
            InProgress = true
            tween.Completed:Wait()
            InventoryFrame.Visible = false
            InProgress = false
        end
end)

for i,v in ipairs(Tabs) do
    if not v:IsA("Frame") then
        table.remove(Tabs,i)
    end
end

--Inventory tab changing
RightArrow.MouseButton1Click:Connect(function()
    if FrameCounter.Value ~= 1 and not TabChangeInProgress then
        FrameCounter.Value -= 1
        Change = -1
        LeftArrow.Visible = true
    end
    if FrameCounter.Value == 1 then
        RightArrow.Visible = false
    end
end)

LeftArrow.MouseButton1Click:Connect(function()
    if FrameCounter.Value ~= #Tabs and not TabChangeInProgress then
        FrameCounter.Value += 1
        Change = 1
        RightArrow.Visible = true
    end
    if FrameCounter.Value == #Tabs then
        LeftArrow.Visible = false
    end
end)

FrameCounter.Changed:Connect(function()
    if not TabChangeInProgress then
    TabChangeInProgress = true
    TabText.Text = TabNames[FrameCounter.Value]
    RunService.Heartbeat:Wait()
    for i,v in ipairs(Tabs) do
        v:TweenPosition(
            UDim2.new(v.Position.X.Scale + Change,0,0,0),
            Enum.EasingDirection.InOut,
            Enum.EasingStyle.Sine,
            1
        )
    end
    wait(1)
    TabChangeInProgress = false
end
end)

--Setting up currency UI
RunService.Heartbeat:Wait()
TextAmount.Text = CandyCanes.Value

CandyCanes.Changed:Connect(function()
    TextAmount.Text = CandyCanes.Value
end)

--Setting up Inventory Presents UI
for i,v in ipairs(PresentsFrame:GetChildren()) do
    if v:IsA("ImageButton") then
        v.Visible = false
        end
end

for i,v in ipairs(PresentsFolder:GetChildren()) do
    --Present UI got changed
    v.Changed:Connect(function(value)
        if value then
        for z,x in pairs(PresentsFrame:GetChildren()) do
            if x:IsA("ImageButton") then --Active present
                local first = string.match(v.Name,"%d")
                local second = string.match(x.Name,"%d")
                if first == second then
                    x.Visible = true
                    --Chose present to deliver/cancel the delivery
                    x.MouseButton1Click:Connect(function()
                        if not BeamBool then
                            BeamBool = true
                            local Beam = Instance.new("Beam")
                            if not Player.Character.PrimaryPart:FindFirstChild("Attachment") then
                                local Attachment1 = Instance.new("Attachment")
                                Attachment1.Parent = Player.Character.PrimaryPart
                            end
                            local Attachment2 = Instance.new("Attachment")
                            Attachment2.Parent = v.Goal.Value
                            Beam.Attachment0 = v.Goal.Value.Attachment
                            Beam.Attachment1 = Player.Character.PrimaryPart.Attachment
                            Beam.TextureLength = 50
                            Beam.TextureSpeed = -1
                            Beam.FaceCamera = true
                            Beam.Texture = "rbxassetid://929678762"
                            Beam.Parent = Player.Character
                        else
                            BeamBool = false
                            Player.Character:FindFirstChild("Beam"):Destroy()
                        end
                    end)
                end
            elseif x:IsA("ImageLabel") then --Inactive/No present
                    local first = string.match(v.Name,"%d")
                    local second = string.match(x.Name,"%d")
                    if first == second then
                        x:FindFirstChild("ItemBox"..second).PresentImage.Visible = true
                end
            end
        end
    end
    end)
    --Present removed
    v.ChildRemoved:Connect(function()
        for z,x in pairs(PresentsFrame:GetChildren()) do
            if x:IsA("ImageButton") then --Was active present
                local first = string.match(v.Name,"%d")
                local second = string.match(x.Name,"%d")
                if first == second then
                    x.Visible = false
                    local Beam = Player.Character:FindFirstChild("Beam")
                    if Beam then
                        BeamBool = false
                        Beam:Destroy()
                    end
                end
            elseif x:IsA("ImageLabel") then --Was not an active present
                local first = string.match(v.Name,"%d")
                local second = string.match(x.Name,"%d")
                if first == second then
                    x:FindFirstChild("ItemBox"..second).PresentImage.Visible = false
                end
            end
        end
    end)
end

--Setting up Sleigh Button Prompt
for i,v in ipairs(SleighFolder:GetChildren()) do
    if v.Value then
        Signs:FindFirstChild("SleighSign"..i).Board.Proxy.ActionText = "Spawn"
    end
end
    
--Opening Sequence
for i,v in ipairs(Gui:GetChildren()) do
    v.Enabled = false
end
Gui.CutsceneGui.Enabled = true
local CutsceneFrame = Gui.CutsceneGui.CutsceneFrame
CutsceneFrame.ChooseSpawn.Visible = false
CutsceneFrame.StartUp.Visible = true
CurrentCamera.CameraType = Enum.CameraType.Scriptable
CurrentCamera.CFrame = workspace.CutsceneStuff.Start.CFrame
local Tween1 = TweenService:Create(CurrentCamera,Info,{CFrame = workspace.CutsceneStuff.End.CFrame})
Tween1:Play()
local Count = 1
local CountArray = {UDim2.new(0.5,0,0.5,0),UDim2.new(-0.48,0,0.5,0),UDim2.new(-1.48,0,0.5,0),UDim2.new(-2.47,0,0.5,0),UDim2.new(-3.46,0,0.5,0)}
local RolesArray = {"Letters","Constructor","Packer","Delivery","Villager"}
CutsceneFrame.StartUp.PlayButton.MouseButton1Click:Connect(function() --Pressed Play on the start screen
    if Tween1.PlaybackState == Enum.PlaybackState.Playing then
        Tween1:Cancel()
    end
    CutsceneFrame.StartUp.Visible = false
    CutsceneFrame.ChooseSpawn.Visible = true
    CurrentCamera.CFrame = workspace.CutsceneStuff.Jobs.Letters.CFrame
end)

local Left = CutsceneFrame.ChooseSpawn.BG.ArrowLeft
local Right = CutsceneFrame.ChooseSpawn.BG.ArrowRight
local Scroll = CutsceneFrame.ChooseSpawn.BG.RoleBG.ScrollableFrame

--Team change event UI
Right.MouseButton1Click:Connect(function()
    if Count ~= #CountArray then
        Left.Visible = true
        Count += 1
        if Count == #CountArray then
            Right.Visible = false
        end
        Scroll.Position = CountArray[Count]
        CurrentCamera.CFrame = workspace.CutsceneStuff.Jobs:FindFirstChild(RolesArray[Count]).CFrame
    end
end)

Left.MouseButton1Click:Connect(function()
    if Count ~= 1 then
        Right.Visible = true
        Count -= 1
        if Count == 1 then
            Left.Visible = false
        end
        Scroll.Position = CountArray[Count]
        CurrentCamera.CFrame = workspace.CutsceneStuff.Jobs:FindFirstChild(RolesArray[Count]).CFrame
    end
end)

--Team chosen
CutsceneFrame.ChooseSpawn.StartPlaying.MouseButton1Click:Connect(function()
    CurrentCamera.CameraType = Enum.CameraType.Custom
    Character:SetPrimaryPartCFrame(workspace.Spawns:FindFirstChild(RolesArray[Count]).CFrame)
    CutsceneFrame.ChooseSpawn.Visible = false
    CurrencyGui.Enabled = true
    InventoryGui.Enabled = true
end)

--Shaky logo at startup
while CutsceneFrame.StartUp.Visible do
    for i = 1,10 do
        RunService.Heartbeat:Wait()
        CutsceneFrame.StartUp.Work.Rotation = i
    end
    for i = 10,-10,-1 do
        RunService.Heartbeat:Wait()
        CutsceneFrame.StartUp.Work.Rotation = i
    end
    for i = -10,1 do
        RunService.Heartbeat:Wait()
        CutsceneFrame.StartUp.Work.Rotation = i
    end
end