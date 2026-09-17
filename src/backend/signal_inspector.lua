local SignalInspector = {}

print("[SignalInspector] Module loaded - vararg fix applied")

function SignalInspector.CanSignalReplicate(signal)
    local success, result = pcall(function()
        return cansignalreplicate(signal)
    end)
    if not success then
        return false
    end
    return result or false
end

function SignalInspector.GetSignalArguments(signal)
    local success, args = pcall(function()
        return getsignalarguments(signal)
    end)
    if not success then
        return {}
    end
    return args or {}
end

function SignalInspector.GetSignalArgumentInfo(signal)
    local success, info = pcall(function()
        return getsignalargumentsinfo(signal)
    end)
    if not success then
        return {}
    end
    return info or {}
end

function SignalInspector.GetSignalWhitelist()
    local success, whitelist = pcall(getsignalwhitelist)
    if not success then
        return {}
    end
    return whitelist or {}
end

function SignalInspector.GetSignalConnections(signal)
    local success, connections = pcall(function()
        return getconnections(signal)
    end)
    if not success then
        return {}
    end
    return connections or {}
end

function SignalInspector.GetSignalConnection(signal, index)
    local success, connection = pcall(function()
        return getconnection(signal, index)
    end)
    if not success then
        return nil
    end
    return connection
end

function SignalInspector.FireSignal(signal, ...)
    local args = {...}
    local success = pcall(function()
        firesignal(signal, unpack(args))
    end)
    return success
end

function SignalInspector.ReplicateSignal(signal, ...)
    local args = {...}
    local success = pcall(function()
        replicatesignal(signal, unpack(args))
    end)
    return success
end

function SignalInspector.InspectSignal(signal)
    if typeof(signal) ~= "RBXScriptSignal" then
        return nil
    end
    
    local record = {
        kind = "signal",
        signal = signal,
        name = tostring(signal),
        replicable = SignalInspector.CanSignalReplicate(signal),
        arguments = SignalInspector.GetSignalArguments(signal),
        argumentsInfo = SignalInspector.GetSignalArgumentInfo(signal),
        connections = {}
    }
    
    local connections = SignalInspector.GetSignalConnections(signal)
    for i, conn in ipairs(connections) do
        table.insert(record.connections, {
            index = i,
            enabled = conn.Enabled,
            foreignState = conn.ForeignState,
            luaConnection = conn.LuaConnection,
            func = conn.Function,
            thread = conn.Thread
        })
    end
    
    return record
end

return SignalInspector
