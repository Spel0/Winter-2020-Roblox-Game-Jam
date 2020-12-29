local module = {}

function module.PickRandom(Folder) --Advanced math.random
    local t = Folder:GetChildren()
    local Result = math.random(1,#t)
    for i,v in ipairs(t) do
        if i == Result then
            return v
        else
            continue
        end
    end
end

return module