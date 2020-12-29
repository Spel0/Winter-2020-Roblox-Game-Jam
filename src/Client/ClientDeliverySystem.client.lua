local DeliveryEvent = game:GetService("ReplicatedStorage").Remotes.DeliveryEvent
local connection
local Player = game:GetService("Players").LocalPlayer

DeliveryEvent.OnClientEvent:Connect(function(Goal,Pres) --OnClientEvent
    local Path = Instance.new("ObjectValue")
    Path.Name = "Goal"
    Path.Value = Goal
    Path.Parent = Pres
    Goal.ProximityPrompt.Enabled = true
connection = Goal.ProximityPrompt.Triggered:Connect(function() --ProximityPrompt Triggered Event
        DeliveryEvent:FireServer(Goal) --Award Player for Delivering
        Goal.ProximityPrompt.Enabled = false
        Pres.Value = false
        Path:Destroy()
        connection:Disconnect()
    end)
end)