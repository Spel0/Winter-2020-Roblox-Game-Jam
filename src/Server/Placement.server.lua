local placementClass = require(game:GetService("ReplicatedStorage"):WaitForChild("PlacementModule"))
local placementObjects = {}

local remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")

-- creates the server twin, stores in a table and returns the CanvasObjects property
function remotes.InitPlacement.OnServerInvoke(player, canvasPart)
    placementObjects[player] = placementClass.new(canvasPart)
    return placementObjects[player].CanvasObjects
end

-- finds the server twin and calls a method on it
-- note: b/c we aren't using the standard method syntax we must manually put in the self argument
remotes.InvokePlacement.OnServerEvent:Connect(function(player, func, ...)
    if (placementObjects[player]) then
        placementClass[func](placementObjects[player], ...)
    end
end)