local DeliveryEvent = game:GetService("ReplicatedStorage").Remotes.DeliveryEvent
local Player = game:GetService("Players").LocalPlayer

DeliveryEvent.OnClientEvent:Connect(function(Goal,Pres) --OnClientEvent
    local Path = Instance.new("ObjectValue")
    Path.Name = "Goal"
    Path.Value = Goal
    Path.Parent = Pres
    Goal.ProximityPrompt.Enabled = true
    coroutine.resume(coroutine.create(function() 
    local connection
    connection = Goal.ProximityPrompt.Triggered:Connect(function() --ProximityPrompt Triggered Event
        DeliveryEvent:FireServer(Goal,Pres) --Award Player for Delivering
        Goal.ProximityPrompt.Enabled = false
        Path:Destroy()
        connection:Disconnect()
    end)
    end))
end)