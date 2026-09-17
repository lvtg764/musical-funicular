local GCExplorer = {}
GCExplorer.__index = GCExplorer

function GCExplorer.new(FunctionInspector)
    local self = setmetatable({}, GCExplorer)
    
    self.FunctionInspector = FunctionInspector
    self.lastScan = 0
    self.throttle = 5
    self.cache = {}
    
    return self
end

function GCExplorer:ShouldRefresh()
    return (os.clock() - self.lastScan) > self.throttle
end

function GCExplorer:GetGC(includeTables)
    local success, gc = pcall(function()
        return getgc(includeTables)
    end)
    if not success then
        return {}
    end
    return gc or {}
end

function GCExplorer:FilterGC(filterType, filterOptions, filterOne)
    local success, result = pcall(function()
        return filtergc(filterType, filterOptions, filterOne)
    end)
    if not success then
        return filterOne and nil or {}
    end
    return result
end

function GCExplorer:Scan(includeTables)
    if not self:ShouldRefresh() then
        return self.cache
    end
    
    self.lastScan = os.clock()
    self.cache = {}
    
    local gc = self:GetGC(includeTables)
    
    for _, obj in ipairs(gc) do
        local objType = type(obj)
        
        if objType == "function" then
            local info = self.FunctionInspector.GetFunctionInfo(obj)
            table.insert(self.cache, {
                kind = "function",
                type = objType,
                func = obj,
                name = info and info.name or "Anonymous",
                source = info and info.source or "Unknown"
            })
        elseif objType == "table" then
            local mt = getrawmetatable(obj)
            table.insert(self.cache, {
                kind = "table",
                type = objType,
                value = obj,
                name = (mt and mt.__type) and tostring(mt.__type) or "Table"
            })
        elseif objType == "userdata" then
            local name = "Userdata"
            pcall(function()
                name = obj:GetFullName()
            end)
            table.insert(self.cache, {
                kind = "userdata",
                type = objType,
                value = obj,
                name = name
            })
        end
    end
    
    return self.cache
end

function GCExplorer:GetFunctions()
    local functions = {}
    for _, obj in ipairs(self.cache) do
        if obj.kind == "function" then
            table.insert(functions, obj)
        end
    end
    return functions
end

function GCExplorer:GetTables()
    local tables = {}
    for _, obj in ipairs(self.cache) do
        if obj.kind == "table" then
            table.insert(tables, obj)
        end
    end
    return tables
end

function GCExplorer:Clear()
    self.cache = {}
    self.lastScan = 0
end

return GCExplorer
