local UIS = game:GetService("UserInputService")
local Player = game:GetService('Players').LocalPlayer
local Pc = Player:WaitForChild("Pc")

UIS.LastInputTypeChanged:Connect(function(input)
    if input == Enum.UserInputType.Keyboard then
        Pc.Value = true
    elseif input == Enum.UserInputType.Touch then
        Pc.Value = false
    end
end)