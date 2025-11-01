repeat task.wait() until game:IsLoaded()
if getgenv().DUPE then return end
local Library = loadstring(game:HttpGetAsync("https://github.com/cloudman4416/Fluent_Clone/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/cloudman4416/Fluent_Clone/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/cloudman4416/Fluent_Clone/master/Addons/InterfaceManager.lua"))()

local options = Library.Options

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

local client = Players.LocalPlayer
local camera = workspace.CurrentCamera

playerData = ReplicatedStorage.Player_Data:WaitForChild(client.Name)

local Handle_Initiate_S = ReplicatedStorage.Remotes.To_Server:WaitForChild("Handle_Initiate_S")
local Handle_Initiate_S_ = ReplicatedStorage.Remotes.To_Server:WaitForChild("Handle_Initiate_S_")

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

local Tabs = {
    ["Main"] = Window:AddTab({Title = "Dupe Hub", Icon = ""});
    ["Settings"] = Window:AddTab({Title = "Settings", Icon = "settings"});
}

Tabs["Main"]:AddToggle("tDupe", {
    Title = "Drop, Dupe, Rejoin";
    Default = false;
    Callback = function(Value)
        if Value then
            local bag = client.Backpack:WaitForChild("Wen", math.huge)
            bag.Parent = client.Character
            task.wait(1)
            bag.Parent = workspace
            workspace:WaitForChild("Money bag", 5)
            Handle_Initiate_S:FireServer("remove_item", playerData)

            task.wait(0.5)

            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, client)
        end
    end
})

Tabs["Main"]:AddButton({
    Title = "Rejoin";
    Callback = function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, client)
    end
})

makefolder("CloudHub")
makefolder("CloudHub/PJS")
makefolder("CloudHub/PJS/DUPE")
makefolder("CloudHub/PJS/" .. client.UserId)

InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("CloudHub")
InterfaceManager:BuildInterfaceSection(Tabs["Settings"])

SaveManager:IgnoreThemeSettings()
SaveManager:SetLibrary(Library)
SaveManager:SetIgnoreIndexes({})
SaveManager:SetFolder("CloudHub/PJS/DUPE/" .. client.UserId)
SaveManager:BuildConfigSection(Tabs["Settings"])

Window:SelectTab(1)

SaveManager:LoadAutoloadConfig()

getgenv().DUPE = true

queue_on_teleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/cloudhub4416tuff/Dupe/refs/heads/main/dupe.lua"))()')
