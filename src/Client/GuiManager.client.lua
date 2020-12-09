local Player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local Gui = Player.PlayerGui
local OpenInventory = Gui.OpenInventory
local InventoryGui = Gui.InventoryGui
local InventoryFrame = InventoryGui.InventoryFrame
local CloseButton = InventoryFrame.CloseButton
local PresentsTab = InventoryFrame.PresentsTab
local HouseDecorTab = InventoryFrame.HouseDecorTab
local VehiclesTab = InventoryFrame.VehiclesTab
local PetsTab = InventoryFrame.PetsTab
local TabsFrame = InventoryFrame.TabsFrame

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

local function Callback(status)
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
hookTab(PetsTab,0.8)