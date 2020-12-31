local RunService = game:GetService("RunService")
local RepStorage = game.ReplicatedStorage
local Drop = workspace["Workshop Area"]["Main Building"].LetterDrop
local FactoryItems = require(game.ServerScriptService.FactoryItems)
local BeamEvent = RepStorage.Remotes.BeamEvent

Drop.Touched:Connect(function() end)

while RunService.Heartbeat:Wait() do
    local Touch = Drop:GetTouchingParts()
    if #Touch ~= 0 then
        for _,v in ipairs(Touch) do
            local Player = game.Players:GetPlayerFromCharacter(v.Parent)
            if Player then
                if Player.HasLetter.Value then
                    Player.HasLetter.Value = false
                    local Letter = Player.Backpack:FindFirstChild("Letter")
                    if Letter then
                        Letter:Destroy()
                    else
                        Player.Character:FindFirstChild("Letter"):Destroy()
                    end
                    BeamEvent:FireClient(Player,nil,true)
                    Player.Currency.CandyCane.Value += 2
                    FactoryItems.LettersInStock += 1
                end
            end
        end
    end
end