local Signs = workspace.Signs
local SleighSpawns = workspace.SleighSpawns
local RepStorage = game.ReplicatedStorage

local function OwnCheck(Own,Number)
    if Own.Value then
        local random = math.random(1,#SleighSpawns:GetChildren())
        local Clone = RepStorage.Sleighs:FindFirstChild("Sleigh"..Number):Clone()
        Clone:SetPrimaryPartCFrame(SleighSpawns:FindFirstChild("Spawn"..tostring(random)).CFrame)
        Clone.Parent = workspace
        return true
    end
end

for i,v in ipairs(Signs:GetChildren()) do
    local Proxy = v.Board.Proxy
    Proxy.Triggered:Connect(function(player)
        local Number = string.match(Proxy.Parent.Parent.Name,"%d")
        local Own = player.Inventory.OwnedSleigh:FindFirstChild("Sleigh"..Number)
        if Number == "1" then
            local result = OwnCheck(Own,Number)
            if result then return end
            if player.Currency.CandyCane.Value >= 100 then
                player.Currency.CandyCane.Value -= 100
                player.Inventory.OwnedSleigh.Sleigh1.Value = true
                Proxy.ActionText = "Spawn"
            end
        elseif Number == "2" then
            local result = OwnCheck(Own,Number)
            if result then return end
            if player.Currency.CandyCane.Value >= 1000 then
                player.Currency.CandyCane.Value -= 1000
                player.Inventory.OwnedSleigh.Sleigh2.Value = true
                Proxy.ActionText = "Spawn"
            end
        elseif Number == "3" then
            local result = OwnCheck(Own,Number)
            if result then return end
            if player.Currency.CandyCane.Value >= 10000 then
                player.Currency.CandyCane.Value -= 10000
                player.Inventory.OwnedSleigh.Sleight3.Value = true
                Proxy.ActionText = "Spawn"
            end
        elseif Number == "4" then
            print("W.I.P")
            end
        end)
    end