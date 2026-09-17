local RemoteSpy = {}
RemoteSpy.__index = RemoteSpy

function RemoteSpy.new(store, events, modules)
    local self = setmetatable({}, RemoteSpy)
    
    self.store = store
    self.events = events
    self.CallStack = modules.CallStack
    self.ScriptInspector = modules.ScriptInspector
    self.running = false
    self.hooks = {}
    self.direction = "outgoing"
    
    return self
end

function RemoteSpy:Start()
    if self.running then return end
    self.running = true
    
    self:HookOutgoing()
    self:HookIncoming()
end

function RemoteSpy:Stop()
    if not self.running then return end
    self.running = false
    
    for _, hook in ipairs(self.hooks) do
        if hook.restore then
            pcall(hook.restore)
        end
    end
    
    self.hooks = {}
end

function RemoteSpy:IsRunning()
    return self.running
end

function RemoteSpy:HookOutgoing()
    local original = hookmetamethod(game, "__namecall", function(...)
        local args = {...}
        local instance = args[1]
        local method = getnamecallmethod()
        
        if self.running and (method == "FireServer" or method == "fireServer" or method == "InvokeServer" or method == "invokeServer") then
            if typeof(instance) == "Instance" and (instance:IsA("RemoteEvent") or instance:IsA("RemoteFunction")) then
                self:CaptureOutgoing(instance, method, {select(2, ...)})
            end
        end
        
        return original(...)
    end)
    
    table.insert(self.hooks, {
        type = "outgoing",
        restore = function()
            hookmetamethod(game, "__namecall", original)
        end
    })
end

function RemoteSpy:HookIncoming()
    local function hookRemoteEvent(remote)
        if not remote:IsA("RemoteEvent") then return end
        
        local success, connection = pcall(function()
            return remote.OnClientEvent:Connect(function(...)
                if self.running then
                    self:CaptureIncoming(remote, "OnClientEvent", {...})
                end
            end)
        end)
        
        if success and connection then
            table.insert(self.hooks, {
                type = "incoming",
                connection = connection,
                restore = function()
                    connection:Disconnect()
                end
            })
        end
    end
    
    local function hookRemoteFunction(remote)
        if not remote:IsA("RemoteFunction") then return end
        
        local success, original = pcall(function()
            return remote.OnClientInvoke
        end)
        
        if success and original then
            local hooked
            hooked = function(...)
                if self.running then
                    self:CaptureIncoming(remote, "OnClientInvoke", {...})
                end
                if type(original) == "function" then
                    return original(...)
                end
            end
            
            remote.OnClientInvoke = hooked
            
            table.insert(self.hooks, {
                type = "incoming",
                restore = function()
                    remote.OnClientInvoke = original
                end
            })
        end
    end
    
    local function scanForRemotes(parent)
        local success, descendants = pcall(function() return parent:GetDescendants() end)
        if not success or not descendants then return end
        
        for _, child in pairs(descendants) do
            if child and typeof(child) == "Instance" then
                local isRemoteEvent = pcall(function() return child:IsA("RemoteEvent") end)
                local isRemoteFunction = pcall(function() return child:IsA("RemoteFunction") end)
                
                if isRemoteEvent then
                    pcall(hookRemoteEvent, child)
                elseif isRemoteFunction then
                    pcall(hookRemoteFunction, child)
                end
            end
        end
    end
    
    scanForRemotes(game)
    
    local connection = game.DescendantAdded:Connect(function(child)
        if child:IsA("RemoteEvent") then
            hookRemoteEvent(child)
        elseif child:IsA("RemoteFunction") then
            hookRemoteFunction(child)
        end
    end)
    
    table.insert(self.hooks, {
        type = "incoming",
        connection = connection,
        restore = function()
            connection:Disconnect()
        end
    })
end

function RemoteSpy:CaptureOutgoing(remote, method, args)
    local record = self:CreateRecord(remote, method, args, "outgoing")
    self.store:AddRemote(record)
    self.events:Emit("OnRemote", record)
end

function RemoteSpy:CaptureIncoming(remote, method, args)
    local record = self:CreateRecord(remote, method, args, "incoming")
    self.store:AddRemote(record)
    self.events:Emit("OnRemote", record)
end

function RemoteSpy:CreateRecord(remote, method, args, direction)
    local id = self.store:GetId()
    local callingScript = self.ScriptInspector.GetCallingScript()
    local callstack = self.CallStack.Get(3)
    
    local record = {
        id = id,
        kind = "remote",
        direction = direction,
        instance = remote,
        name = remote.Name,
        path = remote:GetFullName(),
        method = method,
        args = args,
        timestamp = os.clock(),
        caller = nil,
        thread = coroutine.running(),
        callstack = callstack,
        origin = nil
    }
    
    if callingScript then
        record.origin = self.ScriptInspector.GetOrigin(callingScript)
    end
    
    return record
end

function RemoteSpy:GetHistory()
    return self.store:GetRemoteHistory()
end

function RemoteSpy:ClearHistory()
    local history = self.store:GetRemoteHistory()
    for i = #history, 1, -1 do
        history[i] = nil
    end
end

function RemoteSpy:SetDirection(direction)
    if direction == "incoming" or direction == "outgoing" or direction == "all" then
        self.direction = direction
    end
end

function RemoteSpy:GetDirection()
    return self.direction
end

return RemoteSpy
