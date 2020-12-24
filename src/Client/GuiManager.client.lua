local Player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService('TweenService')
local Gui = Player:WaitForChild("PlayerGui",math.huge)
local InventoryGui = Gui:WaitForChild("InventoryGui")
local InventoryFrame = InventoryGui.InventoryFrame
local InventoryButton = InventoryGui.InventoryButton
local WhiteBorder = InventoryFrame.WhiteBorder
local BlueBorder = WhiteBorder.BlueBorder
local DecorFrame = BlueBorder.DecorFrame
local ScrollingFrame = DecorFrame.ScrollingFrame
local RightArrow = WhiteBorder.ArrowRight
local LeftArrow = WhiteBorder.ArrowLeft
local FrameCounter = WhiteBorder.FrameNumber
local Tabs = BlueBorder:GetChildren()
local TabText = WhiteBorder.Cloud.TabText
local TabNames = {"Decorations","Presents"}



local Open = false
local InProgress = false
local TabChangeInProgress = false
local Change = nil
--[[local OpenInventory = Gui.OpenInventory
local InventoryGui = Gui.InventoryGui
local InventoryFrame = InventoryGui.InventoryFrame
local CloseButton = InventoryFrame.CloseButton
local PresentsTab = InventoryFrame.PresentsTab
local HouseDecorTab = InventoryFrame.HouseDecorTab
local VehiclesTab = InventoryFrame.VehiclesTab
local PetsTab = InventoryFrame.PetsTab
local TabsFrame = InventoryFrame.TabsFrame--]]

--[[
Reference:
>OpenInventory(TextButton/ImageButton)
>InventoryGui(ScreenGui)
->InventoryFrame(Frame)(Anchor Point must be at the Center)
-->CloseButton(TextButton/ImageButton)
-->PresentsTab(TextButton/ImageButton)
-->HouseDecorTab(TextButton/ImageButton)
-->VehiclesTab(TextButton/ImageButton)
-->PetsTab(TextButton/ImageButton)
-->TabsFrame(Frame)(Anchor Point must be at the Center)
--->Stuff for Frame Above

Screen Position Reference(X.Scale):
0.2 = Presents tab
0.4 = HouseDecor tab
0.6 = Vehicles tab
0.8 = Pets tab
--]]

--[[local function Callback(status)
    if status == Enum.TweenStatus.Completed then
        return true
    end
end

local function hookTab(button,X)
    return button.MouseButton1Click:Connect(function()
   TabsFrame:TweenPosition(
        UDim2.new(X,0,0.5,0),
        Enum.EasingDirection.InOut,
        Enum.EasingStyle.Sine,
        1,
        true,
        nil
    )
end)
end

OpenInventory.MouseButton1Click:Connect(function()
    Gui.InventoryGui.Enabled = true
    Gui.InventoryGui.InventoryFrame:TweenPosition(
        UDim2.new(0.5,0,0.5,0),
        Enum.EasingDirection.InOut,
        Enum.EasingStyle.Sine,
        1.5,
        false
    )
end)

CloseButton.MouseButton1Click:Connect(function()
    Gui.InventoryGui.InventoryFrame:TweenPosition(
        UDim2.new(2,0,0.5,0),
        Enum.EasingDirection.InOut,
        Enum.EasingStyle.Sine,
        1.5,
        true,
        Callback
    )
    repeat RunService.Heartbeat:Wait() until Callback()
    Gui.InventoryGui.Enabled = false
end)

hookTab(PresentsTab,0.2)
hookTab(HouseDecorTab,0.4)
hookTab(VehiclesTab,0.6)
hookTab(PetsTab,0.8)--]]

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
    end
end)

LeftArrow.MouseButton1Click:Connect(function()
    if FrameCounter.Value ~= #Tabs and not TabChangeInProgress then
        FrameCounter.Value += 1
        Change = 1
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