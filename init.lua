local VERSION = "1.1.2"
local BASE_URL = "https://raw.githubusercontent.com/lvtg764/musical-funicular/main/"
local TIMESTAMP = tostring(math.floor(tick()))
local RANDOM = tostring(math.random(100000, 999999))
local CACHE_BUST = "?v=" .. VERSION .. "&t=" .. TIMESTAMP .. "&r=" .. RANDOM

print("[Cobalt] Starting loader v" .. VERSION)

local function load(path)
    print("[Cobalt] Fetching:", path)
    local success, content = pcall(function()
        return game:HttpGet(BASE_URL .. path .. CACHE_BUST)
    end)
    
    if not success then
        error("[Cobalt] Failed to fetch " .. path .. ": " .. tostring(content))
    end
    
    if not content or content == "" then
        error("[Cobalt] Empty content from " .. path)
    end
    
    print("[Cobalt] Compiling:", path)
    local func, compileErr = loadstring(content)
    if not func then
        error("[Cobalt] Failed to compile " .. path .. ": " .. tostring(compileErr))
    end
    
    print("[Cobalt] Executing:", path)
    local execSuccess, result = pcall(func)
    if not execSuccess then
        error("[Cobalt] Failed to execute " .. path .. ": " .. tostring(result))
    end
    
    return result
end

print("[Cobalt] Loading modules...")

local RuntimeStore = load("src/backend/runtime_store.lua")
local Events = load("src/backend/events.lua")
local CallStack = load("src/backend/callstack.lua")
local ScriptInspector = load("src/backend/script_inspector.lua")
local SignalInspector = load("src/backend/signal_inspector.lua")
local ConnectionInspector = load("src/backend/connection_inspector.lua")
local FunctionInspector = load("src/backend/function_inspector.lua")
local InstanceInspector = load("src/backend/instance_inspector.lua")
local ThreadInspector = load("src/backend/thread_inspector.lua")
local ActorInspector = load("src/backend/actor_inspector.lua")
local GCExplorer = load("src/backend/gc_explorer.lua")
local RemoteSpy = load("src/backend/remote_spy.lua")
local Backend = load("src/backend/init.lua")
local UI = load("src/ui/main.lua")

print("[Cobalt] Initializing backend...")

local backend = Backend.new({
    RuntimeStore = RuntimeStore,
    Events = Events,
    RemoteSpy = RemoteSpy,
    SignalInspector = SignalInspector,
    ConnectionInspector = ConnectionInspector,
    FunctionInspector = FunctionInspector,
    ScriptInspector = ScriptInspector,
    ThreadInspector = ThreadInspector,
    ActorInspector = ActorInspector,
    InstanceInspector = InstanceInspector,
    GCExplorer = GCExplorer,
    CallStack = CallStack
})

print("[Cobalt] Creating UI...")

local ui = UI.new()

backend:OnRemote(function(record)
    ui:Add("RemoteSpy", record)
end)

ui:SetDirectionChangeCallback(function(direction)
    ui:RenderList("RemoteSpy")
end)

backend:Start()
ui:SelectTab("RemoteSpy")

getgenv().Cobalt = {
    Backend = backend,
    UI = ui
}

print("[Cobalt] Loaded successfully!")
