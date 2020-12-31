local Players = game:GetService("Players")
local DataStore = game:GetService("DataStoreService")
local PhysicsService = game:GetService("PhysicsService")
local RepStorage = game.ReplicatedStorage
local HouseTable = workspace["Village Area"].Houses:GetChildren()
local DataDict = require(game.ServerScriptService.SessionData)

local function GetData(Key,player) --Get Data
    local count = 0
    local Data
    local playerData = DataStore:GetDataStore("Data", Key)
    repeat
        if count >= 1 then
            print("Retries: "..count..".")
            wait(5)
        end
    local success, error = pcall(function()
       Data = playerData:GetAsync(Key)
    end)
    count += 1
    
    if success and Data then
        player:WaitForChild("Currency").CandyCane.Value = Data["CandyCane"]
        for i = 1,3 do
        player:WaitForChild("Inventory").OwnedSleigh:FindFirstChild("Sleigh"..tostring(i)).Value = Data["Sleigh"..tostring(i)]
        end
        return true
    elseif not Data then
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
    player.CharacterAdded:Connect(function(character)
        PhysicsService:CollisionGroupSetCollidable("Scrap","Players",false)
        for i,v in ipairs(character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CollisionGroupId = PhysicsService:GetCollisionGroupId("Players")
            end
        end
        local Attachment1 = Instance.new("Attachment")
        Attachment1.Parent = player.Character.PrimaryPart
        player.CharacterAppearanceLoaded:Connect(function()
            character.Archivable = true
            local Cloned = character:Clone()
            Cloned.Humanoid.DisplayDistanceType = "None"
            Cloned.Parent = RepStorage.NPC
        end)
        end)

    local PlayerKey = "Player_"..player.UserId
    DataDict[#DataDict+1] = PlayerKey
    DataDict.PlayerKey = {}

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
    DataDict.PlayerKey["CandyCane"] = 0

    local Inventory = Instance.new("Folder") --Inventory Folder
    Inventory.Name = "Inventory"
    Inventory.Parent = player

    local SleighFolder = Instance.new("Folder") --Sleigh Ownage Folder
    SleighFolder.Name = "OwnedSleigh"
    SleighFolder.Parent = Inventory

    for i = 1,3 do
        local Sleigh = Instance.new("BoolValue")
        Sleigh.Name = "Sleigh"..tostring(i)
        Sleigh.Parent = SleighFolder
        DataDict.PlayerKey["Sleigh"..tostring(i)] = false
    end

    local PresentFolder = Instance.new("Folder") --Presents Folder
    PresentFolder.Name = "Presents"
    PresentFolder.Parent = Inventory

    for i = 1,4 do --Presents Bool Value
        local Present = Instance.new("BoolValue")
        Present.Name = "Present"..i
        Present.Parent = PresentFolder
    end

    local result = GetData(PlayerKey,player)
    Loaded.Value = result --In Case of Roblox Being Down don't Save Data

    local Letter = Instance.new("BoolValue") --Cashier Job
    Letter.Name = "HasLetter"
    Letter.Parent = player

    local OneToy = Instance.new("BoolValue") --Toy Maker Job
    OneToy.Name = "HasToy"
    OneToy.Parent = player

    local TwoToy = Instance.new("BoolValue") --Toy Wraper Job
    TwoToy.Name = "HasToyForWrap"
    TwoToy.Parent = player
    end)

Players.PlayerRemoving:Connect(function(player)
    local PlayerKey = "Player_"..player.UserId
    local PlayerData = DataDict.PlayerKey
    local Loaded = player.DataLoaded
    local Data = DataStore:GetDataStore("Data", PlayerKey)
    local House = player.OwnedHouse

    --Trying to save CandyCanes Currency
    local success, error = pcall(function()
        if Loaded.Value then
        PlayerData["CandyCane"] = player.Currency.CandyCane.Value
        for i = 1,3 do
        PlayerData["Sleigh"..tostring(i)] = player.Inventory.OwnedSleigh:FindFirstChild("Sleigh"..tostring(i)).Value
        end
        Data:UpdateAsync(PlayerKey,function()
                print(PlayerData)
                return PlayerData
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

require(game.ServerScriptService.FactoryItems).StartProduction()