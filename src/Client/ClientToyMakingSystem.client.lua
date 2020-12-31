local RepStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ToyEvent = RepStorage.Remotes.ToyEvent
local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local PlayerModule = require(Player.PlayerScripts:WaitForChild("PlayerModule"))
local PictureID = {
    LamboAddition1 = "rbxassetid://6162944974", 
    LamboAddition2 = "rbxassetid://6162944665",
    LamboAddition3 = "rbxassetid://6162944827",
    LamboAddition4 = "rbxassetid://6162945157",
    RoPhoneAddition1 = "rbxassetid://6162946477",
    RoPhoneAddition2 = "rbxassetid://6162944379",
    RoPhoneAddition3 = "rbxassetid://6162946260",
    RoPhoneAddition4 = "rbxassetid://6162946051",
    TVAddition1 = "rbxassetid://6162943922",
    TVAddition2 = "rbxassetid://6162943605",
    PlayBoxAddition1 = "rbxassetid://6162945454",
    PlayBoxAddition2 = "rbxassetid://6162945297"
}

local function ChangeTransparency(Toy,Num,ToAssign,ToUpdate)
    for n,m in ipairs(Toy:GetChildren()) do
            if m.Name ~= "Addition"..tostring(Num) then
                m.Transparency = ToUpdate
            else
                m.Transparency = ToAssign
            end
        end
end

ToyEvent.OnClientEvent:Connect(function(WorkPlace,CamPos,ToyLook)
    local ChosenToy = nil
    local ClonedToy = nil
    local Controls = PlayerModule:GetControls()
    local RandomToy = math.random(1,#RepStorage.Gifts:GetChildren())
    Player.Character:SetPrimaryPartCFrame(WorkPlace.CFrame)
    Controls:Disable()
    workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
    workspace.CurrentCamera.CFrame = CamPos.CFrame
    for i,v in ipairs(PlayerGui:GetChildren()) do
        v.Enabled = false
    end
    local ToyMakingGui = PlayerGui.ToyMakingGui
    ToyMakingGui.Enabled = true
    local Order = 1
    local Completed = false
    for i,v in ipairs(RepStorage.Gifts:GetChildren()) do
        if i == RandomToy then
            ChosenToy = v
            ClonedToy = v:Clone()
            if v.Name == "Lambo" or v.Name == "PlayBox" then
                ClonedToy:SetPrimaryPartCFrame(CFrame.lookAt(CamPos.Position + Vector3.new(0,-9.1,0),ToyLook.Position))
            else
                ClonedToy:SetPrimaryPartCFrame(CFrame.new(CamPos.Position + Vector3.new(0,-8.5,0)) * CFrame.Angles(0,math.rad(180),-math.rad(90)))
            end
            for n,m in pairs(ClonedToy:GetDescendants()) do
                if (m:IsA("MeshPart") or m:IsA("UnionOperation") or m:IsA("BasePart")) then
                    m.Anchored = true
                end
            end
            ClonedToy.Parent = workspace.ToyInProgress
            local Base = ClonedToy:FindFirstChild("Base")
            if Base then
                for n,m in ipairs(ClonedToy:GetChildren()) do
                    if m.Name ~= "Base" then
                        if m.Name ~= "Addition1" then
                            m.Transparency = 1
                        else
                            m.Transparency = 0.6
                        end
                    end
                end
                local Frames = ToyMakingGui.ToyMakingFrame:GetChildren()
                for z,x in ipairs(Frames) do
                    x.Visible = true
                    x.Addition.Image = PictureID[v.Name.."Addition"..tostring(z)]
                    coroutine.resume(coroutine.create(function()
                        local connection
                        connection = x.Addition.MouseButton1Click:Connect(function()
                            if Order == z then
                                x.Visible = false
                                Order += 1
                                ChangeTransparency(ClonedToy,Order,0.6,1)
                                if Order == 5 then
                                    Completed = true
                                    Order = 1
                                end
                                connection:Disconnect()
                            else
                                return
                            end
                        end)
                    end))
                end
            else
                local Frames = ToyMakingGui.ToyMakingFrame:GetChildren()
                for n,m in ipairs(ClonedToy:GetChildren()) do
                    if m.Name ~= "Addition1" then
                        m.Transparency = 1
                    else
                        m.Transparency = 0.6
                    end
                end
                for z,x in ipairs(Frames) do
                    if z == 3 or z == 4 then
                        x.Visible = false
                    else
                        x.Visible = true
                        x.Addition.Image = PictureID[v.Name.."Addition"..tostring(z)]
                    coroutine.resume(coroutine.create(function()
                        local connection
                        connection = x.Addition.MouseButton1Click:Connect(function()
                            if Order == z then
                                x.Visible = false
                                Order += 1
                                ChangeTransparency(ClonedToy,Order,0.6,1)
                                if Order == 3 then
                                    Completed = true
                                    Order = 1
                                end
                                connection:Disconnect()
                            else
                                return
                            end
                        end)
                    end))
                    end
                end
            end
        else
            continue
        end            
    end
    while RunService.Heartbeat:Wait() do
        if Completed then
            Completed = false
            Controls:Enable()
            workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
            ClonedToy:Destroy()
            ToyEvent:FireServer(ChosenToy)
            for i,v in pairs(PlayerGui:GetChildren()) do
                v.Enabled = true
            end
            ToyMakingGui.Enabled = false
            local Attachment = Instance.new("Attachment")
            Attachment.Parent = workspace["Workshop Area"]["Main Building"].Conv.Conveyor10
            local Beam = Instance.new("Beam")
            Beam.Attachment0 = Attachment
            Beam.Attachment1 = Player.Character.PrimaryPart.Attachment
            Beam.TextureLength = 50
            Beam.TextureSpeed = -1
            Beam.FaceCamera = true
            Beam.Texture = "rbxassetid://929678762"
            Beam.Parent = Player.Character
            break
        end
    end
end)