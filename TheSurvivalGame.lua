local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local Entity = loadstring(game:HttpGet("https://github.com/joeengo/VapeV4ForRoblox/blob/main/Libraries/entityHandler.lua?raw=true", true))()

local BoatsFolder = Workspace.boats
local MinablesFolder = Workspace.worldResources.mineable
local ChoppablesFolder = Workspace.worldResources.choppable
local AnimalsFolder = Workspace.animals
local DroppedItemsFolder = Workspace.droppedItems

local KillAura = false
local MineAura = false
local HuntAura = false
local AutoPickup = false
local Speed = false

function IsBoatOccopied(Boat)
    if Boat.VehicleSeat.Occupant == LocalPlayer then
        return false
    end
    if Boat.VehicleSeat.Occupant ~= nil then
        return true
    end

    return false
end

function IsInBoat()
    if LocalPlayer.Character.Humanoid.SeatPart ~= nil then
        if LocalPlayer.Character.Humanoid.SeatPart.Parent.Name == "Raft" then
            return true
        end
    end

    return false
end

function GetRandomBoat()
    if #BoatsFolder:GetChildren() > 0 then
        local Boats = {}

        if IsInBoat() then
            return LocalPlayer.Character.Humanoid.SeatPart.Parent
        end

        for _, v in pairs(BoatsFolder:GetChildren()) do
            if v.Name == "Raft" then
                --if not IsBoatOccopied(v) then
                    table.insert(Boats, v)
                --end
            end
        end

        return Boats[math.random(1, #Boats)]
    end
end

function GetMagnitude(Position1, Position2)
    return (Position1 - Position2).Magnitude
end

function ClearBoat(Boat)
    for _, v in pairs(Boat.prim:GetChildren()) do
        if v.Name == "BodyPosition" or v.Name == "BodyGyro" then
            v:Destroy()
        end
    end
end

function GetOre(OreType)
    for _, Ore in pairs(MinablesFolder:GetChildren()) do
        if Ore.Name == OreType then
            for _, v in pairs(Ore:GetChildren()) do
                if v.PrimaryPart.Transparency ~= 1 then
                    return v
                end
            end
        end
    end
end

function GetClosestOre()
    local ClosestOre
    local ClosestMagnitude = math.huge

    for _, Ore in pairs(MinablesFolder:GetChildren()) do
        for _, v in pairs(Ore:GetChildren()) do
            if v.PrimaryPart ~= nil and v.PrimaryPart.Transparency ~= 1 then
                local Magnitude = GetMagnitude(LocalPlayer.Character.HumanoidRootPart.Position, v.PrimaryPart.Position)

                if Magnitude < ClosestMagnitude then
                    ClosestOre = v
                    ClosestMagnitude = Magnitude
                end
            end
        end
    end

    return ClosestOre
end

function GetChoppable(Type)
    for _, Choppable in pairs(ChoppablesFolder:GetChildren()) do
        if Choppable.Name:lower() == Type:lower() then
            for _, v in pairs(Choppable:GetChildren()) do
                if (v.PrimaryPart.Name == "hitbox" and v:FindFirstChildWhichIsA("MeshPart").Transparency ~= 1) or v.PrimaryPart.Transparency ~= 1 then
                    return v
                end
            end
        end
    end
end

function GetDroppedItem(ItemName)
    for _, v in pairs(DroppedItemsFolder:GetChildren()) do
        if v:FindFirstChild(ItemName) then
            return v:FindFirstChild(ItemName)
        end
    end
end

function GetAnimal(Type)
    for _, v in pairs(AnimalsFolder:GetChildren()) do
        if v.Name == Type then
            return v
        end
    end
end

function GetPlayer(String)
    for _, v in pairs(Players:GetPlayers()) do
        if string.find(v.Name:lower(), String:lower()) then
            return v
        end
    end
end

function GetPlayerByDisplayName(String)
    for _, v in pairs(Players:GetPlayers()) do
        if string.find(v.DisplayName:lower(), String:lower()) then
            return v
        end
    end
end

local TeleportDelay1 = 2
local TeleportDelay2 = 3

function BoatTeleport(Position)
    if #BoatsFolder:GetChildren() > 0 then
        local Boat = GetRandomBoat()

        if not IsInBoat() then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Boat.VehicleSeat.Position)
        end

        ClearBoat(Boat)

        local Count = 0

        Boat:SetPrimaryPartCFrame(CFrame.new(Position))
        wait(TeleportDelay1)
        LocalPlayer.Character.Humanoid.Sit = false
        repeat task.wait() Count += 1 until GetMagnitude(LocalPlayer.Character.HumanoidRootPart.Position, Position) > 20 or Count > 100
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Boat.VehicleSeat.Position)
        repeat task.wait() until IsInBoat()
        wait(TeleportDelay2)
        LocalPlayer.Character.Humanoid.Sit = false
    end
end

function GetSword()
    for _, Tool in pairs(LocalPlayer.Backpack:GetChildren()) do
        if Tool:FindFirstChild("toolModel") then
            for _, v in pairs(Tool.toolModel:GetChildren()) do
                if string.find(v.Name:lower(), "sword") or string.find(v.Name:lower(), "blade") or string.find(v.Name:lower(), "club") then
                    return tonumber(Tool.Name)
                end
            end
        end
    end
    if LocalPlayer.Character ~= nil then
        for _, Tool in pairs(LocalPlayer.Character:GetChildren()) do
            if Tool:IsA("Tool") and Tool:FindFirstChild("toolModel") then
                for _, v in pairs(Tool.toolModel:GetChildren()) do
                    if string.find(v.Name:lower(), "sword") or string.find(v.Name:lower(), "blade") or string.find(v.Name:lower(), "club") then
                        return tonumber(Tool.Name)
                    end
                end
            end
        end
    end
end

function GetPickaxe()
    for _, Tool in pairs(LocalPlayer.Backpack:GetChildren()) do
        if Tool:FindFirstChild("toolModel") then
            for _, v in pairs(Tool.toolModel:GetChildren()) do
                if string.find(v.Name:lower(), "pickaxe") then
                    return tonumber(Tool.Name)
                end
            end
        end
    end
    if LocalPlayer.Character ~= nil then
        for _, Tool in pairs(LocalPlayer.Character:GetChildren()) do
            if Tool:IsA("Tool") and Tool:FindFirstChild("toolModel") then
                for _, v in pairs(Tool.toolModel:GetChildren()) do
                    if string.find(v.Name:lower(), "pickaxe") then
                        return tonumber(Tool.Name)
                    end
                end
            end
        end
    end
end

function GetAxe()
    for _, Tool in pairs(LocalPlayer.Backpack:GetChildren()) do
        if Tool:FindFirstChild("toolModel") then
            for _, v in pairs(Tool.toolModel:GetChildren()) do
                if string.find(v.Name:lower(), "axe") then
                    return tonumber(Tool.Name)
                end
            end
        end
    end
    if LocalPlayer.Character ~= nil then
        for _, Tool in pairs(LocalPlayer.Character:GetChildren()) do
            if Tool:IsA("Tool") and Tool:FindFirstChild("toolModel") then
                for _, v in pairs(Tool.toolModel:GetChildren()) do
                    if string.find(v.Name:lower(), "axe") then
                        return tonumber(Tool.Name)
                    end
                end
            end
        end
    end
end

function HitPlayer(Player)
    local HotbarId = GetSword()

    if HotbarId then
        ReplicatedStorage.remoteInterface.interactions.meleePlayer:FireServer(HotbarId, Player)
    end
end

function GetClosestPlayer()
    local ClosestPlayer
    local ClosestMagnitude = math.huge

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            if v.Character ~= nil and v.Character:FindFirstChild("HumanoidRootPart") then
                local PlayerMagnitude = GetMagnitude(LocalPlayer.Character.HumanoidRootPart.Position, v.Character.HumanoidRootPart.Position)
                if PlayerMagnitude < ClosestMagnitude then
                    ClosestPlayer = v
                    ClosestMagnitude = PlayerMagnitude
                end
            end
        end
    end

    return ClosestPlayer
end

function MineOre(Ore)
    local HotbarId = GetPickaxe()
    local MineCFrame

    if HotbarId then
        if Ore.PrimaryPart ~= nil then
            if GetMagnitude(LocalPlayer.Character.HumanoidRootPart.Position, Ore.PrimaryPart.Position) < 10 then
                MineCFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position)
            else
                MineCFrame = Ore.PrimaryPart.CFrame
            end
            ReplicatedStorage.remoteInterface.interactions.mine:FireServer(HotbarId, Ore, MineCFrame)
        end
    end
end

function PickupItem(Item)
    ReplicatedStorage.remoteInterface.inventory.pickupItem:FireServer(Item)
end

function GetClosestItem()
    local ClosestItem
    local ClosestMagnitude = math.huge

    for _, Item in pairs(game.Workspace.droppedItems:GetChildren()) do
        if #Item:GetChildren() > 1 then
            local Model = Item:FindFirstChildWhichIsA("Model")

            if Model ~= nil and Model.PrimaryPart ~= nil then
                if GetMagnitude(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, Model.PrimaryPart.Position) < ClosestMagnitude then
                    ClosestMagnitude = GetMagnitude(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, Model.PrimaryPart.Position)
                    ClosestItem = Item
                end
            end
        end
    end

    return ClosestItem
end

function GetAmountOfOre(OreType)
    local OresTable = {}

    for _, Ore in pairs(MinablesFolder:GetChildren()) do
        if Ore.Name == OreType then
            for _, v in pairs(Ore:GetChildren()) do
                if v.PrimaryPart.Transparency ~= 1 then
                    table.insert(OresTable, Ore)
                end
            end
        end
    end

    return #OresTable
end

function GetClosestAnimal()
    local ClosestAnimal
    local ClosestMagnitude = math.huge

    for i, v in pairs(AnimalsFolder:GetChildren()) do
        if v:FindFirstChild("HumanoidRootPart") then
            local Root = v:FindFirstChild("HumanoidRootPart")
            local Magnitude = GetMagnitude(LocalPlayer.Character.HumanoidRootPart.Position, Root.Position)

            if Magnitude < ClosestMagnitude then
                ClosestAnimal = v
                ClosestMagnitude = Magnitude
            end
        end
    end

    return ClosestAnimal
end

function HitAnimal(Animal)
    local HotbarId = GetSword()

    if HotbarId then
        ReplicatedStorage.remoteInterface.interactions.meleeAnimal:FireServer(HotbarId, Animal)
    end
end

function HasSteelArmor(Player)
    if Player and Player.Character ~= nil then
        for i, v in pairs(Player.Character:GetDescendants()) do
            if v:IsA("MeshPart") and string.find(v.Name:lower(), "steel") then
                return true
            end
        end
    end

    return false
end

local library = loadstring(game:HttpGet('https://raw.githubusercontent.com/qxkya/UI-Libraries/main/Valiant.lua'))()

local Window = library:CreateWindow("Kya-Ware", "The Survival Game [BETA]", 10044538000)

local MainTab = Window:CreateTab("Main")

local PlayerFrame = MainTab:CreateFrame("Player")
local FarmingFrame = MainTab:CreateFrame("Farming")
local CombatFrame = MainTab:CreateFrame("Combat")
local TeleportsFrame = MainTab:CreateFrame("Teleports")
local MiscFrame = MainTab:CreateFrame("Misc")
local SettingsFrame = MainTab:CreateFrame("Settings")

local HarvestToggle
local PlantToggle

local IronButton
local CoalButton
local CopperButton

HarvestToggle = FarmingFrame:CreateToggle("Harvest", "Sets the farming mode to Harvest", function(Bool)
    AutoPickup = Bool

    Plant:SetToggle(false)
end)

PlantToggle = FarmingFrame:CreateToggle("Plant", "Sets the farming mode to Plant", function(Bool)
    AutoPickup = Bool

    HarvestToggle:SetToggle(true)
end)

CombatFrame:CreateToggle("Kill Aura", "Hits the closest person to you inside of a 5 stud radius.", function(Bool)
    KillAura = Bool
end)

CombatFrame:CreateToggle("Hunt Aura", "Hits the closest animal to you inside of a 10 stud radius.", function(Bool)
    HuntAura = Bool
end)

CombatFrame:CreateToggle("Mine Aura", "Mines the closest ore to you inside of a 10 stud radius.", function(Bool)
    MineAura = Bool
end)

PlayerFrame:CreateToggle("Speed", "Makes you walk faster than normal?", function(Bool)
    Speed = Bool
end)

PlayerFrame:CreateToggle("Auto Pickup", "Picks up all the items inside of a 5 stud radius around you.", function(Bool)
    AutoPickup = Bool
end)

SettingsFrame:CreateSlider("Teleport Delay 1 (2 Best)", 0, 10, function(Int)
    TeleportDelay1 = Int
end)

SettingsFrame:CreateSlider("Teleport Delay 2 (3 Best)", 0, 10 ,function(Int)
    TeleportDelay2 = Int
end)

IronButton = TeleportsFrame:CreateButton("Iron Ore", "Telepors you to an Iron Ore.", function()
    BoatTeleport(GetOre("Iron Ore").PrimaryPart.Position)
end)

CoalButton = TeleportsFrame:CreateButton("Coal Ore", "Telepors you to a Coal Ore.", function()
    BoatTeleport(GetOre("Coal Ore").PrimaryPart.Position)
end)

CopperButton = TeleportsFrame:CreateButton("Copper Ore", "Telepors you to a Copper Ore.", function()
    BoatTeleport(GetOre("Copper Ore").PrimaryPart.Position)
end)

TeleportsFrame:CreateButton("Boulder", "Telepors you to a Boulder.", function()
    BoatTeleport(GetOre("Boulder").Boulder.Position)
end)

TeleportsFrame:CreateBox("Player", 10044538000, function(Text)
    if (Text ~= nil and Text ~= "") and string.len(Text) > 1 then
        local Player = GetPlayer(Text) or GetPlayerByDisplayName(Text)

        if Player.Character ~= nil and Player.Character:FindFirstChild("HumanoidRootPart") then
            BoatTeleport(Player.Character.HumanoidRootPart.Position + Vector3.new(0, 10, 0))
        end
    end
end)

TeleportsFrame:CreateBox("Position (Vector3)", 10044538000, function(Text)
    local Filtered1 = string.gsub(Text, " ", "")
    local Split1 = string.split(Filtered1, ",")

    if #Split1 == 3 then
        local Position = Vector3.new(tonumber(Split1[1]), tonumber(Split1[2]), tonumber(Split1[3]))

        BoatTeleport(Position)
    end

    if #Split ~= 3 then
        local Split2 = string.split(Text, " ")

        if #Split2 == 3 then
            local Position = Vector3.new(tonumber(Split2[1]), tonumber(Split2[2]), tonumber(Split2[3]))

            BoatTeleport(Position)
        end
    end
end)

TeleportsFrame:CreateBox("Choppable", 10044538000, function(Text)
    local Choppable = GetChoppable(Text)

    if Choppable ~= nil then
        if Choppable.PrimaryPart then
            BoatTeleport(Choppable.PrimaryPart.Position)
        end
    end
end)

local SteelArmorButton

SteelArmorButton = MiscFrame:CreateButton("Get Players with Steal Armor", "N/A", function()
    local PlayersWithSteelArmor = {}

    for i, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and HasSteelArmor(v) then
            table.insert(PlayersWithSteelArmor, v.Name)
        end
    end

    if #PlayersWithSteelArmor > 0 then
        print(table.unpack(PlayersWithSteelArmor))
    else
        print("none")
    end
end)

MiscFrame:CreateBox("Has Steel Armor (Player)", 10044538000, function(Text)
    if (Text ~= nil and Text ~= "") and string.len(Text) > 1 then
        local Player = GetPlayer(Text) or GetPlayerByDisplayName(Text)

        if Player and Player.Character ~= nil then
            CreateNotification("Player Notification", Player.Name .. " has steel armor.", function(value)
                print(value)
            end)
        end
    end
end)

RunService.Heartbeat:Connect(function(DeltaTime)
    IronButton:UpdateButton("Iron Ore", "Telepors you to an Iron Ore.  |  " .. GetAmountOfOre("Iron Ore") .. " left.")
    CoalButton:UpdateButton("Coal Ore", "Telepors you to a Coal Ore.  |  " .. GetAmountOfOre("Coal Ore") .. " left.")
    CopperButton:UpdateButton("Copper Ore", "Telepors you to a Copper Ore.  |  " .. GetAmountOfOre("Copper Ore") .. " left.")

    if KillAura then
        if LocalPlayer.Character ~= nil and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local Player = GetClosestPlayer()

            if Player and Player.Character ~= nil and Player.Character:FindFirstChild("HumanoidRootPart") then
                if GetMagnitude(LocalPlayer.Character.HumanoidRootPart.Position, Player.Character.HumanoidRootPart.Position) < 10 then
                    HitPlayer(Player)
                end
            end
        end
    end
    if HuntAura then
        if LocalPlayer.Character ~= nil and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local Animal = GetClosestAnimal()

            if Animal and Animal:FindFirstChild("HumanoidRootPart") then
                if GetMagnitude(LocalPlayer.Character.HumanoidRootPart.Position, Animal:FindFirstChild("HumanoidRootPart").Position) < 15 then
                    HitAnimal(Animal)
                end
            end
        end
    end
    if AutoPickup then
        if LocalPlayer.Character ~= nil and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local Item = GetClosestItem()
            local Model

            if Item then
                Model = Item:FindFirstChildWhichIsA("Model")

                if Model and Model.PrimaryPart ~= nil then
                    if GetMagnitude(LocalPlayer.Character.HumanoidRootPart.Position, Model.PrimaryPart.Position) < 10 then
                        PickupItem(Item)
                    end
                else
                    PickupItem(Item)
                end
            end
        end
    end
    if Speed then
        if LocalPlayer.Character ~= nil and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local Humanoid = LocalPlayer.Character.Humanoid
            local MoveDirection = Humanoid.MoveDirection

            local Factor = 27 - 16
            local MultMoveDirection = (MoveDirection * DeltaTime) * Factor

            LocalPlayer.Character:TranslateBy(MultMoveDirection)
        end
    end
end)

RunService.Stepped:Connect(function()
    if MineAura then
        if LocalPlayer.Character ~= nil and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local Ore = GetClosestOre()

            if Ore and Ore.PrimaryPart ~= nil then
                if GetMagnitude(LocalPlayer.Character.HumanoidRootPart.Position, Ore.PrimaryPart.Position) < 15 then
                    MineOre(Ore)
                    task.wait(0.1)
                end
            end
        end
    end
end)
