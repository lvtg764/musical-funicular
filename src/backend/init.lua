local Backend = {}
Backend.__index = Backend

function Backend.new(modules)
    local self = setmetatable({}, Backend)
    
    local RuntimeStore = modules.RuntimeStore
    local Events = modules.Events
    local RemoteSpy = modules.RemoteSpy
    local SignalInspector = modules.SignalInspector
    local ConnectionInspector = modules.ConnectionInspector
    local FunctionInspector = modules.FunctionInspector
    local ScriptInspector = modules.ScriptInspector
    local ThreadInspector = modules.ThreadInspector
    local ActorInspector = modules.ActorInspector
    local InstanceInspector = modules.InstanceInspector
    local GCExplorer = modules.GCExplorer
    local CallStack = modules.CallStack
    
    self.store = RuntimeStore.new()
    self.events = Events.new()
    
    self.remoteSpy = RemoteSpy.new(self.store, self.events, {
        CallStack = CallStack,
        ScriptInspector = ScriptInspector
    })
    self.gcExplorer = GCExplorer.new(FunctionInspector)
    
    self.SignalInspector = SignalInspector
    self.ConnectionInspector = ConnectionInspector
    self.FunctionInspector = FunctionInspector
    self.ScriptInspector = ScriptInspector
    self.ThreadInspector = ThreadInspector.new({
        CallStack = CallStack,
        ScriptInspector = ScriptInspector
    })
    self.ActorInspector = ActorInspector.new(self.ThreadInspector)
    self.InstanceInspector = InstanceInspector
    self.CallStack = CallStack
    
    return self
end

function Backend:Start()
    self.remoteSpy:Start()
end

function Backend:Stop()
    self.remoteSpy:Stop()
end

function Backend:Refresh()
    self.gcExplorer:Clear()
end

function Backend:Clear()
    self.store:Clear()
end

function Backend:Destroy()
    self:Stop()
    self.store:Destroy()
    self.events:Destroy()
end

function Backend:OnRemote(callback)
    return self.events:OnRemote(callback)
end

function Backend:OnSignal(callback)
    return self.events:OnSignal(callback)
end

function Backend:OnConnection(callback)
    return self.events:OnConnection(callback)
end

function Backend:OnFunction(callback)
    return self.events:OnFunction(callback)
end

function Backend:OnThread(callback)
    return self.events:OnThread(callback)
end

function Backend:OnScript(callback)
    return self.events:OnScript(callback)
end

function Backend:OnInstance(callback)
    return self.events:OnInstance(callback)
end

function Backend:OnLog(callback)
    return self.events:OnLog(callback)
end

function Backend:InspectRemote(remoteRecord)
    if not remoteRecord or remoteRecord.kind ~= "remote" then
        return nil
    end
    
    local detailed = {
        id = remoteRecord.id,
        kind = remoteRecord.kind,
        direction = remoteRecord.direction,
        instance = remoteRecord.instance,
        name = remoteRecord.name,
        path = remoteRecord.path,
        method = remoteRecord.method,
        args = remoteRecord.args,
        timestamp = remoteRecord.timestamp,
        callstack = remoteRecord.callstack,
        origin = remoteRecord.origin
    }
    
    if remoteRecord.thread then
        detailed.thread = self.ThreadInspector.Inspect(remoteRecord.thread)
    end
    
    local callstack = remoteRecord.callstack or {}
    if #callstack > 0 and callstack[1].func then
        detailed["function"] = self.FunctionInspector.Inspect(callstack[1].func)
    end
    
    return detailed
end

function Backend:InspectSignal(signalRecord)
    return self.SignalInspector.InspectSignal(signalRecord.signal or signalRecord)
end

function Backend:InspectConnection(connectionRecord)
    return self.ConnectionInspector.InspectConnection(connectionRecord)
end

function Backend:InspectFunction(functionRecord)
    local fn = functionRecord.func or functionRecord["function"] or functionRecord
    return self.FunctionInspector.Inspect(fn)
end

function Backend:InspectScript(scriptRecord)
    local script = scriptRecord.script or scriptRecord
    return self.ScriptInspector.GetScriptInfo(script)
end

function Backend:InspectThread(threadRecord)
    local thread = threadRecord.thread or threadRecord
    return self.ThreadInspector.Inspect(thread)
end

function Backend:InspectActor(actorRecord)
    local actor = actorRecord.actor or actorRecord
    return self.ActorInspector.Inspect(actor)
end

function Backend:InspectInstance(instanceRecord)
    local instance = instanceRecord.instance or instanceRecord
    return self.InstanceInspector.Inspect(instance)
end

function Backend:GetRemoteHistory()
    return self.remoteSpy:GetHistory()
end

function Backend:SetRemoteDirection(direction)
    self.remoteSpy:SetDirection(direction)
end

function Backend:GetRemoteDirection()
    return self.remoteSpy:GetDirection()
end

function Backend:GetScripts()
    return self.ScriptInspector.GetAllScripts()
end

function Backend:GetRunningScripts()
    return self.ScriptInspector.GetRunningScripts()
end

function Backend:GetLoadedModules()
    return self.ScriptInspector.GetLoadedModules()
end

function Backend:GetActors()
    return self.ActorInspector.GetActors()
end

function Backend:GetInstances()
    return self.InstanceInspector.GetInstances()
end

function Backend:GetNilInstances()
    return self.InstanceInspector.GetNilInstances()
end

function Backend:ScanGC(includeTables)
    return self.gcExplorer:Scan(includeTables)
end

function Backend:GetGCFunctions()
    return self.gcExplorer:GetFunctions()
end

function Backend:GetGCTables()
    return self.gcExplorer:GetTables()
end

return Backend
