# Cobalt Loader

Due to GitHub raw content caching, use one of these methods:

## Method 1: Direct with strong cache busting
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/lvtg764/musical-funicular/main/init.lua?cb=" .. tick() .. math.random(1,999999)))()
```

## Method 2: Via Pastebin (no cache)
1. Go to https://pastebin.com/
2. Paste the content of init.lua
3. Set to "Unlisted" and create
4. Use: `loadstring(game:HttpGet("https://pastebin.com/raw/YOUR_ID"))()`

## Method 3: Via GitHub Gist (minimal cache)
Create a gist at https://gist.github.com/ and use the raw URL

## Method 4: jsdelivr CDN (updates every 12 hours but can purge)
```lua
loadstring(game:HttpGet("https://cdn.jsdelivr.net/gh/lvtg764/musical-funicular@main/init.lua"))()
```

## Method 5: Direct file hosting
Upload to a service like:
- https://paste.ee
- https://hastebin.com
- https://textbin.net
