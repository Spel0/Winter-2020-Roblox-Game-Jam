local Bottom = false
local Side = false
local connection = nil
local Binded = false
local LastCF
local CAS = game:GetService("ContextActionService")
local RS = game:GetService("RunService")

local function CanvasBottom()
    Bottom = true
CAS:UnbindAction("Bottom")
CAS:UnbindAction("Side")
local canvas = game.Workspace.ExampleCanvasFloor
local furniture = game.ReplicatedStorage.Furniture
local placementClass = require(game:GetService("ReplicatedStorage"):WaitForChild("PlacementModule"))

-- create an object with the constructor
local placement = placementClass.new(canvas)

local mouse = game.Players.LocalPlayer:GetMouse()
mouse.TargetFilter = placement.CanvasObjects

local tableModel = furniture.Table:Clone()
tableModel.Parent = mouse.TargetFilter

local rotation = 0

local function onRotate(actionName, userInputState, input)
    if (userInputState == Enum.UserInputState.Begin) then
        rotation = rotation + math.pi/2
    end
end

local function onPlace(actionName, userInputState, input)
    if (userInputState == Enum.UserInputState.Begin) then
        placement:Place(furniture[tableModel.Name], LastCF,placement:isColliding(tableModel))
    end
end

local function unBind(actionName, userInputState) 
    if userInputState == Enum.UserInputState.Begin then 
        Bottom = false
        tableModel:Destroy()
    end 
end

CAS:BindAction("place", onPlace, true, Enum.UserInputType.MouseButton1)
    CAS:SetPosition("place",UDim2.new(0.8, 0,-0.2, 0))
    CAS:SetTitle("place","Place")
    CAS:BindAction("UnBind",unBind,true,Enum.KeyCode.B)
    CAS:SetPosition("UnBind",UDim2.new(0.8, 0,-0.6, 0))
    CAS:SetTitle("UnBind","UnBind")
    CAS:BindAction("rotate", onRotate, true, Enum.KeyCode.R)
    CAS:SetPosition("rotate",UDim2.new(-2.2, 0,-0.5, 0))
    CAS:SetTitle("rotate","Rotate")

connection = RS.RenderStepped:Connect(function(dt)
    if Bottom then
    local cf = placement:CalcPlacementCFrame(tableModel, mouse.Hit.Position, rotation, true, mouse.Target)
    if cf ~= nil then
        LastCF = cf
        tableModel:SetPrimaryPartCFrame(cf)
    end
    else
        Binded = false
        CAS:UnbindAction("place")
        CAS:UnbindAction("rotate")
        CAS:UnbindAction("UnBind")
        connection:Disconnect()
    end
end)
end

local function CanvasSide()
    Side = true
    CAS:UnbindAction("Side")
    CAS:UnbindAction("Bottom")
    local canvas = game.Workspace.ExampleCanvasSide
    local furniture = game.ReplicatedStorage.Furniture
    local placementClass = require(game:GetService("ReplicatedStorage"):WaitForChild("PlacementModule"))
    
    -- create an object with the constructor
    local placement = placementClass.new(canvas)
    
    local mouse = game.Players.LocalPlayer:GetMouse()
    mouse.TargetFilter = placement.CanvasObjects
    
    local tableModel = furniture.Table:Clone()
    tableModel.Parent = mouse.TargetFilter
    
    local rotation = 0
    
    local function onRotate(actionName, userInputState, input)
        if (userInputState == Enum.UserInputState.Begin) then
            rotation = rotation + math.pi/2
        end
    end
    
    local function onPlace(actionName, userInputState, input)
        if (userInputState == Enum.UserInputState.Begin) then
            placement:Place(furniture[tableModel.Name], LastCF,placement:isColliding(tableModel))
        end
    end

    local function unBind(actionName, userInputState) 
        if userInputState == Enum.UserInputState.Begin then
            Side = false 
            tableModel:Destroy()
        end 
    end
    
    CAS:BindAction("place", onPlace, true, Enum.UserInputType.MouseButton1)
    CAS:SetPosition("place",UDim2.new(0.8, 0,-0.2, 0))
    CAS:SetTitle("place","Place")
    CAS:BindAction("UnBind",unBind,true,Enum.KeyCode.N)
    CAS:SetPosition("UnBind",UDim2.new(0.8, 0,-0.6, 0))
    CAS:SetTitle("UnBind","UnBind")
    CAS:BindAction("rotate", onRotate, true, Enum.KeyCode.R)
    CAS:SetPosition("rotate",UDim2.new(-2.2, 0,-0.5, 0))
    CAS:SetTitle("rotate","Rotate")
    
    connection = RS.RenderStepped:Connect(function(dt)
        if Side then
        local cf = placement:CalcPlacementCFrame(tableModel, mouse.Hit.Position, rotation, false, mouse.Target)
        if cf ~= nil then
        LastCF = cf
        tableModel:SetPrimaryPartCFrame(cf)
        end
    else
        Binded = false
        CAS:UnbindAction("place")
        CAS:UnbindAction("rotate")
        CAS:UnbindAction("UnBind")
        connection:Disconnect()
        end
    end)
    end

while RS.Heartbeat:Wait() do
    if not Binded then
             CAS:BindAction("Bottom",CanvasBottom,true,Enum.KeyCode.B)
             CAS:SetPosition("Bottom",UDim2.new(0.2,0,0.2,0))
             CAS:SetTitle("Bottom","Bottom")
            CAS:BindAction("Side",CanvasSide,true,Enum.KeyCode.N)
            CAS:SetPosition("Side",UDim2.new(0,0,0,0))
            CAS:SetTitle("Side","Side")
            Binded = true
end
end