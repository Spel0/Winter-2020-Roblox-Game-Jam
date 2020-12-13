local RepStorage = game:GetService("ReplicatedStorage")
local Presents = RepStorage.Presents:GetChildren()
local Functions = require(game:GetService("ServerScriptService").Functions)
local DeliveryFolder = workspace.DeliveryPoints
local DeliveryEvent = RepStorage.DeliveryEvent

for _,v in pairs(Presents) do --Setting up ProximityPrompt Triggered Event for completed Present
    v.ProximityPrompt.Triggered:Connect(function(player)
    local PresentFolder = player.Inventory.Presents
    local Present = PresentFolder:FindFirstChild(v.Name)
    if not Present.Value then --Picking Up Present
        Present.Value = true
        local Path = Instance.new("ObjectValue")
        Path.Name = "Goal"
        local Finish = Functions.PickRandom(DeliveryFolder)
        Path.Value = Finish
        Path.Parent = Present
        DeliveryEvent:FireClient(player,Path)
        v:Destroy()
    else --If Player already has that Present
        print("You already have this type of Present!")
    end
    end)
end

for _,v in pairs(DeliveryFolder:GetDescendants()) do --Setting up ProximityPrompt to not show up until Present is acquired
    if v:IsA("ProximityPrompt") then
        v.Enabled = false
    end
end

DeliveryEvent.OnServerEvent:Connect(function(player,House) --When Player deliveres the Present
    print(player.Name.." delivered present to "..House.."!")
    player.Currency.CandyCane.Value += 10
end)