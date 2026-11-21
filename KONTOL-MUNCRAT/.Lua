-- SENAR HUB | Blox Fruits  (WindUI, Theme Amber)
-- By GGSIHLUH / Ardy / SenarHub
--
-- CATATAN PENTING:
--  * Data quest (CheckQuest) dipakai dari script yang kamu kirim (sudah dipadatkan jadi tabel).
--  * Banyak fitur memakai remote/objek internal Blox Fruits yang SERING berubah tiap update.
--    Bagian yang aku tahu pasti struktur umumnya: quest, farming level, chest, fruit, status.
--    Bagian lain (raid, dojo, ship, leviathan, trials, halloween, dll) = best-effort dengan pcall;
--    kalau satu fitur tidak jalan, script lain tetap jalan dan status menampilkan alasannya.
--  * Blox Fruits punya anti-cheat. Pakai di akun alt dan atas risiko sendiri.
--  * Key premium divalidasi di sisi client (lihat CFG.VALID_KEYS / CFG.KEY_CHECK_URL).

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Senar Hub Blox fruit",
    Icon = "Door",
    Author = "GGSIHLUH",
    Folder = "ProjectHubConfig",
    Size = UDim2.fromOffset(300, 400),
    Transparent = true,
    Theme = "Amber",
    Resizable = true,
    SideBarWidth = 170,
    User = {
        Enabled = true,
        Anonymous = false
    }
})

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

local antiAfkConnection = nil
local function EnableAntiAFK()
    if antiAfkConnection then antiAfkConnection:Disconnect() end
    antiAfkConnection = LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
    end)
end
EnableAntiAFK()

if game:GetService("CoreGui"):FindFirstChild("WindUIToggleGui") then
    game:GetService("CoreGui").WindUIToggleGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
local ToggleBtn = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")

if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
elseif protectgui then
    protectgui(ScreenGui)
end

ScreenGui.Name = "WindUIToggleGui"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

ToggleBtn.Name = "ToggleButton"
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleBtn.BackgroundTransparency = 0.5
ToggleBtn.Position = UDim2.new(0, 15, 0.4, 0)
ToggleBtn.Size = UDim2.new(0, 55, 0, 55)
ToggleBtn.Image = "rbxassetid://120264930670687"
ToggleBtn.ScaleType = Enum.ScaleType.Fit
ToggleBtn.Active = true
ToggleBtn.Draggable = true

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = ToggleBtn

UIStroke.Color = Color3.fromRGB(255, 102, 153)
UIStroke.Thickness = 2.5
UIStroke.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function()
    if Window and Window.Toggle then
        Window:Toggle()
    end
end)

-- ================= SERVICES =================
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local env = (getgenv and getgenv()) or _G
if env.__SenarBFCleanup then pcall(env.__SenarBFCleanup) end

local World1 = game.PlaceId == 2753915549
local World2 = game.PlaceId == 4442272183
local World3 = game.PlaceId == 7449423635

-- ================= CONFIG =================
local CFG = {
	VALID_KEYS = {},          -- isi key valid di sini, contoh: { "SENAR-XXXX-XXXX" }
	KEY_CHECK_URL = nil,      -- opsional: URL validasi, key ditambahkan di belakang. Balasan berisi "true"/"valid" = sah
	KEY_LINK = "https://key-generation-system-68d39b.netlify.app",
	DISCORD = "https://discord.gg/My9aazvDeM",
	KEY_FILE = "SenarHubKey.txt",

	TEMPLE_ENTRANCE = Vector3.new(28286.355, 14895.301, 102.625),
	BOSS_BONE = { "Reborn Skeleton", "Living Zombie", "Demonic Soul", "Posessed Mummy" },
	BOSS_KATAKURI = { "Katakuri", "Cake Prince" },
	BOSS_DOUGH = { "Dough King" },
	BOSS_RIPINDRA = { "rip_indra", "Rip_Indra" },
	BOSS_SKYWINGS = { "Sky Wings" },
	ELITE = { "Diablo", "Urban", "Deandre" },
	SEA_CREATURES = { ["Sea Beast"] = "SeaBeast", ["Terror Shark"] = "Terror", ["Water Rumbling"] = "Rumbling", ["Leviathan"] = "Leviathan" },
	TIKI_OUTPOST = Vector3.new(-16300, 40, 250),
	BOAT_SPEED = 150,
}

-- ================= DATA QUEST (dari CheckQuest milikmu) =================
-- {minLevel, maxLevel, Mon, LevelQuest, NameQuest, qx,qy,qz, mx,my,mz, [ex,ey,ez = requestEntrance]}
local Q1 = {
	{1,9,"Bandit",1,"BanditQuest1",1059.37,15.45,1550.42,1045.96,27.00,1560.82},
	{10,14,"Monkey",1,"JungleQuest",-1598.09,35.55,153.38,-1448.52,67.85,11.47},
	{15,29,"Gorilla",2,"JungleQuest",-1598.09,35.55,153.38,-1129.88,40.46,-525.42},
	{30,39,"Pirate",1,"BuggyQuest1",-1141.07,4.10,3831.55,-1103.51,13.75,3896.09},
	{40,59,"Brute",2,"BuggyQuest1",-1141.07,4.10,3831.55,-1140.08,14.81,4322.92},
	{60,74,"Desert Bandit",1,"DesertQuest",894.49,5.14,4392.43,924.80,6.45,4481.59},
	{75,89,"Desert Officer",2,"DesertQuest",894.49,5.14,4392.43,1608.28,8.61,4371.01},
	{90,99,"Snow Bandit",1,"SnowQuest",1389.74,88.15,-1298.91,1354.35,87.27,-1393.95},
	{100,119,"Snowman",2,"SnowQuest",1389.74,88.15,-1298.91,1201.64,144.58,-1550.07},
	{120,149,"Chief Petty Officer",1,"MarineQuest2",-5039.59,27.35,4324.68,-4881.23,22.65,4273.75},
	{150,174,"Sky Bandit",1,"SkyQuest",-4839.53,716.37,-2619.44,-4953.21,295.74,-2899.23},
	{175,189,"Dark Master",2,"SkyQuest",-4839.53,716.37,-2619.44,-5259.84,391.40,-2229.04},
	{190,209,"Prisoner",1,"PrisonerQuest",5308.93,1.66,475.12,5098.97,-0.32,474.24},
	{210,249,"Dangerous Prisoner",2,"PrisonerQuest",5308.93,1.66,475.12,5654.56,15.63,866.30},
	{250,274,"Toga Warrior",1,"ColosseumQuest",-1580.05,6.35,-2986.48,-1820.21,51.68,-2740.67},
	{275,299,"Gladiator",2,"ColosseumQuest",-1580.05,6.35,-2986.48,-1292.84,56.38,-3339.03},
	{300,324,"Military Soldier",1,"MagmaQuest",-5313.37,10.95,8515.29,-5411.16,11.08,8454.29},
	{325,374,"Military Spy",2,"MagmaQuest",-5313.37,10.95,8515.29,-5802.87,86.26,8828.86},
	{375,399,"Fishman Warrior",1,"FishmanQuest",61122.65,18.50,1569.40,60878.30,18.48,1543.76,61163.85,11.68,1819.78},
	{400,449,"Fishman Commando",2,"FishmanQuest",61122.65,18.50,1569.40,61922.63,18.48,1493.93,61163.85,11.68,1819.78},
	{450,474,"God's Guard",1,"SkyExp1Quest",-4721.89,843.87,-1949.97,-4710.04,845.28,-1927.31,-4607.82,872.54,-1667.56},
	{475,524,"Shanda",2,"SkyExp1Quest",-7859.10,5544.19,-381.48,-7678.49,5566.40,-497.22,-7894.62,5547.14,-380.29},
	{525,549,"Royal Squad",1,"SkyExp2Quest",-7906.82,5634.66,-1411.99,-7624.25,5658.13,-1467.35},
	{550,624,"Royal Soldier",2,"SkyExp2Quest",-7906.82,5634.66,-1411.99,-7836.75,5645.66,-1790.62},
	{625,649,"Galley Pirate",1,"FountainQuest",5259.82,37.35,4050.03,5551.02,78.90,3930.41},
	{650,1e9,"Galley Captain",2,"FountainQuest",5259.82,37.35,4050.03,5441.95,42.50,4950.09},
}
local Q2 = {
	{700,724,"Raider",1,"Area1Quest",-429.54,71.77,1836.18,-728.33,52.78,2345.77},
	{725,774,"Mercenary",2,"Area1Quest",-429.54,71.77,1836.18,-1004.32,80.16,1424.62},
	{775,799,"Swan Pirate",1,"Area2Quest",638.44,71.77,918.28,1068.66,137.61,1322.11},
	{800,874,"Factory Staff",2,"Area2Quest",632.70,73.11,918.67,73.08,81.86,-27.47},
	{875,899,"Marine Lieutenant",1,"MarineQuest3",-2440.80,71.71,-3216.07,-2821.37,75.90,-3070.09},
	{900,949,"Marine Captain",2,"MarineQuest3",-2440.80,71.71,-3216.07,-1861.23,80.18,-3254.70},
	{950,974,"Zombie",1,"ZombieQuest",-5497.06,47.59,-795.24,-5657.78,78.97,-928.69},
	{975,999,"Vampire",2,"ZombieQuest",-5497.06,47.59,-795.24,-6037.67,32.18,-1340.66},
	{1000,1049,"Snow Trooper",1,"SnowMountainQuest",609.86,400.12,-5372.26,549.15,427.39,-5563.70},
	{1050,1099,"Winter Warrior",2,"SnowMountainQuest",609.86,400.12,-5372.26,1142.75,475.64,-5199.42},
	{1100,1124,"Lab Subordinate",1,"IceSideQuest",-6064.07,15.24,-4902.98,-5707.47,15.95,-4513.39},
	{1125,1174,"Horned Warrior",2,"IceSideQuest",-6064.07,15.24,-4902.98,-6341.37,15.95,-5723.16},
	{1175,1199,"Magma Ninja",1,"FireSideQuest",-5428.03,15.06,-5299.43,-5449.67,76.66,-5808.20},
	{1200,1249,"Lava Pirate",2,"FireSideQuest",-5428.03,15.06,-5299.43,-5213.33,49.74,-4701.45},
	{1250,1274,"Ship Deckhand",1,"ShipQuest1",1037.80,125.09,32911.60,1212.01,150.79,33059.25,923.21,126.98,32852.83},
	{1275,1299,"Ship Engineer",2,"ShipQuest1",1037.80,125.09,32911.60,919.48,43.54,32779.97,923.21,126.98,32852.83},
	{1300,1324,"Ship Steward",1,"ShipQuest2",968.81,125.09,33244.13,919.44,129.56,33436.04,923.21,126.98,32852.83},
	{1325,1349,"Ship Officer",2,"ShipQuest2",968.81,125.09,33244.13,1036.02,181.44,33315.73,923.21,126.98,32852.83},
	{1350,1374,"Arctic Warrior",1,"FrostQuest",5667.66,26.80,-6486.09,5966.25,62.97,-6179.38,-6508.56,5000.03,-132.84},
	{1375,1424,"Snow Lurker",2,"FrostQuest",5667.66,26.80,-6486.09,5407.07,69.19,-6880.88},
	{1425,1449,"Sea Soldier",1,"ForgottenQuest",-3054.44,235.54,-10142.82,-3028.22,64.67,-9775.43},
	{1450,1e9,"Water Fighter",2,"ForgottenQuest",-3054,240,-10146,-3291,252,-10501},
}
local Q3 = {
	{1500,1524,"Pirate Millionaire",1,"PiratePortQuest",-290.07,42.90,5581.59,-245.996,47.31,5584.10},
	{1525,1574,"Pistol Billionaire",2,"PiratePortQuest",-290.07,42.90,5581.59,-187.33,86.24,6013.51},
	{1575,1599,"Dragon Crew Warrior",1,"DragonCrewQuest",6738.96,127.82,-713.51,6920.71,56.16,-942.50},
	{1600,1624,"Dragon Crew Archer",2,"DragonCrewQuest",6738.96,127.82,-713.51,6817.91,484.80,513.41},
	{1625,1649,"Hydra Enforcer",1,"VenomCrewQuest",5213.87,1004.50,758.69,4584.69,1002.64,705.80},
	{1650,1699,"Venomous Assailant",2,"VenomCrewQuest",5213.87,1004.50,758.69,4638.79,1078.94,881.80},
	{1700,1724,"Marine Commodore",1,"MarineTreeIsland",2180.54,27.82,-6741.55,2286.01,73.13,-7159.81},
	{1725,1774,"Marine Rear Admiral",2,"MarineTreeIsland",2179.99,28.73,-6740.06,3656.77,160.52,-7001.60},
	{1775,1799,"Fishman Raider",1,"DeepForestIsland3",-10581.66,330.87,-8761.19,-10407.53,331.76,-8368.52},
	{1800,1824,"Fishman Captain",2,"DeepForestIsland3",-10581.66,330.87,-8761.19,-10994.70,352.38,-9002.11},
	{1825,1849,"Forest Pirate",1,"DeepForestIsland",-13234.04,331.49,-7625.40,-13274.48,332.38,-7769.58},
	{1850,1899,"Mythological Pirate",2,"DeepForestIsland",-13234.04,331.49,-7625.40,-13680.61,501.08,-6991.19},
	{1900,1924,"Jungle Pirate",1,"DeepForestIsland2",-12680.38,389.97,-9902.02,-12256.16,331.74,-10485.84},
	{1925,1974,"Musketeer Pirate",2,"DeepForestIsland2",-12680.38,389.97,-9902.02,-13457.90,391.55,-9859.18},
	{1975,1999,"Reborn Skeleton",1,"HauntedQuest1",-9479.22,141.22,5566.09,-8763.72,165.72,6159.86},
	{2000,2024,"Living Zombie",2,"HauntedQuest1",-9479.22,141.22,5566.09,-10144.13,138.63,5838.09},
	{2025,2049,"Demonic Soul",1,"HauntedQuest2",-9516.99,172.02,6078.47,-9505.87,172.10,6158.99},
	{2050,2074,"Posessed Mummy",2,"HauntedQuest2",-9516.99,172.02,6078.47,-9582.02,6.25,6205.48},
	{2075,2099,"Peanut Scout",1,"NutsIslandQuest",-2104.39,38.10,-10194.22,-2143.24,47.72,-10029.995},
	{2100,2124,"Peanut President",2,"NutsIslandQuest",-2104.39,38.10,-10194.22,-1859.35,38.10,-10422.43},
	{2125,2149,"Ice Cream Chef",1,"IceCreamIslandQuest",-820.65,65.82,-10965.80,-872.25,65.82,-10919.96},
	{2150,2199,"Ice Cream Commander",2,"IceCreamIslandQuest",-820.65,65.82,-10965.80,-558.06,112.05,-11290.77},
	{2200,2224,"Cookie Crafter",1,"CakeQuest1",-2021.32,37.80,-12028.73,-2374.14,37.80,-12125.31},
	{2225,2249,"Cake Guard",2,"CakeQuest1",-2021.32,37.80,-12028.73,-1598.31,43.77,-12244.58},
	{2250,2274,"Baking Staff",1,"CakeQuest2",-1927.92,37.80,-12842.54,-1887.81,77.62,-12998.35},
	{2275,2299,"Head Baker",2,"CakeQuest2",-1927.92,37.80,-12842.54,-2216.19,82.88,-12869.29},
	{2300,2324,"Cocoa Warrior",1,"ChocQuest1",233.23,29.88,-12201.23,-21.55,80.57,-12352.39},
	{2325,2349,"Chocolate Bar Battler",2,"ChocQuest1",233.23,29.88,-12201.23,582.59,77.19,-12463.16},
	{2350,2374,"Sweet Thief",1,"ChocQuest2",150.51,30.69,-12774.50,165.19,76.06,-12600.84},
	{2375,2399,"Candy Rebel",2,"ChocQuest2",150.51,30.69,-12774.50,134.87,77.25,-12876.55},
	{2400,2424,"Candy Pirate",1,"CandyQuest1",-1150.04,20.38,-14446.33,-1310.50,26.02,-14562.40},
	{2425,2449,"Snow Demon",2,"CandyQuest1",-1150.04,20.38,-14446.33,-880.20,71.25,-14538.61},
	{2450,2474,"Isle Outlaw",1,"TikiQuest1",-16547.75,61.14,-173.41,-16442.81,116.14,-264.46},
	{2475,2524,"Island Boy",2,"TikiQuest1",-16547.75,61.14,-173.41,-16901.26,84.07,-192.89},
	{2525,2550,"Isle Champion",2,"TikiQuest2",-16539.08,55.69,1051.57,-16641.68,235.78,1031.28},
	{2551,2574,"Serpent Hunter",1,"TikiQuest3",-16665.19,104.60,1579.69,-16521.06,106.09,1488.78},
	{2575,1e9,"Skull Slayer",2,"TikiQuest3",-16665.19,104.60,1579.69,-16855.04,122.46,1478.15},
}

local function myLevel()
	local d = LocalPlayer:FindFirstChild("Data")
	local l = d and d:FindFirstChild("Level")
	return l and l.Value or 1
end

-- CheckQuest: kembalikan data quest sesuai level & world
local function CheckQuest()
	local lv = myLevel()
	local tbl = World1 and Q1 or (World2 and Q2 or (World3 and Q3 or nil))
	if not tbl then return nil end
	for _, r in ipairs(tbl) do
		if lv >= r[1] and lv <= r[2] then
			return {
				Mon = r[3], NameMon = r[3], LevelQuest = r[4], NameQuest = r[5],
				CFrameQuest = CFrame.new(r[6], r[7], r[8]), CFrameMon = CFrame.new(r[9], r[10], r[11]),
				Entrance = r[12] and Vector3.new(r[12], r[13], r[14]) or nil,
			}
		end
	end
	return nil
end

-- ================= STATE =================
local S = { alive = true, busy = false, noclip = false, floatOn = false }
local settings = {
	-- farming
	farmLevel = false, farmNearest = false, farmBone = false, farmSkyWings = false, farmKatakuri = false,
	farmDough = false, farmRipIndra = false,
	chest = false, fruitEsp = false, fruitForce = false,
	raid = false, buyChip = false, startRaid = false, instantRaid = false, chip = "Flame",
	beltQuest = false, getTalon = false, amber = false,
	elite = false, eliteQuest = false,
	sail = false, danger = "1", stopOn = {},
	leviathan = false, shootHeart = false, sailTiki = false,
	killSharkBoss = false, giftShark = false, buyShark = false,
	-- setting
	tween = 150, fast = false, autoattack = false, autoquest = true, autotap = false,
	weapon = "Melee", height = 18,
	-- trials / race
	myDoor = false, killTrial = false, buyTrials = false, safeZone = false, toClock = false,
	autoV4 = false, autoV3 = false, upV2 = false, v3Quest = false,
	-- event / rolls / trade
	pumpkins = false, tricks = false, spookySpin = false,
	rollFruit = false, skipGacha = false, autoStore = false, tradeChair = false,
}
local styles = {
	{ "darkstep", "Auto Dark Step", { { "BuyBlackLeg" } }, "Black Leg" },
	{ "electric", "Auto Electric", { { "BuyElectro" } }, "Electro" },
	{ "waterkf", "Auto Water Kun Fu", { { "BuyFishmanKarate" } }, "Fishman Karate" },
	{ "dragonbreath", "Auto Dragon Breath", { { "BlackbeardReward", "DragonClaw", "1" }, { "BlackbeardReward", "DragonClaw", "2" } }, "Dragon Claw" },
	{ "deathstep", "Auto Death Step", { { "BuyDeathStep" } }, "Death Step" },
	{ "sharkkarate", "Auto Shark Man Karate", { { "BuySharkmanKarate" } }, "Sharkman Karate" },
	{ "electriclaw", "Auto Electric Law", { { "BuyElectricClaw" } }, "Electric Claw" },
	{ "superhuman", "Auto Super Human", { { "BuySuperhuman" } }, "Superhuman" },
	{ "dragontalon", "Auto Dragon Talon", { { "BuyDragonTalon" } }, "Dragon Talon" },
	{ "godhuman", "Auto God Human", { { "BuyGodhuman" } }, "Godhuman" },
}
for _, st in ipairs(styles) do settings[st[1]] = false end

local premium = false
local statusLines = "Siap"
local conns, floatPart, espObjs = {}, nil, {}
local homePara, statusPara

local Remotes = ReplicatedStorage:WaitForChild("Remotes", 15)
local CommF = Remotes and Remotes:WaitForChild("CommF_", 15)
local CommE = Remotes and Remotes:FindFirstChild("CommE")
local function inv(...)
	if not CommF then return nil end
	local ok, res = pcall(CommF.InvokeServer, CommF, ...)
	return ok and res or nil
end

-- ================= UTIL =================
local function any(s, words)
	s = tostring(s):lower()
	for _, w in ipairs(words) do if s:find(tostring(w):lower(), 1, true) then return true end end
	return false
end
local function randName(n)
	local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	local t = table.create(n)
	for i = 1, n do local k = math.random(1, #chars) t[i] = chars:sub(k, k) end
	return table.concat(t)
end
local function hrp() local c = LocalPlayer.Character return c and c:FindFirstChild("HumanoidRootPart") end
local function hum() local c = LocalPlayer.Character return c and c:FindFirstChildOfClass("Humanoid") end
local function notify(title, content)
	pcall(function() WindUI:Notify({ Title = title, Content = content, Duration = 4 }) end)
end
local function setStatus(t)
	statusLines = tostring(t)
	if statusPara then pcall(function() statusPara:SetDesc(statusLines) end) end
end

table.insert(conns, RunService.Heartbeat:Connect(function()
	local h = hrp()
	if S.floatOn and h then
		if not floatPart or not floatPart.Parent then
			floatPart = Instance.new("Part")
			floatPart.Name = randName(8)
			floatPart.Size = Vector3.new(14, 1, 14)
			floatPart.Anchored = true
			floatPart.CanCollide = true
			floatPart.Transparency = 1
			floatPart.CanQuery = false
			floatPart.CanTouch = false
			floatPart.Parent = Workspace
		end
		floatPart.CFrame = CFrame.new(h.Position - Vector3.new(0, 3.5, 0))
	elseif floatPart then
		floatPart:Destroy()
		floatPart = nil
	end
end))
table.insert(conns, RunService.Stepped:Connect(function()
	if not S.noclip then return end
	local c = LocalPlayer.Character
	if not c then return end
	for _, p in ipairs(c:GetDescendants()) do
		if p:IsA("BasePart") then p.CanCollide = false end
	end
end))

-- ================= GERAK: Tween smooth (animasi tetap jalan) =================
local function tweenTo(pos, cond, stop)
	local h = hrp()
	if not h then return false end
	local dist = (pos - h.Position).Magnitude
	if dist <= (stop or 3) then return true end
	S.floatOn, S.noclip = true, true
	pcall(function() LocalPlayer:RequestStreamAroundAsync(pos) end)
	local tw = TweenService:Create(h, TweenInfo.new(dist / math.max(settings.tween, 1), Enum.EasingStyle.Linear), { CFrame = CFrame.new(pos) })
	tw:Play()
	local t0 = os.clock()
	while tw.PlaybackState == Enum.PlaybackState.Playing and os.clock() - t0 < 120 do
		if not cond() then tw:Cancel() break end
		h = hrp()
		if h then h.AssemblyLinearVelocity = Vector3.zero end
		task.wait()
	end
	S.noclip = false
	h = hrp()
	return h ~= nil and (h.Position - pos).Magnitude <= (stop or 3) + 4
end

local function goTo(pos, cond, entrance, stop)
	local h = hrp()
	if not h then return false end
	if entrance and (pos - h.Position).Magnitude > 10000 then
		inv("requestEntrance", entrance)
		task.wait(1.5)
	end
	return tweenTo(pos, cond, stop)
end

-- ================= SERANG =================
local function getWeapon()
	local c, hm = LocalPlayer.Character, hum()
	if not c or not hm then return nil end
	for _, t in ipairs(c:GetChildren()) do
		if t:IsA("Tool") and t.ToolTip == settings.weapon then return t end
	end
	local bp = LocalPlayer:FindFirstChild("Backpack")
	if bp then
		for _, t in ipairs(bp:GetChildren()) do
			if t:IsA("Tool") and t.ToolTip == settings.weapon then
				pcall(function() hm:EquipTool(t) end)
				task.wait(0.1)
				return t
			end
		end
	end
	for _, t in ipairs(c:GetChildren()) do if t:IsA("Tool") then return t end end
	return nil
end
local lastHit = 0
local function attackTick()
	local gap = settings.fast and 0.02 or 0.12
	if os.clock() - lastHit < gap then return end
	lastHit = os.clock()
	local tool = getWeapon()
	local n = settings.fast and 3 or 1
	for _ = 1, n do
		if tool then pcall(function() tool:Activate() end) end
		pcall(function() VirtualUser:CaptureController() VirtualUser:ClickButton1(Vector2.new(900, 500)) end)
	end
end

-- ================= MUSUH =================
local function enemyFolder() return Workspace:FindFirstChild("Enemies") end
local function isAlive(m)
	local hm = m and m:FindFirstChildOfClass("Humanoid")
	return hm and hm.Health > 0 and m:FindFirstChild("HumanoidRootPart") and true or false
end
local function nearestEnemy(filter)
	local f, h = enemyFolder(), hrp()
	if not f or not h then return nil end
	local best, bd
	for _, m in ipairs(f:GetChildren()) do
		if isAlive(m) and (not filter or filter(m)) then
			local d = (m.HumanoidRootPart.Position - h.Position).Magnitude
			if not bd or d < bd then best, bd = m, d end
		end
	end
	return best
end
local function byNames(names)
	return function(m) return any(m.Name, names) end
end

local function fight(mob, cond)
	local mr = mob:FindFirstChild("HumanoidRootPart")
	if not mr then return end
	local h = hrp()
	if h and (mr.Position - h.Position).Magnitude > 80 then
		tweenTo(mr.Position + Vector3.new(0, settings.height, 0), cond, 6)
	end
	S.floatOn, S.noclip = true, true
	while cond() and isAlive(mob) and mob.Parent do
		h = hrp()
		mr = mob:FindFirstChild("HumanoidRootPart")
		if not h or not mr then break end
		local pos = mr.Position + Vector3.new(0, settings.height, 0)
		h.CFrame = CFrame.lookAt(pos, mr.Position)
		h.AssemblyLinearVelocity = Vector3.zero
		attackTick()
		RunService.Heartbeat:Wait()
	end
	S.floatOn, S.noclip = false, false
end

local function exclusive(fn)
	if S.busy then return false end
	S.busy = true
	local ok, err = pcall(fn)
	S.floatOn, S.noclip, S.busy = false, false, false
	if not ok then warn("[Senar Hub] " .. tostring(err)) end
	return true
end
local function loop(flagFn, fn, delay)
	task.spawn(function()
		while S.alive do
			if flagFn() then exclusive(fn) end
			task.wait(delay or 0.2)
		end
	end)
end

-- ================= QUEST + FARMING LEVEL =================
local function questActive()
	local ok, vis = pcall(function() return LocalPlayer.PlayerGui.Main.Quest.Visible end)
	return ok and vis
end

local function farmLevelStep(cond)
	local q = CheckQuest()
	if not q then setStatus("quest tidak ditemukan untuk world ini") task.wait(1) return end
	if settings.autoquest and not questActive() then
		setStatus("ambil quest " .. q.NameQuest)
		goTo(q.CFrameQuest.Position, cond, q.Entrance, 8)
		inv("StartQuest", q.NameQuest, q.LevelQuest)
		task.wait(0.4)
	end
	local mob = nearestEnemy(function(m) return m.Name == q.NameMon or m.Name:find(q.NameMon, 1, true) end)
	if mob then
		setStatus("farming " .. q.NameMon)
		fight(mob, cond)
	else
		-- tunggu spawn: naik 300 studs, farming lagi kalau mob muncul
		setStatus("menunggu " .. q.NameMon .. " spawn")
		goTo(q.CFrameMon.Position + Vector3.new(0, 300, 0), cond, q.Entrance, 10)
		local t0 = os.clock()
		while cond() and os.clock() - t0 < 8 do
			if nearestEnemy(function(m) return m.Name == q.NameMon or m.Name:find(q.NameMon, 1, true) end) then break end
			local h = hrp()
			if h then h.AssemblyLinearVelocity = Vector3.zero end
			task.wait(0.3)
		end
		if cond() then goTo(q.CFrameMon.Position + Vector3.new(0, 12, 0), cond, q.Entrance, 10) end
	end
end

loop(function() return settings.farmLevel end, function()
	farmLevelStep(function() return S.alive and settings.farmLevel end)
end)

loop(function() return settings.farmNearest end, function()
	local cond = function() return S.alive and settings.farmNearest end
	local mob = nearestEnemy()
	if mob then setStatus("farming terdekat: " .. mob.Name) fight(mob, cond) else setStatus("tidak ada musuh dekat") task.wait(1) end
end)

local function bossLoop(flag, names, label)
	loop(function() return settings[flag] end, function()
		local cond = function() return S.alive and settings[flag] end
		local mob = nearestEnemy(byNames(names))
		if mob then setStatus("farming " .. label) fight(mob, cond)
		else setStatus(label .. " belum spawn") task.wait(1.5) end
	end)
end
bossLoop("farmBone", CFG.BOSS_BONE, "Bone")
bossLoop("farmSkyWings", CFG.BOSS_SKYWINGS, "Sky Wings")
bossLoop("farmKatakuri", CFG.BOSS_KATAKURI, "Katakuri")
bossLoop("farmDough", CFG.BOSS_DOUGH, "Dough King")
bossLoop("farmRipIndra", CFG.BOSS_RIPINDRA, "Rip Indra")

-- ================= CHEST =================
loop(function() return settings.chest end, function()
	local cond = function() return S.alive and settings.chest end
	local h = hrp()
	if not h then return end
	local best, bd
	for _, c in ipairs(CollectionService:GetTagged("_ChestTagged")) do
		if c:IsA("BasePart") and c.Parent then
			local d = (c.Position - h.Position).Magnitude
			if not bd or d < bd then best, bd = c, d end
		end
	end
	if best then
		setStatus("chest: " .. math.floor(bd) .. " stud")
		tweenTo(best.Position, cond, 2)
		pcall(function()
			local hh = hrp()
			if hh and firetouchinterest then firetouchinterest(hh, best, 0) firetouchinterest(hh, best, 1) end
		end)
		task.wait(0.3)
	else
		setStatus("tidak ada chest")
		task.wait(1.5)
	end
end)

-- ================= FRUITS =================
local function fruitList()
	local out = {}
	for _, d in ipairs(Workspace:GetChildren()) do
		if (d:IsA("Tool") or d:IsA("Model")) and d.Name:find("Fruit") then
			local part = d:FindFirstChild("Handle") or d:FindFirstChildWhichIsA("BasePart", true)
			if part then out[#out + 1] = { obj = d, part = part } end
		end
	end
	return out
end
local espFolder = Instance.new("Folder")
espFolder.Name = randName(10)
pcall(function() espFolder.Parent = (gethui and gethui()) or game:GetService("CoreGui") end)
if not espFolder.Parent then espFolder.Parent = LocalPlayer:WaitForChild("PlayerGui") end

task.spawn(function()
	while S.alive do
		if settings.fruitEsp then
			local h = hrp()
			local seen = {}
			for _, f in ipairs(fruitList()) do
				seen[f.obj] = true
				local o = espObjs[f.obj]
				if not o then
					local bb = Instance.new("BillboardGui")
					bb.Adornee = f.part
					bb.Size = UDim2.fromOffset(160, 30)
					bb.StudsOffset = Vector3.new(0, 3, 0)
					bb.AlwaysOnTop = true
					bb.Parent = espFolder
					local l = Instance.new("TextLabel")
					l.Size = UDim2.fromScale(1, 1)
					l.BackgroundTransparency = 1
					l.TextColor3 = Color3.fromRGB(255, 200, 80)
					l.TextStrokeTransparency = 0
					l.Font = Enum.Font.GothamBold
					l.TextSize = 13
					l.Parent = bb
					o = { gui = bb, lbl = l }
					espObjs[f.obj] = o
				end
				o.lbl.Text = string.format("%s [%dm]", f.obj.Name, h and math.floor((f.part.Position - h.Position).Magnitude) or 0)
			end
			for k, o in pairs(espObjs) do
				if not seen[k] then pcall(function() o.gui:Destroy() end) espObjs[k] = nil end
			end
		elseif next(espObjs) then
			for k, o in pairs(espObjs) do pcall(function() o.gui:Destroy() end) espObjs[k] = nil end
		end
		task.wait(1)
	end
end)

loop(function() return settings.fruitForce end, function()
	local cond = function() return S.alive and settings.fruitForce end
	local h = hrp()
	local best, bd
	for _, f in ipairs(fruitList()) do
		local d = h and (f.part.Position - h.Position).Magnitude or math.huge
		if not bd or d < bd then best, bd = f, d end
	end
	if best then
		setStatus("menuju " .. best.obj.Name)
		tweenTo(best.part.Position, cond, 2)
		task.wait(0.3)
	else
		setStatus("tidak ada fruit")
		task.wait(2)
	end
end)

-- ================= RAID =================
local function raidActive()
	local ok, vis = pcall(function() return LocalPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible end)
	return ok and vis
end
local function raidIslands()
	local out = {}
	local loc = Workspace:FindFirstChild("_WorldOrigin") and Workspace._WorldOrigin:FindFirstChild("Locations")
	if loc then
		for i = 5, 1, -1 do
			local isl = loc:FindFirstChild("Island " .. i)
			if isl then out[#out + 1] = isl.Position end
		end
	end
	return out
end

task.spawn(function()
	while S.alive do
		if settings.buyChip and not raidActive() then
			inv("RaidsNpc", "Select", settings.chip)
		end
		if settings.startRaid and not raidActive() then
			pcall(function()
				local cd
				if World2 then cd = Workspace.Map.CircleIsland.RaidSummon.Button.Main.ClickDetector
				elseif World3 then cd = Workspace.Map["Boat Castle"].RaidSummon2.Button.Main.ClickDetector end
				if cd and fireclickdetector then fireclickdetector(cd) end
			end)
		end
		task.wait(3)
	end
end)

loop(function() return settings.raid or (settings.instantRaid and premium) end, function()
	local cond = function() return S.alive and (settings.raid or (settings.instantRaid and premium)) end
	if not raidActive() then setStatus("raid belum aktif") task.wait(1.5) return end
	local mob = nearestEnemy()
	if mob then
		if settings.instantRaid and premium then
			-- Instant Kill Raid (premium): hajar tiap musuh dengan burst serangan
			local mr = mob:FindFirstChild("HumanoidRootPart")
			local h = hrp()
			if mr and h then
				S.floatOn, S.noclip = true, true
				for _ = 1, 25 do
					if not isAlive(mob) or not cond() then break end
					h.CFrame = CFrame.lookAt(mr.Position + Vector3.new(0, 10, 0), mr.Position)
					attackTick()
					attackTick()
					task.wait(0.02)
				end
			end
		else
			fight(mob, cond)
		end
	else
		local islands = raidIslands()
		if #islands > 0 then
			setStatus("pindah pulau raid")
			tweenTo(islands[1] + Vector3.new(0, 25, 0), cond, 10)
		end
		task.wait(0.5)
	end
end)

-- ================= DOJO DRAGON =================
local function hasTool(name)
	local c, bp = LocalPlayer.Character, LocalPlayer:FindFirstChild("Backpack")
	for _, root in ipairs({ c, bp }) do
		if root then
			for _, t in ipairs(root:GetChildren()) do
				if t:IsA("Tool") and t.Name == name then return true end
			end
		end
	end
	return false
end
local function dataVal(name)
	local d = LocalPlayer:FindFirstChild("Data")
	local v = d and d:FindFirstChild(name)
	return v and v.Value or 0
end

task.spawn(function()
	while S.alive do
		if settings.beltQuest then
			local npc
			for _, d in ipairs(Workspace:GetDescendants()) do
				if d:IsA("Model") and any(d.Name, { "Dojo Trainer", "Dojo" }) and d:FindFirstChild("HumanoidRootPart") then npc = d break end
			end
			if npc then
				exclusive(function()
					tweenTo(npc.HumanoidRootPart.Position + Vector3.new(0, 3, 4), function() return settings.beltQuest end, 6)
					inv("DojoQuest") -- tebakan; kalau gagal, interaksi manual
					for _, d in ipairs(npc:GetDescendants()) do
						if d:IsA("ProximityPrompt") and fireproximityprompt then pcall(fireproximityprompt, d) end
					end
				end)
				setStatus("quest belt: NPC dojo ditemukan")
			else
				setStatus("quest belt: NPC dojo tidak ketemu")
			end
		end
		if settings.getTalon and not hasTool("Dragon Talon") then
			if dataVal("Beli") >= 5000000 and dataVal("Fragments") >= 5000 then
				inv("BuyDragonTalon")
			else
				setStatus("Dragon Talon butuh 5M Beli & 5.000 Fragments")
			end
		end
		if settings.amber then
			local h = hrp()
			local best, bd
			for _, d in ipairs(Workspace:GetDescendants()) do
				if d:IsA("BasePart") and any(d.Name, { "Amber", "Ember" }) then
					local dist = h and (d.Position - h.Position).Magnitude or math.huge
					if not bd or dist < bd then best, bd = d, dist end
				end
			end
			if best then
				exclusive(function()
					tweenTo(best.Position, function() return settings.amber end, 3)
					pcall(function()
						local hh = hrp()
						if hh and firetouchinterest then firetouchinterest(hh, best, 0) firetouchinterest(hh, best, 1) end
					end)
				end)
			end
		end
		task.wait(3)
	end
end)

-- ================= ELITE HUNTER =================
task.spawn(function()
	while S.alive do
		if settings.eliteQuest then inv("EliteHunter") end
		task.wait(5)
	end
end)
loop(function() return settings.elite end, function()
	local cond = function() return S.alive and settings.elite end
	local mob = nearestEnemy(byNames(CFG.ELITE))
	if mob then setStatus("elite: " .. mob.Name) fight(mob, cond)
	else setStatus("elite hunter belum spawn") task.wait(2) end
end)

-- ================= SHIP / LEVIATHAN =================
local function myBoat()
	local boats = Workspace:FindFirstChild("Boats")
	if not boats then return nil end
	for _, b in ipairs(boats:GetChildren()) do
		local o = b:FindFirstChild("Owner")
		if o and (o.Value == LocalPlayer or tostring(o.Value) == LocalPlayer.Name) then return b end
	end
	return nil
end
local function seaCreature(namePart)
	for _, folderName in ipairs({ "SeaBeasts", "Enemies" }) do
		local f = Workspace:FindFirstChild(folderName)
		if f then
			for _, m in ipairs(f:GetChildren()) do
				if m.Name:lower():find(namePart:lower(), 1, true) then return m end
			end
		end
	end
	return nil
end
local function dangerLevelNow()
	local pg = LocalPlayer:FindFirstChild("PlayerGui")
	if not pg then return nil end
	for _, d in ipairs(pg:GetDescendants()) do
		if d:IsA("TextLabel") and d.Visible and d.Text:lower():find("danger", 1, true) then
			local n = tonumber(d.Text:match("(%d+)"))
			if n then return n end
		end
	end
	return nil
end
local function sailTo(target, cond, speed)
	local boat = myBoat()
	if not boat then setStatus("kapal tidak ditemukan") return false end
	local seat = boat:FindFirstChildWhichIsA("VehicleSeat", true)
	local hm = hum()
	if seat and hm and not hm.SeatPart then pcall(function() seat:Sit(hm) end) end
	while cond() do
		local pivot = boat:GetPivot()
		local d = target - pivot.Position
		d = Vector3.new(d.X, 0, d.Z)
		if d.Magnitude < 25 then return true end
		local dt = RunService.Heartbeat:Wait()
		boat:PivotTo(CFrame.lookAt(pivot.Position + d.Unit * math.min(d.Magnitude, speed * dt), pivot.Position + d.Unit * 100))
	end
	return false
end

task.spawn(function()
	while S.alive do
		if settings.sail then
			exclusive(function()
				local boat = myBoat()
				if not boat then setStatus("sail: buat kapal dulu") task.wait(2) return end
				local wantInf = settings.danger == "inf"
				local want = tonumber(settings.danger) or 1
				local cond = function() return S.alive and settings.sail end
				local seen
				for label, key in pairs(CFG.SEA_CREATURES) do
					if settings.stopOn[label] and seaCreature(key) then seen = label end
				end
				if seen then setStatus("berhenti: " .. seen .. " terdeteksi") task.wait(1) return end
				local lv = dangerLevelNow()
				if lv and not wantInf and lv >= want then setStatus("danger " .. lv .. " tercapai") task.wait(1) return end
				local pivot = boat:GetPivot()
				-- maju lurus ke arah hadap kapal selama 1 detik, cek kondisi lagi
				local ahead = pivot.Position + pivot.LookVector * CFG.BOAT_SPEED
				setStatus("sail danger " .. tostring(settings.danger) .. (lv and (" (sekarang " .. lv .. ")") or ""))
				sailTo(ahead, cond, CFG.BOAT_SPEED)
			end)
		end
		task.wait(0.1)
	end
end)

loop(function() return settings.leviathan or settings.shootHeart end, function()
	local cond = function() return S.alive and (settings.leviathan or settings.shootHeart) end
	local lev = seaCreature("Leviathan")
	if not lev then setStatus("leviathan belum ada") task.wait(2) return end
	local part
	if settings.shootHeart then
		for _, d in ipairs(lev:GetDescendants()) do
			if d:IsA("BasePart") and d.Name:lower():find("heart", 1, true) then part = d break end
		end
	end
	part = part or lev:FindFirstChild("HumanoidRootPart") or lev:FindFirstChildWhichIsA("BasePart", true)
	if part then
		setStatus(settings.shootHeart and "tembak heart leviathan" or "serang leviathan")
		S.floatOn, S.noclip = true, true
		local t0 = os.clock()
		while cond() and lev.Parent and os.clock() - t0 < 30 do
			local h = hrp()
			if not h then break end
			h.CFrame = CFrame.lookAt(part.Position + Vector3.new(0, 60, 0), part.Position)
			h.AssemblyLinearVelocity = Vector3.zero
			attackTick()
			RunService.Heartbeat:Wait()
		end
	end
end)

task.spawn(function()
	while S.alive do
		if settings.sailTiki then
			exclusive(function()
				setStatus("sail ke Tiki Outpost")
				local reached = sailTo(CFG.TIKI_OUTPOST, function() return S.alive and settings.sailTiki end, CFG.BOAT_SPEED)
				if reached then settings.sailTiki = false setStatus("sampai di Tiki Outpost") end
			end)
		end
		task.wait(0.5)
	end
end)

-- ================= COMBAT: BELI FIGHTING STYLE =================
task.spawn(function()
	while S.alive do
		for _, st in ipairs(styles) do
			if settings[st[1]] and not hasTool(st[4]) then
				for _, args in ipairs(st[3]) do inv(table.unpack(args)) end
				setStatus("coba beli " .. st[4])
				task.wait(1)
			end
		end
		task.wait(5)
	end
end)

-- ================= SHARKMAN KARATE =================
loop(function() return settings.killSharkBoss end, function()
	local cond = function() return S.alive and settings.killSharkBoss end
	local mob = nearestEnemy(byNames({ "Tide Keeper" }))
	if mob then setStatus("kill Tide Keeper") fight(mob, cond)
	else setStatus("Tide Keeper belum spawn") task.wait(2) end
end)
task.spawn(function()
	while S.alive do
		if settings.giftShark then inv("BuySharkmanKarate", true) end
		if settings.buyShark and not hasTool("Sharkman Karate") then inv("BuySharkmanKarate") end
		task.wait(5)
	end
end)

-- ================= SETTING LOOPS =================
task.spawn(function()
	while S.alive do
		if settings.autoattack then
			local f, h = enemyFolder(), hrp()
			if f and h then
				for _, m in ipairs(f:GetChildren()) do
					if isAlive(m) and (m.HumanoidRootPart.Position - h.Position).Magnitude < 60 then attackTick() break end
				end
			end
		end
		if settings.autotap then
			pcall(function() VirtualUser:CaptureController() VirtualUser:ClickButton1(Vector2.new(900, 500)) end)
		end
		task.wait(settings.fast and 0.02 or 0.1)
	end
end)

-- ================= TRIALS / RACE =================
task.spawn(function()
	while S.alive do
		if settings.buyTrials then inv("UpgradeRace", "Buy") end
		if settings.myDoor then
			local race = tostring(dataVal("Race"))
			local data = LocalPlayer:FindFirstChild("Data")
			race = data and data:FindFirstChild("Race") and data.Race.Value or race
			local door
			for _, d in ipairs(Workspace:GetDescendants()) do
				if d:IsA("BasePart") and d.Name:lower():find("door", 1, true) and d:IsDescendantOf(Workspace)
					and (d.Parent.Name:lower():find(tostring(race):lower(), 1, true) or d.Name:lower():find(tostring(race):lower(), 1, true)) then
					door = d break
				end
			end
			if door then
				exclusive(function() tweenTo(door.Position + Vector3.new(0, 3, 0), function() return settings.myDoor end, 4) end)
				setStatus("di pintu race " .. tostring(race))
			else
				setStatus("pintu race tidak ketemu")
			end
		end
		if settings.toClock then
			local clock
			for _, d in ipairs(Workspace:GetDescendants()) do
				if d:IsA("BasePart") and d.Name:lower():find("clock", 1, true) then clock = d break end
			end
			if clock then exclusive(function() tweenTo(clock.Position + Vector3.new(0, 5, 0), function() return settings.toClock end, 5) end) end
		end
		task.wait(2)
	end
end)

local safePos
loop(function() return settings.killTrial end, function()
	local cond = function() return S.alive and settings.killTrial end
	local h = hrp()
	local best, bd
	for _, pl in ipairs(Players:GetPlayers()) do
		if pl ~= LocalPlayer and pl.Character and isAlive(pl.Character) and h then
			local d = (pl.Character.HumanoidRootPart.Position - h.Position).Magnitude
			if d < 500 and (not bd or d < bd) then best, bd = pl.Character, d end
		end
	end
	if best then setStatus("trial: serang " .. best.Name) fight(best, cond)
	else setStatus("trial: tidak ada target") task.wait(1) end
end)
task.spawn(function()
	while S.alive do
		if settings.safeZone and safePos then
			exclusive(function() tweenTo(safePos, function() return settings.safeZone end, 4) end)
		end
		task.wait(1)
	end
end)

local function pressKey(key)
	pcall(function()
		VirtualInputManager:SendKeyEvent(true, key, false, game)
		task.wait(0.05)
		VirtualInputManager:SendKeyEvent(false, key, false, game)
	end)
end
task.spawn(function()
	while S.alive do
		if settings.autoV4 then
			if CommE then pcall(function() CommE:FireServer("ActivateAbility") end) end
			pressKey(Enum.KeyCode.Y)
		end
		if settings.autoV3 then pressKey(Enum.KeyCode.T) end
		task.wait(3)
	end
end)

task.spawn(function()
	while S.alive do
		if settings.upV2 then
			inv("Alchemist", "1")
			for _, name in ipairs({ "Flower1", "Flower2", "Flower3" }) do
				local fl = Workspace:FindFirstChild(name, true)
				if fl and fl:IsA("BasePart") then
					exclusive(function()
						tweenTo(fl.Position + Vector3.new(0, 3, 0), function() return settings.upV2 end, 3)
						pcall(function()
							local h = hrp()
							if h and firetouchinterest then firetouchinterest(h, fl, 0) firetouchinterest(h, fl, 1) end
						end)
					end)
				end
			end
			inv("Alchemist", "3")
		end
		if settings.v3Quest then
			inv("Wenlocktoad", "1")
			inv("Wenlocktoad", "2")
			inv("Wenlocktoad", "3")
		end
		task.wait(4)
	end
end)

-- ================= HALLOWEEN / ROLLS / TRADE =================
local function collectNamed(words, flag)
	local h = hrp()
	local best, bd
	for _, d in ipairs(Workspace:GetDescendants()) do
		if d:IsA("BasePart") and any(d.Name, words) then
			local dist = h and (d.Position - h.Position).Magnitude or math.huge
			if not bd or dist < bd then best, bd = d, dist end
		end
	end
	if best then
		exclusive(function()
			tweenTo(best.Position + Vector3.new(0, 2, 0), function() return settings[flag] end, 3)
			pcall(function()
				local hh = hrp()
				if hh and firetouchinterest then firetouchinterest(hh, best, 0) firetouchinterest(hh, best, 1) end
			end)
		end)
		return true
	end
	return false
end

task.spawn(function()
	while S.alive do
		if settings.pumpkins then
			if not collectNamed({ "Pumpkin" }, "pumpkins") then setStatus("tidak ada pumpkin") end
		end
		if settings.tricks then
			for _, d in ipairs(Workspace:GetDescendants()) do
				if d:IsA("ProximityPrompt") and any(d.ObjectText .. d.ActionText, { "trick", "treat" }) and fireproximityprompt then
					pcall(fireproximityprompt, d)
				end
			end
		end
		if settings.spookySpin then
			inv("SpookySpin")
			inv("Halloween", "Spin")
		end
		task.wait(2)
	end
end)

task.spawn(function()
	while S.alive do
		if settings.rollFruit then inv("Cousin", "Buy") end
		if settings.skipGacha then
			local pg = LocalPlayer:FindFirstChild("PlayerGui")
			if pg then
				for _, d in ipairs(pg:GetDescendants()) do
					if d:IsA("GuiObject") and d.Visible and d.Name:lower():find("gacha", 1, true) and not d:IsDescendantOf(Workspace) then
						pcall(function() d.Visible = false end)
					end
				end
			end
		end
		if settings.autoStore then
			local bp = LocalPlayer:FindFirstChild("Backpack")
			if bp then
				for _, t in ipairs(bp:GetChildren()) do
					if t:IsA("Tool") and (t:GetAttribute("OriginalName") or t.Name:find("Fruit")) then
						inv("StoreFruit", t:GetAttribute("OriginalName") or t.Name, t)
					end
				end
			end
		end
		task.wait(settings.skipGacha and 0.3 or 3)
	end
end)

task.spawn(function()
	while S.alive do
		if settings.tradeChair then
			local chair
			for _, d in ipairs(Workspace:GetDescendants()) do
				if (d:IsA("Seat") or d:IsA("BasePart")) and d.Name:lower():find("chair", 1, true) then chair = d break end
			end
			if chair then
				exclusive(function() tweenTo(chair.Position + Vector3.new(0, 3, 0), function() return settings.tradeChair end, 3) end)
			else
				setStatus("kursi trade tidak ketemu")
			end
		end
		task.wait(2)
	end
end)

-- ================= KEY PREMIUM =================
local function validateKey(key)
	key = tostring(key or ""):gsub("%s+", "")
	if key == "" then return false end
	for _, k in ipairs(CFG.VALID_KEYS) do if k == key then return true end end
	if CFG.KEY_CHECK_URL then
		local ok, body = pcall(function() return game:HttpGet(CFG.KEY_CHECK_URL .. key) end)
		if ok and body then
			local low = body:lower()
			return low:find("true", 1, true) ~= nil or low:find("valid", 1, true) ~= nil and low:find("invalid", 1, true) == nil
		end
	end
	return false
end
local function applyKey(key, silent)
	if validateKey(key) then
		premium = true
		if writefile then pcall(writefile, CFG.KEY_FILE, key) end
		if not silent then notify("Premium", "Key valid, fitur premium aktif") end
		return true
	end
	if not silent then notify("Premium", "Key tidak valid") end
	return false
end
if readfile and isfile and isfile(CFG.KEY_FILE) then
	pcall(function() applyKey(readfile(CFG.KEY_FILE), true) end)
end

-- ================= STATUS HOME =================
local function raceInfo()
	local d = LocalPlayer:FindFirstChild("Data")
	local r = d and d:FindFirstChild("Race")
	if not r then return "?", "?" end
	local v = r:FindFirstChild("Evolved") and "V2+" or "V1"
	return tostring(r.Value), v
end
local function ripIndraStatus()
	local f = enemyFolder()
	if f then
		for _, m in ipairs(f:GetChildren()) do
			if any(m.Name, CFG.BOSS_RIPINDRA) then return "Spawned" end
		end
	end
	for _, n in ipairs(CFG.BOSS_RIPINDRA) do
		if ReplicatedStorage:FindFirstChild(n) then return "Spawn (ReplicatedStorage)" end
	end
	return "Belum"
end
local function fmt(n)
	n = tonumber(n) or 0
	local s = tostring(math.floor(n))
	return (s:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
end
task.spawn(function()
	while S.alive do
		if homePara then
			local race, ver = raceInfo()
			local transformed = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("RaceTransformed") and "No" or "Yes"
			local txt = string.format("Level: %s\nBelly: %s\nFragments: %s\nRip Indra: %s\nRace: %s\nVersi: %s (cek V3/V4 = perkiraan)\nNormal: %s",
				fmt(myLevel()), fmt(dataVal("Beli")), fmt(dataVal("Fragments")), ripIndraStatus(), race, ver, transformed)
			pcall(function() homePara:SetDesc(txt) end)
		end
		task.wait(2)
	end
end)

-- ================= UI HELPERS =================
local function norm(v)
	if type(v) == "table" then return v.Title or v.Name or v[1] or tostring(v) end
	return v
end
local function add(tab, kind, props)
	if not tab then return nil end
	local ok, res = pcall(function() return tab[kind](tab, props) end)
	if not ok then warn("[Senar Hub] UI " .. kind .. ": " .. tostring(res)) end
	return ok and res or nil
end
local function newTab(title, icon)
	local ok, tab = pcall(function() return Window:Tab({ Title = title, Icon = icon }) end)
	if ok and tab then return tab end
	ok, tab = pcall(function() return Window:Tab({ Title = title, Icon = "folder" }) end)
	return ok and tab or nil
end
local function toggle(tab, title, desc, key, cb)
	return add(tab, "Toggle", {
		Title = title, Desc = desc, Value = settings[key], Default = settings[key],
		Callback = function(v)
			settings[key] = v and true or false
			if cb then cb(settings[key]) end
		end,
	})
end
local function slider(tab, title, desc, key, min, max, default, step)
	return add(tab, "Slider", {
		Title = title, Desc = desc, Step = step or 1,
		Value = { Min = min, Max = max, Default = default },
		Callback = function(v) settings[key] = tonumber(v) or default end,
	})
end
local function copy(text, label)
	if setclipboard then pcall(setclipboard, text) end
	notify(label or "Copy", "Disalin: " .. text)
end

-- ---------- Home ----------
local tHome = newTab("Home", "home")
homePara = add(tHome, "Paragraph", { Title = "Status", Desc = "Memuat..." })
statusPara = add(tHome, "Paragraph", { Title = "Aktivitas", Desc = "Siap" })

-- ---------- Farming ----------
local tFarm = newTab("Farming", "swords")
toggle(tFarm, "Farming Level", "Quest otomatis; saat mob belum spawn naik 300 studs", "farmLevel")
toggle(tFarm, "Farming Nearest", "Serang musuh terdekat", "farmNearest")
toggle(tFarm, "Farming Bone", "Mob Haunted Castle (World 3)", "farmBone")
toggle(tFarm, "Farming Sky Wings Blue", "Nama target tebakan: 'Sky Wings'", "farmSkyWings")
toggle(tFarm, "Farming Katakuri", nil, "farmKatakuri")
toggle(tFarm, "Farming Dough King", nil, "farmDough")
toggle(tFarm, "Farming Rip Indra", nil, "farmRipIndra")

-- ---------- Chest ----------
local tChest = newTab("Chest", "package")
toggle(tChest, "Farming Chest Force", "Tween ke chest terdekat", "chest")

-- ---------- Fruits ----------
local tFruit = newTab("Fruits", "apple")
toggle(tFruit, "Esp Fruit", nil, "fruitEsp")
toggle(tFruit, "Force to Fruit", nil, "fruitForce")

-- ---------- Raid Fruit ----------
local tRaid = newTab("Raid Fruit", "zap")
add(tRaid, "Dropdown", {
	Title = "Pilih Chip", Values = { "Flame", "Ice", "Quake", "Light", "Dark", "Spider", "Rumble", "Magma", "Buddha", "Sand", "Phoenix", "Dough" },
	Value = "Flame", Callback = function(v) settings.chip = norm(v) end,
})
toggle(tRaid, "Auto Raid", nil, "raid")
toggle(tRaid, "Auto Buy Chip Raid", nil, "buyChip")
toggle(tRaid, "Auto Start Raid", nil, "startRaid")
toggle(tRaid, "Instant Kill Raid (premium unlocker)", "Perlu key premium", "instantRaid", function(v)
	if v and not premium then notify("Premium", "Fitur ini perlu key premium (menu Unlock Premium)") end
end)

-- ---------- Dojo Dragon ----------
local tDojo = newTab("Dojo Dragon", "flame")
toggle(tDojo, "Auto Quest Belt", nil, "beltQuest")
toggle(tDojo, "Get Fighting Style Dragon Talon", "Butuh 5M Belly + 5.000 fragments (dilewati jika sudah punya)", "getTalon")
toggle(tDojo, "Auto Farming Api Amber", nil, "amber")

-- ---------- Elite Hunter ----------
local tElite = newTab("Elite Hunter", "target")
toggle(tElite, "Farming Elit Hunter", nil, "elite")
toggle(tElite, "Auto Quest Elit Hunter", nil, "eliteQuest")

-- ---------- Ship ----------
local tShip = newTab("Ship", "ship")
add(tShip, "Dropdown", {
	Title = "Auto Sail To Danger", Values = { "1", "2", "3", "4", "5", "6", "inf" }, Value = "1",
	Callback = function(v) settings.danger = tostring(norm(v)) end,
})
add(tShip, "Dropdown", {
	Title = "Auto Stop When", Multi = true, AllowNone = true,
	Values = { "Sea Beast", "Terror Shark", "Water Rumbling", "Leviathan" }, Value = {},
	Callback = function(v)
		local set = {}
		if type(v) == "table" then
			for k, val in pairs(v) do
				if type(k) == "number" then set[tostring(norm(val))] = true
				elseif val then set[tostring(k)] = true end
			end
		elseif v then set[tostring(v)] = true end
		settings.stopOn = set
	end,
})
toggle(tShip, "Auto Sail", "Kapal maju lurus sampai danger level tercapai", "sail")

-- ---------- Leviathan ----------
local tLev = newTab("Leviathan", "waves")
toggle(tLev, "Auto Leviathan", nil, "leviathan")
toggle(tLev, "Auto Shot To Heart Leviathan", nil, "shootHeart")
toggle(tLev, "Sail To Tiki Out Pus", "Kapal menuju Tiki Outpost (koordinat di CFG.TIKI_OUTPOST)", "sailTiki")

-- ---------- Combat ----------
local tCombat = newTab("Combat", "hand")
for _, st in ipairs(styles) do toggle(tCombat, st[2], "Beli otomatis jika belum punya", st[1]) end

-- ---------- Sharks Man Karate ----------
local tShark = newTab("Sharks Man Karate", "fish")
toggle(tShark, "Auto Kill Boss", "Tide Keeper", "killSharkBoss")
toggle(tShark, "Auto Gift To Shark Man", nil, "giftShark")
toggle(tShark, "Auto Buy", nil, "buyShark")

-- ---------- Setting ----------
local tSet = newTab("Setting", "settings")
slider(tSet, "Force Tween", "Kecepatan tween 100-200 (animasi karakter tetap jalan)", "tween", 100, 200, 150)
add(tSet, "Dropdown", {
	Title = "Senjata", Values = { "Melee", "Sword", "Blox Fruit", "Gun" }, Value = "Melee",
	Callback = function(v) settings.weapon = norm(v) end,
})
slider(tSet, "Tinggi Farming", "Jarak di atas musuh (stud)", "height", 8, 30, 18)
toggle(tSet, "Fast Attack", "Klik/aktivasi senjata lebih cepat", "fast")
toggle(tSet, "Auto Attack", nil, "autoattack")
toggle(tSet, "Auto Quest", nil, "autoquest")
toggle(tSet, "Auto Tap", nil, "autotap")

-- ---------- Trials ----------
local tTrial = newTab("Trials", "door-open")
toggle(tTrial, "Auto Go To My door Race", nil, "myDoor")
toggle(tTrial, "Kill Player in Trials", nil, "killTrial")
toggle(tTrial, "Buy Trials", nil, "buyTrials")
toggle(tTrial, "Auto Go to Safe Zone", "Pakai tombol 'Set Safe Zone' dulu", "safeZone")
add(tTrial, "Button", {
	Title = "Set Safe Zone (posisiku)",
	Callback = function()
		local h = hrp()
		if h then safePos = h.Position notify("Safe Zone", "Disimpan") end
	end,
})
toggle(tTrial, "Go To Clock", nil, "toClock")
add(tTrial, "Button", {
	Title = "Tp To Temple of time",
	Callback = function()
		task.spawn(function() inv("requestEntrance", CFG.TEMPLE_ENTRANCE) end)
	end,
})

-- ---------- Race V4 ----------
local tV4 = newTab("Race V4", "dna")
toggle(tV4, "Auto On v4", nil, "autoV4")
toggle(tV4, "Auto Use v3", nil, "autoV3")

-- ---------- Race Level ----------
local tRace = newTab("Race Level", "trending-up")
toggle(tRace, "Up v2 (cari 3 bunga)", nil, "upV2")
toggle(tRace, "v3 Sesuai Race", nil, "v3Quest")

-- ---------- Unlock Premium ----------
local tPrem = newTab("Unlock Premium", "key")
local keyText = ""
add(tPrem, "Input", {
	Title = "Input Key", Value = "", Placeholder = "Masukkan key...",
	Callback = function(v) keyText = tostring(norm(v) or "") end,
})
add(tPrem, "Button", { Title = "Submit Key", Callback = function() task.spawn(function() applyKey(keyText) end) end })
add(tPrem, "Button", { Title = "Get key", Desc = CFG.KEY_LINK, Callback = function() copy(CFG.KEY_LINK, "Link key") end })
add(tPrem, "Button", { Title = "Discord", Desc = CFG.DISCORD, Callback = function() copy(CFG.DISCORD, "Discord") end })

-- ---------- Credits ----------
local tCred = newTab("Credits", "info")
add(tCred, "Paragraph", {
	Title = "Senar Hub",
	Desc = "By GGSIHLUH/Ardy/SenarHub\nProject: Senar Hub\nMake script Only 1 person\ni make this script 4 Days",
})

-- ---------- Helloween ----------
local tHallo = newTab("Helloween", "ghost")
toggle(tHallo, "Auto Farming Pumpkins", nil, "pumpkins")
toggle(tHallo, "Auto Tricks", nil, "tricks")
toggle(tHallo, "Auto Spooky Spin", nil, "spookySpin")

-- ---------- Rolls ----------
local tRolls = newTab("Rolls", "dices")
toggle(tRolls, "Auto Rolls Fruit", nil, "rollFruit")
toggle(tRolls, "Skip animation Gacha", nil, "skipGacha")
toggle(tRolls, "Auto Store", "Simpan fruit ke inventory", "autoStore")

-- ---------- Trade ----------
local tTrade = newTab("Trade", "repeat")
toggle(tTrade, "Auto Go To Chair Trade", nil, "tradeChair")

pcall(function() Window:SelectTab(1) end)

env.__SenarBFCleanup = function()
	S.alive = false
	if floatPart then pcall(function() floatPart:Destroy() end) end
	for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
	if antiAfkConnection then antiAfkConnection:Disconnect() end
	pcall(function() espFolder:Destroy() end)
	pcall(function() ScreenGui:Destroy() end)
	pcall(function() Window:Destroy() end)
end
