# Cobalt

Runtime analysis tool for Roblox executors built with Potassium API.

## Usage

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/lvtg764/musical-funicular/main/loader.lua"))()
```

## Features

- **Remote Spy**: Capture and analyze both incoming and outgoing RemoteEvent/RemoteFunction calls
- **Script Explorer**: Browse and decompile scripts in the game
- **Function Explorer**: Inspect functions from the garbage collector
- **Thread Explorer**: Monitor active threads and their call stacks
- **Instance Explorer**: View instances with properties and connections
- **GC Explorer**: Browse all objects in the garbage collector
- **Actor Explorer**: Monitor parallel actors and their threads
- **Logs**: Capture output with call stacks

## Structure

```
musical-funicular/
├── init.lua
├── loader.lua
└── src/
    ├── backend/
    │   ├── init.lua
    │   ├── runtime_store.lua
    │   ├── events.lua
    │   ├── callstack.lua
    │   ├── remote_spy.lua
    │   ├── signal_inspector.lua
    │   ├── connection_inspector.lua
    │   ├── function_inspector.lua
    │   ├── script_inspector.lua
    │   ├── thread_inspector.lua
    │   ├── actor_inspector.lua
    │   ├── instance_inspector.lua
    │   └── gc_explorer.lua
    └── ui/
        └── main.lua
```

## Push to GitHub

Push all files maintaining the directory structure:

```bash
git add .
git commit -m "Initial commit"
git push origin main
```

## License

MIT
