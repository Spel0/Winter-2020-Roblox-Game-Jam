local RepStorage = game:GetService("ReplicatedStorage")
local Player = game:GetService("Players").LocalPlayer
local BeamEvent = RepStorage.Remotes.BeamEvent

BeamEvent.OnClientEvent:Connect(function(ToAttach,bool)
    if not bool then
    local Attachment = Instance.new("Attachment")
    Attachment.Parent = ToAttach
    local Beam = Instance.new("Beam")
    Beam.Attachment0 = Attachment
    Beam.Attachment1 = Player.Character.PrimaryPart.Attachment
    Beam.TextureLength = 50
    Beam.TextureSpeed = -1
    Beam.FaceCamera = true
    Beam.Texture = "rbxassetid://929678762"
    Beam.Parent = Player.Character
    elseif bool then
        Player.Character:FindFirstChildOfClass("Beam"):Destroy()
    end
end)