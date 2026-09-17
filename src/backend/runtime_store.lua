local RuntimeStore = {}
RuntimeStore.__index = RuntimeStore

function RuntimeStore.new()
    local self = setmetatable({}, RuntimeStore)
    
    self.instanceCache = {}
    self.functionCache = {}
    self.scriptCache = {}
    self.threadCache = {}
    self.actorCache = {}
    
    self.remoteHistory = {}
    self.signalHistory = {}
    self.connectionHistory = {}
    
    self.nextId = 1
    
    return self
end

function RuntimeStore:GetId()
    local id = self.nextId
    self.nextId = id + 1
    return tostring(id)
end

function RuntimeStore:CacheInstance(instance)
    if not instance then return nil end
    
    local existing = self.instanceCache[instance]
    if existing then return existing end
    
    local id = self:GetId()
    self.instanceCache[instance] = id
    return id
end

function RuntimeStore:CacheFunction(fn)
    if not fn then return nil end
    
    local existing = self.functionCache[fn]
    if existing then return existing end
    
    local id = self:GetId()
    self.functionCache[fn] = id
    return id
end

function RuntimeStore:CacheScript(script)
    if not script then return nil end
    
    local existing = self.scriptCache[script]
    if existing then return existing end
    
    local id = self:GetId()
    self.scriptCache[script] = id
    return id
end

function RuntimeStore:CacheThread(thread)
    if not thread then return nil end
    
    local existing = self.threadCache[thread]
    if existing then return existing end
    
    local id = self:GetId()
    self.threadCache[thread] = id
    return id
end

function RuntimeStore:CacheActor(actor)
    if not actor then return nil end
    
    local existing = self.actorCache[actor]
    if existing then return existing end
    
    local id = self:GetId()
    self.actorCache[actor] = id
    return id
end

function RuntimeStore:AddRemote(record)
    table.insert(self.remoteHistory, record)
end

function RuntimeStore:AddSignal(record)
    table.insert(self.signalHistory, record)
end

function RuntimeStore:AddConnection(record)
    table.insert(self.connectionHistory, record)
end

function RuntimeStore:GetRemoteHistory()
    return self.remoteHistory
end

function RuntimeStore:GetSignalHistory()
    return self.signalHistory
end

function RuntimeStore:GetConnectionHistory()
    return self.connectionHistory
end

function RuntimeStore:Clear()
    self.remoteHistory = {}
    self.signalHistory = {}
    self.connectionHistory = {}
end

function RuntimeStore:Destroy()
    self.instanceCache = {}
    self.functionCache = {}
    self.scriptCache = {}
    self.threadCache = {}
    self.actorCache = {}
    self.remoteHistory = {}
    self.signalHistory = {}
    self.connectionHistory = {}
end

return RuntimeStore
