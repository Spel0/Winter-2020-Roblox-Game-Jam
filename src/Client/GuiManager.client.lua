local Player = game:GetService("Players").LocalPlayer
local Currency = Player:WaitForChild("Currency")
local CandyCanes = Currency.CandyCane
local Inventory = Player.Inventory
local PresentsFolder = Inventory.Presents
local RunService = game:GetService("RunService")
local TweenService = game:GetService('TweenService')
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


local Open = false
local InProgress = false
local TabChangeInProgress = false
local Change = nil
local BeamBool = false


InventoryFrame.Position = UDim2.new(1,0,0.5,0)

InventoryButton.MouseButton1Click:Connect(function()
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

RunService.Heartbeat:Wait()
TextAmount.Text = CandyCanes.Value

CandyCanes.Changed:Connect(function()
    TextAmount.Text = CandyCanes.Value
end)

for i,v in ipairs(PresentsFrame:GetChildren()) do
    if v:IsA("ImageButton") then
        v.Visible = false
        end
end

for i,v in ipairs(PresentsFolder:GetChildren()) do
    v.Changed:Connect(function()
        for z,x in pairs(PresentsFrame:GetChildren()) do
            if x:IsA("ImageButton") then
                local first = string.match(v.Name,"%d")
                local second = string.match(x.Name,"%d")
                if first == second then
                    x.Visible = true
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
            end
        end
    end)
    v.ChildRemoved:Connect(function()
        for z,x in pairs(PresentsFrame:GetChildren()) do
            if x:IsA("ImageButton") then
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
            end
        end
    end)
end