local CallStack = {}

function CallStack.Get(offset)
    offset = offset or 2
    
    local success, stack = pcall(function()
        return debug.getcallstack(offset)
    end)
    
    if not success or not stack then
        return {}
    end
    
    local normalized = {}
    for i, frame in ipairs(stack) do
        table.insert(normalized, {
            level = i,
            source = frame.source or "Unknown",
            line = frame.line or 0,
            what = frame.what or "?",
            name = frame.name or "",
            func = frame.func
        })
    end
    
    return normalized
end

function CallStack.GetStack(level, index)
    local success, result = pcall(function()
        return debug.getstack(level, index)
    end)
    
    if not success then
        return nil
    end
    
    return result
end

function CallStack.IsValidLevel(level)
    local success, valid = pcall(function()
        return debug.isvalidlevel(level)
    end)
    
    if not success then
        return false
    end
    
    return valid
end

return CallStack
