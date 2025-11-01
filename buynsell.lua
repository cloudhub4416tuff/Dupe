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

playerData = ReplicatedStorage.Player_Data:FindFirstChild(client.Name)

local Handle_Initiate_S = ReplicatedStorage.Remotes.To_Server:WaitForChild("Handle_Initiate_S")
local Handle_Initiate_S_ = ReplicatedStorage.Remotes.To_Server:WaitForChild("Handle_Initiate_S_")

local viewportSize = camera.ViewportSize

local noclip = function()
    for i, v in ipairs(client.Character:GetChildren()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
        end
    end
end

local farmHelper = function()
	local Farm = {}
    client.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
	local _conn = RunService.Stepped:Connect(noclip)
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
}

local item = "Lantern"
local price = 600
local sell = 180
local money = 150000
local ore = 25000
local much = ((money/price) * sell) // ore
local wensneed = math.ceil((ore * much) / sell) * price

Tabs["Main"]:AddToggle("tDupe", {
    Title = "Do Everything";
    Default = false;
    Callback = function(Value)
        if Value then
            task.spawn(function()
                while options.tDupe.Value do
                    task.wait()
                    if not (client.Backpack:FindFirstChild("Wen") or client.Character:FindFirstChild("Wen")) then
                        if playerData.Inventory.Items:FindFirstChild("Wen") then
                            Handle_Initiate_S:FireServer("change_equip_for_item", client, playerData.Inventory, playerData.Inventory.Items.Wen)
                        else
                            local bag = workspace:WaitForChild("Money bag")
                            repeat
                                client.Character.HumanoidRootPart.CFrame = bag.CFrame
                                Handle_Initiate_S:FireServer("transfer_money_to_money_bag2", client, playerData, bag)
                                task.wait(1)
                            until playerData.Inventory.Items:FindFirstChild("Wen") or not options.tDupe.Value
                            Handle_Initiate_S:FireServer("change_equip_for_item", client, playerData.Inventory, playerData.Inventory.Items.Wen)
                        end
                    end

                    local wen = client.Character:FindFirstChild("Wen") or client.Backpack:WaitForChild("Wen", 5)

                    if not wen then
                        Library:Notify({
                            Title = "ATTENTION",
                            Content = "Error while transfering wen from inventory to backpack",
                            Duration = 5
                        })
                        return
                    end

                    Handle_Initiate_S_:InvokeServer("give_thing_thing_yem", playerData, wen:WaitForChild("Handle"), "Wen")

                    Handle_Initiate_S:FireServer("buysomething", client, item, playerData.Yen, playerData.Inventory, 139)

                    local lanterns = playerData.Inventory.Items:WaitForChild(item, 5)
                    task.wait(1)

                    game:GetService("ReplicatedStorage"):WaitForChild("Sell_Items_tang"):InvokeServer({[lanterns.Settings.Id.Value] = lanterns.Amount.Value}, much, 0)

                    Library:Notify({
                        Title = "ATTENTION",
                        Content = "Worked",
                        Duration = 5
                    })
                end
            end)
        end
    end
})

Window:SelectTab(1)
