-- DONT BOTHER TAKING THIS SCRIPT - ADD qxkya#6909 ON DISCORD TO ASK FOR PERMISSION TO TAKE SOME FUNCTIONS

-- Services

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

-- Remotes

local remoteProxy = ReplicatedStorage.Interaction.RemoteProxy
local ClientIsDragging = ReplicatedStorage.Interaction.ClientIsDragging
local PlayerChattedRemote = ReplicatedStorage.NPCDialog.PlayerChatted
local PromptChat = ReplicatedStorage.NPCDialog.PromptChat
local SetChattingValue = ReplicatedStorage.NPCDialog.SetChattingValue
local clientPurchasedProperty = ReplicatedStorage.PropertyPurchasing.ClientPurchasedProperty
local setPropertyPurchasingValue = ReplicatedStorage.PropertyPurchasing.SetPropertyPurchasingValue
local clientExpandedProperty = ReplicatedStorage.PropertyPurchasing.ClientExpandedProperty
local ClientInteracted = ReplicatedStorage.Interaction.ClientInteracted

-- Folders

local axeFolder = ReplicatedStorage.AxeClasses
local LogModels = WS.LogModels
local PlayerModels = WS.PlayerModels
local StoresFolder = WS.Stores

-- Variables

local selectedTree = "Generic"
local treeClasses = {"Generic", "GoldSwampy", "CaveCrawler", "Cherry", "Frost", "Volcano", "Oak", "Walnut", "Birch", "SnowGlow", "Pine", "GreenSwampy", "Koa", "Palm", "Spooky", "SpookyNeon", "LoneCave"}

local WalkSpeedToggle = false
local WalkSpeedAmount = 16
local JumpPowerToggle = false
local JumpPowerAmount = 50
local NoclipToggle = false

local AutoBuyItem = "BasicHatchet"
local AutoBuying = false
local AutoBuyQuantity = 1
local buyingBlueprints = false
local AutoBuyingBlueprints = false

local LoopDupeTools = false
local LoopDuping = false
local LoopGettingTree = false

local GettingTree = false

local SelectionMode = "Single"
local SelectionModeToggle = false

local StealPlayer = game.Players.LocalPlayer
local StealItem

local selectionFrame
local mouseDown
local Inset = GuiService:GetGuiInset()

local sellPosition = CFrame.new(315.4, 1.2, 85.4)

local Items = {}
local selectedItem

local SelectedItems = {}

local cashierIds = {
	["Thom"] = 7,
	["Corey"] = 8,
	["Jenny"] = 9,
	["Bob"] = 10,
	["Timothy"] = 11,
	["Lincoln"] = 12,
}

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

if not game:GetService("CoreGui"):FindFirstChild("SelectionLasso") then
	local LassoSelection = Instance.new("ScreenGui")
	local Frame = Instance.new("Frame")
	local UIStroke = Instance.new("UIStroke")

	LassoSelection.Name = "LassoSelection"
	LassoSelection.Parent = game:GetService("CoreGui")
	LassoSelection.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	Frame.Parent = LassoSelection
	Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Frame.BackgroundTransparency = 1.000
	Frame.Position = UDim2.new(0.476566106, 0, 0.444687843, 0)
	Frame.Size = UDim2.new(0, 100, 0, 100)
	Frame.Visible = false

	UIStroke.Color = Color3.fromRGB(189, 189, 189)
	UIStroke.Parent = Frame
	UIStroke.Thickness = 1.399999976158142

	selectionFrame = game:GetService("CoreGui"):WaitForChild("LassoSelection"):FindFirstChild("Frame")
else
	selectionFrame = game:GetService("CoreGui"):WaitForChild("LassoSelection"):FindFirstChild("Frame")
end

function Notify(title, text, duration)
	game.StarterGui:SetCore(
		"SendNotification",
		{
			Title = title,
			Text = text,
			Duration = duration
		}
	)
end

function hasHumanoid(Player)
	if Player then
		if LocalPlayer.Character ~= nil and LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid") then
			return true
		end
	end
	
	return false
end

function MaxLand(Plot)
	local OriginSquare = Plot.OriginSquare

	if #Plot:GetChildren() < 26 then
		setPropertyPurchasingValue:InvokeServer(true)
		clientExpandedProperty:FireServer(Plot, CFrame.new(OriginSquare.Position.X + 40, OriginSquare.Position.Y, OriginSquare.Position.Z)) clientExpandedProperty:FireServer(Plot, CFrame.new(OriginSquare.Position.X - 40, OriginSquare.Position.Y, OriginSquare.Position.Z)) clientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X, OriginSquare.Position.Y, OriginSquare.Position.Z + 40)) clientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X, OriginSquare.Position.Y, OriginSquare.Position.Z - 40)) clientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X + 40, OriginSquare.Position.Y, OriginSquare.Position.Z + 40)) clientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X + 40, OriginSquare.Position.Y, OriginSquare.Position.Z - 40)) clientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X - 40, OriginSquare.Position.Y, OriginSquare.Position.Z + 40)) clientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X - 40, OriginSquare.Position.Y, OriginSquare.Position.Z - 40)) clientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X + 80, OriginSquare.Position.Y, OriginSquare.Position.Z)) clientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X - 80, OriginSquare.Position.Y, OriginSquare.Position.Z)) clientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X, OriginSquare.Position.Y, OriginSquare.Position.Z + 80)) clientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X, OriginSquare.Position.Y, OriginSquare.Position.Z - 80)) clientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X + 80, OriginSquare.Position.Y, OriginSquare.Position.Z + 80)) clientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X + 80, OriginSquare.Position.Y, OriginSquare.Position.Z - 80)) clientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X - 80, OriginSquare.Position.Y, OriginSquare.Position.Z + 80)) clientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X - 80, OriginSquare.Position.Y, OriginSquare.Position.Z - 80)) clientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X + 40, OriginSquare.Position.Y, OriginSquare.Position.Z + 80)) clientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X - 40, OriginSquare.Position.Y, OriginSquare.Position.Z + 80)) clientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X + 80, OriginSquare.Position.Y, OriginSquare.Position.Z + 40)) clientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X + 80, OriginSquare.Position.Y, OriginSquare.Position.Z - 40)) clientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X - 80, OriginSquare.Position.Y, OriginSquare.Position.Z + 40)) clientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X - 80, OriginSquare.Position.Y, OriginSquare.Position.Z - 40)) clientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X + 40, OriginSquare.Position.Y, OriginSquare.Position.Z - 80)) clientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X - 40, OriginSquare.Position.Y, OriginSquare.Position.Z - 80))
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Plot.OriginSquare.CFrame.p) + Vector3.new(0, 5, 0)
		setPropertyPurchasingValue:InvokeServer(false)	
	end
end

function getFreeLand()
	for _, v in pairs(WS.Properties:GetChildren()) do 
		if v.Owner.Value == nil then
			return v
		end
	end
end

function FreeLand()
	local plot = getFreeLand()
	setPropertyPurchasingValue:InvokeServer(true)
	clientPurchasedProperty:FireServer(plot, plot.OriginSquare.CFrame.p)
	setPropertyPurchasingValue:InvokeServer(false)

	LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(plot.OriginSquare.CFrame.p) + Vector3.new(0, 5, 0)
end

function getPlayersBase(plr)
	for i, v in pairs(game.Workspace.Properties:GetChildren()) do 
		if v:IsA("Model") and v.Owner.Value == plr then 
			return v
		end
	end

	return false
end

function findSelectedTree(treeClass)
	for _, v in pairs(WS:GetChildren()) do
		if tostring(v) == "TreeRegion" then
			for _, g in pairs(v:GetChildren()) do
				if g:FindFirstChild("TreeClass") and tostring(g.TreeClass.Value) == treeClass and g:FindFirstChild("Owner") then
					if g.Owner.Value == nil or tostring(g.Owner.Value) == tostring(LocalPlayer) then
						if #g:GetChildren() > 5 and g:FindFirstChild("WoodSection") then
							for h, j in pairs(g:GetChildren()) do
								if j:FindFirstChild("ID") and j.ID.Value == 1 and j.Size.Y > .5 then
									return j
								end
							end
						end
					end
				end
			end
		end
	end

	return false
end

function selectPart(part)
	local color = Color3.fromRGB(84, 129, 184)

	local SB = Instance.new("SelectionBox", part)
	SB.LineThickness = 0.03
	SB.Adornee = part

	table.insert(SelectedItems, part)
end

function getAllItems()
	local itemsFound = {}
	
	table.insert(itemsFound, "---!--- Tools ---!---")

	for i, v in pairs(StoresFolder:GetDescendants()) do
		if v:IsA("Model") then
			if v:FindFirstChild("BoxItemName") and v.Parent.Name == "ShopItems" then
				if v:FindFirstChild("Type") then
					if v:FindFirstChild("Type").Value == "Tool" then
						if not table.find(itemsFound, v:FindFirstChild("BoxItemName").Value) then
							table.insert(itemsFound, v:FindFirstChild("BoxItemName").Value)
						end
					end
				end
			end
		end
	end

	table.insert(itemsFound, "---!--- Structures ---!---")

	for i, v in pairs(StoresFolder:GetDescendants()) do
		if v:IsA("Model") then
			if v:FindFirstChild("BoxItemName") and v.Parent.Name == "ShopItems" then
				if v:FindFirstChild("Type") then
					if v:FindFirstChild("Type").Value == "Structure" then
						if not table.find(itemsFound, v:FindFirstChild("BoxItemName").Value) then
							table.insert(itemsFound, v:FindFirstChild("BoxItemName").Value)
						end
					end
				end
			end
		end
	end

	table.insert(itemsFound, "---!--- Blueprints ---!---")

	for i, v in pairs(StoresFolder:GetDescendants()) do
		if v:IsA("Model") then
			if v:FindFirstChild("BoxItemName") and v.Parent.Name == "ShopItems" then
				if v:FindFirstChild("Type") then
					if v:FindFirstChild("Type").Value == "Blueprint" then
						if not table.find(itemsFound, v:FindFirstChild("BoxItemName").Value) then
							table.insert(itemsFound, v:FindFirstChild("BoxItemName").Value)
						end
					end
				end
			end
		end
	end

	table.insert(itemsFound, "---!--- Wires ---!---")

	for i, v in pairs(StoresFolder:GetDescendants()) do
		if v:IsA("Model") then
			if v:FindFirstChild("BoxItemName") and v.Parent.Name == "ShopItems" then
				if v:FindFirstChild("Type") then
					if v:FindFirstChild("Type").Value == "Wire" then
						if not table.find(itemsFound, v:FindFirstChild("BoxItemName").Value) then
							table.insert(itemsFound, v:FindFirstChild("BoxItemName").Value)
						end
					end
				end
			end
		end
	end

	table.insert(itemsFound, "---!--- Vehicles ---!---")

	for i, v in pairs(StoresFolder:GetDescendants()) do
		if v:IsA("Model") then
			if v:FindFirstChild("BoxItemName") and v.Parent.Name == "ShopItems" then
				if v:FindFirstChild("Type") then
					if v:FindFirstChild("Type").Value == "Vehicle" then
						if not table.find(itemsFound, v:FindFirstChild("BoxItemName").Value) then
							table.insert(itemsFound, v:FindFirstChild("BoxItemName").Value)
						end
					end
				end
			end
		end
	end

	table.insert(itemsFound, "---!--- Loose Items ---!---")

	for i, v in pairs(StoresFolder:GetDescendants()) do
		if v:IsA("Model") then
			if v:FindFirstChild("BoxItemName") and v.Parent.Name == "ShopItems" then
				if v:FindFirstChild("Type") then
					if v:FindFirstChild("Type").Value == "Loose Item" then
						if not table.find(itemsFound, v:FindFirstChild("BoxItemName").Value) then
							table.insert(itemsFound, v:FindFirstChild("BoxItemName").Value)
						end
					end
				end
			end
		end
	end

	return itemsFound
end

function findLowestIDTree(tree)
	local lowestID = nil

	if tree:IsA("Model") then
		for i, v in pairs(tree:GetChildren()) do
			if v:FindFirstChild("Owner") and tostring(v.Owner.Value) == tostring(LocalPlayer) then
				for i, v2 in pairs(v:GetChildren()) do
					if v2.Name == "WoodSection" and v2:FindFirstChild("ID") then
						if lowestID == nil then
							lowestID = v2
						else
							if lowestID.ID.Value > v2:FindFirstChild("ID").Value then
								lowestID = v2
							end
						end
					end
				end
			end
		end
	else
		Notify("Error", "Failed to find tree", 3)
	end
end

local function To3dSpace(pos)
	return Camera:ScreenPointToRay(pos.x, pos.y).Origin 
end

local function CalcSlope(vec)
	local rel = Camera.CFrame:pointToObjectSpace(vec)
	return Vector2.new(rel.x/-rel.z, rel.y/-rel.z)
end

local function Overlaps(cf, a1, a2)
	local rel = Camera.CFrame:ToObjectSpace(cf)
	local x, y = rel.x / -rel.z, rel.y / -rel.z

	return (a1.x) < x and x < (a2.x) 
		and (a1.y < y and y < a2.y) and rel.z < 0 
end

local function Swap(a1, a2)
	return Vector2.new(math.min(a1.x, a2.x), math.min(a1.y, a2.y)), Vector2.new(math.max(a1.x, a2.x), math.max(a1.y, a2.y))
end

local function Search(objs, p1, p2)
	local Found = {}
	local a1 = CalcSlope(p1)
	local a2 = CalcSlope(p2)

	a1, a2 = Swap(a1, a2)

	for _ ,obj in ipairs(objs) do

		if obj:IsA("Model") then
			--if obj:FindFirstChild("Owner") and (tostring(obj.Owner.Value) == tostring(Players.LocalPlayer) or obj.Owner.Value == nil) then
			if obj:FindFirstChild("Type") then
				if (obj.Type.Value == "Tool" or obj.Type.Value == "Gift" or obj.Type.Value == "Loose Item" or obj.Type.Value == "Furniture") and (obj.Type.Value ~= "" and obj.Type.Value ~= "Vehicle Spot") then
					local cf = obj:IsA("Model") and obj:GetBoundingBox() or obj.CFrame

					if Overlaps(cf,a1, a2) then
						table.insert(Found, obj)
					end
				end
			elseif obj:FindFirstChild("TreeClass") then
				local cf = obj:IsA("Model") and obj:GetBoundingBox() or obj.CFrame

				if Overlaps(cf,a1, a2) then
					table.insert(Found, obj)
				end
			end
			--end
		end
	end

	return Found
end

function findOwnedTrees()
	local TreesFound = {}

	for i, v in pairs(LogModels:GetChildren()) do
		if v:FindFirstChild("Owner") then
			if tostring(v.Owner.Value) == LocalPlayer.Name or tostring(v.Owner.Value) == tostring(LocalPlayer) then
				table.insert(TreesFound, v)
			end
		end
	end

	return TreesFound
end

function findOwnedPlanks()
	local TreesFound = {}

	for i, v in pairs(PlayerModels:GetChildren()) do
		if v:FindFirstChild("Owner") and v:FindFirstChild("TreeClass") then
			if tostring(v.Owner.Value) == LocalPlayer.Name or tostring(v.Owner.Value) == tostring(LocalPlayer) then
				table.insert(TreesFound, v)
			end
		end
	end

	return TreesFound
end

function sellTree(tree)
	local oldPos = LocalPlayer.Character:WaitForChild("HumanoidRootPart", 5).CFrame

	if not tree.PrimaryPart then
		tree.PrimaryPart = tree:FindFirstChild("WoodSection")
	end

	LocalPlayer.Character:WaitForChild("HumanoidRootPart", 5).CFrame = CFrame.new(tree.PrimaryPart.Position) + Vector3.new(2, 0, 2)

	wait(0.2)

	for i = 1, 10 do
		ClientIsDragging:FireServer(tree)
	end

	tree:SetPrimaryPartCFrame(sellPosition)

	wait(0.05)
end

function bringTree(tree)
	local oldPos = LocalPlayer.Character:WaitForChild("HumanoidRootPart", 5).CFrame

	if not tree.PrimaryPart then
		tree.PrimaryPart = tree:FindFirstChild("WoodSection")
	end

	LocalPlayer.Character:WaitForChild("HumanoidRootPart", 5).CFrame = CFrame.new(tree.PrimaryPart.Position) + Vector3.new(2, 0, 2)

	wait(0.2)

	for i = 1, 10 do
		ClientIsDragging:FireServer(tree)
	end

	tree:SetPrimaryPartCFrame(oldPos)

	wait(0.05)
end

function getBestAxe()
	local toolName
	local axes = {}
	local bestAxe
	local dmg = 0
	local damage

	for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do
		table.insert(axes, v)
	end

	for _, v in pairs(LocalPlayer.Character:GetChildren()) do
		if v:IsA("Tool") then
			table.insert(axes, v)
		end
	end

	for _, v in pairs(axes) do
		if v:FindFirstChild("ToolName") and axeFolder:FindFirstChild("AxeClass_" .. tostring(v.ToolName.Value)) then
			local axeStats = require(axeFolder:FindFirstChild("AxeClass_" .. tostring(v.ToolName.Value))).new()

			if axeStats.SpecialTrees then
				if axeStats.SpecialTrees[selectedTree] then
					damage = axeStats.SpecialTrees[selectedTree].Damage
					bestAxe = v
					return bestAxe
				end
			end

			damage = axeStats.Damage

			if damage > dmg then
				dmg = damage
				bestAxe = v
			end
		end
	end

	return bestAxe
end

function GetHitPoint(axe)
	local axeFolder = axeFolder["AxeClass_" .. axe]
	local axeModule = require(axeFolder).new()
	local hitPoint = axeModule.Damage

	if axeModule.SpecialTrees then
		if axeModule.SpecialTrees[selectedTree] then
			hitPoint = axeModule.SpecialTrees[selectedTree].Damage
		end
	end

	return hitPoint
end

function chopTree(cutEvent)
	remoteProxy:FireServer(cutEvent, {
		["tool"] = getBestAxe(),
		["faceVector"] = Vector3.new(1,0,0),
		["height"] = 0.32,
		["sectionId"] = 1,
		["hitPoints"] = GetHitPoint(getBestAxe().ToolName.Value),
		["cooldown"] = -14,
		["cuttingClass"] = "Axe"
	})
end

function bringSelectedTree()
	if GettingTree == false then
		GettingTree = true
		local treeToBring = findSelectedTree(selectedTree)
		local treeIsChopped = false
		local treeIsBrung = false

		local OldPosition = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position)

		if not treeToBring then
			Notify("Bring Tree", "Couldn't find any grown " .. selectedTree .. "s")
			repeat wait() treeToBring = findSelectedTree(selectedTree) until treeToBring
			wait(0.1)
		end

		LogModels.ChildAdded:Connect(function(tree)
			wait(0.5)

			if tostring(tree.Owner.OwnerString.Value) == LocalPlayer.Name and tree.TreeClass.Value == selectedTree then
				if treeIsBrung == false then
					treeIsChopped = true
					treeIsBrung = true

					for i = 1, 10 do
						ClientIsDragging:FireServer(tree)
					end

					if not tree.PrimaryPart then
						tree.PrimaryPart = tree:FindFirstChild("WoodSection")
					end

					tree:SetPrimaryPartCFrame(OldPosition)
				end
			end
		end)

		LocalPlayer.Character.HumanoidRootPart.CFrame = treeToBring.CFrame + Vector3.new(2, 1, 2)

		repeat 
			wait()

			if getBestAxe() and treeToBring and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
				chopTree(treeToBring.Parent.CutEvent)
			end
		until treeIsChopped or GettingTree == false

		LocalPlayer.Character.HumanoidRootPart.CFrame = OldPosition + Vector3.new(0, 2, 0)
		wait(0.05)
		GettingTree = false
	end
end

local autoBuyToggle

function getItem(name)
	for i, v in pairs(StoresFolder:GetDescendants()) do
		if v:IsA("Model") then
			if v:FindFirstChild("BoxItemName") then
				if v:FindFirstChild("BoxItemName").Value == name then
					return v
				end
			end
		end
	end
end

function getCounter(store)
	for i, v in pairs(store.Parent:GetChildren()) do 
		if v:IsA("Part") and v.Name == "Counter" then 
			return v
		end
	end
end

function getStore(item)
	local magnitude = 9e9
	local counter

	local primaryPartSet = false

	local PP

	if item.PrimaryPart == nil then
		for i, v in pairs(item:GetChildren()) do
			if primaryPartSet == false then
				if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("Union") then
					PP = v

					primaryPartSet = true
				end
			end
		end
	else
		PP = item.PrimaryPart
	end

	for _, v in pairs(WS.Stores:GetChildren()) do
		if tostring(v) == "WoodRUs" or tostring(v) == "CarStore" or tostring(v) == "FineArt" or tostring(v) == "ShackShop" or tostring(v) == "LogicStore" or tostring(v) == "FurnitureStore" then 
			if (item:FindFirstChildWhichIsA("Part").CFrame.p - v.Counter.CFrame.p).magnitude < magnitude then
				magnitude = (item:FindFirstChildWhichIsA("Part").CFrame.p - v.Counter.CFrame.p).magnitude
				counter = v.Counter
			end
		end
	end

	return counter
end

function getCashier(item)
	local store = getStore(item)

	for i, v in pairs(store.Parent:GetChildren()) do 
		if v:IsA("Model") and v:FindFirstChild("Humanoid") then 
			return v
		end
	end
end

function getID(item)
	local v = getCashier(item)

	return cashierIds[tostring(v)]
end

function buyItem(item)
	local Cashier = getCashier(item)
	local CashierID = getID(item)

	PlayerChattedRemote:InvokeServer({Character = Cashier, Name = tostring(Cashier), ID = CashierID}, "Initiate")
	wait()
	PlayerChattedRemote:InvokeServer({Character = Cashier, Name = tostring(Cashier), ID = CashierID}, "ConfirmPurchase")
	wait()
	PlayerChattedRemote:InvokeServer({Character = Cashier, Name = tostring(Cashier), ID = CashierID}, "EndChat")
end

function loopBuyItem(itemName, amont)
	if AutoBuying == false then
		AutoBuying = true

		local itemToBuy = getItem(itemName)

		local oldpos = LocalPlayer.Character.HumanoidRootPart.Position
		local timesLeft = amont

		local Counter = getCounter(getStore(itemToBuy))

		repeat
			if AutoBuying == true then
				timesLeft -= 1

				itemToBuy = getItem(itemName)

				local primaryPartSet = false

				if not itemToBuy then
					repeat itemToBuy = getItem(itemName) wait() until itemToBuy

					wait(0.05)
				end

				if itemToBuy.PrimaryPart == nil then
					for i,v in pairs(itemToBuy:GetChildren()) do
						if primaryPartSet == false then
							if v:IsA("Part") or v:IsA("Union") or v:IsA("MeshPart") then
								itemToBuy.PrimaryPart = v

								primaryPartSet = true
							end
						end
					end
				else
					primaryPartSet = true
				end

				LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(itemToBuy.PrimaryPart.Position) + Vector3.new(0, 2, 0)
				wait(0.05)
				for i = 1, 5 do
					ClientIsDragging:FireServer(itemToBuy)
				end
				wait(0.05)
				itemToBuy:SetPrimaryPartCFrame(Counter.CFrame + Vector3.new(0, itemToBuy.PrimaryPart.Size.Y + (Counter.Size.Y / 2), 0))
				wait(0.05)
				LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(itemToBuy.PrimaryPart.Position) + Vector3.new(2, 2, 2)

				repeat buyItem(itemToBuy) wait() until itemToBuy:FindFirstChild("PurchasedBoxItemName") or AutoBuying == false

				for i = 1, 5 do
					ClientIsDragging:FireServer(itemToBuy)
				end
				wait(0.05)
				itemToBuy:SetPrimaryPartCFrame(CFrame.new(oldpos) + Vector3.new(0, 4, 0))
				wait(0.05)
				LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(oldpos)
				wait(0.05)
			end
		until timesLeft == 0 or AutoBuying == false

		buyingBlueprints = false
		AutoBuying = false
	end
end

function dupeTools()
	loopDuping = true

	LocalPlayer.Character.Humanoid:UnequipTools()

	local tools = {}
	local oldPosition = LocalPlayer.Character.HumanoidRootPart.Position

	for i, v in pairs(LocalPlayer.Backpack:GetChildren()) do
		if v:IsA("Tool") and v.Name == "Tool" then
			v.Parent = LocalPlayer.Character
			table.insert(tools, v)
		end
	end

	if #tools <= 1 then
		for i, v in pairs(tools) do
			ClientInteracted:FireServer(v, "Drop tool", LocalPlayer.Character.Head.CFrame)
		end

		LocalPlayer.Character.Head:Destroy()

		repeat wait() until LocalPlayer.Character:FindFirstChild("Head")

		wait(0.05)

		LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(oldPosition)
	end

	loopDuping = false
end

function loopDupeTools()
	while LoopDupeTools == true do

		if loopDuping == false then
			dupeTools()
		end

		wait(0.1)
	end
end

local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/Rain-Design/PPHUD/main/Library.lua'))()
local Flags = Library.Flags

local Window = Library:Window({
	Text = "Lumber Tycoon 2 | qxkya#6909"
})

local PlayerTab = Window:Tab({
	Text = "Player"
})

local WoodTab = Window:Tab({
	Text = "Wood"
})

local BaseTab = Window:Tab({
	Text = "Base"
})

local AutoBuyTab = Window:Tab({
	Text = "Auto Buy"
})

local DupeTab = Window:Tab({
	Text = "Dupe"
})

local StealTab = Window:Tab({
	Text = "Steal"
})

local TeleportsTab = Window:Tab({
	Text = "Teleports"
})

local MiscTab = Window:Tab({
	Text = "Misc"
})

local SettingsTab = Window:Tab({
	Text = "Settings"
})

local PlayerSection = PlayerTab:Section({
	Text = "Player"
})

local BaseSection = BaseTab:Section({
	Text = "Base"
})

local StealSection = StealTab:Section({
	Text = "Steal"
})

local WoodSection = WoodTab:Section({
	Text = "Wood"
})

local AutoBuySection = AutoBuyTab:Section({
	Text = "Auto Buy"
})

local DupeSection = DupeTab:Section({
	Text = "Dupe"
})

local TeleportsSection = TeleportsTab:Section({
	Text = "Teleports"
})

local MiscSection = MiscTab:Section({
	Text = "Misc"
})

local SettingsSection = SettingsTab:Section({
	Text = "Settings"
})

-- Player Section

do
	PlayerSection:Check({
		Text = "Walkspeed",
		Callback = function(bool)
			WalkSpeedToggle = bool
		end
	})

	PlayerSection:Slider({
		Text = "Walkspeed",
		Default = 16,
		Minimum = 16,
		Maximum = 200,
		Callback = function(int)
			WalkSpeedAmount = int
		end
	})

	PlayerSection:Check({
		Text = "Jump Power",
		Callback = function(bool)
			JumpPowerToggle = bool
		end
	})

	PlayerSection:Slider({
		Text = "Jump Power",
		Default = 50,
		Minimum = 50,
		Maximum = 200,
		Callback = function(int)
			JumpPowerAmount = int
		end
	})

	PlayerSection:Check({
		Text = "Noclip",
		Callback = function(bool)
			NoclipToggle = bool
		end
	})
end

-- Base Section

do
	BaseSection:Button({
		Text = "Free Land",
		Callback = function()
			FreeLand()
		end
	})

	BaseSection:Button({
		Text = "Max Land",
		Callback = function()
			MaxLand(getPlayersBase(LocalPlayer))
		end
	})
	
	BaseSection:Button({
		Text = "Sell Property Sold Sign",
		Callback = function()
			for i, v in pairs(PlayerModels:GetChildren()) do
				if v:FindFirstChild("ItemName") and tostring(v.ItemName.Value) == "PropertySoldSign" then
					sellTree(v)
				end
			end
		end
	})
end

-- Wood Section

do
	WoodSection:Dropdown({
		Text = "Tree Class",
		List = treeClasses,
		Callback = function(class)
			selectedTree = class
		end
	})

	WoodSection:Button({
		Text = "Get Selected Tree",
		Callback = function()
			bringSelectedTree()
		end
	})

	WoodSection:Check({
		Text = "Loop Get Selected Tree",
		Callback = function(state)
			LoopGettingTree = state

			if LoopGettingTree == true then
				while LoopGettingTree == true do
					bringSelectedTree()
					wait(0.1)
				end
			else
				GettingTree = false
			end
		end
	})

	WoodSection:Button({
		Text = "Sell Trees",
		Callback = function()
			local oldPos = LocalPlayer.Character:WaitForChild("HumanoidRootPart", 5).Position

			for i, v in pairs(findOwnedTrees()) do
				sellTree(v)
			end

			wait(0.1)

			LocalPlayer.Character:WaitForChild("HumanoidRootPart", 5).CFrame = CFrame.new(oldPos)
		end
	})

	WoodSection:Button({
		Text = "Sell Planks",
		Callback = function()
			local oldPos = LocalPlayer.Character:WaitForChild("HumanoidRootPart", 5).Position

			for i, v in pairs(findOwnedPlanks()) do
				sellTree(v)
			end

			wait(0.1)

			LocalPlayer.Character:WaitForChild("HumanoidRootPart", 5).CFrame = CFrame.new(oldPos)
		end
	})

	WoodSection:Button({
		Text = "Bring Trees",
		Callback = function()
			local oldPos = LocalPlayer.Character:WaitForChild("HumanoidRootPart", 5).Position

			for i, v in pairs(findOwnedTrees()) do
				bringTree(v)
			end

			wait(0.1)

			LocalPlayer.Character:WaitForChild("HumanoidRootPart", 5).CFrame = CFrame.new(oldPos)
		end
	})

	WoodSection:Button({
		Text = "Bring Planks",
		Callback = function()
			local oldPos = LocalPlayer.Character:WaitForChild("HumanoidRootPart", 5).Position
			
			for i, v in pairs(findOwnedPlanks()) do
				bringTree(v)
			end
			
			wait(0.1)

			LocalPlayer.Character:WaitForChild("HumanoidRootPart", 5).CFrame = CFrame.new(oldPos)
		end
	})
end

-- Autobuy Section

do
	AutoBuySection:Dropdown({
		Text = "Item",
		List = getAllItems(),
		Callback = function(itemName)
			AutoBuyItem = itemName
		end
	})

	AutoBuySection:Slider({
		Text = "Item Quantity",
		Default = 1,
		Minimum = 1,
		Maximum = 100,
		Callback = function(quantity)
			AutoBuyQuantity = quantity
		end
	})

	AutoBuySection:Button({
		Text = "Auto Buy",
		Callback = function()
			loopBuyItem(AutoBuyItem, AutoBuyQuantity)
		end
	})

	AutoBuySection:Button({
		Text = "Abort",
		Callback = function()
			AutoBuying = false
		end
	})

	AutoBuySection:Check({
		Text = "Buy All Blueprints",
		Callback = function(bool)
			AutoBuyingBlueprints = bool
			
			if AutoBuyingBlueprints == true then
				if buyingBlueprints == false then
					for i, v1 in pairs(StoresFolder:GetChildren()) do
						if v1:IsA("Model") then
							for i, v in pairs(v1:GetChildren()) do
								if v:FindFirstChild("BoxItemName") and v.Parent.Name == "ShopItems" then
									if v:FindFirstChild("Type") then
										if v.Type.Value == "Blueprint" then
											if not LocalPlayer.PlayerBlueprints.Blueprints:FindFirstChild(tostring(v:FindFirstChild("BoxItemName").Value)) then
												if AutoBuying == true then
													repeat wait() until AutoBuying == false or AutoBuyingBlueprints == false
												end
												
												if AutoBuyingBlueprints then
													if LocalPlayer.leaderstats.Money.Value >= 80 then
														loopBuyItem(tostring(v:FindFirstChild("BoxItemName").Value), 1)
													else
														Notify("Not enough cash!", "You do not have enough cash to buy " .. tostring(v:FindFirstChild("BoxItemName").Value) .. ". You need $" .. tostring(80 - LocalPlayer.leaderstats.Money.Value) .. " more money to afford it.")
														
														AutoBuying = false
														buyingBlueprints = false
														
														AutoBuyingBlueprints = false
													end
												end
											end
										end
									end
								end
							end
						end
					end
				end
			else
				AutoBuying = false
				buyingBlueprints = false
			end
		end
	})
end

-- Dupe Section

do
	DupeSection:Button({
		Text = "Dupe Tool",
		Callback = function()
			dupeTools()
		end
	})

	DupeSection:Check({
		Text = "Loop Dupe Tool",
		Callback = function(bool)
			LoopDupeTools = bool
			
			if LoopDupeTools == true then
				loopDupeTools()
			end
		end
	})
end

-- Teleports Section


-- Steal Section

StealSection:Dropdown({
	Text = "Selection Mode",
	List = {"Single", "All of one item / plank", "Lasso"},
	Callback = function(mode)
		SelectionMode = mode
	end
})

StealSection:Check({
	Text = "Select Items",
	Callback = function(bool)
		SelectionModeToggle = bool
	end
})

Mouse.Button1Down:Connect(function()
	if SelectionModeToggle then
		if SelectionMode == "Single" then
			if Mouse.Target and not Mouse:IsA("Model") then
				if Mouse.Target.Parent:FindFirstChild("Owner") then
					if Mouse.Target:FindFirstChild("SelectionBox") then
						Mouse.Target:FindFirstChild("SelectionBox"):Destroy()

						if table.find(SelectedItems, Mouse.Target) then
							table.remove(SelectedItems, tonumber(table.find(SelectedItems, Mouse.Target)))
						end
					else
						if Mouse.Target.Name ~= "Square" then
							if not Mouse.Target.Parent:FindFirstChild("CutEvent") then
								selectPart(Mouse.Target)
							end
						end
					end
				end
			end
		elseif SelectionMode == "All of one item / plank" then
			local Target
			local TargetClass
			local TargetIsATree = false

			if Mouse.Target then
				if not Mouse.Target:IsA("Model") then
					Target = Mouse.Target

					repeat
						Target = Target.Parent
						wait()
					until Target:IsA("Model")
				else
					Target = Mouse.Target
				end

				if Target:FindFirstChild("TreeClass") then
					TargetIsATree = true
					TargetClass = Target:FindFirstChild("TreeClass").Value
				end
				
				if (Target:FindFirstChild("Type") or Target:FindFirstChild("TreeClass")) and Target:FindFirstChild("PurchasedBoxItemName") then
					for i, v in pairs(game.Workspace.PlayerModels:GetChildren()) do
						if v:FindFirstChild("PurchasedBoxItemName") and tostring(v:FindFirstChild("PurchasedBoxItemName").Value) == tostring(Target:FindFirstChild("PurchasedBoxItemName").Value) then
							if v:FindFirstChild("Owner") and (v.Owner.Value == Players.LocalPlayer or v.Owner.Value == nil or v.Owner.Value == Target.Owner.Value) then
								if TargetIsATree == false then
									local b = v:FindFirstChild("Main") or nil
									
									if b.Name ~= "Square" then
										if b ~= nil then
											if b:FindFirstChild("SelectionBox") then
												b:FindFirstChild("SelectionBox"):Destroy()
											end		

											if table.find(SelectedItems, b) then
												table.remove(SelectedItems, tonumber(table.find(SelectedItems, b)))
											end

											selectPart(b)
										end
									end
								else
									local b = v:FindFirstChild("WoodSection") or nil 

									if v:FindFirstChild("TreeClass") and v.TreeClass.Value == TargetClass then
										if b:FindFirstChild("SelectionBox") then
											b:FindFirstChild("SelectionBox"):Destroy()
										end		

										if table.find(SelectedItems, b) then
											table.remove(SelectedItems, tonumber(table.find(SelectedItems, b)))
										end

										selectPart(b)
									end
								end
							end
						end
					end

					for i, g in pairs(game.Workspace.Stores:GetChildren()) do
						if g.Name == "ShopItems" then
							for i, v in pairs(g:GetChildren()) do
								if v:FindFirstChild("Owner") and (v.Owner.Value == Players.LocalPlayer or v.Owner.Value == nil) then
									if Target:FindFirstChild("BoxItemName") then
										if v:FindFirstChild("BoxItemName") and v.BoxItemName.Value == Target.BoxItemName.Value then
											local b = v:FindFirstChild("Main") or nil

											if b ~= nil then
												if b:FindFirstChild("SelectionBox") then
													b:FindFirstChild("SelectionBox"):Destroy()
												end		

												if table.find(SelectedItems, b) then
													table.remove(SelectedItems, tonumber(table.find(SelectedItems, b)))
												end

												selectPart(b)
											end
										end
									end
								end
							end
						end
					end
				end
				
				print(#SelectedItems)
			end
		end
	end
end)

UserInputService.InputBegan:Connect(function(input)
	if SelectionModeToggle then
		if input.UserInputType == Enum.UserInputType.MouseButton1 and SelectionMode == "Lasso" then
			lastPos = Vector2.new(input.Position.x, input.Position.y) 
			mouseDown = true
		end
	end
end)


UserInputService.InputEnded:Connect(function(input)
	if SelectionModeToggle then
		if input.UserInputType == Enum.UserInputType.MouseButton1 and SelectionMode == "Lasso" then

			local pos = Vector2.new(input.Position.x, input.Position.y)
			local result = Search(workspace.PlayerModels:GetChildren(), To3dSpace(lastPos), To3dSpace(pos))
			mouseDown = false; selectionFrame.Visible = false 

			for i, v in pairs(result) do
				local model = v

				repeat
					if not model:IsA("Model") then
						model = model.Parent
					end
				until model:IsA("Model")
				
				if not model.PrimaryPart:FindFirstChild("SelectionBox") then
					if not table.find(SelectedItems, model) then
						local b = model:FindFirstChild("WoodSection") or model:FindFirstChild("Main") or model.PrimaryPart or nil

						selectPart(b)
					end
				end
			end
		end
	end
end)

RunService.Heartbeat:Connect(function()
	if SelectionModeToggle then
		if mouseDown and SelectionMode == "Lasso" then
			local pos = UserInputService:GetMouseLocation()

			local lastPos = lastPos + Inset
			local Center = ((lastPos+ pos) * .5) - Inset

			local DistX = math.abs(lastPos.X - pos.X)  
			local DistY = math.abs(lastPos.Y - pos.Y)  

			selectionFrame.Position = UDim2.new(0, Center.X,0, Center.Y)
			selectionFrame.Size =  UDim2.new(0, DistX,0, DistY)

			selectionFrame.Visible = true
		end
	end
end)

RunService.Stepped:Connect(function()
	if WalkSpeedToggle then
		if hasHumanoid(LocalPlayer) then
			LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid").WalkSpeed = WalkSpeedAmount
		end
	else
		if hasHumanoid(LocalPlayer) then
			LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid").WalkSpeed = 16
		end
	end
	
	if JumpPowerToggle then
		if hasHumanoid(LocalPlayer) then
			LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid").JumpPower = JumpPowerAmount
		end
	else
		if hasHumanoid(LocalPlayer) then
			LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid").JumpPower = 50
		end
	end
	
	if NoclipToggle then
		if hasHumanoid(LocalPlayer) then
			for i, v in pairs(LocalPlayer.Character:GetChildren()) do
				if v:IsA("BasePart") then
					v.CanCollide = false
				end
			end
		end
	end
end)
