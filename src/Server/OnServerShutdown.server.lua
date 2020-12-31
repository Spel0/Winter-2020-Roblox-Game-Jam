local RunService = game:GetService("RunService")
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local DataDict = require(game.ServerScriptService.SessionData)

game:BindToClose(function()
    if not RunService:IsStudio() then
        local PlayersInGame = Players:GetPlayers()
        print("Server Shutdown Occured, Saving Players Data!")
        local Data = DataStoreService:GetDataStore("Data")
        for i,v in ipairs(PlayersInGame) do
            local PlayerKey = "Player_"..v.UserId
            local PlayerData = DataDict.PlayerKey
            local Loaded = v.DataLoaded
            if Loaded.Value then
                PlayerData["CandyCane"] = v.Currency.CandyCane.Value
                for n = 1,3 do
                    PlayerData["Sleigh"..tostring(n)] = v.Inventory.OwnedSleigh:FindFirstChild("Sleigh"..tostring(n)).Value
                end
                Data:UpdateAsync(PlayerKey,function()
                    print(PlayerData)
                    return PlayerData
                end)          
            end
        end      
      print("Completed Saving Data")
    end
end)
