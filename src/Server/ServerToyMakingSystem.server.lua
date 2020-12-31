local RepStorage = game.ReplicatedStorage
local ToyEvent = RepStorage.Remotes.ToyEvent

ToyEvent.OnServerEvent:Connect(function(player,Toy)
    local WorkerPlace = workspace["Workshop Area"]["Main Building"].WorkingPos
    local Distance = (player.Character.PrimaryPart.Position - WorkerPlace.Position).Magnitude
    if Distance > 4 then
        player:Kick("Your internet connection is unstable. Please reconnect")
    else
        local Clone = RepStorage.Tools:FindFirstChild(Toy.Name):Clone()
        Clone.Parent = player.Backpack
        player.Character.Humanoid:EquipTool(Clone)
        player.HasToy.Value = true
    end
end)