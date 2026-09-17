local ScriptInspector = {}

function ScriptInspector.GetAllScripts()
    local success, scripts = pcall(getscripts)
    if not success then
        return {}
    end
    return scripts or {}
end

function ScriptInspector.GetRunningScripts()
    local success, scripts = pcall(getrunningscripts)
    if not success then
        return {}
    end
    return scripts or {}
end

function ScriptInspector.GetLoadedModules()
    local success, modules = pcall(getloadedmodules)
    if not success then
        return {}
    end
    return modules or {}
end

function ScriptInspector.GetScriptClosure(script)
    local success, closure = pcall(function()
        return getscriptclosure(script)
    end)
    if not success then
        return nil
    end
    return closure
end

function ScriptInspector.GetScriptBytecode(script)
    local success, bytecode = pcall(function()
        return getscriptbytecode(script)
    end)
    if not success then
        return nil
    end
    return bytecode
end

function ScriptInspector.GetScriptFromThread(thread)
    local success, script = pcall(function()
        return getscriptfromthread(thread)
    end)
    if not success then
        return nil
    end
    return script
end

function ScriptInspector.GetScriptThread(script)
    local success, thread = pcall(function()
        return getscriptthread(script)
    end)
    if not success then
        return nil
    end
    return thread
end

function ScriptInspector.GetCallingScript()
    local success, script = pcall(getcallingscript)
    if not success then
        return nil
    end
    return script
end

function ScriptInspector.GetScriptHash(script)
    local success, hash = pcall(function()
        return getscripthash(script)
    end)
    if not success then
        return nil
    end
    return hash
end

function ScriptInspector.GetDecompiledSource(script)
    local success, source = pcall(function()
        return decompile(script)
    end)
    if not success then
        return nil
    end
    return source
end

function ScriptInspector.GetDumpedBytecode(fn)
    local success, bytecode = pcall(function()
        return dumpbytecode(fn)
    end)
    if not success then
        return nil
    end
    return bytecode
end

function ScriptInspector.GetScriptInfo(script)
    if not script or not script:IsA("LuaSourceContainer") then
        return nil
    end
    
    return {
        name = script.Name,
        path = script:GetFullName(),
        className = script.ClassName,
        hash = ScriptInspector.GetScriptHash(script),
        source = ScriptInspector.GetDecompiledSource(script),
        bytecode = ScriptInspector.GetScriptBytecode(script),
        closure = ScriptInspector.GetScriptClosure(script),
        thread = ScriptInspector.GetScriptThread(script)
    }
end

function ScriptInspector.GetOrigin(script)
    if not script or not script:IsA("LuaSourceContainer") then
        return nil
    end
    
    return {
        script = script,
        name = script.Name,
        path = script:GetFullName(),
        hash = ScriptInspector.GetScriptHash(script),
        decompiled = ScriptInspector.GetDecompiledSource(script)
    }
end

return ScriptInspector
