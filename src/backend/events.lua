local Events = {}
Events.__index = Events

function Events.new()
    local self = setmetatable({}, Events)
    
    self.listeners = {
        OnRemote = {},
        OnSignal = {},
        OnConnection = {},
        OnFunction = {},
        OnThread = {},
        OnScript = {},
        OnInstance = {},
        OnLog = {}
    }
    
    return self
end

function Events:On(eventName, callback)
    if not self.listeners[eventName] then
        self.listeners[eventName] = {}
    end
    
    table.insert(self.listeners[eventName], callback)
    
    return function()
        for i, cb in ipairs(self.listeners[eventName]) do
            if cb == callback then
                table.remove(self.listeners[eventName], i)
                break
            end
        end
    end
end

function Events:Emit(eventName, ...)
    local listeners = self.listeners[eventName]
    if not listeners then return end
    
    for _, callback in ipairs(listeners) do
        task.spawn(callback, ...)
    end
end

function Events:OnRemote(callback)
    return self:On("OnRemote", callback)
end

function Events:OnSignal(callback)
    return self:On("OnSignal", callback)
end

function Events:OnConnection(callback)
    return self:On("OnConnection", callback)
end

function Events:OnFunction(callback)
    return self:On("OnFunction", callback)
end

function Events:OnThread(callback)
    return self:On("OnThread", callback)
end

function Events:OnScript(callback)
    return self:On("OnScript", callback)
end

function Events:OnInstance(callback)
    return self:On("OnInstance", callback)
end

function Events:OnLog(callback)
    return self:On("OnLog", callback)
end

function Events:Destroy()
    for key in pairs(self.listeners) do
        self.listeners[key] = {}
    end
end

return Events
