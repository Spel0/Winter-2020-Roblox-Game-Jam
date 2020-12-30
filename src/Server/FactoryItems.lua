local module = {
    LettersInStock = 0,
    ToysInStock = 0,
    PresentsInStock = 0
}

function module.StartProduction()
    local ScrapLine = {}
    local Max = 10
    local CoroutinePlaying = false
    local RunService = game:GetService("RunService")
    local RepStorage = game:GetService("ReplicatedStorage")
    coroutine.resume(coroutine.create(function()
        workspace.ScrapFolder.ChildAdded:Connect(function(child)
            ScrapLine[#ScrapLine+1] = child
            module.ToysInStock += 1
            child.PrimaryPart.Proxy.Triggered:Connect(function(player)
                print("Toy Proxy got Triggered!!!")
                --To Do player constructing a toy section of the Script
                child:Destroy()
                module.ToysInStock -= 1
            end)
        end)
        while wait(30) do
            if #ScrapLine > Max then
                repeat
                    RunService.Heartbeat:Wait()
                    ScrapLine[#ScrapLine]:Destroy()
                    table.remove(ScrapLine,#ScrapLine)
                until #ScrapLine <= Max
            end
        end
    end))
    while RunService.Heartbeat:Wait() do
        if not CoroutinePlaying and module.LettersInStock > 0 then
        coroutine.resume(coroutine.create(function()
            CoroutinePlaying = true
            while module.LettersInStock > 0 do
                wait(10)
                local Clone = RepStorage.Scrap:Clone()
                Clone:SetPrimaryPartCFrame(workspace["Workshop Area"]["Main Building"].ScrapSpawn.CFrame)
                Clone.Parent = workspace.ScrapFolder
                module.LettersInStock -= 1
            end
            CoroutinePlaying = false
        end))
    end
    end
end

return module