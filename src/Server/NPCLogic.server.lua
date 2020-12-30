local RunService = game:GetService("RunService")
local Max = 1
local Spawn = workspace["Workshop Area"]["Main Building"].NPCSpawnPart
local NPCFolder = workspace.SpawnedNPC

NPCFolder.ChildAdded:Connect(function(NPC)
    local Proxy = Instance.new("ProximityPrompt")
    Proxy.HoldDuration = 0.5
    Proxy.ObjectText = "Villager"
    Proxy.ActionText = "Accept a Letter!"
    local ProxyPart = Instance.new("Part")
    ProxyPart.Anchored = true
    ProxyPart.Transparency = 1
    ProxyPart.CanCollide = false
    ProxyPart.CFrame = NPC.PrimaryPart.CFrame * CFrame.new(0,0,-1)  
    ProxyPart.Parent = NPC
    Proxy.Parent = ProxyPart
    Proxy.Triggered:Connect(function(player)
        if player.HasLetter.Value then return end
        player.HasLetter.Value = true
        local ClonedLetter = game.ReplicatedStorage.Tools:FindFirstChild("Letter"):Clone()
        ClonedLetter.Parent = player.Backpack
        coroutine.resume(coroutine.create(function() 
            local Animator = Instance.new("Animator")
            Animator.Parent = NPC.Humanoid
            if NPC.Humanoid.RigType == Enum.HumanoidRigType.R15 then
                local Anim = Instance.new("Animation")
                Anim.AnimationId = "rbxassetid://507770239"
                local anim = Animator:LoadAnimation(Anim)
                anim:Play()
                Anim:Destroy()
            elseif NPC.Humanoid.RigType == Enum.HumanoidRigType.R6 then
                local Anim = Instance.new("Animation")
                Anim.AnimationId = "rbxassetid://128777973"
                local anim = Animator:LoadAnimation(Anim)
                anim:Play()
                Anim:Destroy()
            end
            wait(3)
            NPC:Destroy()
        end))
        Proxy:Destroy()
    end)
end)

while true do
    RunService.Heartbeat:Wait()
    while #NPCFolder:GetChildren() < Max do
        wait(math.random(5,10))
        local Npc = game:GetService("ReplicatedStorage").NPC:GetChildren()
        local RandomNumber = math.random(1,#Npc)
        for i,v in ipairs(Npc) do
            if i == RandomNumber then
                local Clone = v:Clone()
                Clone.PrimaryPart.CFrame = Spawn.CFrame
                Clone.Parent = NPCFolder
            end
        end
    end
end