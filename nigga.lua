repeat task.wait() until game:IsLoaded()
task.spawn(function()
    local ifh = getgenv().isfunctionhooked
    while task.wait(0.25) do
        pcall(function()
            local mt = getrawmetatable(game);
            local nmc = mt.__namecall;
            if getgenv().SimpleSpyExecuted or ifh(nmc) then
                while true do end;
            end;
        end)
    end
end)

local Library = loadstring(game:HttpGetAsync("https://github.com/cloudman4416/Fluent_Clone/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/cloudman4416/Fluent_Clone/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/cloudman4416/Fluent_Clone/master/Addons/InterfaceManager.lua"))()

local options = Library.Options
local linked = {}
linked.fallbackdist = 15
linked.distance = 15
linked.ordered = {}
linked.bosses = {}
linked.ouwi_names = {}
linked.blankTween = {
    Play = function() end;
    Cancel = function() end;
    Completed = {
        Wait = function() end;
    };
}
warn("---------------------------------")

-- SERVICES
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StatsService = game:GetService("Stats")
local CollectionService = game:GetService("CollectionService")
local StarterGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")
local LocalizationService = game:GetService("LocalizationService")

--SHITSPLOITS HANDLE PART


local exec = identifyexecutor()
local isBadExec = false
if table.find({"Xeno", "Solara"}, exec) then
    local data = loadstring(game:HttpGet("https://raw.githubusercontent.com/cloudman4416/scripts/refs/heads/main/2142948266/modular.lua"), "modular")()
    isBadExec = true
	getgenv().require = function(source)
        return data[source:GetFullName()]
    end
end

-- VARS
local client = Players.LocalPlayer
local camera = workspace.CurrentCamera
local ping = StatsService.Network.ServerStatsItem["Data Ping"]
local placeId = game.PlaceId
local jobId = game.JobId
local renv = getrenv and getrenv()._G
local SERVER_ID = tonumber(jobId:gsub("%D", ""):sub(-9))
linked.AttackPlace = table.find({11468075017, 11468034852, 13883059853, 13883279773, 17387475546, 17387482786}, placeId)
linked.MapPlace = table.find({13883059853, 13883279773, 17387475546, 17387482786}, placeId)
linked.LobbysPlace = table.find({5956785391, 9321822839}, placeId)
linked.playerValues = nil
linked.playerData = nil
if not linked.LobbysPlace then
    linked.playerValues = ReplicatedStorage.PlayerValues:WaitForChild(client.Name, math.huge)
    linked.playerData = ReplicatedStorage.Player_Data:WaitForChild(client.Name, math.huge)
end
local Handle_Initiate_S = ReplicatedStorage.Remotes.To_Server:WaitForChild("Handle_Initiate_S")
local Handle_Initiate_S_ = ReplicatedStorage.Remotes.To_Server:WaitForChild("Handle_Initiate_S_")
local New_Item = ReplicatedStorage.Remotes.To_Client:FindFirstChild("New_Item")
local places = require(game:GetService("ReplicatedStorage").Modules.Global.Map_Locaations)

-- DUMP

linked.ordered = {
    "Muichiro";
    "Rengoku";
    "BanditBoss";
    "Akaza";
    "Inosuke";
    "Enmu";
    "Reaper Boss";
    "Sound Trainee";
    "Tengen";
    "Snow Trainee";
    "Douma";
    "Flame Trainee";
    "Swampy";

	"Tamari";
    "Arrow";
    "Sanemi";
    "Kaden";
    "Zanegutsu";
    "Boss";
    "Sabito";
    "Water";
    "Ouwbae";
    "Bomb_boss";
    "Reaper Boss";
}

linked.bosses = {}

if workspace:FindFirstChild("Mobs") then
    for i, v in ipairs(linked.ordered) do
        local success;
        local real;
        while not success do
            success = pcall(function()
                real = workspace.Mobs:FindFirstChild(v, true)
                if real then
                    local info = require(real.Npc_Configuration)
                    linked.bosses[v] = {info["Npc_Spawning"]["Spawn_Locations"][1], info["Name"], real, info["Code"]}
                end
            end)
            if not success then
                warn(("Error at %s, retrying..."):format(tostring(v)))
                real:Destroy()
                task.wait(0.5)
            end
        end
    end
end

local robloxLang = client.LocaleId
local lang = robloxLang:split("-")[1]:lower()

local translations = (isfile("CloudHub/PJS/translations.json") and HttpService:JSONDecode(readfile("CloudHub/PJS/translations.json"))) or game:HttpGet("https://raw.githubusercontent.com/cloudman4416/scripts/refs/heads/main/2142948266/translations.json")

local function getTrans(id, field)
    local data = translations[id]
    if data then
        return data[field][lang] or data[field]["en"]
    else
        return id
    end
end

local new_items = setmetatable({}, {
    __index = function(t, ind)
        return 0
    end
})

if New_Item then
    New_Item.OnClientEvent:Connect(function(item)
        new_items[item] += 1
        --webhook(item, (images:FindFirstChild(item) and images[item].Image.Image or ReplicatedStorage.Tools:FindFirstChild(item) and ReplicatedStorage.Tools[item].TextureId))
    end)
else
    warn("No Webhook for you lil bro")
end

local rarities = {"Mythic", "Supreme", "Polar", "Devourer", "Limited"}
local items_data = require(game:GetService("ReplicatedStorage").Modules.Data.ItemsData)
local colors = {
    normal = 16711680;
    dungeon = 1376000;
    mugen = 18431;
}

local function wbhook(mode)
    local filds = {}
    for i, v in pairs(new_items) do
        if table.find(rarities, items_data[i]["Data"][1]["Settings"]["Rarity"]) then
            table.insert(filds, {name = i, value = "x" .. v, inline = true})
        end
    end
    if #filds == 0 then return end
    local data = {
        username = "Step Mom",
        avatar_url = "https://cdn.discordapp.com/avatars/1300809146903429120/152ae0be266098e7a09ce8548796fc63.png",
        embeds = {
            {
                title = "Farm Result For ||" .. client.Name .. "||",
                description = "Configure your webhook in the script settings",
                timestamp = DateTime.now():ToIsoDate(),
                color = colors[mode],
                fields = filds
            }
        }
    }
    request({
        Url = options["iWebhook"].Value,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json",
        },
        Body = HttpService:JSONEncode(data),
    })
    table.clear(new_items)
end

-- CLOUD HUB SIGNATURE

workspace.FallenPartsDestroyHeight = -math.huge

if linked.playerData then
    Handle_Initiate_S:FireServer("Change_Value", linked.playerData:WaitForChild("Custom_Properties"):WaitForChild("Nezuko_pacifier_stuff"):WaitForChild("Shrinkage"), SERVER_ID)
end

client.CharacterAdded:Connect(function(Character)
    local wagon = Character:WaitForChild(client.Name .. "'s Wagon", math.huge)
    if wagon then wagon:Destroy() end
end)

task.defer(function()
    local wagon = client.Character:WaitForChild(client.Name .. "'s Wagon", math.huge)
    if wagon then wagon:Destroy() end
end)

local antiatk = Instance.new("ScreenGui")
antiatk.DisplayOrder = -1000
antiatk.Enabled = false
antiatk.IgnoreGuiInset = true
antiatk.ResetOnSpawn = false
local fram = Instance.new("Frame", antiatk)
fram.Active = true
fram.AnchorPoint = Vector2.new(0.5, 0.5)
fram.BackgroundTransparency = 1
fram.Position = UDim2.fromScale(0.5, 0.5)
fram.Size = UDim2.fromScale(1, 1)

antiatk.Parent = client.PlayerGui

-- FUNCTIONS

linked.SafeCallback = function(func, toggle)
	local succ, ret = pcall(func)
	if succ then return end
	toggle:SetValue(false)
	toggle:SetValue(true)
end


linked.tweento = function(coords, skip)
    if not coords then
        return linked.blankTween
    end
    local hrp = client.Character:WaitForChild("HumanoidRootPart")
    local Distance = (coords.Position - hrp.Position).Magnitude
    local Speed = Distance/options["sTweenSpeed"].Value

    local tween = TweenService:Create(hrp,
        TweenInfo.new(Speed, Enum.EasingStyle.Linear),
        { CFrame = coords}
    )

    if linked.tween then linked.tween:Cancel() end
    tween:Play()
    linked.tween = tween
    return tween
end

linked.tpto = function(p1)
    client.Character:WaitForChild("HumanoidRootPart").CFrame = p1
end

linked.smartTp = function(dest:CFrame, offset:CFrame)
    print("very smart but dangerous")
    dest = dest.Position
    local closest = nil
    local shortest = (client.Character.HumanoidRootPart.Position - dest).Magnitude
    for loc, coord in pairs(places) do
        if linked.playerData.MapUi.UnlockedLocations:FindFirstChild(loc) and client.PlayerGui.Map_Ui.Holder.Locations:FindFirstChild(loc) then
            local dist = (coord-dest).Magnitude
            if dist < shortest then
                closest = loc
                shortest = dist
            end
        end
    end
    if closest then
        local args = {
            [1] = `Players.{client.Name}.PlayerGui.Npc_Dialogue.Guis.ScreenGui.LocalScript`,
            [2] = os.clock(),
            [3] = closest
        }
        game:GetService("ReplicatedStorage"):WaitForChild("teleport_player_to_location_for_map_tang"):InvokeServer(unpack(args))
    end
    print("H1")
    linked.tweento(CFrame.new(dest) * (offset or CFrame.new())).Completed:Wait()
    print("H2")
end

linked.findBoss = function(name, delay)
    local data = linked.bosses[name]
    return data[3]:WaitForChild(data[2], delay or 0.4)
end

linked.findMob = function(players, multi)
    local v1 = {}
    for _, tag in ipairs({"Bosses", "Npcs", (players and "Players") or nil}) do
        for _, v in ipairs(CollectionService:GetTagged(tag)) do
            local plr = game.Players:GetPlayerFromCharacter(v)
            if v:IsDescendantOf(workspace.Mobs) or (plr and plr.Name ~= client.Name and not plr.Name:lower():find("arrow") and not ReplicatedStorage.PlayerValues[v.Name]:FindFirstChild("KnockedOut") and not ReplicatedStorage.PlayerValues[v.Name]:FindFirstChild("in_safe_zone")) then
                local hum = v:FindFirstChild("Humanoid")
                local hrp = v:FindFirstChild("HumanoidRootPart")
                if hum and hrp and hum.Health > 0 and (options.sKaDist.Value == 350 or (hrp.Position - client.Character:WaitForChild("HumanoidRootPart").Position).Magnitude <= options.sKaDist.Value) then
                    if multi then
                        table.insert(v1, v)
                    else
                        return v
                    end
                end
            end
        end
    end
    if multi then
        return v1
    end
end

linked.noclip = function()
    for i, v in ipairs(client.Character:GetChildren()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
        end
    end
end

linked.farmHelper = function()
	local Farm = {}
    client.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
	local _conn = RunService.Stepped:Connect(linked.noclip)
	local antifall = Instance.new("BodyVelocity")
	antifall.Velocity = Vector3.new(0, 0, 0)
	antifall.Parent = client.Character.HumanoidRootPart
	local _conn2 = client.CharacterAdded:Connect(function(Character)
		antifall.Parent = Character:WaitForChild("HumanoidRootPart")
	end)

	function Farm:Stop()
        client.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Zoom
		_conn:Disconnect()
		_conn2:Disconnect()
		antifall:Destroy()
        for i, v in ipairs(client.Character:GetChildren()) do
            if v:IsA("BasePart") then
                v.CanCollide = true
            end
        end
	end
	return Farm
end

linked.getPower = function(name)
	local thang = client.PlayerGui.Power_Adder:FindFirstChild((name == "Blood" and "Blood_Burst") or name)
	if thang then
		return thang
	end
	for i, v in ipairs(client.PlayerGui.Power_Adder:GetChildren()) do
		if v:FindFirstChild("Mastery_Equiped") and v.Mastery_Equiped.Value == name then
			return v
		end
	end
end

linked.webhook = function(name, link)
    local ret;
    if link then
        local img_link = string.match(link, "id=(%d+)")
        repeat
            ret = request({
                Url = `https://thumbnails.roblox.com/v1/assets?assetIds={img_link}&size=250x250&format=Png&cacheBust={tostring(tick())}`,
                Method = "GET",
                Headers = {
                    ["Content-Type"] = "text/json",
                }
            })
            task.wait(0.3)
        until HttpService:JSONDecode(ret.Body)["data"][1]["state"] == "Completed"
    end
    local msg = {
        ["embeds"] = {
            {
                ["title"] = "Got An Item !!!",
                ["color"] = 16711680,
                ["fields"] = {},
                ["thumbnail"] = {
                    ["url"] = link and HttpService:JSONDecode(ret.Body)["data"][1]["imageUrl"] or nil;
                },
                ["description"] = `||{client.Name}|| collected a \n{name}`,
                ["timestamp"] = DateTime.now():ToIsoDate(),
            },
        },
        ["username"] = "Step Mom",
        ["avatar_url"] = "https://cdn.discordapp.com/avatars/1300809146903429120/152ae0be266098e7a09ce8548796fc63.png",
    }
    request({
        Url = options["iWebhook"].Value,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json",
        },
        Body = HttpService:JSONEncode(msg),
    })
end

local SafeCallback, tweento, tpto, smartTp, findBoss, findMob, noclip, farmHelper, getPower, webhook = linked.SafeCallback, linked.tweento, linked.tpto, linked.smartTp, linked.findBoss, linked.findMob, linked.noclip, linked.farmHelper, linked.getPower, linked.webhook

-- GUI PART
--local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/dawid-scripts/Fluent-Renewed/master/Addons/SaveManager.luau"))()
--local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/dawid-scripts/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()

local viewportSize = camera.ViewportSize

local Window = Library:CreateWindow{
    Title = "Cloudhub | Project Slayer (discord.gg/wgFBpD7mRh)",
    TabWidth = math.clamp(viewportSize.X/8, 100, 150),
    Size = UDim2.fromOffset(viewportSize.X/2, viewportSize.Y/1.8),
    Resize = false, -- Resize this ^ Size according to a 1920x1080 screen, good for mobile users but may look weird on some devices
    MinSize = Vector2.new(470, 380),
    Acrylic = false, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Obsidian",
    MinimizeKey = Enum.KeyCode.RightShift -- Used when theres no MinimizeKeybind
}

if UserInputService.TouchEnabled then
    local ScreenGui = Instance.new("ScreenGui", gethui() or game.CoreGui)
    ScreenGui.IgnoreGuiInset = true
    local Frame = Instance.new("ImageButton", ScreenGui)
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Size = UDim2.fromOffset(viewportSize.Y/10, viewportSize.Y/10)
    Frame.Position = UDim2.new(0.35, 0, 0, viewportSize.Y/20 + 5)
    Window.Root.Active = true
    Frame.Activated:Connect(function()
        Window:Minimize()
    end)
    local frame = Frame
    local UIS = UserInputService

    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

local Tabs = {
    ["Lobby"] = Window:AddTab({Title = "Lobby/Hub", Icon = ""});
    ["Auto Farm"] = Window:AddTab({Title = "Auto Farm", Icon = ""});
    ["Kill Aura"] = Window:AddTab({Title = "Kill Aura", Icon = ""});
    ["Skills"] = Window:AddTab({Title = "Skills", Icon = ""});
    ["Misc"] = Window:AddTab({Title = "Misc", Icon = ""});
    ["Quests"] = Window:AddTab({Title = "Quests", Icon = ""});
    ["Buffs"] = Window:AddTab({Title = "Buffs", Icon = ""});
    ["Teleport"] = Window:AddTab({Title = "Teleport", Icon = ""});
    ["Dungeon"] = Window:AddTab({Title = "Dungeon", Icon = ""});
    ["Mugen"] = Window:AddTab({Title = "Mugen", Icon = ""});
    ["Webhook"] = Window:AddTab({Title = "Webhook", Icon = ""});
    ["Settings"] = Window:AddTab({Title = "Settings", Icon = "settings"});
    ["Visuals"] = Window:AddTab({Title = "Visuals", Icon = ""});
}

-- LOBBY
Tabs["Lobby"]:AddSection(getTrans("seLobby", "Title"))

Tabs["Lobby"]:AddButton({
    Title = getTrans("bDailySpin", "Title");
    Callback = function()
        if placeId == 5956785391 then
            ReplicatedStorage:WaitForChild("spins_thing_remote", math.huge):InvokeServer()
        end
    end
})

Tabs["Lobby"]:AddSlider("sSlot", {
    Title = getTrans("sSlot", "Title"),
    Description = getTrans("sSlot", "Desc"),
    Default = 1,
    Min = 1,
    Max = 3,
    Rounding = 0,
})

Tabs["Lobby"]:AddInput("iCode", {
    Title = getTrans("iCode", "Title"),
    Default = nil,
    Placeholder = "Enter private server code",
    Numeric = false, -- Only allows numbers
    Finished = false -- Only calls callback when you press enter
})

Tabs["Lobby"]:AddDropdown("dMapSelect", {
    Title = getTrans("dMapSelect", "Title"),
    Values = {"Map 1", "Map 2", "Hub"};
    Default = "Map 2",
    Multi = false,
})

Tabs["Lobby"]:AddToggle("tAutoJoin", {
    Title = getTrans("tAutoJoin", "Title");
    Description = getTrans("tAutoJoin", "Title");
    Default = false;
})

Tabs["Lobby"]:AddSection(getTrans("seHub", "Title"))

Tabs["Lobby"]:AddDropdown("dHubMode", {
    Title = getTrans("dHubMode", "Title");
    Values = {"Ouwigahara", "1v1", "2v2", "3v3", "4v4", "5v5", "Trading"};
    Default = "Ouwigahara";
    Multi = false;
})

Tabs["Lobby"]:AddToggle("tHubJoin", {
    Title = getTrans("tHubJoin", "Title");
    Default = false;
})

Tabs["Lobby"]:AddSection(getTrans("seClan", "Title"))

Tabs["Lobby"]:AddButton({
    Title = getTrans("bClanSpin", "Title");
    Callback = function()
        if placeId == 5956785391 then
            Handle_Initiate_S_:InvokeServer("check_can_spin")
        end
    end
})

local clans = require(game:GetService("ReplicatedStorage").Modules.Global.Random_Clan_Picker)

local raw_clans = {}

for i, v in pairs(clans) do
    if typeof(v) == "table" then
        for a, b in ipairs(v) do
            table.insert(raw_clans, b)
        end
    end
end

Tabs["Lobby"]:AddDropdown("dClan", {
    Title = "Clan Selection";
    Values = raw_clans;
    Default = {"Kamado", "Agatsuma", "Rengoku", "Uzui"};
    Multi = true;
})

Tabs["Lobby"]:AddToggle("tSpinClan", {
    Title = "Spin For Clan";
    Description = "Spin until you get one of the selected clan";
    Default = false;
    Callback = function(Value)
        if placeId == 5956785391 and Value then
            Window:Dialog({
                Title = "ATTENTION",
                Content = "Are you really sure you want to spin you current clan off ?",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            task.defer(function()
                                while options.tSpinClan.Value do
                                    local succ, ret = Handle_Initiate_S_:InvokeServer("check_can_spin")
                                    if succ then
                                        print(ret)
                                        if options.dClan.Value[ret] then
                                            Library:Notify({
                                                Title = "LETS GO",
                                                Content = `You spun one of the selected clans`,
                                                Duration = 5
                                            })
                                            options.tSpinClan:SetValue(false); break
                                        end
                                    end
                                    task.wait()
                                end
                            end)
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                            options.tSpinClan:SetValue(false); return
                        end
                    }
                }
            })
        else
            if options.tSpinClan then
                options.tSpinClan:SetValue(false)
            end
        end
    end
})

-- AUTO FARM

local weapons = {
    ["Combat"] = "fist_combat";
    ["Scythe"] = "Scythe_Combat_Slash";
    ["Sword"] = "Sword_Combat_Slash";
    ["Fans"] = "fans_combat_slash";
    ["Claws"] = "claw_Combat_Slash";
}

Tabs["Auto Farm"]:AddDropdown("dWeaponSelect", {
    Title = getTrans("dWeaponSelect", "Title");
    Values = {"Combat", "Scythe", "Sword", "Fans", "Claws"};
    Default = "Claws";
    Multi = false;
}):OnChanged(function(Value)
    if Value == "Scythe" then
        --linked.fallbackdist = 9
        linked.distance = 7
    else
        --linked.fallbackdist = 15
        linked.distance = 15
    end
end)

Tabs["Auto Farm"]:AddSlider("sTweenSpeed", {
    Title = getTrans("sTweenSpeed", "Title");
    Description = "If you have a weak device please lower this value";
    Default = 400;
    Min = 100;
    Max = 500;
    Rounding = 0;
})
Tabs["Auto Farm"]:AddToggle("tAutoBoss", {
	Title = getTrans("tAutoBoss", "Title");
    Description = getTrans("tAutoBoss", "Desc");
	Default = false;
}):OnChanged(function(Value)
    if Value then
        task.spawn(function()
            if not linked.MapPlace then return end
            options.tAutoFlower:SetValue(false)
            local farmhelp = farmHelper()
            --[[local pos = client.Character.HumanoidRootPart.Position
            local closest = math.huge
            local ind = 1
            for i, v in ipairs(linked.ordered) do
                local coord = linked.bosses[boss] and linked.bosses[boss][1]
                if not coord then continue end
                if (coord - pos).Magnitude < closest then
                    ind = i
                    closest = (coord - pos).Magnitude
                end
            end
            local s = {}
            for i = 1, #linked.ordered do
                s[i] = linked.ordered[((i-2+ind) % #linked.ordered) + 1]
            end]]
            while options.tAutoBoss.Value do
                for _, boss in ipairs(linked.ordered) do
                    local coord = linked.bosses[boss] and linked.bosses[boss][1]
                    if not coord then continue end
                    if options.tAutoBoss.Value then
                        if options.tMuzanQuest.Value then
                            for i, v in ipairs(ReplicatedStorage.Muzan_Quests[client.Name]:GetChildren()) do
                                if v.Name:match("^Eliminate (.+)$") == linked.bosses[boss][2] then
                                    ReplicatedStorage.Remotes.To_Server:WaitForChild("muzan_quest_ting"):FireServer(v.Name, "Do")
                                    break
                                end
                            end
                        end
                        tweento(CFrame.new(coord) * CFrame.new(0, -35, 0)).Completed:Wait()
                        --smartTp(CFrame.new(coord) * CFrame.new(0, 3, 0))
                        local boboss = findBoss(boss, 0.6)
                        while boboss and boboss:FindFirstChild("HumanoidRootPart") and boboss:FindFirstChild("Humanoid").Health > 0 and options.tAutoBoss.Value do
                            tpto(
                                CFrame.new(boboss.HumanoidRootPart.Position) *
                                ((options.tAutoM1.Value and CFrame.new(0, linked.distance, 0) * CFrame.Angles(math.rad(-90), 0, 0)) or CFrame.new(0, -35, 0))
                            )
                            task.wait()
                        end
                        if not options.tAutoBoss.Value and not options.tJoinMugen.Value then tweento(CFrame.new(coord) * CFrame.new(0, 3, 0), true).Completed:Wait() end
                    end
                end
                task.wait()
            end
            farmhelp:Stop()
        end)
    end
end)

Tabs["Auto Farm"]:AddToggle("tAutoM1", {
	Title = getTrans("tAutoM1", "Title");
    Description = "Dont equip any weapon or you will get kicked";
	Default = false;
}):OnChanged(function(Value)
    task.spawn(function()
        if Value then
            task.spawn(function()
                antiatk.Enabled = true
                while options.tAutoM1.Value do
                    repeat task.wait() until (not client:FindFirstChild("combotangasd123") or client.combotangasd123.Value == 0) and not linked.playerValues:FindFirstChild("Stun") and not linked.playerValues:FindFirstChild("KnockedOut")
                    if not options.tAutoM1.Value then break end
                    task.wait(0.1)
                    --if not options["tGodMode"].Value then linked.distance = 6 end
                    --task.wait(ping:GetValue() / 500)
                    for i = 1, 8 do
                        Handle_Initiate_S:FireServer(weapons[options.dWeaponSelect.Value], nil, client.Character, client.Character:WaitForChild("HumanoidRootPart"), client.Character:WaitForChild("Humanoid"), 919, "ground_slash", nil, 1/0)
                        Handle_Initiate_S:FireServer(weapons[options.dWeaponSelect.Value], nil, client.Character, client.Character.HumanoidRootPart, client.Character.Humanoid, 1/0, "ground_slash", nil, 1/0)
                        --Handle_Initiate_S:FireServer(weapons[options.dWeaponSelect.Value], client, client.Character.HumanoidRootPart, client.Character.Humanoid, 919, "ground_slash")
                        --Handle_Initiate_S:FireServer(weapons[options.dWeaponSelect.Value], client, client.Character.HumanoidRootPart, client.Character.Humanoid, 1/0, "ground_slash")
                        --Handle_Initiate_S:FireServer(weapons[options.dWeaponSelect.Value], client, client.Character, client.Character:WaitForChild("HumanoidRootPart"), client.Character:WaitForChild("Humanoid"), 919, "ground_slash")
                        --Handle_Initiate_S:FireServer(weapons[options.dWeaponSelect.Value], client, client.Character, client.Character.HumanoidRootPart, client.Character.Humanoid, 1/0, "ground_slash")
                    end
                    task.wait(0.5)
                    --task.wait(ping:GetValue() / 1000)
                    --if not options["tGodMode"].Value then linked.distance = 15 end
                end
                antiatk.Enabled = false
            end)
        end
    end)
end)

Tabs["Auto Farm"]:AddToggle("tAutoBlock", {
    Title = getTrans("tAutoBlock", "Title");
    Default = false;
}):OnChanged(function(Value)
    if Value then
        while options["tAutoBlock"].Value do
            local args = {
                [1] = "add_blocking",
                [2] = `Players.{client.Name}.PlayerScripts.Skills_Modules.Combat.Combat//Block`,
                [3] =  os.clock(),
                [4] = linked.playerValues,
                [5] = 99999
            }
            Handle_Initiate_S:FireServer(unpack(args))
            task.wait(0.5)
        end
        Handle_Initiate_S:FireServer("remove_blocking", linked.playerValues)
    end
end)

Tabs["Auto Farm"]:AddToggle("tMuzanQuest", {
    Title = "Auto Take Muzan Quest";
    Description = "This work in sync with autoboss and only take quest of boss you'r about to kill";
    Default = false
})

Tabs["Auto Farm"]:AddToggle("tAutoChest", {
	Title = getTrans("tAutoChest", "Title");
	Default = false;
}):OnChanged(function(Value)
    if Value then
        task.spawn(function()
            while options.tAutoChest.Value do
                for a, b in ipairs(CollectionService:GetTagged("Chests")) do
                    if b.Name == "Loot_Chest" then
                        for c, d in ipairs(b:WaitForChild("Drops"):GetChildren()) do
                            b.Add_To_Inventory:InvokeServer(d.Name)
                            d:Destroy()
                        end
                    end
                end
                task.wait()
            end
        end)
    end
end)


Tabs["Auto Farm"]:AddToggle("tAutoFlower", {
    Title = getTrans("tAutoFlower", "Title");
    Description = getTrans("tAutoFlower", "Desc");
    Default = false;
}):OnChanged(function(Value)
    if Value then
        task.spawn(function()
            options.tAutoBoss:SetValue(false)
            local farmhelp = farmHelper()
            while options["tAutoFlower"].Value do
                local closest 
                local distance = math.huge
                for i, v in ipairs(workspace:WaitForChild("Demon_Flowers_Spawn", math.huge):GetChildren()) do
                    if not v:IsA("Model") then continue end
                    local dist = (v:GetModelCFrame().Position - client.Character:WaitForChild("HumanoidRootPart").Position).Magnitude
                    if dist < distance then
                        closest = v
                        distance = dist
                    end
                end
                pcall(function()
                    tweento(closest:GetModelCFrame()).Completed:Wait()
                    closest["Cube.002"].CFrame = closest["Cube.002"].CFrame * CFrame.new(0, 5, 0)
                    task.wait(0.5)
                    fireproximityprompt(closest["Cube.002"].Pick_Demon_Flower_Thing)
                    closest:Destroy()
                end)
            end
            farmhelp:Stop()
        end)
    end
end)

-- KILL AURAS
Tabs["Kill Aura"]:AddToggle("tKillaura", {
    Title = "Killaura Toggle";
    Description = "This need to be toggled on for the killaura you activated below to get active";
    Default = true;
})

Tabs["Kill Aura"]:AddToggle("tInclPlrs", {
    Title = "Include Players in Kill Aura";
    Description = getTrans("tInclPlrs", "Desc");
    Default = false;
})

Tabs["Kill Aura"]:AddSlider("sKaDist", {
    Title = "Killaura Max Distance";
    Description = "I recommend to let this to max";
    Default = 350;
    Min = 20;
    Max = 350;
    Rounding = 0;
})

Tabs["Kill Aura"]:AddParagraph({
    Title = "Information",
    Content = "Potential strengh is a ratio of cooldown and dmg\nBig potential strengh = big dps"
})

local add = require(game:GetService("ReplicatedStorage").Modules.Global.skills_custom_add_thing)
local cd_mod = require(game:GetService("ReplicatedStorage").Modules.Global.skill_cooldowns) or {}
if isBadExec and linked.AttackPlace then
    for _, v in ipairs(game.StarterGui:WaitForChild("Power_Adder"):GetDescendants()) do
        if v.Name == "Actual_Skill_Name" and v.Parent:FindFirstChild("CoolDown") ~= nil then
            cd_mod[v.Value] = v.Parent.CoolDown.Value
        end
    end
end
local skill_data = require(game:GetService("ReplicatedStorage").Modules.Server.Skills_Modules_Handler).Skills
cd_mod["Rapid_Slashes_Damage"] = 12;--"Thunderbreathingrapidslashes";
cd_mod["thunderbreathingthunderrain"] = 20;--"thunder_rumblinmg_thunder_bolkt_skill";
cd_mod["ice_demon_art_barren_hanging_garden_damage"] = 25;--"ice_demon_art_barren_hanging_garden";


local function newKa(rm5, ...)
    local values = {}
	local cd5 = (cd_mod[rm5] or 5) - 5
    local add5 = (add[rm5] and add[rm5] + 3) or 1
	local cdAtk = cd5/(add5) + math.clamp(1/add5, 0, 0.1)
    local data = skill_data[rm5]
    local art = data["Art"] or data["Power"]
    local mastery = data["Mastery"]
    local races = data["Race"]
    local item = data["Item"]
	for i, v in ipairs({...}) do

		local togName = `t{mastery}{i}Ka`
        table.insert(values, togName)
		local strengh = math.round(v.Boost / cdAtk)

        Tabs["Kill Aura"]:AddToggle(togName, {
            Title = `{mastery} KA ({v.Mastery} mastery required, {strengh} potential strengh)`;
            Description = v.Info;
            Default = false;
        }):OnChanged(function(Value)
            if Value then
                for i, v in ipairs(values) do
                    if v ~= togName and options[v].Value then
                            Library:Notify({
                            Title = "Attention",
                            Content = `Activate only a single killaura`,
                            Duration = 5
                        })
                        options[togName]:SetValue(false)
                        return
                    end
                end
                local Race = linked.playerData.Race.Value
                if not table.find(races, Race) then
                    Library:Notify({
                        Title = "Attention",
                        Content = `You don't have the correct race DUMAH`,
                        Duration = 5
                    })
                    options[togName]:SetValue(false)
                    return
                end
                local pow = (Race == 3 and linked.playerData.Demon_Art.Value) or ((Race == 1 or Race == 2) and linked.playerData.Power.Value )
                if art and pow ~= art then
                    Library:Notify({
                        Title = "Attention",
                        Content = `You don't have {art:lower()} DUMAH`,
                        Duration = 5
                    })
                    options[togName]:SetValue(false)
                    return
                end
                if item and not (client.Backpack:FindFirstChild(item, true) or client.Character:FindFirstChild(item, true)) then
                    Library:Notify({
                        Title = "Attention",
                        Content = `You don't have the required item : {mastery}`,
                        Duration = 5
                    })
                    options[togName]:SetValue(false)
                    return
                end
                if linked.playerData.Mastery_Bundle:FindFirstChild("mastery") and linked.playerData.Mastery_Bundle[mastery].Max.Value / 30 < v.Mastery then
                    Library:Notify({
                        Title = "Attention",
                        Content = `You don't have {v.Mastery} mastery DUMAH`,
                        Duration = 5
                    })
                    options[togName]:SetValue(false)
                    return
                end
                if options.tGodMode.Value then
                    Library:Notify({
                        Title = "Attention",
                        Content = "Can't toggle godmode and arrow ka at the same time",
                        Duration = 3
                    })
                    options[togName]:SetValue(false)
                    return
                end
                task.spawn(function()
                    if not linked.LobbysPlace then
                        while true do
                            for i, v in ipairs(values) do 
                                if options[v].Value and options.tKillaura.Value then
                                    local args = {
                                        [1] = "skil_ting_asd",
                                        [2] = client,
                                        [3] = rm5,
                                        [4] = 5
                                    }
                                    Handle_Initiate_S:FireServer(unpack(args))
                                    task.wait(cd5 + 0.1)
                                end
                            end
                            task.wait()
                        end
                    end
                end)
                task.defer(function()
                    while options[togName].Value do
                        local target = findMob(options.tInclPlrs.Value) --workspace.PrivateServerDummies["Dummy (Infinite Hp)"]
                        if target and options.tKillaura.Value then
                            --[[if v.Skill == "Koketsu_arrow_damage" then
                                task.spawn(function()
                                    Handle_Initiate_S_:InvokeServer("Arrow_knock_back_throw", client, client.Character:WaitForChild("HumanoidRootPart"), target.HumanoidRootPart.CFrame)

                                    local smegma = workspace.Debree:WaitForChild(client.Name .. "'s arrow", 2)
                                    smegma.Name = "UsedTypeShit"

                                    if not target:FindFirstChild("HumanoidRootPart") then return end

                                    Handle_Initiate_S:FireServer("Koketsu_arrow_damage", client.Character, smegma, target.HumanoidRootPart.CFrame)

                                    while smegma.Parent == workspace.Debree do
                                        smegma.Damagething:FireServer()
                                        task.wait()
                                    end
                                end)
                                task.wait(cdAtk)
                                continue
                            end]]
                            
                            local args = {
                                [1] = v.Skill,
                                [2] = client.Character,
                                [3] = target.HumanoidRootPart.CFrame
                            }

                            for a, b in ipairs(v.Args) do
                                if b == "CFrame" then
                                    args[3] = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, -100)
                                    table.insert(args, target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 100))
                                    continue
                                elseif b == "nil" then
                                    args[3 + a] = nil
                                elseif b == "target" then
                                    args[3 + a] = target
                                else
                                    args[3 + a] = b
                                end 
                            end

                            Handle_Initiate_S:FireServer(table.unpack(args, 1, 3+#v.Args))
                            task.wait(cdAtk)
                        else
                            task.wait()
                        end
                    end
                end)
            end
        end)
	end
end

---------------------Claws
Tabs["Kill Aura"]:AddSection("Claws (every race)")

newKa("Claws//Spin", {Mastery = 20, Skill = "Claw_Spin_Damage", Boost = 100, Args = {100}})


---------------------BLOOD DEMON ARTS

Tabs["Kill Aura"]:AddSection("Blood Demon Art")

---------------------ARROW

newKa("arrow_knock_back", {Mastery = 1, Skill = "arrow_knock_back_damage", Boost = 150, Args = {"nil", "nil", 200}}, {Mastery = 22, Skill = "piercing_arrow_damage", Boost = 30, Args = {}}--[[, {Mastery = 31, Skill = "Koketsu_arrow_damage", Boost = math.huge, Args = {}}]])

--[[Tabs["Kill Aura"]:AddButton({
    Title = "Glitch";
    Callback = function()

        local targets = findMob(false, true)
        
        Handle_Initiate_S:FireServer("skil_ting_asd", client, "arrow_knock_back", 5)

        --Handle_Initiate_S:FireServer("arrow_knock_back_damage", client.Character, targets[1].HumanoidRootPart.CFrame, nil, nil, 7)
        local args = {
            "fist_combat",
            client,
            client.Character,
            client.Character:WaitForChild("HumanoidRootPart"),
            client.Character:WaitForChild("Humanoid"),
            1
        }
        Handle_Initiate_S_:InvokeServer(unpack(args))

        task.wait(0.7)

        Handle_Initiate_S_:InvokeServer("Arrow_knock_back_throw", client, client.Character:WaitForChild("HumanoidRootPart"), targets[1].HumanoidRootPart.CFrame)

        local smegma = workspace.Debree:WaitForChild(client.Name .. "'s arrow", 2)
        smegma.Name = "UsedTypeShit"

        for i, v in ipairs(targets) do
            Handle_Initiate_S:FireServer("Koketsu_arrow_damage", client.Character, smegma, v.HumanoidRootPart.CFrame, v)
        end

        for i = 1, 4 do
            smegma.Damagething:FireServer()
            task.wait()
        end

        while smegma.Parent == workspace.Debree do
            smegma.Damagething:FireServer()
            task.wait()
        end

    end
})]]

---------------------BLOOD BURST

newKa("blood_burst_explosive_land_mines", {Mastery = 30, Skill = "blood_burst_blood_shot_damage", Boost = 100, Args = {100}})

---------------------DREAM

newKa("Dream_Bda_Melodic_Whisper", {Mastery = 38, Skill = "dreasm_bda_damsdasdasd", Boost = 350, Args = {175}})

---------------------REAPER

newKa("reaperbda_reapofdispair", {Mastery = 1, Skill = "slash_thing_damage", Boost = 19, Args = {}}, {Mastery = 23, Skill = "blazing_amputation_damage", Boost = 100, Args = {100}})
--newKa("Reaper", "Reaper_demon_art_runasd123", {Mastery = 45, Skill = "blazing_amputation_damage", Boost = 100, Args = {100}})

---------------------ICE

newKa("ice_demon_art_wintry_iciles", {Mastery = 1, Skill = "ice_demon_art_wintry_iciles_damage", Boost = 10, Args = {}}, {Mastery = 35, Skill = "ice_demon_art_barren_hanging_garden_damage2", Boost = 100, Args = {100}})

---------------------SWAMP

newKa("swampbda_swamp_puddle", {Mastery = 1, Skill = "swamp_puddle_damage", Boost = 3, Args = {}}, {Mastery = 17, Skill = "swamp_traveling_claws_damage", Boost = 75, Args = {75}})

---------------------SHOCKWAVE

newKa("akaza_bda_chaotic_type", {Mastery = 39, Skill = "Akaza_Crown_Split_damage", Boost = 100, Args = {100}})

---------------------TAMARI

newKa("Tamari2_double_Throw", {Mastery = 10, Skill = "Tamari_Double_Throw_Damage_new", Boost = 26, Args = {"target", 26}})



---------------------BREATHINGS

Tabs["Kill Aura"]:AddSection("Breathing")

---------------------Beast

newKa("beast_breathing_crazy_cutting", {Mastery = 20, Skill = "beast_breathing_pierce_damage", Boost = 100, Args = {100}})

---------------------Flame

newKa("flame_breathing_flaming_eruption", {Mastery = 32, Skill = "flmae_rising_scorch_damage", Boost = 100, Args = {100}})

---------------------INSECT

newKa("Insect_breathing_compound_eye_hexagon", {Mastery = 23, Skill = "inssect_flatter_damage", Boost = 100, Args = {100}})

---------------------Mist

newKa("mist_breathing_eight_layerd_Dispersing_mist", {Mastery = 20, Skill = "mist_cloud_haze_damage", Boost = 100, Args = {100}}, {Mastery = 48, Skill = "mist_breathing_shifting_flow_flash_damage", Boost = 150, Args = {150}})

---------------------Snow

newKa("snow_breathing_frost_path", {Mastery = 17, Skill = "snow_breathing_frozen_desert_damage", Boost = 100, Args = {100}})

---------------------Sound

newKa("sound_breathing_resounding_slashes", {Mastery = 32, Skill = "sound_breathing_roar_damage", Boost = 200, Args = {200}})

---------------------THUNDER

newKa("Thunderbreathingrapidslashes", {Mastery = 20, Skill = "thunder_clap_and_flash_damage", Boost = 100, Args = {"CFrame", 100, 200}, Info = "Hit in a 200 meter radius (very op)"})

---------------------Water

newKa("Water_wheel", {Mastery = 17, Skill = "water_surface_slash_damage", Boost = 100, Args = {100}})

---------------------Wind

newKa("wind_breathing_cold_mountain_wind", {Mastery = 37, Skill = "Purifying_wind_damage", Boost = 100, Args = {100}})

--SKILLS

Tabs["Skills"]:AddToggle("tAutoSkill", {
    Title = "Auto Skill";
    Description = "Toggle the what you want below";
}):OnChanged(function(Value)
    if Value then
        task.spawn(function()
            local FakeCombat = Instance.new("Folder")
            Instance.new("BoolValue", FakeCombat).Name = "CombatIsEquiped"
            Instance.new("IntValue", FakeCombat).Name = "Id"
            FakeCombat:Clone().Parent = client.Character
            local _conn = client.CharacterAdded:Connect(function(char)
                FakeCombat:Clone().Parent = client.Character
            end)
            while options.tAutoSkill.Value do task.wait() end
            _conn:Disconnect()
            client.Character:FindFirstChild("Folder"):Destroy()
        end)
    end
end)

if renv and linked.AttackPlace then
    local succ, err = pcall(function()
        local tang = linked.playerData:WaitForChild("Keys", math.huge)
        local skill = renv.skills_modules_thing
        for i = 1, 6 do
            Tabs["Skills"]:AddToggle(`tMove{i}`, {
                Title = `Use {tang:WaitForChild("Move"..i)["2"].Value}`;
                Default = false;
            }):OnChanged(function(Value)
                if Value then
                    task.spawn(function()
                        local Race = linked.playerData.Race.Value
                        local art = ( Race == 3 and linked.playerData.Demon_Art.Value) or ((Race == 1 or Race == 2) and linked.playerData.Power.Value)
                        while options[`tMove{i}`].Value do
                            local skill_config = getPower(art)["Skills"]:GetChildren()[i]
                            if skill_config.Locked.Value then
                                task.wait()
                                continue
                            end
                            skill[skill_config["Actual_Skill_Name"].Value]["Down"](skill_config)
                            task.wait(0.1)
                            skill[skill_config["Actual_Skill_Name"].Value]["Up"](skill_config)
                            task.wait(skill_config["CoolDown"].Value + 1)
                        end
                    end)
                end
            end)
        end
    end)
    if not succ then
        Library:Notify({
            Title = "Attention",
            Content = "Your exploit doesn't support auto skill\n".. err,
            Duration = 5
        })
    end
end

--MISC

Tabs["Misc"]:AddToggle("tAutoSoul", {
    Title = getTrans("tAutoSoul", "Title");
    Default = false;
}):OnChanged(function(Value)
    if Value then
        task.spawn(function()
            while options["tAutoSoul"].Value do
                for i, v in ipairs(workspace.Debree:GetChildren()) do
                    if v.Name == "Soul" then
                        v:WaitForChild("Handle"):WaitForChild("Eatthedamnsoul"):FireServer()
                    end
                end
                task.wait()
            end
        end)
    end
end)

local block_conn;
Tabs["Misc"]:AddToggle("tAntiBlock", {
    Title = getTrans("tAntiBlock", "Title");
    Description = getTrans("tAntiBlock", "Desc");
    Default = false;
}):OnChanged(function(Value)
    if Value then
        task.spawn(function()
            for i, v in ipairs(CollectionService:GetTagged("Blocking")) do
                if v.Parent == linked.playerValues then
                    continue
                end
                Handle_Initiate_S:FireServer("remove_blocking", v.Parent)
            end
            block_conn = CollectionService:GetInstanceAddedSignal("Blocking"):Connect(function(v) 
                if v.Parent == linked.playerValues then
                    return
                end
                task.wait(0.1)
                Handle_Initiate_S:FireServer("remove_blocking", v.Parent)
            end)
        end)
    else
        if block_conn then
            block_conn:Disconnect()
        end
    end
end)

Tabs["Misc"]:AddToggle("tFx", {
    Title = "Spam Random Visual and Sound Effects on Everyone";
    Description = "water, swamp";
}):OnChanged(function(Value)
    if Value then
        task.spawn(function()
            while options.tFx.Value do
                for i, v in ipairs(CollectionService:GetTagged("Players")) do
                    if Players:GetPlayerFromCharacter(v) and v:FindFirstChild("HumanoidRootPart") then
                        local fxs = {
                            {
                                `Players.{v.Name}.PlayerScripts.Client_Modules.Main_Script`,
                                os.clock(),
                                "water_splash_particle",
                                v:GetModelCFrame().Position
                            },
                            {
                                `Players.{client.Name}.PlayerScripts.Client_Modules.Main_Script`,
                                os.clock(),
                                "Swamp_Travel_Loop",
                                {
                                    Character = v
                                }
                            }
                        }
                        ReplicatedStorage.Remotes.To_Server:WaitForChild("Handle_Initiate_C"):FireServer(unpack(fxs[math.random(1, #fxs)]))
                        task.wait(0.7)
                    end
                end
                task.wait()
            end
        end)
    end
end)

Tabs["Misc"]:AddButton({
    Title = getTrans("bTpToMuzan", "Title");
    Description = getTrans("bTpToMuzan", "Desc");
    Callback = function()
        local farmhelp = farmHelper()
        if workspace:FindFirstChild("Muzan") then
            tweento(CFrame.new(workspace.Muzan.SpawnPos.Value)).Completed:Wait()
        else
            Library:Notify({
                Title = "Muzan",
                Content = "Muzan Is Not Spawned Wait For The Night",
                Duration = 2
            })
        end
        farmhelp:Stop()
    end
})

Tabs["Misc"]:AddButton({
    Title = getTrans("bDoctorQuest", "Title");
    Callback = function()
        local args = {
            [1] = "Quest_add",
            [2] = `Players.{client.Name}.PlayerGui.Npc_Dialogue.LocalScript.Functions`,
            [3] = os.clock(),
            [4] = {},
            [5] = client,
            [6] = "doctorhigoshimabringbacktomuzan"
        }
        Handle_Initiate_S:FireServer(unpack(args))
    end
})

Tabs["Misc"]:AddToggle("tGourds", {
    Title = "Auto Blow Gourds";
    Description = "Will buy and blow gourds the most efficiently possible until you have max breathing level";
    Default = false;
}):OnChanged(function(Value)
    if Value then
        task.spawn(function()
            while options.tGourds.Value do
                if linked.playerData.BreathingProgress["1"].Value == 900 then
                    Library:Notify({
                        Title = "Attention",
                        Content = "You maxed out gourd progress",
                        Duration = 3
                    })
                    options.tGourds:SetValue(false)
                    return
                end
                local prop = linked.playerData.Custom_Properties
                local typ = "Small Gourd"
                local i = 3
                if prop.Used_Small_Gourd.Value < 7 then
                    typ = "Small Gourd"
                    i = 1
                elseif prop.Used_Medium_Gourd.Value < 7 then
                    typ = "Small Gourd"
                    i = 2
                else
                    typ = "Big Gourd"
                    i = 3
                end
                Handle_Initiate_S:FireServer("buysomething", client, typ, linked.playerData.Yen)

                local gourd = linked.playerData.Inventory.Items:WaitForChild(typ, 3)
                if not gourd then 
                    Library:Notify({
                        Title = "Attention",
                        Content = "Error while getting gourd, make sure you got enough money",
                        Duration = 5
                    })
                    options.tGourds:SetValue(false)
                    return
                end

                if not client.Backpack:FindFirstChild(typ) then Handle_Initiate_S:FireServer("change_equip_for_item", client, linked.playerData["Inventory"], gourd) end

                local blows = prop:WaitForChild(gourd.Settings.Id.Value).Blows

                local tool = client.Backpack:WaitForChild(typ)

                while blows.Parent ~= nil do
                    Handle_Initiate_S_:InvokeServer("blow_in_gourd_thing", client, tool, i)
                    task.wait()
                end
                task.wait()
            end
        end)
    end
end)

--[[Tabs["Misc"]:AddButton({
    Title = "CRASH SERVER";
    Description = "Clicking this button will crash the current server instantly and immediatly";
    Callback = function()
        if linked.AttackPlace then
            Window:Dialog({
                Title = "ATTENTION",
                Content = "Are you really sure of what you are about to do ?",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            Handle_Initiate_S:FireServer("ricespiritdamage", client, CFrame.new(0, 0, 0), 999999)
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                            print("Cancelled the dialog.")
                        end
                    }
                }
            })
        end
    end
})]]

Tabs["Misc"]:AddSection("Gamepasses")

Tabs["Misc"]:AddButton({
    Title = getTrans("bGPProg", "Title");
    Description = getTrans("bGPProg", "Desc");
    Callback = function()
        local unlock = Instance.new("Part")
        unlock.Name = "18589360"
        unlock.Parent = client.gamepasses
    end
})

Tabs["Misc"]:AddButton({
    Title = getTrans("bGPSpins", "Title");
    Description = getTrans("bGPSpins", "Desc");
    Callback = function()
        local unlock = Instance.new("Part")
        unlock.Name = "46503236"
        unlock.Parent = client.gamepasses
    end
})

Tabs["Misc"]:AddButton({
    Title = getTrans("bGPGourd", "Title");
    Description = getTrans("bGPGourd", "Desc");
    Callback = function()
        local unlock = Instance.new("Part")
        unlock.Name = "19241624"
        unlock.Parent = client.gamepasses
    end
})

-- QUESTS

local fullnames = renv and renv.fullnames or {}

Tabs["Quests"]:AddSection(getTrans("seQuests", "Title"))

--[[Tabs["Quests"]:AddToggle("tAutoRice", {
    Title = getTrans("tAutoRice", "Title");
    Default = false;
})

Tabs["Quests"]:AddToggle("tAutoWagon", {
    Title = getTrans("tAutoWagon", "Title");
    Default = false;
})]]

Tabs["Quests"]:AddButton({
    Title = getTrans("bTTarget", "Title");
    Callback = function()
        local text = `Players.{client.Name}.PlayerGui.ExcessGuis.chairui.Holder.LocalScript`
        if not fullnames[text] then
            local target = workspace:WaitForChild("Target_Training") -- or workspace.Map:FindFirstChild("Chunk23")
            if not target then 
                Library:Notify({
                    Title = "Attention",
                    Content = "Targets not found",
                    Duration = 3
                })
                return
            end
            local farmhelp = farmHelper()
            tweento(target:GetModelCFrame()).Completed:Wait()
            target:WaitForChild("Chair"):WaitForChild("Detect_Part"):WaitForChild("Initiated"):FireServer()
            task.wait(0.2)
            farmhelp:Stop()
        end
        Handle_Initiate_S_:InvokeServer("Quest_add", text, os.clock, {}, client, "donetargettraining")
        Handle_Initiate_S:FireServer("remove_item", client.PlayerGui.ExcessGuis:FindFirstChild("chairui")) 
    end
})

Tabs["Quests"]:AddButton({
    Title = getTrans("bTMeditation", "Title");
    Callback = function()
        if not fullnames[`Players.{client.Name}.PlayerGui.ExcessGuis.Meditate_gui.Holder.LocalScript`] then
            local spot = workspace.Debree:WaitForChild("thundertrainingmeditate", 1) or workspace.Debree:WaitForChild("mediatasd123vv", 1) -- or workspace.Map:FindFirstChild("Chunk23")
            if not spot then 
                Library:Notify({
                    Title = "Attention",
                    Content = "No Meditate Quest",
                    Duration = 3
                })
                return
            end
            local farmhelp = farmHelper()
            tweento(spot.CFrame).Completed:Wait()
            local mat = workspace:WaitForChild("Meditate_Mat", 1) or workspace.Map:WaitForChild("Chunk23"):WaitForChild("Meditate_Mat")
            mat:WaitForChild("Initiated"):FireServer()
            task.wait(0.2)
            farmhelp:Stop()
        end
        Handle_Initiate_S_:InvokeServer("Quest_add", `Players.{client.Name}.PlayerGui.ExcessGuis.Meditate_gui.Holder.LocalScript`, os.clock, {}, client, "donedoingmeditation")
        Handle_Initiate_S:FireServer("remove_item", client.PlayerGui.ExcessGuis:FindFirstChild("Meditate_gui"))
    end
})

Tabs["Quests"]:AddButton({
    Title = getTrans("bTPushup", "Title");
    Callback = function()
        if not fullnames[`Players.{client.Name}.PlayerGui.ExcessGuis.Push_Up_Gui.Holder.push_up_mat_local_script`] then
            local spot = workspace.Debree:WaitForChild("thundertrainingpushups", 2)-- or workspace.Map:FindFirstChild("Chunk23")
            if not spot then 
                Library:Notify({
                    Title = "Attention",
                    Content = "No Pushup Quest",
                    Duration = 3
                })
                return
            end
            local farmhelp = farmHelper()
            tweento(spot.CFrame).Completed:Wait()
            local mat; for i, v in ipairs(workspace:GetChildren()) do 
                if v.Name == "Push_Ups_Mat" and #v:GetChildren() > 0 then 
                    mat = v 
                    break
                end
            end
            mat = mat or workspace.Map:WaitForChild("Chunk23"):WaitForChild("Push_Ups_Mat")
            mat:WaitForChild("Initiated"):FireServer()
            --workspace.Map:WaitForChild("Chunk23"):WaitForChild("Push_Ups_Mat"):WaitForChild("Initiated"):FireServer()
            task.wait(0.2)
            farmhelp:Stop()
        end
        Handle_Initiate_S_:InvokeServer("Quest_add", `Players.{client.Name}.PlayerGui.ExcessGuis.Push_Up_Gui.Holder.push_up_mat_local_script`, os.clock, {}, client, "donepushuptraining")
        Handle_Initiate_S:FireServer("remove_item", client.PlayerGui.ExcessGuis:FindFirstChild("Push_Up_Gui"))
    end
})

Tabs["Quests"]:AddButton({
    Title = getTrans("bTLightning", "Title");
    Callback = function()
        --thundertrainingthunderdodge
        Handle_Initiate_S_:InvokeServer("Quest_add", `Players.{client.Name}.PlayerGui.ExcessGuis.thnder_gui.Holder.LocalScript`, os.clock(), {}, client, "donelightningdodge")
    end
})

Tabs["Quests"]:AddButton({
    Title = "Auto Cup";
    Callback = function()
        if not fullnames[`Players.{client.Name}.PlayerGui.ExcessGuis.cup_game_gui.Holder.cup_game_script123`] then
            local cup = workspace:WaitForChild("cup game", 2)
            if not cup.Model then 
                Library:Notify({
                    Title = "Attention",
                    Content = "No cup to win here",
                    Duration = 3
                })
                return
            end
            local farmhelp = farmHelper()
            tweento(cup.Model:GetModelCFrame()).Completed:Wait()
            cup.Model:WaitForChild("Main"):WaitForChild("Initiated"):FireServer()
            task.wait(0.2)
            farmhelp:Stop()
        end
        Handle_Initiate_S_:InvokeServer("Quest_add", `Players.{client.Name}.PlayerGui.ExcessGuis.cup_game_gui.Holder.cup_game_script123`, os.clock(), {}, client, "donecuptraining123asd")
        Handle_Initiate_S:FireServer("remove_item", client.PlayerGui.ExcessGuis:FindFirstChild("cup_game_gui"))
    end
})

Tabs["Quests"]:AddButton({
    Title = "Auto Book Quest";
    Callback = function()
        Handle_Initiate_S_:InvokeServer("Quest_add", `Players.{client.Name}.PlayerScripts.Small_Scripts.Soryu_trainer_book_find`, os.clock(), {}, client, "givebookasd123asdasd")
    end
})

Tabs["Quests"]:AddButton({
    Title = "Split Boulder";
    Description = "Please equip sword before activating";
    Callback = function()
        if not fullnames[`Players.{client.Name}.PlayerGui.ExcessGuis.boulder_split_ui.Holder.LocalScript`] then
            local boulder = workspace:WaitForChild("Boulder_To_Split", 2)
            if not boulder then 
                Library:Notify({
                    Title = "Attention",
                    Content = "No boulder to split here",
                    Duration = 3
                })
                return
            end
            local farmhelp = farmHelper()
            tweento(boulder:GetModelCFrame() * CFrame.new(0, 8, 0)).Completed:Wait()
            boulder:WaitForChild("Main"):WaitForChild("Initiated"):FireServer()
            task.wait(0.2)
            farmhelp:Stop()
        end
        Handle_Initiate_S_:InvokeServer("Quest_add", `Players.{client.Name}.PlayerGui.ExcessGuis.boulder_split_ui.Holder.LocalScript`, os.clock(), {}, client, "donebouldersplitthing")
        Handle_Initiate_S:FireServer("remove_item", client.PlayerGui.ExcessGuis:FindFirstChild("boulder_split_ui"))
    end
})

Tabs["Quests"]:AddButton({
    Title = "Find Glowy Rocks";
    Callback = function()
        local rocks = workspace:WaitForChild("Sea_Rocks", 2)
        if rocks then
            local farmhelp = farmHelper()
            for i, v in ipairs(rocks:GetChildren()) do
                if v:IsA("Model") then
                    tweento(v:GetModelCFrame()).Completed:Wait()
                    task.wait(0.2)
                    v:WaitForChild("Main"):WaitForChild("take_rock"):WaitForChild("RemoteEvent"):FireServer()
                end
            end
            tweento(CFrame.new(677, 279, -2962)).Completed:Wait()
            farmhelp:Stop()
        else
            Library:Notify({
                Title = "Attention",
                Content = "No rocks to collect here",
                Duration = 3
            })
        end
    end
})

Tabs["Quests"]:AddButton({
    Title = "Pull Boulder";
    Callback = function()
        if true then --not fullnames[`Players.{client.Name}.PlayerGui.ExcessGuis.boulder_pull_ui.Holder.LocalScript`] then
            local boulder = workspace:WaitForChild("Rock", 2)
            if not boulder then 
                Library:Notify({
                    Title = "Attention",
                    Content = "No rock to pull here",
                    Duration = 3
                })
                return
            end
            local farmhelp = farmHelper()
            tweento(boulder:GetModelCFrame() * CFrame.new(0, 3, 0)).Completed:Wait()
            boulder:WaitForChild("Un_Part_experiemnt"):WaitForChild("Initiated"):FireServer()
            task.wait(0.2)
            farmhelp:Stop()
        end
        Handle_Initiate_S_:InvokeServer("Quest_add", `Players.{client.Name}.PlayerGui.ExcessGuis.boulder_pull_ui.Holder.LocalScript`, os.clock(), {}, client, "doneboulderpulling")
        Handle_Initiate_S:FireServer("remove_item", client.PlayerGui.ExcessGuis:FindFirstChild("boulder_pull_ui"))
    end
})


-- BUFFS

local skillMod = require(game:GetService("ReplicatedStorage").Modules.Server.Skills_Modules_Handler).Skills
local gmSkills = {
    "scythe_asteroid_reap";
    "Water_Surface_Slash";
    "insect_breathing_dance_of_the_centipede";
    "blood_burst_explosive_choke_slam";
    "Wind_breathing_black_wind_mountain_mist";
    "snow_breatihng_layers_frost";
    "flame_breathing_flaming_eruption";
    "Beast_breathing_devouring_slash";
    "akaza_flashing_williow_skillasd";
    "dream_bda_flesh_monster";
    "swamp_bda_swamp_domain";
    "sound_breathing_smoke_screen";
    "ice_demon_art_bodhisatva";
}
local newtbl = {}
if linked.AttackPlace then
    for i, v in ipairs(gmSkills) do
        for a, b in ipairs(game:GetService("Players").LocalPlayer.PlayerGui.Power_Adder:GetChildren()) do
            if b:IsA("Configuration") and b.Mastery_Equiped.Value == skillMod[v]["Mastery"] then
                for c, d in ipairs(b.Skills:GetChildren()) do
                    if d.Actual_Skill_Name.Value == v then
                        table.insert(newtbl, `{skillMod[v]["Mastery"]} -- {if d:FindFirstChild("Locked_Txt") then "Ult Unlocked" else `Mas {skillMod[v]["MasteryNeed"]}`}`)
                    end
                end
            end
        end
    end
end

Tabs["Buffs"]:AddDropdown("dGodMode", {
    Title = getTrans("dGodMode", "Title");
    Values = newtbl;
    Default = nil;
    Multi = false;
})

Tabs["Buffs"]:AddToggle("tGodMode", {
    Title = getTrans("tGodMode", "Title");
    Default = false;
}):OnChanged(function(Value)
    if Value then
        if options["tKillaura"].Value then
            Library:Notify({
                Title = "Attention",
                Content = "Can't toggle godmode and killaura at the same time",
                Duration = 3
            })
            options["tGodMode"]:SetValue(false)
            return
        end
        task.spawn(function()
            --linked.distance = 6
            while options["tGodMode"].Value do
                local skillName = gmSkills[table.find(newtbl, options["dGodMode"].Value)]
                local args = {
                    [1] = "skil_ting_asd",
                    [2] = client,
                    [3] = skillName,
                    [4] = 1
                }
                
                Handle_Initiate_S:FireServer(unpack(args))  
                task.wait(skillMod[skillName]["addiframefor"] - 0.2)
            end
            --linked.distance = 7
        end)
    end
end)

Tabs["Buffs"]:AddToggle("tWarDrum", {
    Title = getTrans("tWarDrum", "Title");
    Default = false;
}):OnChanged(function(Value)
    if Value then
        task.spawn(function()
            while options["tWarDrum"].Value do
                ReplicatedStorage.Remotes:WaitForChild("war_Drums_remote", math.huge):FireServer(true)
                task.wait(20)
            end
        end)
    end
end)
options["tWarDrum"]:SetValue(true)

Tabs["Buffs"]:AddToggle("tSunImm", {
    Title = getTrans("tSunImm", "Title");
    Default = true;
}):OnChanged(function(Value)
    pcall(function()
        client.PlayerScripts.Small_Scripts.Gameplay.Sun_Damage.Disabled = Value
    end)
end)

Tabs["Buffs"]:AddToggle("tInfStam", {
    Title = getTrans("tInfStam", "Title");
    Default = true;
}):OnChanged(function(Value)
    if not linked.playerValues then return end
    if Value then
        linked.playerValues:WaitForChild("Stamina", math.huge).MinValue = 9999
        linked.playerValues:WaitForChild("Stamina", math.huge).Value = 9999
    else
        linked.playerValues:WaitForChild("Stamina", math.huge).MinValue = 0
    end
end)

Tabs["Buffs"]:AddToggle("tInfBreath", {
    Title = getTrans("tInfBreath", "Title");
    Default = true;
}):OnChanged(function(Value)
    if not linked.playerValues then return end
    if Value then
        linked.playerValues:WaitForChild("Breath", math.huge).MinValue = 9999
        linked.playerValues:WaitForChild("Breath", math.huge).Value = 9999
    else
        linked.playerValues:WaitForChild("Breath", math.huge).MinValue = 0
    end
end)

Tabs["Buffs"]:AddToggle("tKamReg", {
    Title = "Kamado Demon Infinite Regenration";
    Description = "YOU NEED TO BE DEMON AND HAVE KAMADO CLAN";
    Default = false;
}):OnChanged(function(Value)
    if linked.AttackPlace and linked.playerData:WaitForChild("Clan").Value == "Kamado" and linked.playerData.Race.Value == 3 then
        ReplicatedStorage.Remotes:WaitForChild("heal_tang123asd"):FireServer(Value)
    else
        options["tKamReg"]:SetValue(false)
    end
end)

Tabs["Buffs"]:AddToggle("tBlaze", {
    Title = "Heart Ablaze Mode For Non Demon";
    Description = "Only requirement is not being a demon";
    Deafult = false;
}):OnChanged(function(Value)
    if not linked.AttackPlace or linked.playerData.Race == 3 then options["tBlaze"]:SetValue(false); return end
    if (not client:FindFirstChild("hacktanbgasd12312312") or client.hacktanbgasd12312312.Value == 0) then
        if Value then
            Handle_Initiate_S:FireServer("skil_ting_asd", client, "heart_ablaze_mode", 5)
            ReplicatedStorage.Remotes:WaitForChild("heart_ablaze_mode_remote"):FireServer(true)
        else
            ReplicatedStorage.Remotes:WaitForChild("heart_ablaze_mode_remote"):FireServer(false)
        end
    else
        Library:Notify({
            Title = "Attention",
            Content = "Please Wait a bit before using it",
            Duration = 3
        })
        options["tBlaze"]:SetValue(false)
    end
end)

--TELEPORT

local actualPlaces = {}

if linked.MapPlace then
    for i, v in ipairs(StarterGui.Map_Ui.Holder.Locations:GetChildren()) do
        if places[v.Name] then
            table.insert(actualPlaces, v.Name)
        end
    end
end

local downLoc = {
    "Zapiwara Mountain";
    "Kabiwaru Village";
    "Final Selection";
    "Ouwbayashi Home";
    "Slasher Demon";
    "Cave 1";
    "Village 2";
    "Mist trainer location";
    "Wop City";
    "Mugen Train Station";
    "Akeza Cave";
}


Tabs["Teleport"]:AddDropdown("dLocSelect", {
    Title = getTrans("dLocSelect", "Title");
    Values = actualPlaces;
    Default = nil;
    Multi = false;
})

Tabs["Teleport"]:AddButton({
    Title = getTrans("bTeleport", "Title");
    Description = getTrans("bTeleport", "Desc");
    Default = false;
    Callback = function()
        local coords = places[options.dLocSelect.Value]
        if coords then
            local farmhelp = farmHelper()
            if table.find(downLoc, options.dLocSelect.Value) then
                smartTp(CFrame.new(coords), CFrame.new(0, 3, 0))
            else
                smartTp(CFrame.new(coords))
            end
            farmhelp:Stop()
        end
    end
})

local quest_place = {}

for i, v in ipairs(CollectionService:GetTagged("Npcs")) do
    if v.Parent == workspace then table.insert(quest_place, v.Name) end
end

table.sort(quest_place)

Tabs["Teleport"]:AddDropdown("dQuestTp", {
    Title = "Select Npc To Tp";
    Values = quest_place;
    Default = nil;
    Multi = false;
})

Tabs["Teleport"]:AddButton({
    Title = "Teleport To Selected Npc";
    Callback = function()
        local npc = workspace:FindFirstChild(options.dQuestTp.Value or "Cloudhub_fgzahbgfuoirehzaof")
        if not npc then return end
        local farmhelp = farmHelper()
        smartTp(npc:GetModelCFrame())
        farmhelp:Stop()
    end
})

Tabs["Teleport"]:AddSection(getTrans("seExtTeleport", "Title"))

Tabs["Teleport"]:AddButton({
    Title = getTrans("bRejoin", "Title");
    Callback = function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, client)
    end
})

Tabs["Teleport"]:AddButton({
    Title = getTrans("bLobby", "Title");
    Callback = function()
        TeleportService:Teleport(5956785391, client)
    end
})

Tabs["Teleport"]:AddButton({
    Title = getTrans("bTp1", "Title");
    Callback = function()
        TeleportService:Teleport(17387475546, client)
    end
})

Tabs["Teleport"]:AddButton({
    Title = getTrans("bTp1Priv", "Title");
    Callback = function()
        TeleportService:Teleport(13883279773, client)
    end
})

Tabs["Teleport"]:AddButton({
    Title = getTrans("bTp2", "Title");
    Callback = function()
        TeleportService:Teleport(17387482786, client)
    end
})

Tabs["Teleport"]:AddButton({
    Title = getTrans("bTp2Priv", "Title");
    Callback = function()
        TeleportService:Teleport(13883059853, client)
    end
})

Tabs["Teleport"]:AddButton({
    Title = getTrans("bHub", "Title");
    Callback = function()
        TeleportService:Teleport(9321822839, client)
    end
})
--DUNGEON

Tabs["Dungeon"]:AddDropdown("dDungeonMode", {
    Title = getTrans("dDungeonMode", "Title");
    Values = {"Normal", "Competitive"};
    Default = "Normal";
    Multi = false
})

Tabs["Dungeon"]:AddToggle("tJoinDungeon", {
    Title = getTrans("tJoinDungeon", "Title");
    Default = false
}):OnChanged(function(Value)
    if Value then
        task.spawn(function()
            while options.tJoinDungeon.Value do
                ReplicatedStorage:WaitForChild("TeleportCirclesEvent", math.huge):FireServer(options.dDungeonMode.Value)
                task.wait(13)
            end
            ReplicatedStorage:WaitForChild("TeleportCirclesEvent", math.huge):FireServer(options.dDungeonMode.Value)
        end)
    end
end)

Tabs["Dungeon"]:AddToggle("tAutoDungeonMob", {
    Title = getTrans("tAutoDungeonMob", "Title");
    Description = getTrans("tAutoDungeonMob", "Desc");
    Default = false;
}):OnChanged(function(Value)
    if Value then
        task.spawn(function()
            local farmhelp = farmHelper()
            client.Character:WaitForChild("Humanoid").Died:Once(function()
                options.tAutoDungeonMob:SetValue(false)
            end)
            while options.tAutoDungeonMob.Value do
                for i, v in ipairs(workspace.Mobs:GetChildren()) do
                    if not options.tAutoDungeonMob.Value then
                        break
                    end
                    local model = v:FindFirstChildWhichIsA("Model")
                    local hrp = model and model:FindFirstChild("HumanoidRootPart")
                    local humanoid = model and model:FindFirstChild("Humanoid")
                    local spawnloc = v:FindFirstChild("Npc_Configuration") and v.Npc_Configuration:FindFirstChild("spawnlocaitonasd123")

                    local loc = (hrp and hrp.CFrame) or (spawnloc and CFrame.new(spawnloc.Value))

                    if not loc or (humanoid and humanoid.Health <= 0) then continue end

                    tweento(
                        loc * (options.tAutoM1.Value and CFrame.new(0, linked.distance, 0) or CFrame.new(0, -35, 0))
                    ).Completed:Wait()

                    model = v:WaitForChild(linked.ouwi_names[v.Name], 2)
                    while model and model:FindFirstChild("Humanoid") and model.Humanoid.Health > 0 and model:FindFirstChild("HumanoidRootPart") and options.tAutoDungeonMob.Value do
                        tpto(
                            CFrame.new(model.HumanoidRootPart.Position) * 
                            ((options.tAutoM1.Value and CFrame.new(0, linked.distance, 0) * CFrame.Angles(math.rad(-90), 0, 0)) or CFrame.new(0, -35, 0))
                        )
                        task.wait()
                    end
                end
                task.wait()
            end
            farmhelp:Stop()
        end)
    end
end)

local orbs = {"BloodMoney", "DoublePoints", "HealthRegen", "InstaKill", "MobCamouflage", "StaminaRegen", "WisteriaPoisoning"}

Tabs["Dungeon"]:AddDropdown("dOrbs", {
    Title = getTrans("dOrbs", "Title");
    Values = table.clone(orbs);
    Multi = true;
    Default = orbs;
})

local orb_conn;
Tabs["Dungeon"]:AddToggle("tCollectOrb", {
    Title = getTrans("tCollectOrb", "Title");
    Default = false;
}):OnChanged(function(Value)
    if Value then
        orb_conn = workspace.Map.ChildAdded:Connect(function(child)
            if options.dOrbs.Value[child.Name] then
                local touch;repeat touch = child:FindFirstChild("TouchInterest", true); task.wait(0.1) until touch
                repeat 
                    firetouchinterest(client.Character.HumanoidRootPart, touch.Parent, 0)
                    task.wait(0.1)
                    firetouchinterest(client.Character.HumanoidRootPart, touch.Parent, 1)
                    task.wait(0.1)
                until not child:IsDescendantOf(workspace.Map)
            end
        end)

        for i, v in ipairs(workspace.Map:GetChildren()) do
            if options.dOrbs.Value[v.Name] then
                task.defer(function()
                    repeat 
                        firetouchinterest(client.Character.HumanoidRootPart, v:FindFirstChild("TouchInterest", true).Parent, 0)
                        task.wait(0.1)
                        firetouchinterest(client.Character.HumanoidRootPart, v:FindFirstChild("TouchInterest", true).Parent, 1)
                        task.wait(0.1)
                    until not v:IsDescendantOf(workspace.Map)
                end)
            end
        end
    else
        if orb_conn then
            orb_conn:Disconnect()
        end
    end
end)

Tabs["Dungeon"]:AddToggle("tAutoShop", {
    Title = getTrans("tAutoShop", "Title");
    Default = false;
}):OnChanged(function(Value)
    if Value then
        client:WaitForChild("OuwigaharaSpectate", math.huge)
        if options.tAutoShop.Value then
            ReplicatedStorage.TeleportToShop:FireServer()
        end
    end
end)

Tabs["Dungeon"]:AddToggle("tAutoQuit", {
    Title = getTrans("tAutoQuit", "Title");
    Description = "Use with 'Auto to shop' toggle above\nWill wait for your chests to spawn first btw";
    Default = false;
}):OnChanged(function(Value)
    if Value then
        client:WaitForChild("TeleportToShop", math.huge)
        if options.tAutoQuit.Value then
            task.wait((workspace.delay_chest_amount.Value / 3.7) + 10)
            pcall(function()
                wbhook("dungeon")
            end)
            TeleportService:Teleport(9321822839, client)
        end
    end
end)


Tabs["Dungeon"]:AddInput("iDieTime", {
    Title = getTrans("iDieTime", "Title");
    Default = nil;
    Placeholder = "Ex : 30";
    Numeric = true;
    Finished = true;
})

Tabs["Dungeon"]:AddToggle("tTimeDie", {
    Title = getTrans("tTimeDie", "Title");
    Default = false;
}):OnChanged(function(Value)
    if Value then
        task.spawn(function()
            local time = workspace:WaitForChild("Total_Time", math.huge)
            local inp = options.iDieTime
            while options.tTimeDie.Value do
                if time.Value / 60 >= (tonumber(inp.Value) or math.huge) then
                    client.Character:WaitForChild("Humanoid").Health = 0
                    break
                end
                task.wait()
            end
        end)
    end 
end)

-- MUGEN
Tabs["Mugen"]:AddSlider("sMugenTeleporter", {
    Title = "Choose Mugen Teleporter";
    Description = "Select wich mugen train teleport you should use when auto joining";
    Default = 1;
    Min = 1;
    Max = 7;
    Rounding = 0;
})

Tabs["Mugen"]:AddToggle("tJoinMugen", {
    Title = "Auto Join Mugen Train";
    Default = false;
    Callback = function(Value)
        if Value then
            task.spawn(function()
                task.wait(0.2)
                if not linked.MapPlace then return end
                local farmhelp = farmHelper()
                while options["tJoinMugen"].Value do
                    local tim = (tick() / 60) % 60
                    if tim > 0 and tim < 10 then
                        local tickets = linked.playerData.Inventory.Items:FindFirstChild("Mugen Train Ticket")
                        if not tickets or tickets.Amount.Value <= 0 then
                            ReplicatedStorage:WaitForChild("purchase_mugen_ticket"):FireServer(1)
                        end
                        options["tAutoBoss"]:SetValue(false)
                        tweento(CFrame.new(workspace.MugenTrain.Teleporters["Teleport" .. options.sMugenTeleporter.Value]:GetModelCFrame().Position)).Completed:Wait()
                        break
                    end
                    task.wait()
                end
                farmhelp:Stop()
            end)
        end
    end
})

local _connections = {}
Tabs["Mugen"]:AddToggle("tAutoMugan", {
    Title = "Full Auto Solo Mugen";
    Description = "Fully automatic BUTT you need to have set a killaura before, this will toggle the main killaura on and off during mugen but not the selected killaura";
    Default = false;
    Callback = function(Value)
        if Value then
            local cutscenes = ReplicatedStorage:WaitForChild("MugenTrain", math.huge)
            cutscenes:WaitForChild("Cutscene1", math.huge)
            _connections[1] = cutscenes.Cutscene1.OnClientEvent:Once(function()
                task.wait(12)
                tpto(workspace.Map.MugenTrain.Cart1.Rengoku.SkipDialogue.CFrame)
                task.wait(1)
                fireproximityprompt(workspace.Map.MugenTrain.Cart1.Rengoku.SkipDialogue.StartDialogue)
            end)
            _connections[3] = cutscenes.Cutscene3.OnClientEvent:Once(function()
                task.wait(8)
                client.Character:WaitForChild("HumanoidRootPart")
                firetouchinterest(client.Character.HumanoidRootPart, workspace.Map.DreamWorld.DreamWorldDetection, 0)
                task.wait()
                firetouchinterest(client.Character.HumanoidRootPart, workspace.Map.DreamWorld.DreamWorldDetection, 1)
                options["tKillaura"]:SetValue(true)
            end)
            _connections[4] = cutscenes.Cutscene4.OnClientEvent:Once(function()
                options["tKillaura"]:SetValue(true)
            end)
            _connections[6] = cutscenes.Cutscene6.OnClientEvent:Once(function()
                options["tKillaura"]:SetValue(false)
            end)
            _connections[7] = cutscenes.Cutscene7.OnClientEvent:Once(function()
                task.wait(7)
                options["tKillaura"]:SetValue(true)
            end)
            _connections[8] = cutscenes.Cutscene8.OnClientEvent:Once(function()
                task.wait(10)
                for i, v in ipairs(workspace.Debree.clash_folder:GetChildren()) do
                    local args = {
                        [1] = "Change_Value",
                        [2] = v:GetChildren()[1],
                        [3] = 200
                    }
                    Handle_Initiate_S:FireServer(unpack(args))
                end
            end)
            _connections[10] = cutscenes.Cutscene10.OnClientEvent:Once(function()
                options.tAutoChest:SetValue(true)
                task.wait(17)
                local prox = workspace.Map.Carriage:FindFirstChild("MenuTeleportProximity", true)
                tpto(prox.Parent.CFrame)
                if options.tWebHook.Value then wbhook("mugen") end
                task.wait(1)
                fireproximityprompt(prox)
            end)
        else
            for i, v in ipairs(_connections) do
                v:Disconnect()
            end
        end
    end
})

Tabs["Mugen"]:AddToggle("tAutoHell", {
    Title = "Auto Activate Hell Mode";
    Default = false;
}):OnChanged(function(Value)
    if Value then
        task.spawn(function()
            local prox = workspace:WaitForChild("HardMode", math.huge):WaitForChild("ProximityPrompt", math.huge)
            tpto(prox.Parent.CFrame)
            task.wait(1)
            fireproximityprompt(prox)
        end)
    end
end)

Tabs["Mugen"]:AddToggle("tAutoMugenMob", {
    Title = "Tween Above Mobs";
    Description = "Use this if you dont have arrow\nHighy recommend using godmode with this or you may die";
    Default = false;
}):OnChanged(function(Value)
    if Value then
        task.spawn(function()
            local farmhelp = farmHelper()
            client.Character:WaitForChild("Humanoid").Died:Once(function()
                print("died")
            end)
            while options.tAutoMugenMob.Value do
                for i, v in ipairs(workspace:WaitForChild("Mobs"):GetChildren()) do
                    if not options.tAutoMugenMob.Value then break end
                    local model = v:FindFirstChildWhichIsA("Model")
                    local hrp = model and model:FindFirstChild("HumanoidRootPart")
                    local humanoid = model and model:FindFirstChild("Humanoid")

                    local loc = (hrp and hrp.CFrame)

                    if not loc or (humanoid and humanoid.Health <= 0) then continue end

                    tweento(
                        loc * (options.tAutoM1.Value and CFrame.new(0, linked.distance, 0) or CFrame.new(0, -35, 0))
                    ).Completed:Wait()

                    while model and model:FindFirstChild("Humanoid") and model.Humanoid.Health > 0 and model:FindFirstChild("HumanoidRootPart") and options.tAutoMugenMob.Value do
                        tpto(
                            CFrame.new(model.HumanoidRootPart.Position) * 
                            ((options.tAutoM1.Value and CFrame.new(0, linked.distance, 0) * CFrame.Angles(math.rad(-90), 0, 0)) or CFrame.new(0, -35, 0))
                        )
                        task.wait()
                    end
                end
                task.wait()
            end
            farmhelp:Stop()
        end)
    end
end)

Tabs["Mugen"]:AddButton({
    Title = "Insta Clash For Everyone";
    Callback = function()
         for i, v in ipairs(workspace.Debree.clash_folder:GetChildren()) do
            local args = {
                [1] = "Change_Value",
                [2] = v:GetChildren()[1],
                [3] = 200
            }
            Handle_Initiate_S:FireServer(unpack(args))
        end
    end
})

Tabs["Mugen"]:AddToggle("tQuitMugen", {
    Title = "Auto Quit Mugen";
    Default = false;
}):OnChanged(function(Value)
    if Value then
        _connections[10] = ReplicatedStorage:WaitForChild("MugenTrain", math.huge):WaitForChild("Cutscene10", math.huge).OnClientEvent:Once(function()
            options.tAutoChest:SetValue(true)
            task.wait(17)
            local prox = workspace.Map.Carriage:FindFirstChild("MenuTeleportProximity", true)
            tpto(prox.Parent.CFrame)
            if options.tWebHook.Value then wbhook("mugen") end
            task.wait(1)
            fireproximityprompt(prox)
        end)
    else
        if _connections[10] then _connections[10]:Disconnect() end
    end
end)

-- WEBHOOK

Tabs["Webhook"]:AddInput("iWebhook", {
    Title = getTrans("iWebhook", "Title");
    Default = nil;
    Placeholder = "Enter your webhook link";
    Numeric = false; -- Only allows numbers
    Finished = true; -- Only calls callback when you press enter
})

Tabs["Webhook"]:AddInput("iWbhookTime", {
    Title = "Delay Between Webhooks";
    Description = "Enter time in minutes";
    Default = 10;
    Placeholder = "Ex : 10";
    Numeric = true; -- Only allows numbers
    Finished = true; -- Only calls callback when you press enter
})

--local images = client.PlayerGui:FindFirstChild("MainGuis") and client.PlayerGui.MainGuis:FindFirstChild("Info2") and client.PlayerGui.MainGuis.Info2:FindFirstChild("Holder") and client.PlayerGui.MainGuis.Info2.Holder:FindFirstChild("Items_Holder")

Tabs["Webhook"]:AddToggle("tWebHook", {
    Title = getTrans("tWebHook", "Title");
    Description = "If your in dungeon or mugen train it will send webhook before auto quitting (you need it enabled of course)";
    Default = false;
}):OnChanged(function(Value)
    if Value then
        task.spawn(function()
            if placeId == 11468075017 or placeId == 11468034852 then
                --task.wait(0.2)
                --if options.tAutoQuit.Value or options.tAutoMugan.Value then return end
                return
            end
            local timer = tick()
            while options.tWebHook.Value do
                if tick() - timer >= (tonumber(options.iWbhookTime.Value) or math.huge) * 60 then
                    wbhook("normal")
                    timer = tick()
                end
                task.wait(task.wait(1))
            end
        end)
    end
end)

makefolder("CloudHub")
makefolder("CloudHub/PJS")
makefolder("CloudHub/PJS/" .. client.UserId)

InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("CloudHub")
InterfaceManager:BuildInterfaceSection(Tabs["Settings"])

SaveManager:IgnoreThemeSettings()
SaveManager:SetLibrary(Library)
SaveManager:SetIgnoreIndexes({})
SaveManager:SetFolder("CloudHub/PJS/" .. client.UserId)
SaveManager:BuildConfigSection(Tabs["Settings"])
Tabs["Settings"]:AddToggle("tAutoExec", {
    Title = getTrans("tAutoExec", "Title");
    Default = true;
    Callback = function(Value)
        getgenv().AutoExecCloudy = Value
    end
})

Tabs["Settings"]:AddToggle("tHopHackers", {
    Title = "Avoid Hacker Servers";
    Description = "If someone else is using CloudHub in the server, automatically change server",
        Default = false;
}):OnChanged(function(Value)
    if Value then
        for i, v in ipairs(ReplicatedStorage.Player_Data:GetChildren()) do
            if v.Name ~= client.Name and v:WaitForChild("Custom_Properties"):WaitForChild("Nezuko_pacifier_stuff"):WaitForChild("Shrinkage").Value == SERVER_ID then
                local save = HttpService:JSONDecode((isfile("CloudHub/Servers") and readfile("CloudHub/Servers")) or `\{"Refresh":{tick()}, "Joined":[], "History":[]\}`)
                if tick() - save.Refresh >= 20 then
                    save.Joined = {}
                    save.Refresh = tick()
                end

                local ret = game:HttpGet(`https://games.roblox.com/v1/games/{placeId}/servers/Public?sortOrder=Asc&limit=100`)
                if ret ~= "" then
                    local dec = HttpService:JSONDecode(ret)
                    if dec.data then
                        save.History = dec.data 
                        for i, v in ipairs(dec.data) do
                            if v.playing > 1 then
                                TeleportService:TeleportToPlaceInstance(placeId, v.id, client)
                                table.insert(save.Joined, v.id)
                                break
                            end
                        end
                    end
                else
                    for i, v in ipairs(save.History) do
                        if v.playing > 1 then
                            TeleportService:TeleportToPlaceInstance(placeId, v.id, client)
                            table.insert(save.Joined, v.id)
                            break
                        end
                    end
                end

                writefile("CloudHub/Servers", HttpService:JSONEncode(save))
            end
        end
    end
end)

--VISUALS

Tabs["Visuals"]:AddButton({
    Title = "Infinite coin spawn on you";
    Description = "Reset to stop";
    Callback = function()
        require(client.PlayerScripts.Client_Modules.Modules.Extra2.coineff)(client.Character.HumanoidRootPart, math.huge)
    end
})

if linked.AttackPlace then
    SaveManager:LoadAutoloadConfig()
end

Window:SelectTab(1)

--[[request(
    {
        Url = "http://127.0.0.1:6463/rpc?v=1",
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json",
            ["Origin"] = "https://discord.com"
        },
        Body = HttpService:JSONEncode(
            {
                cmd = "INVITE_BROWSER",
                args = {code = "wgFBpD7mRh"},
                nonce = HttpService:GenerateGUID(false)
            }
        )
    }
)]]


pcall(function()
    client.PlayerGui.text_notification:Fire({
        Profile_Image = getcustomasset("CloudHub/logo.webp");
        custom_image_size = UDim2.fromScale(1.2, 1.0);
        Text = "<AnimateStepFrequency=2><AnimateStepTime=.002><TextScale=.288><AnimateStyle=Rainbow>Welcome to CloudHub\nJoin discord for support<AnimateStyle=/><TextScale=/><AnimateStepTime=/><AnimateStepFrequency=/>";
        Duration = 10;
    })
end)

client.OnTeleport:Once(function(State)
    if linked.MapPlace then
        wbhook("normal")
    end
end)

return options, linked, SaveManager
