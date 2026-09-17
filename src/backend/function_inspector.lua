local FunctionInspector = {}

function FunctionInspector.GetFunctionInfo(fn)
    if type(fn) ~= "function" then
        return nil
    end
    
    local success, info = pcall(function()
        return debug.getinfo(fn)
    end)
    
    if not success or not info then
        return nil
    end
    
    return {
        source = info.source,
        short_src = info.short_src,
        linedefined = info.linedefined,
        what = info.what,
        name = info.name,
        namewhat = info.namewhat,
        nups = info.nups,
        func = info.func,
        currentline = info.currentline,
        numparams = info.numparams,
        is_vararg = info.is_vararg
    }
end

function FunctionInspector.GetConstants(fn)
    if type(fn) ~= "function" then
        return {}
    end
    
    local success, constants = pcall(function()
        return debug.getconstants(fn)
    end)
    
    if not success or not constants then
        return {}
    end
    
    return constants
end

function FunctionInspector.GetConstant(fn, index)
    if type(fn) ~= "function" then
        return nil
    end
    
    local success, constant = pcall(function()
        return debug.getconstant(fn, index)
    end)
    
    if not success then
        return nil
    end
    
    return constant
end

function FunctionInspector.GetProtos(fn)
    if type(fn) ~= "function" then
        return {}
    end
    
    local success, protos = pcall(function()
        return debug.getprotos(fn)
    end)
    
    if not success or not protos then
        return {}
    end
    
    return protos
end

function FunctionInspector.GetProto(fn, index, active)
    if type(fn) ~= "function" then
        return nil
    end
    
    local success, proto = pcall(function()
        return debug.getproto(fn, index, active)
    end)
    
    if not success then
        return nil
    end
    
    return proto
end

function FunctionInspector.GetUpvalues(fn)
    if type(fn) ~= "function" then
        return {}
    end
    
    local success, upvalues = pcall(function()
        return debug.getupvalues(fn)
    end)
    
    if not success or not upvalues then
        return {}
    end
    
    return upvalues
end

function FunctionInspector.GetUpvalue(fn, index)
    if type(fn) ~= "function" then
        return nil
    end
    
    local success, upvalue = pcall(function()
        return debug.getupvalue(fn, index)
    end)
    
    if not success then
        return nil
    end
    
    return upvalue
end

function FunctionInspector.GetFunctionHash(fn)
    if type(fn) ~= "function" then
        return nil
    end
    
    local success, hash = pcall(function()
        return getfunctionhash(fn)
    end)
    
    if not success then
        return nil
    end
    
    return hash
end

function FunctionInspector.GetClosureType(fn)
    if type(fn) ~= "function" then
        return "unknown"
    end
    
    local checks = {
        {fn = iscclosure, name = "C"},
        {fn = islclosure, name = "Lua"},
        {fn = isexecutorclosure, name = "Executor"},
        {fn = isnewcclosure, name = "NewCClosure"}
    }
    
    for _, check in ipairs(checks) do
        local success, result = pcall(function()
            return check.fn(fn)
        end)
        
        if success and result then
            return check.name
        end
    end
    
    return "unknown"
end

function FunctionInspector.Inspect(fn, depth)
    depth = depth or 0
    if depth > 5 or type(fn) ~= "function" then
        return nil
    end
    
    local info = FunctionInspector.GetFunctionInfo(fn)
    if not info then
        return nil
    end
    
    local record = {
        kind = "function",
        func = fn,
        info = info,
        hash = FunctionInspector.GetFunctionHash(fn),
        closureType = FunctionInspector.GetClosureType(fn),
        constants = FunctionInspector.GetConstants(fn),
        upvalues = FunctionInspector.GetUpvalues(fn),
        protos = {}
    }
    
    local protos = FunctionInspector.GetProtos(fn)
    for i, proto in ipairs(protos) do
        if depth < 3 then
            local protoRecord = FunctionInspector.Inspect(proto, depth + 1)
            if protoRecord then
                table.insert(record.protos, protoRecord)
            end
        end
    end
    
    return record
end

return FunctionInspector
