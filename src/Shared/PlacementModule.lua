local isServer = game:GetService("RunService"):IsServer()

local Placement = {}
Placement.__index = Placement

function Placement.new(canvasPart)
    local self = setmetatable({}, Placement)

    -- the part we are placing models on
    self.CanvasPart = canvasPart

    -- custom logic depending on if the sevrer or not
    if (isServer) then
        -- create a folder we'll place the objects in
        self.CanvasObjects = Instance.new("Folder")
        self.CanvasObjects.Name = "CanvasObjects"
        self.CanvasObjects.Parent = canvasPart
    else
        -- initiate the twin on the server
        local initPlacement = game:GetService("ReplicatedStorage").Remotes.InitPlacement
        self.CanvasObjects = initPlacement:InvokeServer(canvasPart)
    end

    -- we'll talk about these properties later in the post
    self.Surface = Enum.NormalId.Top
    self.GridUnit = 2

    return self
end

function Placement:CalcCanvasBottom()
    local canvasSize = self.CanvasPart.Size

    -- want to create CFrame such that cf.lookVector == self.CanvasPart.CFrame.upVector
    -- do this by using object space and build the CFrame
    local back = Vector3.new(0, -1, 0)
    local top = Vector3.new(0, 0, -1)
    local right = Vector3.new(-1, 0, 0)

    -- convert to world space
    local cf = self.CanvasPart.CFrame * CFrame.fromMatrix(-back*canvasSize/2, right, top, back)
    -- use object space vectors to find the width and height
    local size = Vector2.new((canvasSize * right).magnitude, (canvasSize * top).magnitude)

    return cf, size
end

function Placement:CalcCanvasSide()
    local canvasSize = self.CanvasPart.Size

    local up = Vector3.new(0, 1, 0)
    local back = -Vector3.FromNormalId(self.Surface)

    -- if we are using the top or bottom then we treat right as up
    local dot = back:Dot(Vector3.new(0, 1, 0))
    local axis = (math.abs(dot) == 1) and Vector3.new(-dot, 0, 0) or up

    -- rotate around the axis by 90 degrees to get right vector
    local right = CFrame.fromAxisAngle(axis, math.pi/2) * back
    -- use the cross product to find the final vector
    local top = back:Cross(right).unit

    -- convert to world space
    local cf = self.CanvasPart.CFrame * CFrame.fromMatrix(-back*canvasSize/2, right, top, back)
    -- use object space vectors to find the width and height
    local size = Vector2.new((canvasSize * right).magnitude, (canvasSize * top).magnitude)

    return cf, size
end

function Placement:CalcPlacementCFrame(model, position, rotation, bottom, target)
    if target ~= self.CanvasPart then return end
    -- use other method to get info about the surface
    local cf, size
    if bottom then
    cf, size = self:CalcCanvasBottom()
    elseif not bottom then
    cf, size = self:CalcCanvasSide()
    end

    -- rotate the size so that we can properly constrain to the surface
    local modelSize = CFrame.fromEulerAnglesYXZ(0, rotation, 0) * model.PrimaryPart.Size
    modelSize = Vector3.new(math.abs(modelSize.X), math.abs(modelSize.Y), math.abs(modelSize.Z))

    -- get the position relative to the surface's CFrame
    local lpos = cf:pointToObjectSpace(position);
    -- the max bounds the model can be from the surface's center
    local size2 = (size - Vector2.new(modelSize.X, modelSize.Z))/2

    -- constrain the position using size2
    local x = math.clamp(lpos.x, -size2.X, size2.X);
    local y = math.clamp(lpos.y, -size2.Y, size2.Y);

    local g = self.GridUnit
    if (g > 0) then
        x = math.sign(x)*((math.abs(x) - math.abs(x) % g) + (size2.X % g))
        y = math.sign(y)*((math.abs(y) - math.abs(y) % g) + (size2.Y % g))
    end

    -- create and return the CFrame
    return cf * CFrame.new(x, y, -modelSize.Y/2) * CFrame.Angles(-math.pi/2, rotation, 0)
end

function Placement:isColliding(model)
    local isColliding = false

    -- must have a touch interest for the :GetTouchingParts() method to work
    local touch = model.PrimaryPart.Touched:Connect(function() end)
    local touching = model.PrimaryPart:GetTouchingParts()

    -- if intersecting with something that isn't part of the model then can't place
    for i = 1, #touching do
        if (not touching[i]:IsDescendantOf(model)) then
            isColliding = true
            break
        end
    end

    -- cleanup and return
    touch:Disconnect()
    return isColliding
end

function Placement:Place(model, cf, isColliding)
    if (not isColliding and isServer) then
        local clone = model:Clone()
        clone:SetPrimaryPartCFrame(cf)
        clone.Parent = self.CanvasObjects
    end

    if (not isServer) then
        local invokePlacement = game:GetService("ReplicatedStorage").Remotes.InvokePlacement
        invokePlacement:FireServer("Place", model, cf, isColliding)
    end
end

return Placement