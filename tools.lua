
local Tools = {}

Tools.clone = function(t) -- deep-copy a table
    if type(t) ~= "table" then return t end
    local meta = getmetatable(t)
    local target = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            target[k] = Tools.clone(v)
        else
            target[k] = v
        end
    end
    setmetatable(target, meta)
    return target
end

Tools.glowEffect = function(min, max, period)
    local temp = math.abs((globalTick % period) - period/2 + 1)*(max-min)/(period/2) + min
    print(temp)
    return temp
end

Tools.setColor = function(color, alpha)
    love.graphics.setColor(color[1], color[2], color[3], alpha)
end

return Tools