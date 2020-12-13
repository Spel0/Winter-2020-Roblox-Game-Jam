local Players = game:GetService("Players")
local DataStore = game:GetService("DataStoreService")

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

Players.PlayerAdded:Connect(function(player)
    local PlayerKey = "Player_"..player.UserId

    print("New Player Joined: "..PlayerKey..". Trying to load Data!")

    local Loaded = Instance.new("BoolValue") --Data Loaded Bool Value
    Loaded.Name = "DataLoaded"
    Loaded.Parent = player

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
    end)

Players.PlayerRemoving:Connect(function(player)
    local PlayerKey = "Player_"..player.UserId
    local CandyCane = player.Currency.CandyCane
    local Loaded = player.DataLoaded
    local playerCandyCane = DataStore:GetDataStore("CandyCane", PlayerKey)

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
end)