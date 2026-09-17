local ActorInspector = {}

function ActorInspector.new(ThreadInspector)
    return setmetatable({
        ThreadInspector = ThreadInspector
    }, {__index = ActorInspector})
end

function ActorInspector.GetActors()
    local success, actors = pcall(getactors)
    if not success then
        return {}
    end
    return actors or {}
end

function ActorInspector.GetActorThreads()
    local success, threads = pcall(getactorthreads)
    if not success then
        return {}
    end
    return threads or {}
end

function ActorInspector.GetDeletedActors()
    local success, actors = pcall(getdeletedactors)
    if not success then
        return {}
    end
    return actors or {}
end

function ActorInspector:Inspect(actor)
    if not actor or not actor:IsA("Actor") then
        return nil
    end
    
    local threads = {}
    local actorThreads = ActorInspector.GetActorThreads()
    
    for _, thread in ipairs(actorThreads) do
        local threadRecord = self.ThreadInspector.Inspect(thread)
        if threadRecord then
            table.insert(threads, threadRecord)
        end
    end
    
    return {
        kind = "actor",
        actor = actor,
        name = actor.Name,
        path = actor:GetFullName(),
        threads = threads
    }
end

return ActorInspector
