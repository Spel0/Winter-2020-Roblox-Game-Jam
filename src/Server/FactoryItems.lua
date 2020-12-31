local module = {
    LettersInStock = 0,
    ToysInStock = 0,
    PresentsInStock = 0
}

function module.StartProduction()
    local ScrapLine = {}
    local Max = 10
    local CoroutinePlaying = false
    local RunService = game:GetService("RunService")
    local RepStorage = game:GetService("ReplicatedStorage")
    local BeamEvent = RepStorage.Remotes.BeamEvent
    local PhysicsService = game:GetService("PhysicsService")
    PhysicsService:CollisionGroupSetCollidable("Working","Working",false)
    PhysicsService:CollisionGroupSetCollidable("Players","Working",false)
    local MainBuilding = workspace["Workshop Area"]["Main Building"]
    local WorkerPlace = MainBuilding.WorkingPos
    local CameraPlace = MainBuilding.CameraPos
    local ToyConv = MainBuilding.Conv.Conveyor10
    local CompToySpawn = MainBuilding.CompletedToySpawn
    local ToyLook = MainBuilding.ToyLookPoint
    ToyConv.Proxy.Triggered:Connect(function(player)
        if player.HasToy.Value then
            local PlayerToy = player.Backpack:FindFirstChildOfClass("Tool")
            local CharacterToy = player.Character:FindFirstChildOfClass("Tool")
            local Toy = nil
            if PlayerToy or CharacterToy then
                if PlayerToy then
                    Toy = RepStorage.Gifts:FindFirstChild(PlayerToy.Name)
                elseif CharacterToy then
                    Toy = RepStorage.Gifts:FindFirstChild(CharacterToy.Name)
                end
                if Toy then
                    if PlayerToy then
                        PlayerToy:Destroy()
                    elseif CharacterToy then
                        CharacterToy:Destroy()
                    end
                    local ClonedToy = Toy:Clone()
                    ClonedToy:SetPrimaryPartCFrame(CompToySpawn.CFrame)
                    ClonedToy.Parent = workspace.CompletedToys
                    player.Currency.CandyCane.Value += 4
                    player.HasToy.Value = false
                    BeamEvent:FireClient(player,nil,true)
                    wait(2)
                    local NewProxy = Instance.new("ProximityPrompt")
                    NewProxy.ObjectText = "Completed Toy"
                    NewProxy.ActionText = "Grab to Wrap a Toy!"
                    NewProxy.RequiresLineOfSight = false
                    NewProxy.Parent = ClonedToy
                    NewProxy.Triggered:Connect(function(player)
                        if not player.HasToyForWrap.Value then
                            local Clone = RepStorage.Tools:FindFirstChild(ClonedToy.Name):Clone()
                            Clone.Parent = player.Backpack
                            player.Character.Humanoid:EquipTool(Clone)
                            player.HasToyForWrap.Value = true  
                            ClonedToy:Destroy()
                        end
                    end)
                else
                    warn("No Toy!!!")
                end
            end
        end
    end)
    coroutine.resume(coroutine.create(function()
        workspace.ScrapFolder.ChildAdded:Connect(function(child)
            ScrapLine[#ScrapLine+1] = child
            module.ToysInStock += 1
            child.PrimaryPart.Proxy.Triggered:Connect(function(player)
                local PlayerTools = player.Backpack:FindFirstChildOfClass("Tool")
                local CharacterTools = player.Character:FindFirstChildOfClass("Tool")
                if not PlayerTools and not CharacterTools then
                    RepStorage.Remotes.ToyEvent:FireClient(player,WorkerPlace,CameraPlace,ToyLook)
                    local Character = player.Character
                    for i,v in ipairs(Character:GetDescendants()) do
                        if v:IsA("BasePart") then
                        v.CollisionGroupId = PhysicsService:GetCollisionGroupId("Working")
                        end
                    end
                    child:Destroy()
                    module.ToysInStock -= 1
                end
            end)
        end)
        while wait(30) do
            if #ScrapLine > Max then
                repeat
                    RunService.Heartbeat:Wait()
                    ScrapLine[1]:Destroy()
                    table.remove(ScrapLine,1)
                until #ScrapLine <= Max
            end
        end
    end))
    coroutine.resume(coroutine.create(function()
        local Switched = true
        local Gifts = MainBuilding.GiftsToGrab
        local function Switch(bool)
            Switched = bool
            local number = nil
            if bool then
                number = 0
            elseif not bool then
                number = 1
            end
            for i,v in ipairs(Gifts:GetChildren()) do
                if v:IsA("Model") then
                    for z,x in ipairs(v:GetChildren()) do
                        x.Transparency = number
                    end
                elseif v:IsA("BasePart") then
                    local Proxy = v:FindFirstChild("Proxy")
                    if Proxy then
                    v.Proxy.Enabled = bool
                    else
                        continue
                    end
                end
            end
        end
        while RunService.Heartbeat:Wait() do
            if module.PresentsInStock == 0 and Switched then
                Switch(false)
            elseif module.PresentsInStock > 0 and not Switched then
                Switch(true)
            end
            Gifts.TimerBlock.SurfaceGui.TextLabel.Text = "Presents in Stock: "..module.PresentsInStock
        end
    end))
    while RunService.Heartbeat:Wait() do
        if not CoroutinePlaying and module.LettersInStock > 0 then
        coroutine.resume(coroutine.create(function()
            CoroutinePlaying = true
            while module.LettersInStock > 0 do
                wait(10)
                local random = math.random(1,2)
                local Clone = RepStorage.Scrap:Clone()
                Clone:SetPrimaryPartCFrame(workspace["Workshop Area"]["Main Building"]:FindFirstChild("ScrapSpawn"..tostring(random)).CFrame)
                Clone.Parent = workspace.ScrapFolder
                module.LettersInStock -= 1
            end
            CoroutinePlaying = false
        end))
    end
    end
end

return module