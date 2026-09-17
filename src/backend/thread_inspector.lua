local ThreadInspector = {}

function ThreadInspector.new(modules)
    return setmetatable({
        CallStack = modules.CallStack,
        ScriptInspector = modules.ScriptInspector
    }, {__index = ThreadInspector})
end

function ThreadInspector.GetThreadIdentity(thread)
    local success, identity = pcall(function()
        return getthreadidentity()
    end)
    if not success then
        return nil
    end
    return identity
end

function ThreadInspector.IsParallel()
    local success, parallel = pcall(is_parallel)
    if not success then
        return false
    end
    return parallel or false
end

function ThreadInspector:Inspect(thread)
    if type(thread) ~= "thread" then
        return nil
    end
    
    local script = self.ScriptInspector.GetScriptFromThread(thread)
    local callstack = self.CallStack.Get()
    
    return {
        kind = "thread",
        thread = thread,
        status = coroutine.status(thread),
        script = script,
        scriptPath = script and script:GetFullName() or nil,
        identity = ThreadInspector.GetThreadIdentity(),
        parallel = ThreadInspector.IsParallel(),
        callstack = callstack
    }
end

return ThreadInspector
