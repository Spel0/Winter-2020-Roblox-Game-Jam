local RepStorage = game:GetService("ReplicatedStorage")
local PresentsProxy = workspace["Workshop Area"]["Main Building"].GiftsToGrab.ProxyPart.Proxy
local Functions = require(game:GetService("ServerScriptService").Functions)
local DeliveryFolder = workspace.DeliveryPoints
local DeliveryEvent = RepStorage.Remotes.DeliveryEvent
local FactoryItems = require(game.ServerScriptService.FactoryItems)

local function GetPresent(player)
    for i,v in ipairs(player.Inventory.Presents:GetChildren()) do
        if not v.Value then
            v.Value = true
            return v
        elseif i == #player.Inventory.Presents:GetChildren() then
            return false
        end
    end
end


PresentsProxy.Triggered:Connect(function(player)
    local Pres = GetPresent(player)
    if Pres then
        local Path = Functions.PickRandom(DeliveryFolder)
        DeliveryEvent:FireClient(player,Path,Pres)
        FactoryItems.PresentsInStock -= 1
    end
end)


for _,v in pairs(DeliveryFolder:GetDescendants()) do --Setting up ProximityPrompt to not show up until Present is acquired
    if v:IsA("ProximityPrompt") then
        v.Enabled = false
    end
end

DeliveryEvent.OnServerEvent:Connect(function(player,House,Pres) --When Player deliveres the Present
    local Distance = (player.Character.PrimaryPart.Position - House.Position).Magnitude
    if Distance <= 10 then
        Pres.Value = false
        print(player.Name.." delivered present to "..House.Name.."!")
        player.Currency.CandyCane.Value += 10
    else
        player:Kick("Exploiting")
    end
end)