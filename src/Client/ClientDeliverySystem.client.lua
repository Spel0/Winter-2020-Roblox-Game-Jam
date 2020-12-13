local DeliveryEvent = game:GetService("ReplicatedStorage").DeliveryEvent
local connection

DeliveryEvent.OnClientEvent:Connect(function(Goal) --OnClientEvent
    local Finish = Goal.Value
    Finish.ProximityPrompt.Enabled = true
connection = Finish.ProximityPrompt.Triggered:Connect(function() --ProximityPrompt Triggered Event
        DeliveryEvent:FireServer(Finish) --Award Player for Delivering
        Finish.ProximityPrompt.Enabled = false
        connection:Disconnect()
    end)
end)