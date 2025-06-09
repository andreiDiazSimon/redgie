-- Auto Hatch Queen Bee + Server Hop
-- Educational use only

-- [⚙️ CONFIG]
local TARGET_PET = "Queen Bee"
local MAX_ATTEMPTS = 5

-- [📦 SERVICES]
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- [🔁 Attempt counter]
local attempts = 0

-- [🔎 Function to get current hatched pet]
local function getHatchedPetName()
    -- EXAMPLE GUI PATH - customize for your game
    local gui = LocalPlayer:WaitForChild("PlayerGui")
    local hatchGui = gui:FindFirstChild("HatchGui", true)
    if hatchGui and hatchGui:FindFirstChild("PetName") then
        return hatchGui.PetName.Text
    end

    -- OR: hook a remote event here if GUI isn't used
    return nil
end

-- [🚪 Function to server hop]
local function serverHop()
    local PlaceID = game.PlaceId
    local success, servers = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(
            "https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Asc&limit=100"
        ))
    end)

    if success then
        for _, server in pairs(servers.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(PlaceID, server.id, LocalPlayer)
                break
            end
        end
    else
        warn("Failed to fetch server list.")
    end
end

-- [🚨 Main logic loop]
while attempts < MAX_ATTEMPTS do
    wait(5) -- Wait for hatch
    local pet = getHatchedPetName()
    if pet then
        print("You hatched: " .. pet)
        if pet == TARGET_PET then
            print("🎉 Success! Hatched a " .. TARGET_PET)
            break
        else
            print("Not the Queen Bee, hopping server...")
            attempts = attemtps + 1 
            wait(1)
            serverHop()
            break
        end
    else
        print("Waiting for pet info...")
    end
end
