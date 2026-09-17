local InstanceInspector = {}

function InstanceInspector.GetInstances()
    local success, instances = pcall(getinstances)
    if not success then
        return {}
    end
    return instances or {}
end

function InstanceInspector.GetNilInstances()
    local success, instances = pcall(getnilinstances)
    if not success then
        return {}
    end
    return instances or {}
end

function InstanceInspector.GetProperties(instance)
    local success, props = pcall(function()
        return getproperties(instance)
    end)
    if not success then
        return {}
    end
    return props or {}
end

function InstanceInspector.GetHiddenProperties(instance)
    local success, props = pcall(function()
        return gethiddenproperties(instance)
    end)
    if not success then
        return {}
    end
    return props or {}
end

function InstanceInspector.GetHiddenProperty(instance, property)
    local success, value = pcall(function()
        return gethiddenproperty(instance, property)
    end)
    if not success then
        return nil
    end
    return value
end

function InstanceInspector.IsScriptable(instance, property)
    local success, scriptable = pcall(function()
        return isscriptable(instance, property)
    end)
    if not success then
        return false
    end
    return scriptable or false
end

function InstanceInspector.GetBinaryStringValue(instance, property, base64)
    local success, value = pcall(function()
        return getbspval(instance, property, base64)
    end)
    if not success then
        return nil
    end
    return value
end

function InstanceInspector.IsNetworkOwner(instance)
    local success, owner = pcall(function()
        return isnetworkowner(instance)
    end)
    if not success then
        return false
    end
    return owner or false
end

function InstanceInspector.GetCallbackValue(instance, property)
    local success, callback = pcall(function()
        return getcallbackvalue(instance, property)
    end)
    if not success then
        return nil
    end
    return callback
end

function InstanceInspector.GetRenderSteppedCallbacks()
    local success, callbacks = pcall(getrendersteppedlist)
    if not success then
        return {}
    end
    return callbacks or {}
end

function InstanceInspector.Inspect(instance)
    if not instance or not typeof(instance) == "Instance" then
        return nil
    end
    
    return {
        kind = "instance",
        instance = instance,
        name = instance.Name,
        path = instance:GetFullName(),
        className = instance.ClassName,
        properties = InstanceInspector.GetProperties(instance),
        hiddenProperties = InstanceInspector.GetHiddenProperties(instance),
        networkOwner = InstanceInspector.IsNetworkOwner(instance)
    }
end

return InstanceInspector
