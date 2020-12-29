local Players = game:GetService("Players")
local DataStore = game:GetService("DataStoreService")
local HouseTable = workspace["Village Area"].Houses:GetChildren()

local function GetData(Key,CandyLocation) --Get CandyCanes Data
    local count = 0
    local CandyCanes
    local playerCandyCane = DataStore:GetDataStore("CandyCane", Key)
    repeat
        if count >= 1 then
            print("Retries: "..count..".")
            wait(5)
        end
    local success, error = pcall(function()
       CandyCanes = playerCandyCane:GetAsync(Key)
    end)
    count += 1
    
    if success then
        CandyLocation.Value = CandyCanes
        return true
    end
    until count == 5
    return false
end

local function AssignHouse(player)
    while game:GetService("RunService").Heartbeat:Wait() do
        local RandomNumber = math.random(1,#HouseTable)
        for i,v in ipairs(HouseTable) do
            if i == RandomNumber then
                if not v.Owned.Value then
                    v.Owned.Value = true
                    v.Sign.Front.SurfaceGui.Ownage.Text = "Owned by: "..player.Name
                    return v
                end
            end
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    local PlayerKey = "Player_"..player.UserId

    print("New Player Joined: "..PlayerKey..". Trying to load Data!")

    local Loaded = Instance.new("BoolValue") --Data Loaded Bool Value
    Loaded.Name = "DataLoaded"
    Loaded.Parent = player

    local Pc = Instance.new("BoolValue") --To detect if Player on PC or not
    Pc.Name = "Pc"
    Pc.Parent = player

    local House = Instance.new("ObjectValue") --Assign a random House to a Player
    House.Name = "OwnedHouse"
    House.Parent = player

    local HouseToClaim = AssignHouse(player)
    House.Value = HouseToClaim

    local Currency = Instance.new("Folder") --In Game Currency Folder
    Currency.Name = "Currency"
    Currency.Parent = player

    local CandyCane = Instance.new("NumberValue") --In Game Currency
    CandyCane.Name = "CandyCane"
    CandyCane.Parent = Currency

    local Inventory = Instance.new("Folder") --Inventory Folder
    Inventory.Name = "Inventory"
    Inventory.Parent = player

    local PresentFolder = Instance.new("Folder") --Presents Folder
    PresentFolder.Name = "Presents"
    PresentFolder.Parent = Inventory

    for i = 1,4 do --Presents Bool Value
        local Present = Instance.new("BoolValue")
        Present.Name = "Present"..i
        Present.Parent = PresentFolder
    end

    local result = GetData(PlayerKey,CandyCane)
    Loaded.Value = result --In Case of Roblox Being Down don't Save Data

    local Letter = Instance.new("BoolValue") --Cashier Job
    Letter.Name = "HasLetter"
    Letter.Parent = player
    end)

Players.PlayerRemoving:Connect(function(player)
    local PlayerKey = "Player_"..player.UserId
    local CandyCane = player.Currency.CandyCane
    local Loaded = player.DataLoaded
    local playerCandyCane = DataStore:GetDataStore("CandyCane", PlayerKey)
    local House = player.OwnedHouse

    --Trying to save CandyCanes Currency
    local success, error = pcall(function()
        if Loaded.Value then
        playerCandyCane:UpdateAsync(PlayerKey,function(oldValue)
            local NewValue = CandyCane.Value
                if oldValue == NewValue then
                    return nil
                 else
                    return NewValue
                end
            end)          
        end
    end)
    if success then
        print("DataStore pcall Successfuly executed!")
    else
        print("An error occured in DataStore Script: "..error)
    end

    House.Value.Owned.Value = false
    House.Value.Sign.Front.SurfaceGui.Ownage.Text = "Owned by: No one"
end)

--On Startup Stuff
local HousesDescendants = workspace["Village Area"].Houses:GetDescendants()
for _,v in pairs(HousesDescendants) do
    if v.Name == "Sign" and v:IsA("Model") then
        v.Front.SurfaceGui.Ownage.Text = "Owned by: No one"
    end
end