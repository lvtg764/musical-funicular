local ConnectionInspector = {}

function ConnectionInspector.Normalize(connection)
    if not connection then
        return nil
    end
    
    return {
        enabled = connection.Enabled,
        foreignState = connection.ForeignState,
        luaConnection = connection.LuaConnection,
        func = connection.Function,
        thread = connection.Thread,
        script = connection.Script
    }
end

function ConnectionInspector.InspectConnection(connection)
    return ConnectionInspector.Normalize(connection)
end

return ConnectionInspector
