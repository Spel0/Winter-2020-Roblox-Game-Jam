local RunService = game:GetService("RunService")
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

game:BindToClose(function()
    if not RunService:IsStudio() then
        local PlayersInGame = Players:GetPlayers()
        print("Server Shutdown Occured, Saving Players Data!")
        for i,v in ipairs(PlayersInGame) do
        local PlayerKey = "Player_"..v.UserId
        local CandyCane = v.Currency.CandyCane
        local Loaded = v.DataLoaded
        local playerCandyCane = DataStoreService:GetDataStore("CandyCane", PlayerKey)
    
        --Trying to save CandyCanes Currency
        local success, error = pcall(function()
            if Loaded.Value then
            playerCandyCane:UpdateAsync(PlayerKey,function(oldValue)
                local NewValue = CandyCane.Value
                    if oldValue == NewValue then
                        return oldValue
                     else
                        return NewValue
                    end
                end)          
            end
        end)
    end
    print("Completed Saving Data")
    end
end)
