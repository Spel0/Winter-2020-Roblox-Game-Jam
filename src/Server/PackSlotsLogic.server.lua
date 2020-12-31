local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local FactoryItems = require(game.ServerScriptService.FactoryItems)
local RepStorage = game.ReplicatedStorage
local Packs = workspace["Workshop Area"]["Main Building"].PresIcons
local Info = TweenInfo.new(2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,0,false,0)

for i,v in ipairs(Packs:GetChildren()) do
    local Proxy = v.GiftOrigin.Proxy
    local Timer = v.Timer
    local Item = v.ItemInSlot
    local Label = v.TimerBlock.SurfaceGui.TextLabel
        coroutine.resume(coroutine.create(function()
            local Current = time()
            while RunService.Heartbeat:Wait() do
                if Timer.Value > 0 and Item.Value then
                    if time() - Current >= 1 then
                        Timer.Value -= 1
                        Current = time()
                    end
                    Label.Text = Timer.Value.." Seconds left"
                elseif Timer.Value <= 0 and not Item.Value then
                    Label.Text = "Available!"
                elseif Timer.Value <= 0 and Item.Value then
                    Item.Value = false
                    local Clone = RepStorage.Presents:FindFirstChild(v.Name):Clone()
                    Clone:SetPrimaryPartCFrame(v.GiftOrigin.CFrame * CFrame.new(0,-4,0))
                    Clone.Parent = workspace.PresentsFolder
                    local Tween = TweenService:Create(Clone.PrimaryPart,Info,{CFrame = Clone.PrimaryPart.CFrame * CFrame.new(0,4,0)})
                    Tween:Play()
                    Tween.Completed:Wait()
                    local NewProxy = Instance.new("ProximityPrompt")
                    NewProxy.ObjectText = "Present"
                    NewProxy.ActionText = "Stash Present!"
                    NewProxy.HoldDuration = 0.5
                    NewProxy.Parent = Clone
                    NewProxy.Triggered:Connect(function(player)
                        FactoryItems.PresentsInStock += 1
                        Clone:Destroy()
                        Proxy.Enabled = true
                        player.Currency.CandyCane.Value += 2
                    end)
                end
            end
        end))
        Proxy.Triggered:Connect(function(player)
            if player.HasToyForWrap.Value and not Item.Value then
                local PlayerTool = player.Backpack:FindFirstChildOfClass("Tool")
                local CharacterTool = player.Character:FindFirstChildOfClass("Tool")
                local Tool = nil
                if PlayerTool or CharacterTool then
                    if PlayerTool then
                        Tool = PlayerTool
                    elseif CharacterTool then
                        Tool = CharacterTool
                    end
                    local Clone = RepStorage.Gifts:FindFirstChild(Tool.Name):Clone()
                    Tool:Destroy()
                    for z,x in ipairs(Clone:GetChildren()) do
                        if x:IsA("BasePart") or x:IsA("MeshPart") or x:IsA("UnionOperation") then
                            if x:FindFirstChild("WeldConstraint") then
                                x.Anchored = true
                            else
                                x.Anchored = false
                            end
                        end
                    end
                    Clone:SetPrimaryPartCFrame(v.GiftOrigin.CFrame)
                    Clone.Parent = workspace.ToyInProgress
                    local Tween = TweenService:Create(Clone.PrimaryPart,Info,{CFrame = Clone.PrimaryPart.CFrame * CFrame.new(0,-4,0)})
                    Tween:Play()
                    Item.Value = true
                    Timer.Value = 30
                    Proxy.Enabled = false
                    player.Currency.CandyCane.Value += 2
                    player.HasToyForWrap.Value = false
                    wait(4)
                    Clone:Destroy()
                end
            end
        end)
end