script_name('CheatsByNyhfox')
script_authors('Nyhfox')
version_script = '1.0'
script_properties('work-in-pause')
require 'lib.moonloader'
local Libs = {}
Libs['windows.message'], 	wm 			= pcall(require, 'windows.message')
Libs['mimgui'], 			imgui 		= pcall(require, 'mimgui')
Libs['vkeys'],				key			= pcall(require, 'vkeys')
Libs['Events'],				sampev 		= pcall(require, 'samp.events')
Libs['inicfg'], 			inicfg 		= pcall(require, 'inicfg')
Libs['ffi'], 				ffi 		= pcall(require, 'ffi')
Libs['SAMemory'], 			samem 		= pcall(require, 'SAMemory')
Libs['memory'], 			mem 		= pcall(require, 'memory')
Libs['matrix3x3'], 			Matrix3X3 	= pcall(require, 'matrix3x3')
Libs['vector3d'], 			Vector3D 	= pcall(require, 'vector3d')
Libs['encoding'], 			encoding 	= pcall(require, 'encoding')
Libs['bitex'],				bitex		= pcall(require, 'bitex')

for lib, bool in pairs(Libs) do
	if not bool then
		error('Library "' .. lib .. '" not found')
		break
	end
end

encoding.default = 'CP1251'
u8 = encoding.UTF8
local new, str, sizeof = imgui.new, ffi.string, ffi.sizeof
local getBonePosition = ffi.cast("int (__thiscall*)(void*, float*, int, bool)", 0x5E4280)
local KeyboardLayoutName, LocalInfo = ffi.new("char[?]", 32), ffi.new("char[?]", 32)
ffi.cdef[[
	short GetKeyState(int nVirtKey);
	bool GetKeyboardLayoutNameA(char* pwszKLID);
	int GetLocaleInfoA(int Locale, int LCType, char* lpLCData, int cchData);
]]

local mainIni = inicfg.load({
	actor = {
		infRun 					= true,
		infSwim 				= true,
		infOxygen 				= true,
		suicide 				= false,
		megaJump 				= false,
		fastSprint 				= false,
		unfreeze 				= false,
		noFall 					= false,
		GM 						= false,
		antiStun				= false,
		invise					= false,
		inviseInt				= 1,
		stopQuick				= false
	},
	vehicle = {
		flip180 				= false,
		flipOnWheels 			= false,
		megaJumpBMX				= false,
		hop 					= false,
		boom 					= false,
		fastExit 				= false,
		AntiBikeFall 			= false,
		GM 						= false,
		GMDefault 				= false,
		GMWheels 				= false,
		fixWheels 				= false,
		speedhack 				= false,
		speedhackMaxSpeed 		= 100.0,
		speedhackSmooth			= 85,
		perfectHandling 		= false,
		allCarsNitro 			= false,
		onlyWheels 				= false,
		tankMode				= false,
		driveOnWater 			= false,
		restoreHealth 			= false,
		engineOn 				= false,
		antiboom_upside			= false,
		invise					= false,
		inviseInt				= 1
	},
	weapon = {
		infAmmo 				= false,
		fullSkills				= false,
		plusC					= false,
		noReload				= false,
		aim						= false,
		bell					= false
	},
	misc = {
		FOV 					= false,
		FOVvalue 				= 70.0,
		antibhop 				= false,
		AirBrake 				= false,
		AirBrakeSpeed 			= 1.0,
		AirBrakeKeys			= 1,
		quickMap 				= false,
		blink 					= false,
		blinkDist 				= 15.0,
		sensfix 				= false,
		clearScreenshot 		= false,
		clearScreenshotDelay	= 1000,
		WalkDriveUnderWater 	= false,
		ClickWarp 				= false,
		reconnect 				= false,
		reconnect_delay			= 1,
		offChatF7				= false,
		notDelayCash			= false,
		gravitation				= false,
		gravitation_value		= 0.008,
		inputHelper				= false,
		chatOnT					= false,
		fastSelectOnDialog		= false
	},
	visual = {
		nameTag 				= false,
		skeleton				= false,
		keyWH					= false,
		infoBar 				= false,
		infbar_grav				= false,
		infbar_coords			= true,
		infbar_interior			= true,
		infbar_time				= true,
		infbar_ping				= false,
		infbar_fps				= true,
		infbar_aid				= false,
		infbar_vid				= false,
		doorLocks				= false,
		distanceDoorLocks		= 30,
		search3dText 			= false,
		traserBullets			= false,
		pulsCash				= false,
		infbar2					= false,
		chatHelper				= false
	},
	menu = {
		checkUpdate 			= true,
		language				= 2,
		language_menu 			= false,
		language_chat 			= false,
		language_visual			= false,
		autoSave 				= true,
		iStyle 					= 0,
		typeToggle				= 1
	},
	notifications = {
		notifications			= false,
		NactorGM 				= false,
		NvehGM 					= false,
		NplusC					= false,
		Nairbrake				= false,
		Nwh 					= false
	},
	developers = {
		dialogId				= false,
		textdraw				= false,
		gametext				= false,
		animations				= false
	},
	reventrp = {
		fixchat					= false,
		venable					= false,
		vline					= false,
		searchCorpse			= false,
		searchHorseshoe			= false,
		searchTotems			= false,
		searchContainers		= false,
		vrainbow				= false,
		vspeed					= 10,
		vcolor					= 0xFFFFFFFF
	},
	arizonarp = {
		passAcc					= '',
		pincode					= 0,
		report					= false,
		venable					= false,
		vline					= false,
		searchGuns 				= false,
		searchSeed 				= false,
		searchDeer				= false,
		searchDrugs 			= false,
		searchGift 				= false,
		searchTreasure 			= false,
		searchMats 				= false,
		vrainbow				= false,
		vspeed					= 10,
		vcolor					= 0xFFFFFFFF,
		autoSkipReport			= false,
		emulateLauncher 		= false
	}
}, 'CheatsByNyhfox')
--teleports
local tpList = {
	["Teleports interior/Òåëåïîðòû â èíòåðüåðû"] = {
		["Interior: Burning Desire House"] = {2338.32, -1180.61, 1027.98, 5},
		["Interior: RC Zero's Battlefield"] = {-975.5766, 1061.1312, 1345.6719, 10},
		["Interior: Liberty City"] = {-750.80, 491.00, 1371.70, 1},
		["Interior: Unknown Stadium"] = {-1400.2138, 106.8926, 1032.2779, 1},
		["Interior: Secret San Fierro Chunk"] = {-2015.6638, 147.2069, 29.3127, 14},
		["Interior: Jefferson Motel"] = {2220.26, -1148.01, 1025.80, 15},
		["Interior: Jizzy's Pleasure Dome"] = {-2660.6185, 1426.8320, 907.3626, 3},
		["Four Dragons' Managerial Suite"] = {2003.1178, 1015.1948, 33.008, 11},
		["Ganton Gym"] = {770.8033, -0.7033, 1000.7267, 5},
		["Brothel"] = {974.0177, -9.5937, 1001.1484, 3},
		["Brothel2"] = {961.9308, -51.9071, 1001.1172, 3},
		["Inside Track Betting"] = {830.6016, 5.9404, 1004.1797, 3},
		["Blastin' Fools Records"] = {1037.8276, 0.397, 1001.2845, 3},
		["The Big Spread Ranch"] = {1212.1489, -28.5388, 1000.9531, 3},
		["Stadium: Bloodbowl"] = {-1394.20, 987.62, 1023.96, 15},
		["Stadium: Kickstart"] = {-1410.72, 1591.16, 1052.53, 14},
		["Stadium: 8-Track Stadium"] = {-1417.8720, -276.4260, 1051.1910, 7},
		["24/7 Store: Big - L-Shaped"] = {-25.8844, -185.8689, 1003.5499, 17},
		["24/7 Store: Big - Oblong"] = {6.0911, -29.2718, 1003.5499, 10},
		["24/7 Store: Med - Square"] = {-30.9469, -89.6095, 1003.5499, 18},
		["24/7 Store: Med - Square"] = {-25.1329, -139.0669, 1003.5499, 16},
		["Warehouse 1"] = {1290.4106, 1.9512, 1001.0201, 18},
		["Warehouse 2"] = {1412.1472, -2.2836, 1000.9241, 1},
		["B Dup's Apartment"] = {1527.0468, -12.0236, 1002.0971, 3},
		["B Dup's Crack Palace"] = {1523.5098, -47.8211, 1002.2699, 2},
		["Wheel Arch Angels"] = {612.2191, -123.9028, 997.9922, 3},
		["OG Loc's House"] = {512.9291, -11.6929, 1001.5653, 3},
		["Barber Shop"] = {418.4666, -80.4595, 1001.8047, 3},
		["24/7 Store: Sml - Long"] = {-27.3123, -29.2775, 1003.5499, 4},
		["24/7 Store: Sml - Square"] = {-26.6915, -55.7148, 1003.5499, 6},
		["Airport: Ticket Sales"] = {-1827.1473, 7.2074, 1061.1435, 14},
		["Airport: Baggage Claim"] = {-1855.5687, 41.2631, 1061.1435, 14},
		["Airplane: Shamal Cabin"] = {2.3848, 33.1033, 1199.8499, 1},
		["Airplane: Andromada Cargo hold"] = {315.8561, 1024.4964, 1949.7973, 9},
		["Planning Department"] = {386.5259, 173.6381, 1008.3828, 3},
		["Las Venturas Police Department"] = {288.4723, 170.0647, 1007.1794, 3},
		["Pro-Laps"] = {206.4627, -137.7076, 1003.0938, 3},
		["Sex Shop"] = {-100.2674, -22.9376, 1000.7188, 3},
		["Las Venturas Tattoo parlor"] = {-201.2236, -43.2465, 1002.2734, 3},
		["Lost San Fierro Tattoo parlor"] = {-202.9381, -6.7006, 1002.2734, 17},
		["24/7 (version 1)"] = {-25.7220, -187.8216, 1003.5469, 17},
		["Diner 1"] = {454.9853, -107.2548, 999.4376, 5},
		["Pizza Stack"] = {372.5565, -131.3607, 1001.4922, 5},
		["Rusty Brown's Donuts"] = {378.026, -190.5155, 1000.6328, 17},
		["Ammu-nation"] = {315.244, -140.8858, 999.6016, 7},
		["Victim"] = {225.0306, -9.1838, 1002.218, 5},
		["Loco Low Co"] = {611.3536, -77.5574, 997.9995, 2},
		["San Fierro Police Department"] = {246.0688, 108.9703, 1003.2188, 10},
		["24/7 (version 2 - large)"] = {6.0856, -28.8966, 1003.5494, 10},
		["Below The Belt Gym (Las Venturas)"] = {773.7318, -74.6957, 1000.6542, 7},
		["Transfenders"] = {621.4528, -23.7289, 1000.9219, 1},
		["World of Coq"] = {445.6003, -6.9823, 1000.7344, 1},
		["Ammu-nation (version 2)"] = {285.8361, -39.0166, 1001.5156, 1},
		["SubUrban"] = {204.1174, -46.8047, 1001.8047, 1},
		["Denise's Bedroom"] = {245.2307, 304.7632, 999.1484, 1},
		["Helena's Barn"] = {290.623, 309.0622, 999.1484, 3},
		["Barbara's Love nest"] = {322.5014, 303.6906, 999.1484, 5},
		["San Fierro Garage"] = {-2041.2334, 178.3969, 28.8465, 1},
		["Oval Stadium"] = {-1402.6613, 106.3897, 1032.2734, 1},
		["8-Track Stadium"] = {-1403.0116, -250.4526, 1043.5341, 7},
		["The Pig Pen (strip club 2)"] = {1204.6689, -13.5429, 1000.9219, 2},
		["Four Dragons"] = {2016.1156, 1017.1541, 996.875, 10},
		["Liberty City"] = {-741.8495, 493.0036, 1371.9766, 1},
		["Ryder's house"] = {2447.8704, -1704.4509, 1013.5078, 2},
		["Sweet's House"] = {2527.0176, -1679.2076, 1015.4986, 1},
		["RC Battlefield"] = {-1129.8909, 1057.5424, 1346.4141, 10},
		["The Johnson House"] = {2496.0549, -1695.1749, 1014.7422, 3},
		["Burger shot"] = {366.0248, -73.3478, 1001.5078, 10},
		["Caligula's Casino"] = {2233.9363, 1711.8038, 1011.6312, 1},
		["Katie's Lovenest"] = {269.6405, 305.9512, 999.1484, 2},
		["Barber Shop 2 (Reece's)"] = {414.2987, -18.8044, 1001.8047, 2},
		["Angel \"Pine Trailer\""] = {1.1853, -3.2387, 999.4284, 2},
		["24/7 (version 3)"] = {-30.9875, -89.6806, 1003.5469, 18},
		["Zip"] = {161.4048, -94.2416, 1001.8047, 18},
		["The Pleasure Domes"] = {-2638.8232, 1407.3395, 906.4609, 3},
		["Madd Dogg's Mansion"] = {1267.8407, -776.9587, 1091.9063, 5},
		["Big Smoke's Crack Palace"] = {2536.5322, -1294.8425, 1044.125, 2},
		["Burning Desire Building"] = {2350.1597, -1181.0658, 1027.9766, 5},
		["Wu-Zi Mu's"] = {-2158.6731, 642.09, 1052.375, 1},
		["Abandoned AC tower"] = {419.8936, 2537.1155, 10.0, 10},
		["Wardrobe/Changing room"] = {256.9047, -41.6537, 1002.0234, 14},
		["Didier Sachs"] = {204.1658, -165.7678, 1000.5234, 14},
		["Casino (Redsands West)"] = {1133.35, -7.8462, 1000.6797, 12},
		["Kickstart Stadium"] = {-1420.4277, 1616.9221, 1052.5313, 14},
		["Club"] = {493.1443, -24.2607, 1000.6797, 17},
		["Atrium"] = {1727.2853, -1642.9451, 20.2254, 18},
		["Los Santos Tattoo Parlor"] = {-202.842, -24.0325, 1002.2734, 16},
		["Safe House group 1"] = {2233.6919, -1112.8107, 1050.8828, 5},
		["Safe House group 2"] = {1211.2484, 1049.0234, 359.941, 6},
		["Safe House group 3"] = {2319.1272, -1023.9562, 1050.2109, 9},
		["Safe House group 4"] = {2261.0977, -1137.8833, 1050.6328, 10},
		["Sherman Dam"] = {-944.2402, 1886.1536, 5.0051, 17},
		["24/7 (version 4)"] = {-26.1856, -140.9164, 1003.5469, 16},
		["Jefferson Motel"] = {2217.281, -1150.5349, 1025.7969, 15},
		["Jet Interior"] = {1.5491, 23.3183, 1199.5938, 1},
		["The Welcome Pump"] = {681.6216, -451.8933, -25.6172, 1},
		["Burglary House X1"] = {234.6087, 1187.8195, 1080.2578, 3},
		["Burglary House X2"] = {225.5707, 1240.0643, 1082.1406, 2},
		["Burglary House X3"] = {224.288, 1289.1907, 1082.1406, 1},
		["Burglary House X4"] = {239.2819, 1114.1991, 1080.9922, 5},
		["Binco"] = {207.5219, -109.7448, 1005.1328, 15},
		["4 Burglary houses"] = {295.1391, 1473.3719, 1080.2578, 15},
		["Blood Bowl Stadium"] = {-1417.8927, 932.4482, 1041.5313, 15},
		["Budget Inn Motel Room"] = {446.3247, 509.9662, 1001.4195, 12},
		["Lil' Probe Inn"] = {-227.5703, 1401.5544, 27.7656, 18},
		["Pair of Burglary Houses"] = {446.626, 1397.738, 1084.3047, 2},
		["Crack Den"] = {227.3922, 1114.6572, 1080.9985, 5},
		["Burglary House X11"] = {227.7559, 1114.3844, 1080.9922, 5},
		["Burglary House X12"] = {261.1165, 1287.2197, 1080.2578, 4},
		["Ammu-nation (version 3)"] = {291.7626, -80.1306, 1001.5156, 4},
		["Jay's Diner"] = {449.0172, -88.9894, 999.5547, 4},
		["24/7 (version 5)"] = {-27.844, -26.6737, 1003.5573, 4},
		["Michelle's Love Nest*"] = {306.1966, 307.819, 1003.3047, 4},
		["Burglary House X14"] = {24.3769, 1341.1829, 1084.375, 10},
		["Sindacco Abatoir"] = {963.0586, 2159.7563, 1011.0303, 1},
		["Burglary House X13"] = {221.6766, 1142.4962, 1082.6094, 4},
		["Unused Safe House"] = {2323.7063, -1147.6509, 1050.7101, 12},
		["Millie's Bedroom"] = {344.9984, 307.1824, 999.1557, 6},
		["Barber Shop"] = {411.9707, -51.9217, 1001.8984, 12},
		["Dirtbike Stadium"] = {-1421.5618, -663.8262, 1059.5569, 4},
		["Cobra Gym"] = {773.8887, -47.7698, 1000.5859, 6},
		["Los Santos Police Department"] = {246.6695, 65.8039, 1003.6406, 6},
		["Los Santos Airport"] = {-1864.9434, 55.7325, 1055.5276, 14},
		["Burglary House X15"] = {-262.1759, 1456.6158, 1084.3672, 4},
		["Burglary House X16"] = {22.861, 1404.9165, 1084.4297, 5},
		["Burglary House X17"] = {140.3679, 1367.8837, 1083.8621, 5},
		["Bike School"] = {1494.8589, 1306.48, 1093.2953, 3},
		["Francis International Airport"] = {-1813.213, -58.012, 1058.9641, 14},
		["Vice Stadium"] = {-1401.067, 1265.3706, 1039.8672, 16},
		["Burglary House X18"] = {234.2826, 1065.229, 1084.2101, 6},
		["Burglary House X19"] = {-68.5145, 1353.8485, 1080.2109, 6},
		["Zero's RC Shop"] = {-2240.1028, 136.973, 1035.4141, 6},
		["Ammu-nation (version 4)"] = {297.144, -109.8702, 1001.5156, 6},
		["Ammu-nation (version 5)"] = {316.5025, -167.6272, 999.5938, 6},
		["Burglary House X20"] = {-285.2511, 1471.197, 1084.375, 15},
		["24/7 (version 6)"] = {-26.8339, -55.5846, 1003.5469, 6},
		["Secret Valley Diner"] = {442.1295, -52.4782, 999.7167, 6},
		["Rosenberg's Office in Caligulas"] = {2182.2017, 1628.5848, 1043.8723, 2},
		["Fanny Batter's Whore House"] = {748.4623, 1438.2378, 1102.9531, 6},
		["Colonel Furhberger's"] = {2807.3604, -1171.7048, 1025.5703, 8},
		["Cluckin' Bell"] = {366.0002, -9.4338, 1001.8516, 9},
		["The Camel's Toe Safehouse"] = {2216.1282, -1076.3052, 1050.4844, 1},
		["Caligula's Roof"] = {2268.5156, 1647.7682, 1084.2344, 1},
		["Old Venturas Strip Casino"] = {2236.6997, -1078.9478, 1049.0234, 2},
		["Driving School"] = {-2031.1196, -115.8287, 1035.1719, 3},
		["Verdant Bluffs Safehouse"] = {2365.1089, -1133.0795, 1050.875, 8},
		["Andromada"] = {315.4544, 976.5972, 1960.8511, 9},
		["Four Dragons' Janitor's Office"] = {1893.0731, 1017.8958, 31.8828, 10},
		["Bar"] = {501.9578, -70.5648, 998.7578, 11},
		["Burglary House X21"] = {-42.5267, 1408.23, 1084.4297, 8},
		["Willowfield Safehouse"] = {2283.3118, 1139.307, 1050.8984, 11},
		["Burglary House X22"] = {84.9244, 1324.2983, 1083.8594, 9},
		["Burglary House X23"] = {260.7421, 1238.2261, 1084.2578, 9}
	},
	["Others teleports/Îñòàëüíûå òåëåïîðòû"] = {
		["Transfender near Wang Cars in Doherty"] = {-1935.77, 228.79, 34.16, 0},
		["Wheel Archangels in Ocean Flats"] = {-2707.48, 218.65, 4.93, 0},
		["LowRider Tuning Garage in Willowfield"] = {2645.61, -2029.15, 14.28, 0},
		["Transfender in Temple"] = {1041.26, -1036.77, 32.48, 0},
		["Transfender in come-a-lot"] = {2387.55, 1035.70, 11.56, 0},
		["Eight Ball Autos near El Corona"] = {1836.93, -1856.28, 14.13, 0},
		["Welding Wedding Bomb-workshop in Emerald Isle"] = {2006.11, 2292.87, 11.57, 0},
		["Michelles Pay 'n' Spray in Downtown"] = {-1787.25, 1202.00, 25.84, 0},
		["Pay 'n' Spray in Dillimore"] = {720.10, -470.93, 17.07, 0},
		["Pay 'n' Spray in El Quebrados"] = {-1420.21, 2599.45, 56.43, 0},
		["Pay 'n' Spray in Fort Carson"] = {-100.16, 1100.79, 20.34, 0},
		["Pay 'n' Spray in Idlewood"] = {2078.44, -1831.44, 14.13, 0},
		["Pay 'n' Spray in Juniper Hollow"] = {-2426.89, 1036.61, 51.14, 0},
		["Pay 'n' Spray in Redsands East"] = {1957.96, 2161.96, 11.56, 0},
		["Pay 'n' Spray in Santa Maria Beach"] = {488.29, -1724.85, 12.01, 0},
		["Pay 'n' Spray in Temple"] = {1025.08, -1037.28, 32.28, 0},
		["Pay 'n' Spray near Royal Casino"] = {2393.70, 1472.80, 11.42, 0},
		["Pay 'n' Spray near Wang Cars in Doherty"] = {-1904.97, 268.51, 41.04, 0},
		["Player Garage: Verdant Meadows"] = {403.58, 2486.33, 17.23, 0},
		["Player Garage: Las Venturas Airport"] = {1578.24, 1245.20, 11.57, 0},
		["Player Garage: Calton Heights"] = {-2105.79, 905.11 ,77.07, 0},
		["Player Garage: Derdant Meadows"] = {423.69, 2545.99, 17.07, 0},
		["Player Garage: Dillimore "] = {785.79, -513.12, 17.44, 0},
		["Player Garage: Doherty"] = {-2027.34, 141.02, 29.57, 0},
		["Player Garage: El Corona"] = {1698.10, -2095.88, 14.29, 0},
		["Player Garage: Fort Carson"] = {-361.10, 1185.23, 20.49, 0},
		["Player Garage: Hashbury"] = {-2463.27, -124.86, 26.41, 0},
		["Player Garage: Johnson House"] = {2505.64, -1683.72, 14.25, 0},
		["Player Garage: Mulholland"] = {1350.76, -615.56, 109.88, 0},
		["Player Garage: Palomino Creek"] = {2231.64, 156.93, 27.63, 0},
		["Player Garage: Paradiso"] = {-2695.51, 810.70, 50.57, 0},
		["Player Garage: Prickle Pine"] = {1293.61, 2529.54, 11.42, 0},
		["Player Garage: Redland West"] = {1401.34, 1903.08, 11.99, 0},
		["Player Garage: Rockshore West"] = {2436.50, 698.43, 11.60, 0},
		["Player Garage: Santa Maria Beach"] = {322.65, -1780.30, 5.55, 0},
		["Player Garage: Whitewood Estates"] = {917.46, 2012.14, 11.65, 0},
		["Commerce Region Loading Bay"] = {1641.14 ,-1526.87, 14.30, 0},
		["San Fierro Police Garage"] = {-1617.58, 688.69, -4.50, 0},
		["Los Santos Cemetery"] = {837.05, -1101.93, 23.98, 0},
		["Grove Street"] = {2536.08, -1632.98, 13.79, 0},
		["4D casino"] = {1992.93, 1047.31, 10.82, 0},
		["LS Hospital"] = {2033.00, -1416.02, 16.99, 0},
		["SF Hospital"] = {-2653.11, 634.78, 14.45, 0},
		["LV Hospital"] = {1580.22, 1768.93, 10.82, 0},
		["SF Export"] = {-1550.73, 99.29, 17.33, 0},
		["Otto's Autos"] = {-1658.1656, 1215.0002, 7.25, 0},
		["Wang Cars"] = {-1961.6281, 295.2378, 35.4688, 0},
		["Palamino Bank"] = {2306.3826, -15.2365, 26.7496, 0},
		["Palamino Diner"] = {2331.8984, 6.7816, 26.5032, 0},
		["Dillimore Gas Station"] = {663.0588, -573.6274, 16.3359, 0},
		["Torreno's Ranch"] = {-688.1496, 942.0826, 13.6328, 0},
		["Zombotech - lobby area"] = {-1916.1268, 714.8617, 46.5625, 0},
		["Crypt in LS cemetery (temple)"] = {818.7714, -1102.8689, 25.794, 0},
		["Blueberry Liquor Store"] = {255.2083, -59.6753, 1.5703, 0},
		["Warehouse 3"] = {2135.2004, -2276.2815, 20.6719, 0},
		["K.A.C.C. Military Fuels Depot"] = {2548.4807, 2823.7429, 10.8203, 0},
		["Area 69"] = {215.1515, 1874.0579, 13.1406, 0},
		["Bike School"] = {1168.512, 1360.1145, 10.9293, 0}
	}
}

local tpListRVRP = {
	["Ôðàêöèè"] = {
		["LSPD"] = {1543.4442, -1675.2795, 13.5565, 0},
		["SFPD"] = {-1606.9584, 720.8036, 12.2308, 0},
		["LVPD"] = {2287.3582, 2421.3423, 10.8203, 0},
		["Áîëüíèöà LS"] = {1178.7211, -1326.7101, 14.1560, 0},
		["Áîëüíèöà SF"] = {-2662.2585, 625.6224, 14.4531, 0},
		["Áîëüíèöà LV"] = {1632.9490, 1821.7103, 10.8203, 0},
		["ÔÁÐ"] = {1046.4518, 1026.6058, 10.9978, 0},
		["Ïðàâèòåëüñòâî"] = {1407.8854, -1788.0032, 13.5469, 0},
		["Radio LS"] = {760.8872, -1358.9816, 13.5198, 0},
		["Radio LV"] = {947.7136, 1743.1909, 8.8516, 0},
		["Àâòîøêîëà"] = {-2037.7787, -99.7488, 35.1641, 0},
		["Îòäåë ëèöåíçèðîâàíèÿ"] = {1910.5309, 2343.3171, 10.8203, 0},
		["Íàö. ãâàðäèÿ"] = {312.4188, 1959.1595, 17.6406, 0},
		["Ðóññêàÿ ìàôèÿ"] = {-2723.7395, -313.8499, 7.1860, 0},
		["ßêóäçà"] = {1492.9370, 724.5159, 10.8203, 0},
		["Aztecas"] = {1673.0597, -2113.4204, 13.5469, 0},
		["Grove"] = {2493.1980, -1673.9980, 13.3359, 0},
		["Ballas"] = {2629.8752, -1077.4902, 69.6170, 0},
		["Vagos"] = {2658.0203, -1991.8776, 13.5546, 0},
		["Rifa"] = {2179.6760, -1001.7764, 62.9305, 0},
		["Comrades MC"] = {157.9299, -172.9156, 1.5781, 0},
		["Warlock MC"] = {-862.3333, 1539.7640, 22.5562, 0}
	},
	["Ðàáîòû"] = {
		["Íåôòÿííàÿ âûøêà"] = {815.8508, 604.5477, 11.8305, 0},
		["Ãðóç÷èê"] = {2788.3308, -2437.6555, 13.6335, 0},
		["Àâòîöåõ"] = {-49.9263, -277.9673, 5.4297, 0},
		["Àâòîöåõ (Èíòåðüåð)"] = {-570.5103, -82.4685, 3001.0859, 1},
		["Äàëüíîáîéùèê"] = {-504.6666, -545.2240, 25.5234, 0},
		["Ëåñîðóá"] = {-555.8159, -189.0762, 78.4063, 0},
		["Ìîéùèê óëèö"] = {-2586.7097, 608.1636, 14.4531, 0},
		["Èíêàñàòîð"] = {2168.6331, 998.6193, 10.8203, 0}
	},
	["Îñòàëüíîå"] = {
		["Ìàÿê"] = {154.9556, -1939.6304, 3.7734, 0},
		["Êîëåñî îáîçðåíèÿ"] = {381.6406, -2044.5220, 7.8359, 0},
		["Áàíê"] = {1457.3635, -1027.2981, 23.8281, 0},
		["×èëëèàä"] = {-2242.5701, -1731.3767, 480.3250, 0},
		["Áèðæà òðóäà"] = {554.2763, -1500.1908, 14.5191, 0},
		["×åðíûé ðûíîê"] = {341.1162, -97.6198, 1.4143, 0},
		["Àâòîñàëîí"] = {-2447.2839, 750.6021, 35.1719, 0},
		["ÁÓ ðûíîê"] = {1492.5591, 2809.7349, 10.8203, 0},
		["ÆÄËÑ"] = {1707.0590, -1895.5723, 13.5685, 0},
		["ÆÄÑÔ"] = {-1975.0864, 141.7100, 27.6873, 0},
		["ÆÄËÂ"] = {2839.9119, 1286.1318, 11.3906, 0},
		["Êëàäáèùå LS"] = {936.1039, -1101.4722, 24.3431, 0},
		["Òîðãîâûé öåíòð"] = {1306.2538, -1331.6825, 13.6422, 0},
		["Ñòðàõîâàÿ"] = {2129.5217, -1139.7073, 25.2925, 0},
		["Àðåíäà àâòî LS"] = {568.2047, -1290.3613, 17.2422, 0},
		["Àðåíäà àâòî SF"] = {-1972.5128, 257.3625, 35.1719, 0},
		["Àðåíäà àâòî LV"] = {2257.1780, 2033.8057, 10.8203, 0},
		["Àðåíäà àâòî LV (Âîçëå êàçèíî)"] = {1897.5586, 949.3096, 10.8203, 0},
		["Êàðüåð"] = {626.8690, 853.0729, -42.9609, 0},
		["Àâòîñåðâèñ"] = {617.2724, -1520.0159, 15.2100, 0},
		["Äåïàðòàìåíò àäìèíèñòðàöèè"] = {635.7059, -565.4893, 16.3359, 0},
		["Âîåíêîìàò"] = {-2449.4761, 498.7346, 30.0873, 0},
		["Êàçèíî"] = {2031.1218, 1006.4854, 10.8203, 0},
		["Êàçèíî-ìèíè"] = {1015.9720, -1127.6450, 23.8574, 0},
		["Ðàçáîðêà LV"] = {-1506.7286, 2623.1606, 55.8359, 0},
		["Ðàçáîðêà LS-SF"] = {-2110.1580, -2431.3657, 30.6250, 0},
		["Çàáðîøåííûé çàâîä"] = {1044.2622, 2078.8237, 10.8203, 0},
		["Òðåíèðîâî÷íûé êîìëïåêñ"] = {2478.8884, -2108.2769, 13.5469, 0},
		["Ñîñòÿçàòåëüíàÿ àðåíà"] = {1088.4347, -900.3381, 42.7011, 0},
		["Îñòðîâ \"Íåâåçåíèÿ\""] = {616.4134, -3549.7146, 86.9716, 0},
		["Ýêñïîðò ÒÑ"] = {-1549.0760, 121.4793, 3.5547, 0},
		["Òèð"] = {-2689.1277, 0.0403, 6.1328, 0},
		["Òðóùîáû"] = {-2541.6707, 25.9529, 16.4438, 0},
		["Àýðîïîðò LS"] = {1449.0017, -2461.8296, 13.5547, 0},
		["Àýðîïîðò SF"] = {-1654.5244, -173.4216, 14.1484, 0},
		["Àýðîïîðò LV"] = {1337.8947, 1303.8196, 10.8203, 0}
	},
	["Îñòàëüíîå (Èíòåðüåðû)"] = {
		["Ñòàðûé äåìîðãàí"] = {1281.1638, -1.8006, 1001.0133, 18},
		["Áàíê"] = {1463.0361, -1009.3804, 34.4652, 0},
		["Áèðæà òðóäà"] = {1561.1443, -1518.2223, 3001.5188, 15},
		["×åðíûé ðûíîê"] = {1696.5221, -1586.8097, 2875.2939, 1},
		["×åðíûé ðûíîê (ïðîïóñê)"] = {1569.4727, 1230.9999, 1055.1804, 1},
		["Àâòîñàëîí"] = {2489.1558, -1017.1227, 1033.1460, 1},
		["Äåïàðòàìåíò àäìèíèñòðàöèè"] = {-265.7054, 725.4685, 1000.0859, 5},
		["Âîåíêîìàò"] = {223.4714, 1540.9908, 3001.0859, 1},
		["Êàçèíî"] = {1888.7018, 1049.5775, 996.8770, 1},
		["Êàçèíî-ìèíè"] = {1411.5062, -586.6498, 1607.3579, 1},
		["Òðåíèðîâî÷íûé êîìëïåêñ"] = {2365.9114, -1943.3044, 919.4700, 1},
		["Ñîñòÿçàòåëüíàÿ àðåíà"] = {825.7631, -1578.9291, 3001.0823, 3},
		["Òèð"] = {285.8546, -78.9205, 1001.5156, 4},
		["Òîðãîâûé öåíòð"] = {1359.7142, -27.9618, 1000.9163, 1},
		["Ñòðàõîâàÿ"] = {1707.3676, 636.4663, 3001.0859, 1}
	}
}
--params
local colors = {
	hex = {
		main = '{888EA0}',
		main2 = '{F9D82F}',
		blue = '{0984D2}',
		red = '{B31A06}',
		green = '{0E8604}'
	},
	chat = {
		main = 0x888EA0,
		main2 = 0xF9D82F,
		blue = 0x0984D2,
		red = 0xB31A06,
		green = 0x0E8604
	}
}

local checkfuncs = {
	main = {
		activecursor = true,
		enabled = true,
		locked = false
	},
	others = {
		AirBrake = false,
		GMactor = false,
		GMveh = false,
		GMWveh = false,
		Clickwarp = false,
		PlusC = false,
		KeyWH = false
	}
}
local jsn_upd = "https://raw.githubusercontent.com/Nyhfox/CheatsByNyhfox/main/version.json"
local tag = '{F9D82F}CheatsByNyhfox {888EA0}- '
local airBrakeCoords = {}
local langIG = {}
local arizoancmds = false
local rvcmds = false
local chars = {
	["é"] = "q", ["ö"] = "w", ["ó"] = "e", ["ê"] = "r", ["å"] = "t", ["í"] = "y", ["ã"] = "u", ["ø"] = "i", ["ù"] = "o", ["ç"] = "p", ["õ"] = "[", ["ú"] = "]", ["ô"] = "a",
	["û"] = "s", ["â"] = "d", ["à"] = "f", ["ï"] = "g", ["ð"] = "h", ["î"] = "j", ["ë"] = "k", ["ä"] = "l", ["æ"] = ";", ["ý"] = "'", ["ÿ"] = "z", ["÷"] = "x", ["ñ"] = "c", ["ì"] = "v",
	["è"] = "b", ["ò"] = "n", ["ü"] = "m", ["á"] = ",", ["þ"] = ".", ["É"] = "Q", ["Ö"] = "W", ["Ó"] = "E", ["Ê"] = "R", ["Å"] = "T", ["Í"] = "Y", ["Ã"] = "U", ["Ø"] = "I",
	["Ù"] = "O", ["Ç"] = "P", ["Õ"] = "{", ["Ú"] = "}", ["Ô"] = "A", ["Û"] = "S", ["Â"] = "D", ["À"] = "F", ["Ï"] = "G", ["Ð"] = "H", ["Î"] = "J", ["Ë"] = "K", ["Ä"] = "L",
	["Æ"] = ":", ["Ý"] = "\"", ["ß"] = "Z", ["×"] = "X", ["Ñ"] = "C", ["Ì"] = "V", ["È"] = "B", ["Ò"] = "N", ["Ü"] = "M", ["Á"] = "<", ["Þ"] = ">"
}
--tags
local imgIntGameRUS = {[[Ïðèâåòñòâóåì Âàñ, äîðîãîé ïîëüçîâàòåëü! Â äàííîì ïðîåêòå åñòü âñïîìîãàòåëüíûå ôóíêöèè äëÿ..
..Âàøåé èãðû â SA:MP.
Ïîìîæåì Âàì ðàçîáðàòüñÿ â CheatsByNyhfox - ñâåðõó âèäèòå âêëàäêè, òàêèå êàê, "Ïåðñîíàæ", "Òðàíñïîðò", ..
.. "Îðóæèå" è äðóãèå.
Ýòè âêëàäêè îòâå÷àþò çà îïðåäåëåííóþ "ñôåðó".]],
[[*Ïåðñîíàæ - ýòà âêëàäêà îòâå÷àåò çà "÷èòû" äëÿ Âàøåãî èãðîêà, äðóãèå çäåñü íå êàñàþòñÿ;
*Òðàíñïîðò - ýòà âêëàäêà îòâå÷àåò çà "÷èòû" äëÿ Âàøåãî òðàíñïîðòà, â êîòîðîì âû íàõîäèòåñü;
*Îðóæèå - ýòà âêëàäêà îòâå÷àåò çà "÷èòû" òîëüêî äëÿ Âàøåãî îðóæèÿ, êîòîðîå ó Âàñ â ðóêàõ;
*Ðàçíîå - ýòà âêëàäêà îòâå÷àåò çà ïðî÷èå ôóíêöèè, îíè ìîãóò áûòü êàê "÷èòû", èëè..
.. ÷òîáû, "ãëàçó áûëî ïðèÿòíî".
Òàêæå åñòü ïîäâêëàäêà "Òåëåïîðòû", òàì Âû ñìîæåòå òåëåïîðòèðîâàòüñÿ íà ëþáîå ìåñòî, ..
.. êîòîðîå åñòü â ñïèñêå;
*Âèçóàëû - ýòà âêëàäêà îòâå÷àåò çà ëþáóþ îòðèñîâêó â CheatsByNyhfox. Òî åñòü âíå èãðîâûå îòðèñîâêè, ..
.. ê ïðèìåðó, îòêðûòû ëè òðàíñïîðòíûå ñðåäñòâà èëè æå íåò è òîìó ïîäîáíîå;
*Íàñòðîéêè - ýòà âêëàäêà îòâå÷àåò çà Âàøè íàñòðîéêè CheatsByNyhfox.
Òàì Âû ìîæåòå íàñòðîèòü âñå ÷òî âîçìîæíî, òàêæå îáðàòèòå âíèìàíèÿ íà ïîäâêëàäêè;
*Ïîìîùü - ýòà âêëàäêà îòâå÷àåò çà Âàøó ïîìîùü. Åñëè Âû çàáûëè ÷òî-ëèáî, ëèáî æå..
.. íå ïîíèìàåòå ÷òî-òî, ìîæåòå îòêðûâàòü äàííóþ âêëàäêó è òàì Âû ñêîðåå âñåãî..
.. íàéäåòå ðåøåíèå Âàøåé ïðîáëåìû;]],
[[Ýòî êðàòêàÿ ïîìîùü. Íàäååìñÿ íà òî, ÷òî Âû ðàçáåðåòåñü â äàííîì òâîðåíèè.
Ïîìíèòå, ÷òî çà "÷èòû" ìîãóò âûäàòü íàêàçàíèÿ, çà êîòîðûå ìû íå íåñåì îòâåòñòâåííîñòè, ..
èñïîëüçóéòå íà ñâîé ÑÒÐÀÕ È ÐÈÑÊ!
Áóäåì î÷åíü áëàãîäàðíû çà ëþáóþ ïîìîùü! Ñ ëþáîâüþ CheatsByNyhfox Project!]]}
local imgIntGameENG = {[[Welcome, dear user! In this project there are support functions for your game in SA:MP.
We will help you understand CheatsByNyhfox - can see tabs from the top, such as, "Actor", "Vehicle", "Weapon", etc.
These tabs are responsible for a certain "sphere".]],
[[*Actor - this tab is responsible for the "cheats" for your player, others do not concern here;
*Vehicle - this tab is responsible for the "cheats" for your vehicle in which you are located;
*Weapon - this tab is responsible for the "cheats" only for your weapon, which is in your hands;
*Misc - this tab is responsible for other functions, they can be like "cheats", or so that..
.. "the eye is pleasant."
There is also a sub-tab "Teleports", where you can teleport to any place that is on the list;
*Visual - this tab is responsible for any drawing in CheatsByNyhfox. That is, outside the game renders, ..
.. for example, whether the vehicles are open or not;
*Settings - this tab is responsible for your CheatsByNyhfox settings.
There you can customize everything that is possible, also pay attention to the sub-tabs;
*Help - this tab is responsible for your help. If you have forgotten something, or do..
.. not understand something, you can open this tab and there you will most likely find..
.. a solution to your problem;]],
[[This is a brief help. We hope that you will understand this creation.
Remember that for "cheats" can give punishments for which we are not responsible, ..
.. use at your own risk and risk!
We will be very grateful for any help! With love CheatsByNyhfox Project!]]}
--others
local BulletSync = {lastId = 0, maxLines = 15}
for i = 1, BulletSync.maxLines do
	BulletSync[i] = {enable = false, o = {x, y, z}, t = {x, y, z}, time = 0, tType = 0}
end

local ltime = {
	mseconds = 0,
	minutes = 0,
	seconds = 0,
	hours = 0
}

local fa = {
	['ICON_INFO_CIRCLE'] = '\xef\x81\x9a',
	['ICON_EYE_SLASH'] = '\xef\x81\xb0',
	['ICON_BOMB'] = '\xef\x87\xa2',
	['ICON_COG'] = '\xef\x80\x93',
	['ICON_STREET_VIEW'] = '\xef\x88\x9d',
	['ICON_SAVE'] = '\xef\x83\x87',
	['ICON_POWER_OFF'] = '\xef\x80\x91',
	['ICON_DOWNLOAD'] = '\xef\x80\x99',
	['ICON_CAR'] = '\xef\x86\xb9',
	['ICON_INFO'] = '\xef\x84\xa9',
	['ICON_EYE'] = '\xef\x81\xae',
	['ICON_SERVER'] = '\xef\x88\xb3',
	['ICON_TIMES_CIRCLE'] = '\xef\x81\x97',
	['ICON_CHECK_CIRCLE'] = '\xef\x81\x98',
	['ICON_CHART_PIE'] = '\xef\x88\x80'
}
--params mimgui
local pw, ph = getScreenResolution()
local sw, sh = 800, 400
local array = {
	main_window_state 						= new.bool(false),

	show_imgui_infRun 						= new.bool(mainIni.actor.infRun),
	show_imgui_infSwim 						= new.bool(mainIni.actor.infSwim),
	show_imgui_infOxygen 					= new.bool(mainIni.actor.infOxygen),
	show_imgui_megajumpActor 				= new.bool(mainIni.actor.megaJump),
	show_imgui_fastsprint 					= new.bool(mainIni.actor.fastSprint),
	show_imgui_suicideActor 				= new.bool(mainIni.actor.suicide),
	show_imgui_unfreeze 					= new.bool(mainIni.actor.unfreeze),
	show_imgui_nofall 						= new.bool(mainIni.actor.noFall),
	show_imgui_gmActor 						= new.bool(mainIni.actor.GM),
	show_imgui_antistun						= new.bool(mainIni.actor.antiStun),
	ainvise									= new.bool(mainIni.actor.invise),
	ainviseInt								= new.int(mainIni.actor.inviseInt),
	stopQuick								= new.bool(mainIni.actor.stopQuick),

	show_imgui_engineOnVeh 					= new.bool(mainIni.vehicle.engineOn),
	show_imgui_restHealthVeh 				= new.bool(mainIni.vehicle.restoreHealth),
	show_imgui_megajumpBMX 					= new.bool(mainIni.vehicle.megaJumpBMX),
	show_imgui_flip180 						= new.bool(mainIni.vehicle.flip180),
	show_imgui_flipOnWheels 				= new.bool(mainIni.vehicle.flipOnWheels),
	show_imgui_suicideVeh 					= new.bool(mainIni.vehicle.boom),
	show_imgui_hopVeh 						= new.bool(mainIni.vehicle.hop),
	show_imgui_fastexit 					= new.bool(mainIni.vehicle.fastExit),
	show_imgui_antiBikeFall 				= new.bool(mainIni.vehicle.AntiBikeFall),
	show_imgui_gmVeh 						= new.bool(mainIni.vehicle.GM),
	show_imgui_gmVehDefault					= new.bool(mainIni.vehicle.GMDefault),
	show_imgui_gmVehWheels					= new.bool(mainIni.vehicle.GMWheels),
	show_imgui_fixWheels 					= new.bool(mainIni.vehicle.fixWheels),
	show_imgui_speedhack 					= new.bool(mainIni.vehicle.speedhack),
	SpeedHackMaxSpeed 						= new.float(mainIni.vehicle.speedhackMaxSpeed),
	SpeedHackSmooth							= new.int(mainIni.vehicle.speedhackSmooth),
	show_imgui_perfectHandling 				= new.bool(mainIni.vehicle.perfectHandling),
	show_imgui_allCarsNitro					= new.bool(mainIni.vehicle.allCarsNitro),
	show_imgui_onlyWheels					= new.bool(mainIni.vehicle.onlyWheels),
	show_imgui_tankMode						= new.bool(mainIni.vehicle.tankMode),
	show_imgui_driveOnWater 				= new.bool(mainIni.vehicle.driveOnWater),
	antiboom_upside							= new.bool(mainIni.vehicle.antiboom_upside),
	vinvise									= new.bool(mainIni.vehicle.invise),
	vinviseInt								= new.int(mainIni.vehicle.inviseInt),

	show_imgui_infAmmo 						= new.bool(mainIni.weapon.infAmmo),
	show_imgui_fullskills					= new.bool(mainIni.weapon.fullSkills),
	show_imgui_plusC						= new.bool(mainIni.weapon.plusC),
	show_imgui_noreload						= new.bool(mainIni.weapon.noReload),
	show_imgui_aim							= new.bool(mainIni.weapon.aim),
	bell									= new.bool(mainIni.weapon.bell),

	show_imgui_UnderWater 					= new.bool(mainIni.misc.WalkDriveUnderWater),
	show_imgui_FOV 							= new.bool(mainIni.misc.FOV),
	FOV_value 								= new.float(mainIni.misc.FOVvalue),
	show_imgui_antibhop 					= new.bool(mainIni.misc.antibhop),
	show_imgui_AirBrake 					= new.bool(mainIni.misc.AirBrake),
	AirBrake_Speed 							= new.float(mainIni.misc.AirBrakeSpeed),
	AirBrake_keys							= new.int(mainIni.misc.AirBrakeKeys),
	show_imgui_quickMap 					= new.bool(mainIni.misc.quickMap),
	show_imgui_blink 						= new.bool(mainIni.misc.blink),
	blink_dist								= new.float(mainIni.misc.blinkDist),
	show_imgui_sensfix 						= new.bool(mainIni.misc.sensfix),
	show_imgui_reconnect 					= new.bool(mainIni.misc.reconnect),
	recon_delay								= new.int(mainIni.misc.reconnect_delay),
	show_imgui_clrScr 						= new.bool(mainIni.misc.clearScreenshot),
	clrScr_delay							= new.int(mainIni.misc.clearScreenshotDelay),
	show_imgui_clickwarp					= new.bool(mainIni.misc.ClickWarp),
	rvanka									= new.bool(false),
	offChatF7								= new.bool(mainIni.misc.offChatF7),
	notDelayCash							= new.bool(mainIni.misc.notDelayCash),
	gravitation								= new.bool(mainIni.misc.gravitation),
	gravitation_value						= new.float(mainIni.misc.gravitation_value),
	inputHelper								= new.bool(mainIni.misc.inputHelper),
	chatOnT									= new.bool(mainIni.misc.chatOnT),
	fastSelectOnDialog						= new.bool(mainIni.misc.fastSelectOnDialog),

	show_imgui_nametag 						= new.bool(mainIni.visual.nameTag),
	show_imgui_skeleton						= new.bool(mainIni.visual.skeleton),
	show_imgui_keyWH						= new.bool(mainIni.visual.keyWH),
	infbar 									= new.bool(mainIni.visual.infoBar),
	infbar_grav								= new.bool(mainIni.visual.infbar_grav),
	infbar_coords							= new.bool(mainIni.visual.infbar_coords),
	infbar_interior							= new.bool(mainIni.visual.infbar_interior),
	infbar_time								= new.bool(mainIni.visual.infbar_time),
	infbar_ping								= new.bool(mainIni.visual.infbar_ping),
	infbar_fps								= new.bool(mainIni.visual.infbar_fps),
	infbar_aid								= new.bool(mainIni.visual.infbar_aid),
	infbar_vid								= new.bool(mainIni.visual.infbar_vid),
	show_imgui_doorlocks					= new.bool(mainIni.visual.doorLocks),
	distDoorLocks							= new.int(mainIni.visual.distanceDoorLocks),
	srch3dtext								= new.bool(mainIni.visual.search3dText),
	traserbull								= new.bool(mainIni.visual.traserBullets),
	pulsCash								= new.bool(mainIni.visual.pulsCash),
	infbar2									= new.bool(mainIni.visual.infbar2),
	chatHelper								= new.bool(mainIni.visual.chatHelper),

	checkupdate 							= new.bool(mainIni.menu.checkUpdate),
	lang 									= new.int(mainIni.menu.language),
	lang_menu 								= new.bool(mainIni.menu.language_menu), --0/1 - eng/rus
	lang_chat 								= new.bool(mainIni.menu.language_chat), --0/1 - eng/rus
	lang_visual								= new.bool(mainIni.menu.language_visual), --0/1 - eng/rus
	AutoSave 								= new.bool(mainIni.menu.autoSave),
	comboStyle 								= new.int(mainIni.menu.iStyle),
	typeToggle								= new.int(mainIni.menu.typeToggle),

	notifications							= new.bool(mainIni.notifications.notifications),
	NactorGM								= new.bool(mainIni.notifications.NactorGM),
	NvehGM									= new.bool(mainIni.notifications.NvehGM),
	NplusC									= new.bool(mainIni.notifications.NplusC),
	Nairbrake								= new.bool(mainIni.notifications.Nairbrake),
	Nwh										= new.bool(mainIni.notifications.Nwh),

	dev_dialogid							= new.bool(mainIni.developers.dialogId),
	dev_textdraw							= new.bool(mainIni.developers.textdraw),
	dev_gametext							= new.bool(mainIni.developers.gametext),
	dev_anim								= new.bool(mainIni.developers.animations),

	rv_fixchat								= new.bool(mainIni.reventrp.fixchat),
	rv_venable								= new.bool(mainIni.reventrp.venable),
	rv_line									= new.bool(mainIni.reventrp.vline),
	rvsearchCorpse							= new.bool(mainIni.reventrp.searchCorpse),
	rvsearchHorseshoe						= new.bool(mainIni.reventrp.searchHorseshoe),
	rvsearchTotems							= new.bool(mainIni.reventrp.searchTotems),
	rvsearchCont							= new.bool(mainIni.reventrp.searchContainers),
	rv_rainbow								= new.bool(mainIni.reventrp.vrainbow),
	rv_speed								= new.int(mainIni.reventrp.vspeed),

	arz_passacc								= new.char[33](mainIni.arizonarp.passAcc),
	arz_pincode								= new.int(mainIni.arizonarp.pincode),
	arz_fastreport							= new.bool(mainIni.arizonarp.report),
	arz_venable								= new.bool(mainIni.arizonarp.venable),
	arz_vline								= new.bool(mainIni.arizonarp.vline),
	arzsearchGuns							= new.bool(mainIni.arizonarp.searchGuns),
	arzsearchSeed							= new.bool(mainIni.arizonarp.searchSeed),
	arzsearchDeer							= new.bool(mainIni.arizonarp.searchDeer),
	arzsearchDrugs							= new.bool(mainIni.arizonarp.searchDrugs),
	arzsearchGift							= new.bool(mainIni.arizonarp.searchGift),
	arzsearchTreasure						= new.bool(mainIni.arizonarp.searchTreasure),
	arzsearchMats							= new.bool(mainIni.arizonarp.searchMats),
	arz_rainbow								= new.bool(mainIni.arizonarp.vrainbow),
	arz_speed								= new.int(mainIni.arizonarp.vspeed),
	arz_autoskiprep							= new.bool(mainIni.arizonarp.autoSkipReport),
	arz_launcher							= new.bool(mainIni.arizonarp.emulateLauncher)
}
local isTypeToggle0, isTypeToggle1, isTypeToggle2 = new.bool(false), new.bool(false), new.bool(false)

function setInterfaceStyle(id)
	imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
	local ImVec4 = imgui.ImVec4
	local ImVec2 = imgui.ImVec2

	style.WindowPadding         = imgui.ImVec2(8, 8)
    style.WindowRounding        = 15
    style.ChildRounding   		= 5
    style.FramePadding          = imgui.ImVec2(5, 3)
    style.FrameRounding         = 3.0
    style.IndentSpacing         = 21
    style.ScrollbarSize         = 10.0
    style.ScrollbarRounding     = 13
    style.GrabMinSize           = 8
    style.GrabRounding          = 1
    style.WindowTitleAlign      = imgui.ImVec2(0.5, 0.5)
    style.ButtonTextAlign       = imgui.ImVec2(0.0, 0.5)
	if id == 0 then
		colors[clr.Text] 					= ImVec4(0.80, 0.80, 0.83, 1.00)
		colors[clr.TextDisabled] 			= ImVec4(0.24, 0.23, 0.29, 1.00)
		colors[clr.WindowBg] 				= ImVec4(0.06, 0.05, 0.07, 1.00)
		colors[clr.ChildBg] 				= ImVec4(0.07, 0.07, 0.09, 1.00)
		colors[clr.PopupBg]				 	= ImVec4(0.07, 0.07, 0.09, 1.00)
		colors[clr.Border]					= ImVec4(0.80, 0.80, 0.83, 0.88)
		colors[clr.BorderShadow] 			= ImVec4(0.92, 0.91, 0.88, 0.00)
		colors[clr.FrameBg] 				= ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[clr.FrameBgHovered] 			= ImVec4(0.24, 0.23, 0.29, 1.00)
		colors[clr.FrameBgActive] 			= ImVec4(0.56, 0.56, 0.58, 1.00)
		colors[clr.TitleBg] 				= ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[clr.TitleBgCollapsed] 		= ImVec4(1.00, 0.98, 0.95, 0.75)
		colors[clr.TitleBgActive] 			= ImVec4(0.07, 0.07, 0.09, 1.00)
		colors[clr.MenuBarBg] 				= ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[clr.ScrollbarBg] 			= ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[clr.ScrollbarGrab] 			= ImVec4(0.80, 0.80, 0.83, 0.31)
		colors[clr.ScrollbarGrabHovered] 	= ImVec4(0.56, 0.56, 0.58, 1.00)
		colors[clr.ScrollbarGrabActive] 	= ImVec4(0.06, 0.05, 0.07, 1.00)
		colors[clr.CheckMark]				= ImVec4(0.80, 0.80, 0.83, 0.31)
		colors[clr.SliderGrab] 				= ImVec4(0.80, 0.80, 0.83, 0.31)
		colors[clr.SliderGrabActive] 		= ImVec4(0.06, 0.05, 0.07, 1.00)
		colors[clr.Button]					= ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[clr.ButtonHovered] 			= ImVec4(0.24, 0.23, 0.29, 1.00)
		colors[clr.ButtonActive] 			= ImVec4(0.56, 0.56, 0.58, 1.00)
		colors[clr.Header] 					= ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[clr.HeaderHovered] 			= ImVec4(0.56, 0.56, 0.58, 1.00)
		colors[clr.HeaderActive] 			= ImVec4(0.06, 0.05, 0.07, 1.00)
		colors[clr.Separator]            	= ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[clr.SeparatorHovered]     	= ImVec4(0.56, 0.56, 0.58, 1.00)
		colors[clr.SeparatorActive]      	= ImVec4(0.06, 0.05, 0.07, 1.00)
		colors[clr.ResizeGrip] 				= ImVec4(0.00, 0.00, 0.00, 0.00)
		colors[clr.ResizeGripHovered] 		= ImVec4(0.56, 0.56, 0.58, 1.00)
		colors[clr.ResizeGripActive] 		= ImVec4(0.06, 0.05, 0.07, 1.00)
		colors[clr.PlotLines] 				= ImVec4(0.40, 0.39, 0.38, 0.63)
		colors[clr.PlotLinesHovered] 		= ImVec4(0.25, 1.00, 0.00, 1.00)
		colors[clr.PlotHistogram]			= ImVec4(0.40, 0.39, 0.38, 0.63)
		colors[clr.PlotHistogramHovered] 	= ImVec4(0.25, 1.00, 0.00, 1.00)
		colors[clr.TextSelectedBg]			= ImVec4(0.25, 1.00, 0.00, 0.43)
		colors[clr.ModalWindowDimBg]		= ImVec4(1.00, 0.98, 0.95, 0.73)
	elseif id == 1 then
		colors[clr.Text]   				  	= ImVec4(0.00, 0.00, 0.00, 0.85)
		colors[clr.TextDisabled]  		  	= ImVec4(0.24, 0.24, 0.24, 1.00)
		colors[clr.WindowBg]              	= ImVec4(0.90, 0.90, 0.90, 1.00)
		colors[clr.ChildBg]        		  	= ImVec4(0.86, 0.86, 0.86, 1.00)
		colors[clr.PopupBg]               	= ImVec4(0.82, 0.82, 0.82, 1.00)
		colors[clr.Border]                	= ImVec4(0.76, 0.76, 0.76, 1.00)
		colors[clr.BorderShadow]          	= ImVec4(0.00, 0.00, 0.00, 0.40)
		colors[clr.FrameBg]              	= ImVec4(0.78, 0.78, 0.78, 1.00)
		colors[clr.FrameBgHovered]       	= ImVec4(0.72, 0.72, 0.72, 1.00)
		colors[clr.FrameBgActive]        	= ImVec4(0.66, 0.66, 0.66, 1.00)
		colors[clr.TitleBg]              	= ImVec4(0.00, 0.45, 1.00, 0.82)
		colors[clr.TitleBgCollapsed]     	= ImVec4(0.00, 0.45, 1.00, 0.82)
		colors[clr.TitleBgActive]       	= ImVec4(0.00, 0.45, 1.00, 0.82)
		colors[clr.MenuBarBg]             	= ImVec4(0.00, 0.37, 0.78, 1.00)
		colors[clr.ScrollbarBg]           	= ImVec4(0.00, 0.00, 0.00, 0.00)
		colors[clr.ScrollbarGrab]         	= ImVec4(0.00, 0.35, 1.00, 0.78)
		colors[clr.ScrollbarGrabHovered]  	= ImVec4(0.00, 0.33, 1.00, 0.84)
		colors[clr.ScrollbarGrabActive]   	= ImVec4(0.00, 0.31, 1.00, 0.88)
		colors[clr.CheckMark]            	= ImVec4(0.00, 0.49, 1.00, 0.59)
		colors[clr.SliderGrab]           	= ImVec4(0.00, 0.49, 1.00, 0.59)
		colors[clr.SliderGrabActive]     	= ImVec4(0.00, 0.39, 1.00, 0.71)
		colors[clr.Button]               	= ImVec4(0.00, 0.49, 1.00, 0.59)
		colors[clr.ButtonHovered]         	= ImVec4(0.00, 0.49, 1.00, 0.71)
		colors[clr.ButtonActive]          	= ImVec4(0.00, 0.49, 1.00, 0.78)
		colors[clr.Header]                	= ImVec4(0.00, 0.49, 1.00, 0.78)
		colors[clr.HeaderHovered]         	= ImVec4(0.00, 0.49, 1.00, 0.71)
		colors[clr.HeaderActive]          	= ImVec4(0.00, 0.49, 1.00, 0.78)
		colors[clr.Separator]             	= ImVec4(0.00, 0.49, 1.00, 0.78)
		colors[clr.SeparatorHovered]      	= ImVec4(0.00, 0.49, 1.00, 0.71)
		colors[clr.SeparatorActive]       	= ImVec4(0.00, 0.49, 1.00, 0.78)
		colors[clr.ResizeGrip]            	= ImVec4(0.00, 0.39, 1.00, 0.59)
		colors[clr.ResizeGripHovered]     	= ImVec4(0.00, 0.27, 1.00, 0.59)
		colors[clr.ResizeGripActive]      	= ImVec4(0.00, 0.25, 1.00, 0.63)
		colors[clr.PlotLines]             	= ImVec4(0.00, 0.39, 1.00, 0.75)
		colors[clr.PlotLinesHovered]      	= ImVec4(0.00, 0.39, 1.00, 0.75)
		colors[clr.PlotHistogram]         	= ImVec4(0.00, 0.39, 1.00, 0.75)
		colors[clr.PlotHistogramHovered]  	= ImVec4(0.00, 0.35, 0.92, 0.78)
		colors[clr.TextSelectedBg]        	= ImVec4(0.00, 0.47, 1.00, 0.59)
		colors[clr.ModalWindowDimBg]  	  	= ImVec4(0.20, 0.20, 0.20, 0.35)
	elseif id == 2 then
		colors[clr.Text]   				  = ImVec4(0.00, 0.00, 0.00, 0.80)
		colors[clr.TextDisabled]  		  = ImVec4(0.24, 0.24, 0.24, 1.00)
		colors[clr.WindowBg]              = ImVec4(0.90, 0.90, 0.90, 1.00)
		colors[clr.ChildBg]         	  = ImVec4(0.86, 0.86, 0.86, 1.00)
		colors[clr.PopupBg]               = ImVec4(0.82, 0.82, 0.82, 1.00)
		colors[clr.Border]                = ImVec4(0.76, 0.76, 0.76, 1.00)
		colors[clr.BorderShadow]          = ImVec4(0.00, 0.00, 0.00, 0.40)
		colors[clr.FrameBg]               = ImVec4(0.78, 0.78, 0.78, 1.00)
		colors[clr.FrameBgHovered]        = ImVec4(0.72, 0.72, 0.72, 1.00)
		colors[clr.FrameBgActive]         = ImVec4(0.66, 0.66, 0.66, 1.00)
		colors[clr.TitleBg]               = ImVec4(0.45, 0.00, 1.00, 0.82)
		colors[clr.TitleBgCollapsed]      = ImVec4(0.45, 0.00, 1.00, 0.82)
		colors[clr.TitleBgActive]         = ImVec4(0.45, 0.00, 1.00, 0.82)
		colors[clr.MenuBarBg]             = ImVec4(0.37, 0.00, 0.78, 1.00)
		colors[clr.ScrollbarBg]           = ImVec4(0.00, 0.00, 0.00, 0.00)
		colors[clr.ScrollbarGrab]         = ImVec4(0.35, 0.00, 1.00, 0.78)
		colors[clr.ScrollbarGrabHovered]  = ImVec4(0.33, 0.00, 1.00, 0.84)
		colors[clr.ScrollbarGrabActive]   = ImVec4(0.31, 0.00, 1.00, 0.88)
		colors[clr.CheckMark]             = ImVec4(0.49, 0.00, 1.00, 0.59)
		colors[clr.SliderGrab]            = ImVec4(0.49, 0.00, 1.00, 0.59)
		colors[clr.SliderGrabActive]      = ImVec4(0.39, 0.00, 1.00, 0.71)
		colors[clr.Button]                = ImVec4(0.49, 0.00, 1.00, 0.59)
		colors[clr.ButtonHovered]         = ImVec4(0.49, 0.00, 1.00, 0.71)
		colors[clr.ButtonActive]          = ImVec4(0.49, 0.00, 1.00, 0.78)
		colors[clr.Header]                = ImVec4(0.49, 0.00, 1.00, 0.78)
		colors[clr.HeaderHovered]         = ImVec4(0.49, 0.00, 1.00, 0.71)
		colors[clr.HeaderActive]          = ImVec4(0.49, 0.00, 1.00, 0.78)
		colors[clr.Separator]             = ImVec4(0.49, 0.00, 1.00, 0.78)
		colors[clr.SeparatorHovered]      = ImVec4(0.49, 0.00, 1.00, 0.71)
		colors[clr.SeparatorActive]       = ImVec4(0.49, 0.00, 1.00, 0.78)
		colors[clr.ResizeGrip]            = ImVec4(0.39, 0.00, 1.00, 0.59)
		colors[clr.ResizeGripHovered]     = ImVec4(0.27, 0.00, 1.00, 0.59)
		colors[clr.ResizeGripActive]      = ImVec4(0.25, 0.00, 1.00, 0.63)
		colors[clr.PlotLines]             = ImVec4(0.39, 0.00, 1.00, 0.75)
		colors[clr.PlotLinesHovered]      = ImVec4(0.39, 0.00, 1.00, 0.75)
		colors[clr.PlotHistogram]         = ImVec4(0.39, 0.00, 1.00, 0.75)
		colors[clr.PlotHistogramHovered]  = ImVec4(0.35, 0.00, 0.92, 0.78)
		colors[clr.TextSelectedBg]        = ImVec4(0.47, 0.00, 1.00, 0.59)
		colors[clr.ModalWindowDimBg]  	  = ImVec4(0.20, 0.20, 0.20, 0.35)
	elseif id == 3 then
		colors[clr.Text] 				  	= ImVec4(0.95, 0.96, 0.98, 1.00)
		colors[clr.TextDisabled] 			= ImVec4(0.36, 0.42, 0.47, 1.00)
		colors[clr.WindowBg] 				= ImVec4(0.11, 0.15, 0.17, 1.00)
		colors[clr.ChildBg] 				= ImVec4(0.15, 0.18, 0.22, 1.00)
		colors[clr.PopupBg] 				= ImVec4(0.08, 0.08, 0.08, 0.94)
		colors[clr.Border] 					= ImVec4(0.43, 0.43, 0.50, 0.50)
		colors[clr.BorderShadow] 			= ImVec4(0.00, 0.00, 0.00, 0.00)
		colors[clr.FrameBg] 				= ImVec4(0.20, 0.25, 0.29, 1.00)
		colors[clr.FrameBgHovered] 			= ImVec4(0.12, 0.20, 0.28, 1.00)
		colors[clr.FrameBgActive] 			= ImVec4(0.09, 0.12, 0.14, 1.00)
		colors[clr.TitleBg] 				= ImVec4(0.09, 0.12, 0.14, 0.65)
		colors[clr.TitleBgCollapsed] 		= ImVec4(0.00, 0.00, 0.00, 0.51)
		colors[clr.TitleBgActive] 			= ImVec4(0.08, 0.10, 0.12, 1.00)
		colors[clr.MenuBarBg] 				= ImVec4(0.15, 0.18, 0.22, 1.00)
		colors[clr.ScrollbarBg] 			= ImVec4(0.02, 0.02, 0.02, 0.39)
		colors[clr.ScrollbarGrab] 			= ImVec4(0.20, 0.25, 0.29, 1.00)
		colors[clr.ScrollbarGrabHovered] 	= ImVec4(0.18, 0.22, 0.25, 1.00)
		colors[clr.ScrollbarGrabActive] 	= ImVec4(0.09, 0.21, 0.31, 1.00)
		colors[clr.CheckMark] 				= ImVec4(0.28, 0.56, 1.00, 1.00)
		colors[clr.SliderGrab] 				= ImVec4(0.28, 0.56, 1.00, 1.00)
		colors[clr.SliderGrabActive] 		= ImVec4(0.37, 0.61, 1.00, 1.00)
		colors[clr.Button] 					= ImVec4(0.20, 0.25, 0.29, 1.00)
		colors[clr.ButtonHovered] 			= ImVec4(0.28, 0.56, 1.00, 1.00)
		colors[clr.ButtonActive] 			= ImVec4(0.06, 0.53, 0.98, 1.00)
		colors[clr.Header] 					= ImVec4(0.20, 0.25, 0.29, 0.55)
		colors[clr.HeaderHovered] 			= ImVec4(0.26, 0.59, 0.98, 0.80)
		colors[clr.HeaderActive] 			= ImVec4(0.26, 0.59, 0.98, 1.00)
		colors[clr.Separator]             	= ImVec4(0.20, 0.25, 0.29, 0.55)
		colors[clr.SeparatorHovered]      	= ImVec4(0.26, 0.59, 0.98, 0.80)
		colors[clr.SeparatorActive]       	= ImVec4(0.26, 0.59, 0.98, 1.00)
		colors[clr.ResizeGrip] 				= ImVec4(0.26, 0.59, 0.98, 0.25)
		colors[clr.ResizeGripHovered] 		= ImVec4(0.26, 0.59, 0.98, 0.67)
		colors[clr.ResizeGripActive] 		= ImVec4(0.06, 0.05, 0.07, 1.00)
		colors[clr.PlotLines] 				= ImVec4(0.61, 0.61, 0.61, 1.00)
		colors[clr.PlotLinesHovered] 		= ImVec4(1.00, 0.43, 0.35, 1.00)
		colors[clr.PlotHistogram] 			= ImVec4(0.90, 0.70, 0.00, 1.00)
		colors[clr.PlotHistogramHovered] 	= ImVec4(1.00, 0.60, 0.00, 1.00)
		colors[clr.TextSelectedBg] 			= ImVec4(0.25, 1.00, 0.00, 0.43)
		colors[clr.ModalWindowDimBg] 		= ImVec4(1.00, 0.98, 0.95, 0.73)
	elseif id == 4 then
		colors[clr.Text] = ImVec4(0.860, 0.930, 0.890, 0.78)
		colors[clr.TextDisabled] = ImVec4(0.860, 0.930, 0.890, 0.28)
		colors[clr.WindowBg] = ImVec4(0.13, 0.14, 0.17, 1.00)
		colors[clr.ChildBg] = ImVec4(0.200, 0.220, 0.270, 0.58)
		colors[clr.PopupBg] = ImVec4(0.200, 0.220, 0.270, 0.9)
		colors[clr.Border] = ImVec4(0.31, 0.31, 1.00, 0.00)
		colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
		colors[clr.FrameBg] = ImVec4(0.200, 0.220, 0.270, 1.00)
		colors[clr.FrameBgHovered] = ImVec4(0.455, 0.198, 0.301, 0.78)
		colors[clr.FrameBgActive] = ImVec4(0.455, 0.198, 0.301, 1.00)
		colors[clr.TitleBg] = ImVec4(0.232, 0.201, 0.271, 1.00)
		colors[clr.TitleBgActive] = ImVec4(0.502, 0.075, 0.256, 1.00)
		colors[clr.TitleBgCollapsed] = ImVec4(0.200, 0.220, 0.270, 0.75)
		colors[clr.MenuBarBg] = ImVec4(0.200, 0.220, 0.270, 0.47)
		colors[clr.ScrollbarBg] = ImVec4(0.200, 0.220, 0.270, 1.00)
		colors[clr.ScrollbarGrab] = ImVec4(0.09, 0.15, 0.1, 1.00)
		colors[clr.ScrollbarGrabHovered] = ImVec4(0.455, 0.198, 0.301, 0.78)
		colors[clr.ScrollbarGrabActive] = ImVec4(0.455, 0.198, 0.301, 1.00)
		colors[clr.CheckMark] = ImVec4(0.71, 0.22, 0.27, 1.00)
		colors[clr.SliderGrab] = ImVec4(0.47, 0.77, 0.83, 0.14)
		colors[clr.SliderGrabActive] = ImVec4(0.71, 0.22, 0.27, 1.00)
		colors[clr.Button] = ImVec4(0.47, 0.77, 0.83, 0.14)
		colors[clr.ButtonHovered] = ImVec4(0.455, 0.198, 0.301, 0.86)
		colors[clr.ButtonActive] = ImVec4(0.455, 0.198, 0.301, 1.00)
		colors[clr.Header] = ImVec4(0.455, 0.198, 0.301, 0.76)
		colors[clr.HeaderHovered] = ImVec4(0.455, 0.198, 0.301, 0.86)
		colors[clr.HeaderActive] = ImVec4(0.502, 0.075, 0.256, 1.00)
		colors[clr.Separator]             = ImVec4(0.455, 0.198, 0.301, 0.76)
		colors[clr.SeparatorHovered]      = ImVec4(0.455, 0.198, 0.301, 0.86)
		colors[clr.SeparatorActive]       = ImVec4(0.502, 0.075, 0.256, 1.00)
		colors[clr.ResizeGrip] = ImVec4(0.47, 0.77, 0.83, 0.04)
		colors[clr.ResizeGripHovered] = ImVec4(0.455, 0.198, 0.301, 0.78)
		colors[clr.ResizeGripActive] = ImVec4(0.455, 0.198, 0.301, 1.00)
		colors[clr.PlotLines] = ImVec4(0.860, 0.930, 0.890, 0.63)
		colors[clr.PlotLinesHovered] = ImVec4(0.455, 0.198, 0.301, 1.00)
		colors[clr.PlotHistogram] = ImVec4(0.860, 0.930, 0.890, 0.63)
		colors[clr.PlotHistogramHovered] = ImVec4(0.455, 0.198, 0.301, 1.00)
		colors[clr.TextSelectedBg] = ImVec4(0.455, 0.198, 0.301, 0.43)
		colors[clr.ModalWindowDimBg] = ImVec4(0.200, 0.220, 0.270, 0.73)
	end
end

function main()
	if not isSampLoaded() and not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(40) end
	if not doesFileExist('moonloader/config/CheatsByNyhfox.ini') then inicfg.save(mainIni, 'CheatsByNyhfox.ini') end
	ifont_height = (((pw == 1680 or pw == 1600 or pw == 1440) and 8) or ((pw == 1366 or pw == 1360 or pw == 1280 or pw == 1152 or pw == 1024) and 7) or ((pw == 800 or pw == 720 or pw == 640) and 6)) or 9
	ifont = renderCreateFont("Verdana", ifont_height, 5)
	ibY = (((pw == 1366 or pw == 1360) and 17) or ((pw == 1366 or pw == 1360) and 17) or ((pw == 1280 or pw == 1152 or pw == 1024) and 16) or ((pw == 800 or pw == 720 or pw == 640) and 14)) or 18
	clickfont = renderCreateFont("Tahoma", 10, FCR_BOLD + FCR_BORDER)
	rfont = renderCreateFont('Verdata', 7, 5)

	if array.checkupdate[0] then autoupdate(jsn_upd, tag, url_upd)
	else sampAddChatMessage(tag..(array.lang_chat[0] and 'Ó Âàñ âûêëþ÷åíî àâòîîáíîâëåíèå. Âû èñïîëüçóåòå âåðñèþ: {F9D82F}'..version_script..' {888EA0}| Ìåíþ: {F9D82F}F10' or 'You have disabled autoupdate. You are using version: {F9D82F}'..version_script..' {888EA0}| Menu: {F9D82F}F10') ,colors.chat.main) end

	sampRegisterChatCommand('zdate', function() sampAddChatMessage(os.date(array.lang_chat[0] and tag..'Ñåãîäíÿøíÿÿ äàòà: {F9D82F}%d.%m.%Y' or tag..'Todays date: {F9D82F}%d.%m.%Y'), colors.chat.main) end)
	sampRegisterChatCommand('zmenu', function() array.main_window_state[0] = not array.main_window_state[0] sampAddChatMessage(tag..(array.lang_chat[0] and 'Âû {F9D82F}îòêðûëè/çàêðûëè {888EA0}ìåíþ ñêðèïòà. Ýòî ìîæíî ñäåëàòü áåç êîìàíäû, èñïîëüçóéòå êëàâèøó {F9D82F}F10' or 'You is {F9D82F}open/close {888EA0}script menu. This can be done without a command, using the key {F9D82F}F10'), colors.chat.main) end)
	sampRegisterChatCommand('zsuicide', function()
		if not isPlayerDead(PLAYER_PED) then
			if not isCharInAnyCar(PLAYER_PED) then
				setCharHealth(PLAYER_PED, 0)
			else
				local myCar = storeCarCharIsInNoSave(PLAYER_PED)
				setCarHealth(myCar, -1)
				markCarAsNoLongerNeeded(myCar)
			end
		end
	end)
	sampRegisterChatCommand('zcoord', function()
		if not isPlayerDead(PLAYER_PED) then
			x, y, z = getCharCoordinates(PLAYER_PED)
			sampAddChatMessage(tag..(array.lang_chat[0] and 'Âàøè êîîðäèíàòû: X: {F9D82F}' .. math.floor(x) .. '{888EA0} | Y: {F9D82F}' .. math.floor(y) .. '{888EA0} | Z: {F9D82F}' .. math.floor (z) or 'You are coords: X: {F9D82F}' .. math.floor(x) .. '{888EA0} | Y: {F9D82F}' .. math.floor(y) .. '{888EA0} | Z: {F9D82F}' .. math.floor (z)), colors.chat.main)
		else
			sampAddChatMessage(tag..(array.lang_chat[0] and '{B31A06}Îøèáêà: {888EA0}Âàø èãðîê ìåðòâ/íå ñóùåñòâóåò' or '{B31A06}Error: {888EA0}You are player is dead/not playing'), colors.chat.main)
		end
	end)
	sampRegisterChatCommand('zgetmoney', function()
		if not isPlayerDead(PLAYER_PED) then
			local money = mem.getint32(0xB7CE50)
			mem.setint32(0xB7CE50, money + 1000, false)
			sampAddChatMessage(tag..(array.lang_chat[0] and 'Âàì âûäàíî: {F9D82F}1.000$ {888EA0}(Âèçóàëüíî)' or 'Issued to you: {F9D82F}1.000$ {888EA0}(Visual)'), colors.chat.main)
		else
			sampAddChatMessage(tag..(array.lang_chat[0] and '{B31A06}Îøèáêà: {888EA0}Âàø èãðîê ìåðòâ/íå ñóùåñòâóåò' or '{B31A06}Error: {888EA0}You are player is dead/not playing'), colors.chat.main)
		end
	end)
	sampRegisterChatCommand('zrepair', function(arg)
		if isPlayerPlaying(PLAYER_PED) and not isPlayerDead(PLAYER_PED) and isCharInAnyCar(PLAYER_PED) then
			local myCar = storeCarCharIsInNoSave(PLAYER_PED)
			if #arg == 0 then
				fixCar(myCar)
				if getServer('revent') then sampAddChatMessage(' Âû ïî÷èíèëè òðàíñïîðò!', 16113331) else printStringNow('Fixed vehicle ~g~1000 HP', 1000) end
			elseif arg == 'max' then
				fixCar(myCar); setCarHealth(myCar, 1410065408)
				if getServer('revent') then sampAddChatMessage(' Âû ïî÷èíèëè òðàíñïîðò!', 16113331) else printStringNow('Fixed vehicle ~g~1410065408 HP', 1000) end
			else
				fixCar(myCar); setCarHealth(myCar, arg)
				if getServer('revent') then sampAddChatMessage(' Âû ïî÷èíèëè òðàíñïîðò!', 16113331) else printStringNow('Fixed vehicle ~g~'..arg..' HP', 1000) end
			end
		else
			sampAddChatMessage(tag..(array.lang_chat[0] and '{B31A06}Îøèáêà: {888EA0}Âàø èãðîê ìåðòâ/íå ñóùåñòâóåò èëè íå â òðàíñïîðòå' or '{B31A06}Error: {888EA0}You are player is dead/not playing or is not in vehicle'), colors.chat.main)
		end
	end)
	sampRegisterChatCommand('ztime', function(param)
		local hour = tonumber(param)
		if hour ~= nil and hour >= 0 and hour <= 23 then
			patch_samp_time_set(true)
			sampAddChatMessage(tag..(array.lang_chat[0] and 'Âðåìÿ èçìåíåíî íà {F9D82F}'..hour or 'Time change to {F9D82F}'..hour), colors.chat.main)
		else
			patch_samp_time_set(false)
			hour = nil
			sampAddChatMessage(tag..(array.lang_chat[0] and '{B31A06}Îøèáêà: {888EA0}Íå íàéäåíî âðåìÿ. Èñïîëüçóéòå: {0984d2}/ztime 0-23' or '{B31A06}Error: {888EA0}Time not found. Use: {0984d2}/ztime 0-23{888EA0})'), colors.chat.main)
		end
		setTimeOfDay(hour, 0)
	end)
	sampRegisterChatCommand('zweather', function(param)
		local weather = tonumber(param)
		if weather ~= nil and weather >= 0 and weather <= 45 then
			forceWeatherNow(weather)
			sampAddChatMessage(tag..(array.lang_chat[0] and 'Ïîãîäà èçìåíåíà íà {F9D82F}¹'..weather or 'Weather change on {F9D82F}¹'..weather), colors.chat.main)
		else
			sampAddChatMessage(tag..(array.lang_chat[0] and '{B31A06}Îøèáêà: {888EA0}Ïîãîäà íå íàéäåíà. Èñïîëüçóéòå: {0984d2}/zweather 0-45' or '{B31A06}Error: {888EA0}Weather not found. Use: {0984d2}/zweather 0-45'), colors.chat.main)
		end
	end)
	sampRegisterChatCommand('zhelp', function() if not array.main_window_state[0] then array.main_window_state[0] = true act1 = 8 elseif array.main_window_state[0] then act1 = 8 end end)
	sampRegisterChatCommand('zsetmark', function(arg)
		if #arg == 0 then
			intMark = getActiveInterior(PLAYER_PED)
			local posX, posY, posZ = getCharCoordinates(PLAYER_PED)
			setmark = {posX, posY, posZ}
			sampAddChatMessage(tag..(array.lang_chat[0] and 'Ñîçäàíà ìåòêà ïî êîîðäèíàòàì: X: {F9D82F}'..math.floor(setmark[1])..'{888EA0} | Y: {F9D82F}'..math.floor(setmark[2])..'{888EA0} | Z: {F9D82F}'..math.floor(setmark[3]) or 'Create mark by coords: X: {F9D82F}'..math.floor(setmark[1])..'{888EA0} | Y: {F9D82F}'..math.floor(setmark[2])..'{888EA0} | Z: {F9D82F}'..math.floor(setmark[3])), colors.chat.main)
			sampAddChatMessage(tag..(array.lang_chat[0] and 'Èíòåðüåð: {F9D82F}'..intMark or 'Interior: {F9D82F}'..intMark), colors.chat.main)
		else
			local arg = split(arg, '%s+', false)
			if arg[1] ~= nil and arg[2] ~= nil and arg[3] ~= nil then
				intMark = arg[4] or 0
				setmark = {arg[1], arg[2], arg[3]}
				sampAddChatMessage(tag..(array.lang_chat[0] and 'Ñîçäàíà ìåòêà ïî êîîðäèíàòàì: X: {F9D82F}'..math.floor(setmark[1])..'{888EA0} | Y: {F9D82F}'..math.floor(setmark[2])..'{888EA0} | Z: {F9D82F}'..math.floor(setmark[3]) or 'Create mark by coords: X: {F9D82F}'..math.floor(setmark[1])..'{888EA0} | Y: {F9D82F}'..math.floor(setmark[2])..'{888EA0} | Z: {F9D82F}'..math.floor(setmark[3])), colors.chat.main)
				sampAddChatMessage(tag..(array.lang_chat[0] and 'Èíòåðüåð: {F9D82F}'..intMark or 'Interior: {F9D82F}'..intMark), colors.chat.main)
			end
		end
	end)
	sampRegisterChatCommand('ztpmark', function()
		if setmark then
			teleportInterior(PLAYER_PED, setmark[1], setmark[2], setmark[3], intMark)
			sampAddChatMessage(tag..(array.lang_chat[0] and 'Âû òåëåïîðòèðîâàëèñü ïî ìåòêå' or 'You are teleport to mark'), colors.chat.main)
		else
			sampAddChatMessage(tag..(array.lang_chat[0] and '{B31A06}Îøèáêà: {888EA0}Ìåòêà íå ñîçäàíà' or '{B31A06}Error: {888EA0}Mark not create'), colors.chat.main)
		end
	end)
	sampRegisterChatCommand('zcc', function() mem.fill(sampGetChatInfoPtr() + 306, 0x0, 25200) mem.write(sampGetChatInfoPtr() + 306, 25562, 4, 0x0) mem.write(sampGetChatInfoPtr() + 0x63DA, 1, 1) end)
	sampRegisterChatCommand('zchecktime', function() local time = getTime(0) sampAddChatMessage(tag..(array.lang_chat[0] and 'Òî÷íîå âðåìÿ ïî ÌÑÊ: {F9D82F}' or 'Exact time to MSK: {F9D82F}')..os.date('%H{888EA0}:{F9D82F}%M{888EA0}:{F9D82F}%S', time), colors.chat.main) end)
	sampRegisterChatCommand('zreload', function() thisScript():reload() end)
	sampRegisterChatCommand('zfps', function() local ifps = string.format('%d', mem.getfloat(0xB7CB50, 4, false)) sampAddChatMessage(tag..(array.lang_chat[0] and 'Ñåé÷àñ FPS: {F9D82F}'..ifps or 'FPS now: {F9D82F}'..ifps), colors.chat.main) end)
	sampRegisterChatCommand('ztpgta', function()
		if tBlipResult then
			setCharCoordinatesDontResetAnim(PLAYER_PED, tbX, tbY, tbZ + 1.0)
		end
	end)

	addEventHandler("onWindowMessage", function (msg, wparam, lparam)
		if msg == wm.WM_MBUTTONDOWN and array.show_imgui_clickwarp[0] and not isSampfuncsConsoleActive() and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() then
			checkfuncs.others.Clickwarp = not checkfuncs.others.Clickwarp
			sampSetCursorMode(checkfuncs.others.Clickwarp and 2 or 0)
		end
		if (msg == wm.WM_KEYDOWN or msg == wm.WM_SYSKEYDOWN) and wparam == key.VK_ESCAPE and array.main_window_state[0] then
			array.main_window_state[0] = false
			consumeWindowMessage(true, true)
		end
		if (msg == wm.WM_KEYUP or msg == wm.WM_SYSKEYUP) and not isSampfuncsConsoleActive() and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() then
			if wparam == key.VK_F12 then
				checkfuncs.main.enabled = not checkfuncs.main.enabled
				if array.main_window_state[0] then array.main_window_state[0] = false end
			end
			if checkfuncs.main.enabled then
				if wparam == key.VK_F10 then array.main_window_state[0] = not array.main_window_state[0] end
				if wparam == key.VK_F11 then checkfuncs.main.activecursor = not checkfuncs.main.activecursor end
				if wparam == key.VK_INSERT and array.show_imgui_gmActor[0] then
					checkfuncs.others.GMactor = not checkfuncs.others.GMactor
					if array.notifications[0] and array.NactorGM[0] then
						printStringNow(checkfuncs.others.GMactor and 'Actor GM ~g~ON' or 'Actor GM ~r~OFF', 1000)
					end
				end
				if wparam == key.VK_R and array.show_imgui_plusC[0] then
					checkfuncs.others.PlusC = not checkfuncs.others.PlusC
					if array.notifications[0] and array.NplusC[0] then
						printStringNow(checkfuncs.others.PlusC and '+C ~g~ON' or '+C ~r~OFF', 1000)
					end
				end
				if wparam == key.VK_HOME and array.show_imgui_gmVeh[0] then
					checkfuncs.others.GMveh = not checkfuncs.others.GMveh
					checkfuncs.others.GMWveh = not checkfuncs.others.GMWveh
					if array.notifications[0] and array.NvehGM[0] then
						printStringNow((checkfuncs.others.GMveh or checkfuncs.others.GMWveh) and 'Vehicle GM ~g~ON' or 'Vehicle GM ~r~OFF', 1000)
					end
				end
				if wparam == key.VK_5 and array.show_imgui_keyWH[0] then
					checkfuncs.others.KeyWH = not checkfuncs.others.KeyWH
					if array.notifications[0] and array.Nwh[0] then
						printStringNow(checkfuncs.others.KeyWH and 'WH ~g~ON' or 'WH ~r~OFF', 1000)
					end
				end
				if wparam == key.VK_OEM_2 and array.show_imgui_unfreeze[0] then
					if isCharInAnyCar(PLAYER_PED) then
						freezeCarPosition(storeCarCharIsInNoSave(PLAYER_PED), false)
					else
						setPlayerControl(PLAYER_HANDLE, true)
						freezeCharPosition(PLAYER_PED, false)
						clearCharTasksImmediately(PLAYER_PED)
					end
					restoreCameraJumpcut()
				end
				if wparam == key.VK_F3 then
					if array.show_imgui_suicideActor[0] and not isCharInAnyCar(PLAYER_PED) then
						setCharHealth(PLAYER_PED, 0)
					else
						sampAddChatMessage(tag..(array.lang_chat[0] and '{B31A06}Îøèáêà: {888EA0}Âàø èãðîê ìåðòâ/íå ñóùåñòâóåò' or '{B31A06}Error: {888EA0}You are player is dead/not playing'), colors.chat.main)
					end
					if array.show_imgui_suicideVeh[0] and isCharInAnyCar(PLAYER_PED) then
						local myCar = storeCarCharIsInNoSave(PLAYER_PED)
						setCarHealth(myCar, 0)
						for i = 0, 3 do burstCarTire(myCar, i) end
						markCarAsNoLongerNeeded(myCar)
					else
						sampAddChatMessage(tag..(array.lang_chat[0] and '{B31A06}Îøèáêà: {888EA0}Âàø èãðîê ìåðòâ/íå ñóùåñòâóåò èëè íå â òðàíñïîðòå' or '{B31A06}Error: {888EA0}You are player is dead/not playing or is not in vehicle'), colors.chat.main)
					end
				end
				if wparam == key.VK_SHIFT and array.show_imgui_AirBrake[0] then
					local scancode = bitex.bextract(lparam, 16, 8)
					if scancode == 54 then
						checkfuncs.others.AirBrake = not checkfuncs.others.AirBrake
						if checkfuncs.others.AirBrake then
							local posX, posY, posZ = getCharCoordinates(PLAYER_PED)
							airBrakeCoords = {posX, posY, posZ, 0.0, 0.0, getCharHeading(PLAYER_PED)}
						end
						if array.notifications[0] and array.Nairbrake[0] then
							printStringNow(checkfuncs.others.AirBrake and 'AirBrake ~g~ON' or 'AirBrake ~r~OFF', 1000)
						end
					end
				end
				if isCharInAnyCar(PLAYER_PED) then
					if wparam == key.VK_N and array.show_imgui_fastexit[0] then
						local posX, posY, posZ = getCarCoordinates(storeCarCharIsInNoSave(PLAYER_PED))
						warpCharFromCarToCoord(PLAYER_PED, posX, posY, posZ)
					end
					if wparam == key.VK_B and array.show_imgui_hopVeh[0] then
						local cVecX, cVecY, cVecZ = getCarSpeedVector(storeCarCharIsInNoSave(PLAYER_PED))
						if cVecZ < 7.0 then applyForceToCar(storeCarCharIsInNoSave(PLAYER_PED), 0.0, 0.0, 0.2, 0.0, 0.0, 0.0) end
					end
					if wparam == key.VK_DELETE and array.show_imgui_flipOnWheels[0] then
						local veh = storeCarCharIsInNoSave(PLAYER_PED)
						local oX, oY, oZ = getOffsetFromCarInWorldCoords(veh, 0.0,  0.0,  0.0)
						setCarCoordinates(veh, oX, oY, oZ)
					end
					if wparam == key.VK_BACK and array.show_imgui_flip180[0] then
						samem.require 'CVehicle'
						samem.require 'CTrain'
						local player_veh = samem.cast('CVehicle **', samem.player_vehicle)
						local veh = player_veh[0]
						if veh ~= samem.nullptr then
							if veh.nVehicleClass == 6 then
								local train = samem.cast('CTrain *', veh)
								train.fTrainSpeed = -train.fTrainSpeed
								return
							end
							local matrix = veh.pMatrix
							matrix.up = -matrix.up
							matrix.right = -matrix.right
							veh.vMoveSpeed = -veh.vMoveSpeed
						end
					end
					if wparam == key.VK_1 and array.show_imgui_restHealthVeh[0] then
						fixCar(storeCarCharIsInNoSave(PLAYER_PED))
					end
				end
			end
		end
	end)

	lua_thread.create(mainfuncs)
	lua_thread.create(waitfuncs)

	while not sampIsLocalPlayerSpawned() do wait(40) end
	gravitation_default = mem.getfloat(0x863984)
	
	while true do
		wait(0)
		mem.setfloat(0x863984, (array.gravitation[0] and array.gravitation_value[0] or gravitation_default), false)
		if not arizoancmds and getServer('arizona') and array.arz_fastreport[0] then
			sampRegisterChatCommand('report', arz_report); sampRegisterChatCommand('rep', arz_report)
			arizoancmds = true
		end
		if not rvcmds and getServer('revent') then
			sampRegisterChatCommand('ztogall', function()
				if getServer('revent') then
					lua_thread.create(function()
						sampSendChat('/togfam')
						sampSendChat('/tognews')
						sampSendChat('/togd')
						sampSendChat('/togphone')
						sampSendChat('/togw')
						wait(250)
						sampAddChatMessage(tag..'Âñåâîçìîæíûå è äîñòóïíûå äëÿ Âàñ êîìàíäû {F9D82F}îòêëþ÷åíû/âêëþ÷åíû', colors.chat.main)
					end)
				end
			end)
			rvcmds = true
		end
	end
end

imgui.OnInitialize(function()
	imgui.GetIO().IniFilename = nil

    local config = imgui.ImFontConfig()
    config.MergeMode, config.PixelSnapH = true, true
    local glyph_ranges = imgui.GetIO().Fonts:GetGlyphRangesCyrillic()
	local iconRanges = new.ImWchar[3](fa.min_range, fa.max_range, 0)
	local glyph_ranges = imgui.GetIO().Fonts:GetGlyphRangesCyrillic()
    local font_path = getFolderPath(0x14) .. '\\trebucbd.ttf'

	imgui.GetIO().Fonts:Clear()
	imgui.GetIO().Fonts:AddFontFromFileTTF(font_path, 15.0, nil, glyph_ranges)
	imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(font85, 15.0, config, iconRanges)

    setInterfaceStyle(mainIni.menu.iStyle)
end)

local convert_color = function(argb)
	local col = imgui.ColorConvertU32ToFloat4(argb)
	return imgui.new.float[4](col.z, col.y, col.x, col.w)
end

local arz_vcolor = convert_color(mainIni.arizonarp.vcolor)
local rv_vcolor = convert_color(mainIni.reventrp.vcolor)

local styles = {"Androvira", "Light Blue", "Light Purple", "Gray ~Blue", "Cherry"}
local arr_styles = imgui.new['const char*'][#styles](styles)

local mainFrame = imgui.OnFrame(
    function() return array.main_window_state[0] end,
    function(self)
		if not checkfuncs.main.activecursor then self.HideCursor = true else self.HideCursor = false end
        if checkfuncs.main.enabled and not isSampfuncsConsoleActive() and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() then
            imgui.SetNextWindowPos(imgui.ImVec2(pw / 2, ph / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.SetNextWindowSize(imgui.ImVec2(sw, sh), imgui.Cond.FirstUseEver)
			imgui.Begin('##begin', array.main_window_state, imgui.WindowFlags.NoDecoration + imgui.WindowFlags.NoNav)
			imgui.Text('\tCheatsByNyhfox | Version: ' .. version_script.. ' | Uptime: '..ltime.hours..':'..ltime.minutes..':'..ltime.seconds)
			imgui.SameLine()
			imgui.Indent(750)
			if imgui.Button(fa.ICON_POWER_OFF) then
				array.main_window_state[0] = false
			end
			imgui.Unindent(750)
			imgui.BeginChild('##tabs', imgui.ImVec2(115, sh-40), true)
			if imgui.ButtonActivated(act1 == 1, fa.ICON_STREET_VIEW .. (array.lang_menu[0] and u8' Ïåðñîíàæ' or ' Actor'), imgui.ImVec2(100, 0)) then act1 = 1 end
			if imgui.ButtonActivated(act1 == 2, fa.ICON_CAR .. (array.lang_menu[0] and u8' Òðàíñïîðò' or ' Vehicle'), imgui.ImVec2(100, 0)) then act1 = 2 end
			if imgui.ButtonActivated(act1 == 3, fa.ICON_BOMB .. (array.lang_menu[0] and u8' Îðóæèå' or ' Weapon'), imgui.ImVec2(100, 0)) then act1 = 3 end
			if imgui.ButtonActivated(act1 == 4, fa.ICON_CHART_PIE .. (array.lang_menu[0] and u8' Ðàçíîå' or ' Misc'), imgui.ImVec2(100, 0)) then act1 = 4 end
			if imgui.ButtonActivated(act1 == 5, fa.ICON_EYE .. (array.lang_menu[0] and u8' Âèçóàëû' or ' Visual'), imgui.ImVec2(100, 0)) then act1 = 5 end
			if imgui.ButtonActivated(act1 == 6, fa.ICON_COG .. (array.lang_menu[0] and u8' Íàñòðîéêè' or ' Settings'), imgui.ImVec2(100, 0)) then act1 = 6 end
			if imgui.ButtonActivated(act1 == 8, ' ' .. fa.ICON_INFO .. (array.lang_menu[0] and u8'   Ïîìîùü' or '   Help'), imgui.ImVec2(100, 0)) then act1 = 8 end
			imgui.Spacing()
			if getServer('arizona') then if imgui.ButtonActivated(act1 == 10, fa.ICON_SERVER .. ' Arizona-RP', imgui.ImVec2(100, 0)) then act1 = 10 end
			elseif getServer('revent') then if imgui.ButtonActivated(act1 == 9, fa.ICON_SERVER .. ' Revent-RP', imgui.ImVec2(100, 0)) then act1 = 9 end end
			imgui.IntSpacing(5)
			imgui.CenterTextColored(imgui.ImVec4(imgui.GetStyle().Colors[imgui.Col.Text]), array.lang_menu[0] and u8'Áûñòðîå ìåíþ' or 'Quick menu')
			if imgui.Button(array.lang_menu[0] and u8'Âûãðóçêà' or 'Unload', imgui.ImVec2(100, 0)) then thisScript():unload() end
			if not array.lang_menu[0] then if imgui.Button(u8'Ñìåíèòü ÿçûê', imgui.ImVec2(100, 0)) then array.lang[0] = 1 end else if imgui.Button('Change language', imgui.ImVec2(100, 0)) then array.lang[0] = 2 end end
			imgui.PushItemWidth(100)
			if imgui.Combo('##Styles', array.comboStyle, arr_styles, #styles) then
				mainIni.menu.iStyle = array.comboStyle[0]
				setInterfaceStyle(mainIni.menu.iStyle)
			end
			imgui.PopItemWidth()
			if imgui.Button(fa.ICON_SAVE) then
				saveini()
				sampAddChatMessage(tag..(array.lang_chat[0] and 'Íàñòðîéêè {0E8604}óñïåøíî{888EA0} ñîõðàíåíû' or 'Settings {0E8604}successfully {888EA0}save'), colors.chat.main)
			end
			imgui.Hint('##ft_save', array.lang_menu[0] and u8'Ñîõðàíèòü íàñòðîéêè' or 'Save settings')
			imgui.SameLine()
			if imgui.Button(fa.ICON_DOWNLOAD) then autoupdate(jsn_upd, tag, url_upd) end
			imgui.Hint('##ft_autoupdate', array.lang_menu[0] and u8'Ïðîâåðèòü îáíîâëåíèÿ' or 'Check updates')
			imgui.EndChild()
			imgui.SameLine()
            if act1 == 1 then
                imgui.BeginChild('##actor', imgui.ImVec2(sw-140, sh-40), true)
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Áåñêîíå÷íàÿ âûíîñëèâîñòü (áåã)' or 'Infinity stamina (run)', array.show_imgui_infRun)
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Áåñêîíå÷íàÿ âûíîñëèâîñòü (ïëàâàíèå)' or 'Infinity stamina (swim)', array.show_imgui_infSwim)
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Áåñêîíå÷íûé êèñëîðîä' or 'Infinity oxygen', array.show_imgui_infOxygen)
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Ìåãà ïðûæîê' or 'Mega jump', array.show_imgui_megajumpActor)
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Áûñòðûé áåã' or 'Fast sprint', array.show_imgui_fastsprint)
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Áåç ïàäåíèé' or 'No fall', array.show_imgui_nofall)
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Ðàçìîðîçèòü' or 'Unfreeze', array.show_imgui_unfreeze)
				imgui.TextQuestion('##unfreeze', array.lang_menu[0] and u8"Åñëè ôóíêöèÿ âêëþ÷åíà, èñïîëüçóéòå: /" or "If function enabled then use key: /")
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Ñóèöèä' or 'Suicide', array.show_imgui_suicideActor)
				imgui.TextQuestion('#suicideactor', array.lang_menu[0] and u8"Åñëè ôóíêöèÿ âêëþ÷åíà, èñïîëüçóéòå: F3\nÅñëè ôóíêöèÿ 'Âçðûâ òðàíñïîðòà' âêëþ÷åí âî âêëàäêå 'Òðàíñïîðò' òî ïðîèçîéäåò òîëüêî ñóèöèä\nÅñëè îáå ôóíêöèè âêëþ÷åíû, òî ïðîèçîéäåò âçðûâ òðàíñïîðòà, à åñëè Âû íå â òðàíñïîðòå, òî Âû ñîâåðøèòå ñóèöèä" or "If function enabled then use key: F3\nIf function 'Boom vehicle' enabled in tab 'Vehicle' then will be only suicide\nThat is, if both functions are enabled, then you will boom vehicle, and not in vehicle will suicide")
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Áåñêîíå÷íîå çäîðîâüå' or 'GM', array.show_imgui_gmActor)
				imgui.TextQuestion('##gmactor', array.lang_menu[0] and u8"Åñëè ôóíêöèÿ âêëþ÷åíà, èñïîëüçóéòå: Insert" or "If function enabled then use key: Insert")
				imgui.ToggleButton(array.typeToggle[0], 'Antistun', array.show_imgui_antistun)
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Íåâèäèìêà' or 'Invise', array.ainvise)
				imgui.SameLine()
				imgui.Text(fa.ICON_COG)
				if imgui.IsItemClicked() then
					imgui.OpenPopup(array.lang_menu[0] and u8'Íàñòðîéêè Invise' or 'Settings Invise')
				end
				if imgui.BeginPopup(array.lang_menu[0] and u8'Íàñòðîéêè Invise' or 'Settings Invise') then
					imgui.RadioButtonIntPtr(array.lang_menu[0] and u8'Ïîä çåìëåé' or 'Underground', array.ainviseInt, 1)
					imgui.RadioButtonIntPtr(array.lang_menu[0] and u8'Â íåáå' or 'In the sky', array.ainviseInt, 2)
					imgui.EndPopup()
				end
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Áûñòðî îñòàíàâëèâàòüñÿ' or 'Stop quickly', array.stopQuick)
                imgui.EndChild()
            elseif act1 == 2 then
                imgui.BeginChild('##vehicle', imgui.ImVec2(sw-140, sh-40), true)
				imgui.Columns(2, id, false)
				imgui.ToggleButton(array.typeToggle[0], 'SpeedHack', array.show_imgui_speedhack)
				imgui.TextQuestion('#sh', array.lang_menu[0] and u8'Åñëè ôóíêöèÿ âêëþ÷åíà, èñïîëüçóéòå: ALT\n×åì âûøå "Ïëàâíîñòü", òåì ïëàâíåå "SpeedHack"' or 'If function enabled then use key: ALT\nThe higher the "Smooth", the smoother "SpeedHack"')
				imgui.SameLine()
				imgui.Text(fa.ICON_COG)
				if imgui.IsItemClicked() then
					imgui.OpenPopup(array.lang_menu[0] and u8'Íàñòðîéêè Speedhack' or 'Settings Speedhack')
				end
				if imgui.BeginPopup(array.lang_menu[0] and u8'Íàñòðîéêè Speedhack' or 'Settings Speedhack') then
					imgui.PushItemWidth(250)
					imgui.SliderFloat(array.lang_menu[0] and u8'Ìàêñèìàëüíàÿ ñêîðîñòü' or 'Max speed', array.SpeedHackMaxSpeed, 80, 300, '%.1f', 0.5)
					imgui.SliderInt(array.lang_menu[0] and u8'Ïëàâíîñòü' or 'Smooth', array.SpeedHackSmooth, 5, 150)
					imgui.PopItemWidth()
					imgui.EndPopup()
				end
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Ïåðåâîðîò íà 180' or 'Flip 180', array.show_imgui_flip180)
				imgui.TextQuestion('##flip180', array.lang_menu[0] and u8"Åñëè ôóíêöèÿ âêëþ÷åíà, èñïîëüçóéòå: Backspace" or "If function enabled then use key: Backspace")
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Ïåðåâîðîò íà êîëåñà' or 'Flip on wheels', array.show_imgui_flipOnWheels)
				imgui.TextQuestion('#fliponwheels', array.lang_menu[0] and u8"Åñëè ôóíêöèÿ âêëþ÷åíà, èñïîëüçóéòå: Delete" or "If function enabled then use key: Delete")
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Ïðûæî÷åê' or 'Hop', array.show_imgui_hopVeh)
				imgui.TextQuestion('##hop', array.lang_menu[0] and u8"Åñëè ôóíêöèÿ âêëþ÷åíà, èñïîëüçóéòå: B" or "If function enabled then use key: B")
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Âçðûâ òðàíñïîðòà' or 'Boom vehicle', array.show_imgui_suicideVeh)
				imgui.TextQuestion('##suicideveh', array.lang_menu[0] and u8"Åñëè ôóíêöèÿ âêëþ÷åíà, èñïîëüçóéòå: F3\nÅñëè ôóíêöèÿ 'Ñóèöèä' âêëþ÷åíà âî âêëàäêå 'Ïåðñîíàæ' òî ïðîèçîéäåò òîëüêî âçðûâ òðàíñïîðòà\nÅñëè îáå ôóíêöèè âêëþ÷åíû, òî ïðîèçîéäåò âçðûâ òðàíñïîðòà, à åñëè Âû íå â òðàíñïîðòå, òî Âû ñîâåðøèòå ñóèöèä" or "If function enabled then use key: F3\nIf function 'Suicide' enabled in tab 'Actor' then will be only boom vehicle\nThat is, if both functions are enabled, then you will boom vehicle, and not in transport will suicide")
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Áûñòðûé âûõîä' or 'Fast exit', array.show_imgui_fastexit)
				imgui.TextQuestion('##fastexit', array.lang_menu[0] and u8"Åñëè ôóíêöèÿ âêëþ÷åíà, èñïîëüçóéòå: N" or "If function enabled then use key: N")
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Ïî÷èíèòü êîëåñà' or 'Restore wheels', array.show_imgui_fixWheels)
				imgui.TextQuestion('##repairwheels', array.lang_menu[0] and u8"Åñëè ôóíêöèÿ âêëþ÷åíà, èñïîëüçóéòå: Z+2" or "If function enabled then use keys: Z+2")
				imgui.ToggleButton(array.typeToggle[0], 'Anti-bike fall', array.show_imgui_antiBikeFall)
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Ìåãà BMX ïðûæîê' or 'Mega BMX jump', array.show_imgui_megajumpBMX)
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Èäåàëüíàÿ åçäà' or 'Perfect handling', array.show_imgui_perfectHandling)
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Ó âñåãî òðàíñïîðòà íèòðî' or 'All cars have nitro', array.show_imgui_allCarsNitro)
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Òàíê ìîä' or 'Tank mode', array.show_imgui_tankMode)
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Åçäà ïî âîäå' or 'Drive on water', array.show_imgui_driveOnWater)
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Ïî÷èíèòü òðàíñïîðò' or 'Restore health', array.show_imgui_restHealthVeh)
				imgui.TextQuestion('##repaircar', array.lang_menu[0] and u8'Åñëè ôóíêöèÿ âêëþ÷åíà, èñïîëüçóéòå: 1' or 'If function enabled then use key: 1')
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Äâèãàòåëü âêëþ÷åí' or 'Engine on', array.show_imgui_engineOnVeh)
				imgui.NextColumn()
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Íå âçðûâàåòñÿ ïðè ïåðåâîðîòå' or 'Does not explode on coup', array.antiboom_upside)
				imgui.TextQuestion('##antiboom_upside', array.lang_menu[0] and u8'Îñòîðîæíî!\nÁóäåò ñòàâèòü Âàøåìó ÒÑ 1000 HP ïðè ïåðåâîðîòå\nÅñëè èãðàåòå íà RP ñåðâåðå - íàïèøåòñÿ îá ýòîì àäìèíèñòðàöèè' or 'Caution!\nWill put your vehicle 1000 HP when you flip\nIf you play on the RP server, the administration will write about it')
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Áåñêîíå÷íîå çäîðîâüå' or 'GM', array.show_imgui_gmVeh)
				imgui.TextQuestion('##gmveh', array.lang_menu[0] and u8'Åñëè ôóíêöèÿ âêëþ÷åíà, èñïîëüçóéòå: Home\nÍåîáõîäèìî âûáðàòü "Îáû÷íûé" èëè(è) "Êîëåñà"' or 'If function enabled then use keys: Home\nYou must select "Default" or(and) "Wheels"')
				imgui.SameLine()
				imgui.Text(fa.ICON_COG)
				if imgui.IsItemClicked() then
					imgui.OpenPopup(array.lang_menu[0] and u8'Íàñòðîéêè GMVeh' or 'Settings GMVeh')
				end
				if imgui.BeginPopup(array.lang_menu[0] and u8'Íàñòðîéêè GMVeh' or 'Settings GMVeh') then
					imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Îáû÷íûé' or 'Default', array.show_imgui_gmVehDefault)
					imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Êîëåñà' or 'Wheels', array.show_imgui_gmVehWheels)
					imgui.EndPopup()
				end
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Íåâèäèìêà' or 'Invise', array.vinvise)
				imgui.SameLine()
				imgui.Text(fa.ICON_COG)
				if imgui.IsItemClicked() then
					imgui.OpenPopup(array.lang_menu[0] and u8'Íàñòðîéêè VInvise' or 'Settings VInvise')
				end
				if imgui.BeginPopup(array.lang_menu[0] and u8'Íàñòðîéêè VInvise' or 'Settings VInvise') then
					imgui.RadioButtonIntPtr(array.lang_menu[0] and u8'Ïîä çåìëåé' or 'Underground', array.vinviseInt, 1)
					imgui.RadioButtonIntPtr(array.lang_menu[0] and u8'Â íåáå' or 'In the sky', array.vinviseInt, 2)
					imgui.EndPopup()
				end
                imgui.EndChild()
            elseif act1 == 3 then
                imgui.BeginChild('##weapon', imgui.ImVec2(sw-140, sh-40), true)
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Áåñêîíå÷íûå ïàòðîíû' or 'Infinity ammo', array.show_imgui_infAmmo)
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Áåç ïåðåçàðÿäêè' or 'No reload', array.show_imgui_noreload)
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Ïîëíîå óìåíèå' or 'Full skills', array.show_imgui_fullskills)
				imgui.ToggleButton(array.typeToggle[0], '+C', array.show_imgui_plusC)
				imgui.TextQuestion('##plusC', array.lang_menu[0] and u8'Åñëè ôóíêöèÿ âêëþ÷åíà, èñïîëüçóéòå: R\nÒîëüêî äëÿ Deagle' or 'If function enabled then use key: R\nOnly for Deagle')
				imgui.ToggleButton(array.typeToggle[0], 'Aim', array.show_imgui_aim)
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Êîëîêîë' or 'Bell', array.bell)
                imgui.EndChild()
            elseif act1 == 4 then
                imgui.BeginChild('##misc', imgui.ImVec2(sw-140, sh-40), true)
				imgui.Columns(2, id, false)
				imgui.ToggleButton(array.typeToggle[0], 'AirBrake', array.show_imgui_AirBrake)
				imgui.TextQuestion('##airbrake', array.lang_menu[0] and u8"Åñëè ôóíêöèÿ âêëþ÷åíà, èñïîëüçóéòå: RShift" or "If function enabled then use key: RShift")
				imgui.SameLine()
				imgui.Text(fa.ICON_COG)
				if imgui.IsItemClicked() then
					imgui.OpenPopup(array.lang_menu[0] and u8'Íàñòðîéêè AirBrake' or 'Settings AirBrake')
				end
				if imgui.BeginPopup(array.lang_menu[0] and u8'Íàñòðîéêè AirBrake' or 'Settings AirBrake') then
					imgui.PushItemWidth(250)
					imgui.SliderFloat(array.lang_menu[0] and u8'Ñêîðîñòü' or 'Speed', array.AirBrake_Speed, 0.1, 14.9, '%.1f', 1.5)
					imgui.PopItemWidth()
					imgui.Text(array.lang_menu[0] and u8'Êëàâèøè:' or 'Keys:')
					imgui.SameLine()
					imgui.RadioButtonIntPtr(array.lang_menu[0] and u8'Ââåðõ & Âíèç' or 'Up & Down', array.AirBrake_keys, 1)
					imgui.SameLine()
					imgui.RadioButtonIntPtr(array.lang_menu[0] and u8'Ïðîáåë & LShift' or 'Space & LShift', array.AirBrake_keys, 2)
					imgui.EndPopup()
				end
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Ïîëå çðåíèÿ' or 'FOV changer', array.show_imgui_FOV)
				imgui.SameLine()
				imgui.Text(fa.ICON_COG)
				if imgui.IsItemClicked() then
					imgui.OpenPopup(array.lang_menu[0] and u8'Íàñòðîéêè FOV' or 'Settings FOV')
				end
				if imgui.BeginPopup(array.lang_menu[0] and u8'Íàñòðîéêè FOV' or 'Settings FOV') then
					imgui.PushItemWidth(250)
					imgui.SliderFloat(array.lang_menu[0] and u8'Çíà÷åíèå' or 'Value', array.FOV_value, 70.0, 108.0, '%.1f', 0.5)
					imgui.PopItemWidth()
					imgui.EndPopup()
				end
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Áûñòðûé òåëåïîðò' or 'Blink', array.show_imgui_blink)
				imgui.TextQuestion('##blink', array.lang_menu[0] and u8"Åñëè ôóíêöèÿ âêëþ÷åíà, èñïîëüçóéòå: X\nÂàñ òåëåïîðòèðóåò íà îïðåäåëåííîå êîëè÷åñòâî ìåòðîâ âïåðåä" or "If function enabled then use key: X\nYou teleport a certain number of meters ahead")
				imgui.SameLine()
				imgui.Text(fa.ICON_COG)
				if imgui.IsItemClicked() then
					imgui.OpenPopup(array.lang_menu[0] and u8'Íàñòðîéêè Blink' or 'Settings Blink')
				end
				if imgui.BeginPopup(array.lang_menu[0] and u8'Íàñòðîéêè Blink' or 'Settings Blink') then
					imgui.PushItemWidth(250)
					imgui.SliderFloat(array.lang_menu[0] and u8'Äèñòàíöèÿ' or 'Distance', array.blink_dist, 1.0, 150.0, '%.1f', 1.5)
					imgui.PopItemWidth()
					imgui.EndPopup()
				end
				imgui.ToggleButton(array.typeToggle[0], 'ClickWarp', array.show_imgui_clickwarp)
				imgui.TextQuestion('##clickwarp', array.lang_menu[0] and u8"Åñëè ôóíêöèÿ âêëþ÷åíà, èñïîëüçóéòå: Êîëåñî ìûøè" or "If function enabled then use key: Mouse wheels")
				imgui.ToggleButton(array.typeToggle[0], 'Anti-BHop', array.show_imgui_antibhop)
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Áûñòðàÿ êàðòà' or 'Quick map', array.show_imgui_quickMap)
				imgui.TextQuestion('##quickmap', array.lang_menu[0] and u8"Åñëè ôóíêöèÿ âêëþ÷åíà, èñïîëüçóéòå: M" or "If function enabled then use key: M")
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Èñïðàâëåíèå ÷óâñòâèòåëüíîñòè' or 'Sensetivity fix', array.show_imgui_sensfix)
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Ïåðåçàõîä' or 'Reconnect', array.show_imgui_reconnect)
				imgui.TextQuestion('##reconnect', array.lang_menu[0] and u8'Åñëè ôóíêöèÿ âêëþ÷åíà, èñïîëüçóéòå: LSHFIT+0' or 'If function enabled then use key: LSHFIT+0')
				imgui.SameLine()
				imgui.Text(fa.ICON_COG)
				if imgui.IsItemClicked() then
					imgui.OpenPopup(array.lang_menu[0] and u8'Íàñòðîéêè Ïåðåçàõîäæ' or 'Settings Reconnect')
				end
				if imgui.BeginPopup(array.lang_menu[0] and u8'Íàñòðîéêè Ïåðåçàõîäæ' or 'Settings Reconnect') then
					imgui.PushItemWidth(250)
					imgui.SliderInt(array.lang_menu[0] and u8'Çàäåðæêà (ñåêóíäû)' or 'Delay (seconds)', array.recon_delay, 1, 30)
					imgui.PopItemWidth()
					imgui.EndPopup()
				end
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'×èñòðûé ñêðèíøîò' or 'Clear screenshot', array.show_imgui_clrScr)
				imgui.SameLine()
				imgui.Text(fa.ICON_COG)
				if imgui.IsItemClicked() then
					imgui.OpenPopup(array.lang_menu[0] and u8'Íàñòðîéêè clrScr' or 'Settings clrScr')
				end
				if imgui.BeginPopup(array.lang_menu[0] and u8'Íàñòðîéêè clrScr' or 'Settings clrScr') then
					imgui.PushItemWidth(250)
					imgui.SliderInt(array.lang_menu[0] and u8'Çàäåðæêà' or 'Delay', array.clrScr_delay, 800, 3000)
					imgui.PopItemWidth()
					imgui.EndPopup()
				end
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Åçäà/Õîäüáà ïîä âîäîé' or 'Drive/Walk under water', array.show_imgui_UnderWater)
				imgui.NextColumn()
				imgui.ToggleButton(array.typeToggle[0], 'Rvanka', array.rvanka)
				imgui.TextQuestion('##rvanka', array.lang_menu[0] and u8'Ôóíêöèÿ íå ñîõðàíÿåòñÿ\nÁåòà' or 'Function don\'t save\nBeta')
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Ñðàçó îòêëþ÷èòü ÷àò íà F7' or 'Immediately disable chat on F7', array.offChatF7)
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Äåíüãè áåç çàäåðæêè' or 'Cash without delay', array.notDelayCash)
				imgui.TextQuestion('##notDelayCash', array.lang_menu[0] and u8'Êîãäà ïðèáàâëÿþòñÿ èëè óáàâëÿþòñÿ äåíüãè, ýòî ïðîèñõîäèò áåç çàäåðæêè â HUD' or 'When cash is added or subtracted, it happens without delay in the HUD')
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Ãðàâèòàöèÿ' or 'Gravitation', array.gravitation)
				imgui.SameLine()
				imgui.Text(fa.ICON_COG)
				if imgui.IsItemClicked() then
					imgui.OpenPopup(array.lang_menu[0] and u8'Íàñòðîéêè Gravitation' or 'Settings Gravitation')
				end
				if imgui.BeginPopup(array.lang_menu[0] and u8'Íàñòðîéêè Gravitation' or 'Settings Gravitation') then
					imgui.PushItemWidth(250)
					imgui.SliderFloat(array.lang_menu[0] and u8'Çíà÷åíèå' or 'Value', array.gravitation_value, 0.01, 0.0001, '%.4f', 1.0)
					imgui.PopItemWidth()
					imgui.EndPopup()
				end
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Ïîìîùíèê ââîäà' or 'Input helper', array.inputHelper)
				imgui.TextQuestion('##inputhelper', array.lang_menu[0] and u8'Íåçàâèñèìî îò ÿçûêà, åñëè ïåðâûé ñèìâîë áóäåò "." (çàìåíèòñÿ íà "/") èëè "/",\náóäåò ââîäèòñÿ êîìàíäà íà àíãëèéñêîì ÿçûêå' or 'Regardless of the language, if the first character is "." (will be replaced with "/") or "/",\nthe command will be entered in English')
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'×àò íà "T"' or 'Chat on "T"', array.chatOnT)
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Âûáîð ñòðîêè êëàâèøåé' or 'Select a line with the key', array.fastSelectOnDialog)
				imgui.TextQuestion('##fastSelectOnDialog', array.lang_menu[0] and u8'Ïðè äèàëîãå âû ìîæåòå íàæàòü íà 1 (è äî 0), ÷òîá âûáðàòü ñòðîêó' or 'During dialogue, you can click on 1 (and up to 0) to select a line')
				imgui.Columns(1, id, false)
				imgui.NewLine()
				imgui.CenterTextColored(imgui.ImVec4(imgui.GetStyle().Colors[imgui.Col.Text]), array.lang_menu[0] and u8'Òåëåïîðòû' or 'Teleports')
				for structure, tOrg in pairs(tpList) do
					if imgui.CollapsingHeader(u8(structure)) then
						imgui.Columns(3)
						for orgName, tCoords in pairs(tOrg) do
							if imgui.Button(u8(orgName), imgui.ImVec2(-1, 20)) then
								teleportInterior(PLAYER_PED, tCoords[1], tCoords[2], tCoords[3], tCoords[4])
							end
							imgui.NextColumn()
						end
						imgui.Columns(1)
					end
				end
                imgui.EndChild()
            elseif act1 == 5 then
                imgui.BeginChild('##visual', imgui.ImVec2(sw-140, sh-40), true)
				imgui.BeginTitleChild(array.lang_menu[0] and u8'Îáùåå' or 'General', imgui.ImVec2(240, array.typeToggle[0] == 0 and 186 or 165))
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Èíôîðìàöèîííàÿ ïàíåëü' or 'Information bar', array.infbar)
				imgui.SameLine()
				imgui.Text(fa.ICON_COG)
				if imgui.IsItemClicked() then
					imgui.OpenPopup(array.lang_menu[0] and u8'Íàñòðîéêè Èíôîðìàöèîííàÿ ïàíåëü' or 'Settings Information bar')
				end
				if imgui.BeginPopup(array.lang_menu[0] and u8'Íàñòðîéêè Èíôîðìàöèîííàÿ ïàíåëü' or 'Settings Information bar') then
					imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Ãðàâèòàöèÿ' or 'Gravitation', array.infbar_grav)
					imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Êîîðäèíàòû' or 'Coordinates', array.infbar_coords)
					imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Èíòåðüåð' or 'Interior', array.infbar_interior)
					imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Âðåìÿ' or 'Time', array.infbar_time)
					imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Ïèíã' or 'Ping', array.infbar_ping)
					imgui.ToggleButton(array.typeToggle[0], 'FPS', array.infbar_fps)
					imgui.ToggleButton(array.typeToggle[0], 'ID', array.infbar_aid)
					imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Òðàíñïîðò ID' or 'Vehicle ID', array.infbar_vid)
					imgui.EndPopup()
				end
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Èíôîðìàöèîííàÿ ïàíåëü 2' or 'Information bar 2', array.infbar2)
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Ïóëüñàòîð äåíåã' or 'Pulsator cash', array.pulsCash)
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Ïîìîùíèê ÷àòà' or 'Chat helper', array.chatHelper)
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Ïîèñê 3D òåêñòîâ' or 'Search 3D text', array.srch3dtext)
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Òðåéñåð ïóëü' or 'Traser bullets', array.traserbull)
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Óâåäîìëåíèÿ' or 'Notifications', array.notifications)
				imgui.SameLine()
				imgui.Text(fa.ICON_COG)
				if imgui.IsItemClicked() then
					imgui.OpenPopup(array.lang_menu[0] and u8'Íàñòðîéêè Óâåäîìëåíèÿ' or 'Settings Notifications')
				end
				if imgui.BeginPopup(array.lang_menu[0] and u8'Íàñòðîéêè Óâåäîìëåíèÿ' or 'Settings Notifications') then
					imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'GM ïåðñîíàæ' or 'GM actor', array.NactorGM)
					imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'GM òðàíñïîðò' or 'GM vehicle', array.NvehGM)
					imgui.ToggleButton(array.typeToggle[0], 'WH', array.Nwh)
					imgui.TextQuestion('##wh_notif', array.lang_menu[0] and u8'"Name tag"/"Ñêåëåò"' or '"Name tag"/"Skeleton"')
					imgui.ToggleButton(array.typeToggle[0], 'AirBrake', array.Nairbrake)
					imgui.ToggleButton(array.typeToggle[0], '+C', array.NplusC)
					imgui.EndPopup()
				end
				imgui.EndChild()
				imgui.SameLine()
				imgui.BeginTitleChild(array.lang_menu[0] and u8'Èãðîêè' or 'Players', imgui.ImVec2(160, array.typeToggle[0] == 0 and 91 or 85))
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Ïî êëàâèøå' or 'On key', array.show_imgui_keyWH)
				imgui.TextQuestion('##keywh', array.lang_menu[0] and u8'Åñëè âêëþ÷åíî, òî äëÿ âêëþ÷åíèÿ "Name tag"/"Ñêåëåò", èñïîëüçóéòå: 5' or 'If enabled, then to include "Name tag"/"Skeleton", use: 5')
				imgui.ToggleButton(array.typeToggle[0], 'Name tag', array.show_imgui_nametag)
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Ñêåëåò' or 'Skeleton', array.show_imgui_skeleton)
				imgui.EndChild()
				imgui.Spacing()
				imgui.BeginTitleChild(array.lang_menu[0] and u8'Òðàíñïîðò' or 'Vehicle', imgui.ImVec2(240, array.typeToggle[0] == 0 and 66 or 65))
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Òîëüêî êîëåñà' or 'Only wheels', array.show_imgui_onlyWheels)
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Ïðîâåðêà äâåðåé' or 'Check doors', array.show_imgui_doorlocks)
				imgui.SameLine()
				imgui.Text(fa.ICON_COG)
				if imgui.IsItemClicked() then
					imgui.OpenPopup(array.lang_menu[0] and u8'Íàñòðîéêè Ïðîâåðêà äâåðåé' or 'Settings Check doors')
				end
				if imgui.BeginPopup(array.lang_menu[0] and u8'Íàñòðîéêè Ïðîâåðêà äâåðåé' or 'Settings Check doors') then
					imgui.SliderInt(array.lang_menu[0] and u8'Äèñòàíöèÿ' or 'Distance', array.distDoorLocks, 5, 200)
					imgui.EndPopup()
				end
				imgui.EndChild()
                imgui.EndChild()
            elseif act1 == 6 then
                imgui.BeginChild('##settings', imgui.ImVec2(sw-140, sh-40), true)
				imgui.TextColoredRGB(array.lang_menu[0] and u8'Âêëþ÷èòü/Îòêëþ÷èòü êóðñîð - {0984d2}F11' or 'On/Off cursor - {0984d2}F11')
				imgui.TextColoredRGB(array.lang_menu[0] and u8'{0984d2}ßçûê:' or '{0984d2}Language:') imgui.SameLine()
				imgui.RadioButtonIntPtr(u8'Ðóññêèé', array.lang, 1) imgui.SameLine()
				imgui.RadioButtonIntPtr('English', array.lang, 2) imgui.SameLine()
				imgui.RadioButtonIntPtr(array.lang_menu[0] and u8'Ïîëüçîâàòåëüñêèé' or 'Custom', array.lang, 3)
				if array.lang[0] == 3 then
					imgui.SameLine()
					imgui.Text(fa.ICON_COG)
					if imgui.IsItemClicked() then
						imgui.OpenPopup(array.lang_menu[0] and u8'Íàñòðîéêè Ïîëüçîâàòåëüñêèé' or 'Settings Custom')
					end
					if imgui.BeginPopup(array.lang_menu[0] and u8'Íàñòðîéêè Ïîëüçîâàòåëüñêèé' or 'Settings Custom') then
						imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Ìåíþ' or 'Menu', array.lang_menu)
						imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'×àò' or 'Chat', array.lang_chat)
						imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Âèçóàëû' or 'Visual', array.lang_visual)
						imgui.Text('* ENG <-> RUS')
						imgui.EndPopup()
					end
				end
				imgui.TextColoredRGB(array.lang_menu[0] and u8'{0984d2}Âûáåðèòå òèï ïåðåêëþ÷àòåëåé: ' or '{0984d2}Select the type of toggle: '); imgui.SameLine()
				imgui.ToggleButton(0, '##0', isTypeToggle0); imgui.SameLine()
				imgui.ToggleButton(1, '##1', isTypeToggle1); imgui.SameLine()
				imgui.ToggleButton(2, '##2', isTypeToggle2)
				if isTypeToggle0[0] then isTypeToggle0[0] = false; array.typeToggle[0] = 0
				elseif isTypeToggle1[0] then isTypeToggle1[0] = false; array.typeToggle[0] = 1
				elseif isTypeToggle2[0] then isTypeToggle2[0] = false; array.typeToggle[0] = 2 end
				imgui.TextColoredRGB(array.lang_menu[0] and u8'{0984d2}Íàñòðîéêà ñòèëåé:' or '{0984d2}Style settings:')
				imgui.SameLine()
				imgui.PushItemWidth(150)
				if imgui.Combo('##Styles', array.comboStyle, arr_styles, #styles) then
					mainIni.menu.iStyle = array.comboStyle[0]
					setInterfaceStyle(mainIni.menu.iStyle)
				end
				imgui.PopItemWidth()
				imgui.TextColoredRGB('{0984d2}Config:')
				imgui.Spacing()
				if imgui.Button(array.lang_menu[0] and u8'Ñîõðàíèòü íàñòðîéêè' or 'Save settings') then
					saveini()
					sampAddChatMessage(tag..(array.lang_chat[0] and 'Íàñòðîéêè {0E8604}óñïåøíî{888EA0} ñîõðàíåíû' or 'Settings {0E8604}successfully {888EA0}save'), colors.chat.main)
				end
				imgui.SameLine()
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Àâòî-ñîõðàíåíèå' or 'Auto-save', array.AutoSave)
				imgui.Spacing()
				if imgui.Button(array.lang_menu[0] and u8'Âûãðóçêà' or 'Unload') then thisScript():unload() end
				imgui.IntSpacing(3)
				imgui.Text(array.lang_menu[0] and u8'Îáðàòíàÿ ñâÿçü:' or 'FeedBack:')
				imgui.TextColoredRGB('- Youtube: {0984d2}https://www.youtube.com/channel/UC2SuHR-VOAg3jO0IyAhJ0oQ'); imgui.ClickCopy('https://www.youtube.com/channel/UC2SuHR-VOAg3jO0IyAhJ0oQ')
				imgui.TextColoredRGB((array.lang_menu[0] and u8'- Ïîääåðæêà: {0984d2}' or '- Donate: {0984d2}')..'paypal.me/plankogaming'); imgui.ClickCopy('paypal.me/plankogaming')
				imgui.Text(array.lang_menu[0] and u8'* Êëèêíèòå ïî òåêñòó äëÿ ñêîïèðîâàíèÿ ññûëêè â áóôåð îáìåíà' or '* Click on the text to copy the link to the clipboard')
				imgui.IntSpacing(3)
				imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Ïðîâåðêà îáíîâëåíèé' or 'Check updates', array.checkupdate)
				imgui.SameLine()
				imgui.Indent(300)
				if imgui.Selectable(array.lang_menu[0] and u8'Ñïèñîê èçìåíåíèé' or 'List updates') then
					listupdate = not listupdate
				end
				imgui.Unindent(300)
				if listupdate then
					imgui.OpenPopup("##listupdate")
					imgui.SetNextWindowSize(imgui.ImVec2(1000, 600), imgui.Cond.FirstUseEver)
					if imgui.BeginPopupModal('##listupdate', false, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize) then
						local wx = imgui.GetWindowWidth()
						imgui.SetCursorPosX(wx / 2)
						if imgui.Button(array.lang_menu[0] and u8'Çàêðûòü##1' or 'Close##1') then
							listupdate = false
						end
						imgui.Text('26.05.2021 - v1.6 '..(array.lang_menu[0] and u8'(Òåêóùàÿ)' or '(Current)'))
							imgui.Text('- '..(array.lang_menu[0] and u8'Óáðàí ïðåôèêñ â êîìàíäàõ, "/z_*", îñòàëîñü òîëüêî "/z*" (* - êîìàíäà)' or 'Removed prefix in commands, "/z_*", only "/z*" is left (* - command)'))
							imgui.Text('- '..(array.lang_menu[0] and u8'Óáðàíà êîìàíäà "/zcmdsamp" è äîáàâëåíû âñå êîìàíäû êîòîðûå òàì áûëè âî âêëàäêó "Ïîìîùü"' or 'Removed the command "/zcmdsamp" and added all the commands that were there in the "Help" tab'))
							imgui.Text('- '..(array.lang_menu[0] and u8'Óáðàíà âîçìîæíîñòü ìåíÿòü ÿçûê ñ äèàëîãîâ (òàê êàê äèàëîãîâ (ëîêàëüíûõ) â ñêðèïòå áîëüøå íåò)' or 'Removed the ability to change the language from dialogs (since there are no more dialogues (local) in the script)'))
							imgui.Text('- '..(array.lang_menu[0] and u8'Òåïåðü â êîìàíäå "/zsetmark" ìîæíî óêàçàòü àðãóìåíòû: 1 - X, 2 - Y, 3 - Z, 4 - Èíòåðüåð (åñëè íå óêàçàí, òî èíòåðüåð "0")' or 'Now in the command "/zsetmark" you can specify the arguments: 1 - X, 2 - Y, 3 - Z, 4 - Interior (if not specified, then interior "0")'))
							imgui.Text('- '..(array.lang_menu[0] and u8'Äîáàâëåíà êîìàíäà "/ztpgta", êîòîðàÿ òåëåïîðòèðóåò íà ìåòêó ïîñòàâëåííóþ èãðîêîì' or 'Added the command "/ztpgta", which will teleport to the mark placed by the player'))
							imgui.Text('- '..(array.lang_menu[0] and u8'Èçìåíåíà "Èíôîðìàöèîííàÿ ïàíåëü", òåïåðü íàñòðîéêè ïðîùå' or 'Changed "Information bar", now their settings are easier'))
							imgui.Text('- '..(array.lang_menu[0] and u8'Äîáàâëåíû "Èíôîðìàöèîííàÿ ïàíåëü 2", "Ïóëüñàòîð äåíåã", "Ïîìîùíèê ÷àòà" âî âêëàäêó "Âèçóàëû"' or 'Added "Information bar 2", "Pulsator cash", "Chat helper" to the "Visual" tab'))
							imgui.Text('- '..(array.lang_menu[0] and u8'Äîáàâëåí âûáîð òðåõ âèäîâ ïåðåêëþ÷àòåëåé â "Íàñòðîéêè"' or 'Added selection of three types of switches in "Settings"'))
							imgui.Text('- '..(array.lang_menu[0] and u8'Äîáàâëåíà "Áûñòðî îñòàíàâëèâàòüñÿ" âî âêëàäêó "Ïåðñîíàæ"' or 'Added "Stop quickly" to the "Actor" tab'))
							imgui.Text('- '..(array.lang_menu[0] and u8'Äîáàâëåíû "Ñðàçó îòêëþ÷èòü ÷àò íà F7", "Äåíüãè áåç çàäåðæêè", "Ãðàâèòàöèÿ", "×àò íà "T"", "Âûáîð ñòðîêè êëàâèøåé" âî âêëàäêó "Ïðî÷åå"' or 'Added "Immediately disable chat on F7", "Cash without delay", "Gravitation", "Chat on "T"", "Select a line with the key" to the "Misc" tab'))
							imgui.Text('- '..(array.lang_menu[0] and u8'Ïðî÷èå èçìåíåíèÿ è èñïðàâëåíèÿ' or 'Other changes and fixes'))
							imgui.NewLine()
						imgui.Text('18.04.2021 - v1.5')
							imgui.Text('- '..(array.lang_menu[0] and u8'Òåïåðü íà êíîïêó "ESCAPE" - ìîæíî çàêðûòü ìåíþ' or 'Now on the "ESCAPE" button - you can close the menu'))
							imgui.Text('- '..(array.lang_menu[0] and u8'Òåïåðü øðèôò èêîíîê íå íóæåí, îí åñòü â ñàìîì ñêðèïòå' or 'Now the icon font is not needed, it is in the script itself'))
							imgui.Text('- '..(array.lang_menu[0] and u8'Óáðàíû ïîäâêëàäêè èç âêëàäîê' or 'Removed sub-tabs from tabs'))
							imgui.Text('- '..(array.lang_menu[0] and u8'Óáðàíà ôóíêöèÿ "Òðàíñïîðò îòëåòàåò åñëè â íåãî ñòðåëüíóòü" èç âêëàäêè "Òðàíñïîðò"' or 'Removed the function "Vehicle float away when hit" from the "Vehicle" tab'))
							imgui.Text('- '..(array.lang_menu[0] and u8'Óáðàíà êîìàíäà "/z_errors", óáðàíû âñåâîçìîæíûå îøèáêè èç ìåíþ âî âêëàäêå "Ïîìîùü", òàêæå óáðàíà íóìåðàöèÿ îøèáîê' or 'Removed the command "/z_errors", removed all kinds of errors from the menu in the "Help" tab, also removed the numbering of errors'))
							imgui.Text('- '..(array.lang_menu[0] and u8'Äîáàâëåíî "Áûñòðîå ìåíþ" ïîä âñåìè âêëàäêàìè' or 'Added "Quick Menu" under all tabs'))
							imgui.Text('- '..(array.lang_menu[0] and u8'Äîáàâëåíî "Rvanka" âî âêëàäêó "Ðàçíîå"' or 'Added "Rvanka" to the "Misc" tab'))
							imgui.Text('- '..(array.lang_menu[0] and u8'Äîáàâëåíà "Íåâèäèìêà" âî âêëàäêó "Òðàíñïîðò" è "Ïåðñîíàæ"' or 'Added "Invisible" to the tab "Vehicle" and "Actor"'))
							imgui.Text('- '..(array.lang_menu[0] and u8'Äîáàâëåí "Êîëîêîë" âî âêëàäêó "Îðóæèå"' or 'Added "Bell" to the "Weapon" tab '))
							imgui.Text('- '..(array.lang_menu[0] and u8'Äîáàâëåíà "Ðàäóãà" è âîçìîæíîñòü èçìåíèòü öâåò (êðîìå ïðîçðà÷íîñòè) äëÿ ôóíêöèè "Ïîèñê" äëÿ ñåðâåðîâ' or 'Added functions for Russian servers'))
							imgui.Text('- '..(array.lang_menu[0] and u8'Îïòèìèçàöèÿ, èñïðàâëåíû îøèáêè' or 'Optimization, bugs fixed'))
							imgui.NewLine()
						imgui.Text('07.03.2021 - v1.4.1')
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Èñïðàâëåíî àâòî-îáíîâëåíèå' or 'Fixed auto-update'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Óäàëåíà êîìàíäà "/z_update"' or 'Removed command "/z_update"'))
							imgui.NewLine()
						imgui.Text('06.03.2021 - v1.4')
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Âñå ìåíþ ïåðåïèñàíî íà mimgui' or 'All menu rewritten to mimgui'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Ìåíþ ïîäâåðãëîñü èçìåíåíèþ, îíî ñòàëî êðàñèâåå' or 'The menu has undergone a change, it has become more beautiful'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Óáðàí ïóòü â ìåíþ' or 'Removed menu path'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Óáðàíû êîìàíäû: "/z_authors" è "/z_version"' or 'Removed commands: "/z_authors" and "/z_version"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Ïåðåèìåíîâàíà êîìàíäà "/z_fakerepair", òåïåðü îíà "/z_repair"' or 'The command "/z_fakerepair" has been renamed, now it is "/z_repair"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Äîáàâëåíû ïîäñâå÷åíûå âêëàäêè (âìåñòî ñòàðîãî ïóòè)' or 'Added highlighted tabs (instead of the old path)'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Äîáàâëåíà çàäåðæêà äëÿ ôóíêöèè "Ïåðåçàõîä" âî âêëàäêå "Ðàçíîå"' or 'Added a delay for the "Restart" function in the "Misc" tab'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Äîáàâëåíà êàñòîìèçàöèÿ äëÿ "Èíôîðìàöèîííàÿ ïàíåëü" âî âêëàäêå "Âèçóàëû"' or 'Added customization for "Information bar" in the "Visual" tab'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Äîáàâëåíû "Èíñòðóìåíòû äëÿ ðàçðàáîò÷èêîâ" âî âêëàäêå "Íàñòðîéêè"' or 'Added "Tools for Developers" in the "Settings" tab'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Òåïåðü ó ôóíêöèè "AirBrake" âî âêëàäêå "Ðàçíîå" èìååòñÿ âûáîð êëàâèø äëÿ óïðàâëåíèÿ ââåðõ/âíèç' or 'Now the "AirBrake" function in the "Misc" tab has a selection of up/down keys'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Òåïåðü íà ðàçíûõ ðàçðåøåíèÿõ ýêðàíà áóäåò àäåêâàòíî ñìîòðåòüñÿ "Èíôîðìàöèîííàÿ ïàíåëü"' or 'Now the "Information bar" will look adequate at different screen resolutions'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Äîáàâëåíà ôóíêöèÿ "Íå âçðûâàåòñÿ ïðè ïåðåâîðîòå" âî âêëàäêå "Òðàíñïîðò"' or 'Added the function "Does not explode on coup" in the "Vehicle" tab'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Óáðàíà ïîäâêëàäêà "Îáíîâëåíèÿ" âî âêëàäêå "Íàñòðîéêè". Òåïåðü èíôîðìàöèÿ îá ýòîì íàõîäèòñÿ âíèçó âêëàäêè "Íàñòðîéêè"' or 'Removed the "Updates" sub-tab in the "Settings" tab. Now information about this is at the bottom of the "Settings" tab'))
							if array.lang_menu[0] then
								imgui.Text(u8'- Óáðàíà ïîäâêëàäêà "Âèçóàëû" âî âêëàäêå "Arizona-RP" è ôóíêöèîíàë ïåðåíåñåí â îñíîâíóþ âêëàäêó')
								imgui.Text(u8'- Äîáàâëåí "Àâòî-ïèíêîä" è "Àâòî-ëîãèí" âî âêëàäêå "Arizona-RP"')
								imgui.Text(u8'- Äîáàâëåíî "Êîíòåéíåðû" ê ôóíêöèè "Ïîèñê" âî âêëàäêå "Revent-RP"')
								imgui.Text(u8'- Òåïåðü íà îïðåäåëåííîì ñåðâåðå, áóäåò ïîêàçûâàòüñÿ ñåðâåð íà êîòîðûé ñóùåñòâóþò ôóíêöèè, òàêæå íà äðóãèõ ñåðâåðàõ ýòè ôóíêöèè ðàáîòàòü íå áóäóò')
							else
								imgui.Text('- Added and deletes more functions for Russian servers')
							end
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Íà êíîïêó F12 - Âêëþ÷èòü/Âûêëþ÷èòü ñêðèïò' or 'On the F12 button - On/Off the script'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Ïðî÷èå èñïðàâëåíèÿ' or 'Miscellaneous fixes'))
							imgui.NewLine()
						imgui.Text('25.12.2020 - v1.3')
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Äîáàâëåíû "Óâåäîìëåíèÿ" âî âêëàäêó "Âèçóàëû"' or 'Added "Notifications" to the "Visual"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Äîáàâëåíû òåëåïîðòû âî âêëàäêó "Ðàçíîå" -> "Òåëåïîðòû"' or 'Added teleports to the "Misc" -> "Teleports"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Ôóíêöèÿ "Îðóæèå" -> "+C" òåïåðü íà êíîïêó "R"' or 'Function "Weapon" -> "+C" is now on the button "R"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Äîáàâëåíà ôóíêöèÿ "Aim" â "Îðóæèå"' or 'Adder function "Aim" in "Weapon"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Â èíôîðìàöèîííîé ïàíåëå òåïåðü "NameTag" ïîìåíÿíî íà "WH" (Òàêæå ðåàãèðóåò è íà "Ñêåëåò")' or 'In the information panel, now "NameTag" is changed to "WH" (Also reacts to "Skeleton")'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Òåïåðü "Âèçóàëû" -> "WH" ìîæíî àêòèâèðîâàòü íà "5" (Ïî æåëàíèþ)' or 'Now "Visual" -> "WH" can be activated to "5" (Optional)'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Äîáàâëåíà ôóíêöèÿ "Òðåéñåð ïóëü" â "Âèçóàëû"' or 'Adder function "Traser bullets" in "Visual"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Òåïåðü "Òðàíñïîðò" -> "GM" îáû÷íûé/êîëåñà àêòèâèðóåòñÿ íà "Home"' or 'Now "Vehicle" -> "GM" default/wheel is activated on "Home"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Èñïðàâëåíî àâòîñîõðàíåíèå' or 'Fixed autosave'))
							if array.lang_menu[0] then
								imgui.Text(u8'- Ñîçäàíà âêëàäêà "Arizona-RP"')
								imgui.Text(u8'- Âî âêëàäêå "Arizona-RP" ñîçäàíà ïîäâêëàäêà "Âèçóàëû" è "Îñíîâíîå"')
								imgui.Text(u8'- Äîáàâëåíû ôóíêöèè "Ïðîïóñê äèàëîãîâîãî îêíà ïðè îòâåòå àäìèíèñòðàöèè íà Âàø /report", "Ýìóëÿöèÿ ëàóí÷åðà" è"Áûñòðûé /rep(ort)" â "Arizona-RP" -> "Îñíîâíîå"')
								imgui.Text(u8'- Äîáàâëåíà ôóíêöèÿ "Ïîèñê" â "Arizona-RP" -> "Âèçóàëû"')
								imgui.Text(u8'- Äîáàâëåíà ôóíêöèÿ "Revent-RP" -> "Èñïðàâëåíèÿ ÷àòà"')
								imgui.Text(u8'- Äîáàâëåíà âêëàäêà "Âèçóàëû" äëÿ "Revent-RP"')
								imgui.Text(u8'- Äîáàâëåíà ôóíêöèÿ "Ïîèñê" â "Revent-RP" -> "Âèçóàëû"')
								imgui.Text(u8'- Äîáàâëåíà ôóíêöèÿ "Èñïðàâëåíèÿ ÷àòà" â "Revent-RP" -> "Îñíîâíîå"')
								imgui.Text(u8'- Óáðàí âåñü ôóíêöèîíàë "Admin Tools" è "Helper Tools" äëÿ "Revent-RP"')
							else
								imgui.Text('- Added and deletes more functions for Russian servers')
							end
							imgui.NewLine()
						imgui.Text('26.11.2020 - v1.2')
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Ïîìåíÿíî íàçâàíèå ôóíêöèè "Îðóæèå"  -> "Áåñêîíå÷íûå ïàòðîíû, áåç ïåðåçàðÿäêè" ->  "Áåñêîíå÷íûå ïàòðîíû"' or 'Changed the name of the "Weapon" function -> "Infinite ammo, no reloading" -> "Infinite ammo"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Äîáàâëåíà "Ïëàâíîñòü" â "Òðàíñïîðò" -> "SpeedHack"' or 'Added "Smooth" to "Vehicle" -> "SpeedHack"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Äîáàâëåíà ôóíêöèÿ "Ïåðñîíàæ" -> "Antistun"' or 'Added function "Actor" -> "Antistun"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Äîáàâëåíà ôóíêöèÿ "Îðóæèå" -> "+C"' or 'Added function "Weapon" -> "+C"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Äîáàâëåíà ôóíêöèÿ "Îðóæèå" -> "Áåç ïåðåçàðÿäêè"' or 'Added function "Weapon" -> "No reload"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Äîáàâëåíà ôóíêöèÿ "Âèçóàëû" -> "Ñêåëåò"' or 'Added function "Visual" -> "Skeleton"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Äîáàâëåíà ôóíêöèÿ "Âèçóàëû" -> "Ïîèñê 3D òåêñòîâ"' or 'Added function "Visual" -> "Search 3D text"'))
							if array.lang_menu[0] then
								imgui.Text(u8'- Äîáàâëåíà "Revent-RP" -> "Helper tools"')
								imgui.Text(u8'- Äîáàâëåíû ôóíêöèè â "Revent-RP" -> "Helper Tools", "Õåëïåðñêèé ÷àò" è "Âîçìîæíûå îòâåòû"')
								imgui.Text(u8'- Äîáàâëåíà ôóíêöèè â "Revent-RP" -> "Admin Tools", "Âîçìîæíûå îòâåòû"')
								imgui.Text(u8'- Äîáàâëåíà êîìàíäà /ahelp (Åñëè âêëþ÷åíî "Revent-RP" -> "Admin Tools" -> "Íîâûå êîìàíäû")')
							else
								imgui.Text('- Added more functions for Russian servers')
							end
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Äîáàâëåí Uptime ñïðàâà îò âñåõ âêëàäîê' or 'Added Uptime to the right of all tabs'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Äîáàâëåíû íåñêîëüêî ñòèëåé ImGui' or 'Added several ImGui styles'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Ìåëêèå èñïðàâëåíèÿ' or 'Minor fixes'))
							imgui.NewLine()
						imgui.Text('23.10.2020 - v1.1.1')
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Èñïðàâëåíà êîäèðîâêà â àâòîîáíîâëåíèè' or 'Fixed encoding in autoupdate'))
							imgui.NewLine()
						imgui.Text('21.10.2020 - v1.1')
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Äîáàâëåíà ôóíêöèÿ "Ïðîâåðêà äâåðåé" â "Âèçóàëû" -> "Òðàíñïîðò"' or 'Added "Check doors" function to "Visuals" -> "Vehicle"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Äîáàâëåíà ñìåíà ÿçûêà äëÿ "Âèçóàëû"' or 'Added language change for "Visuals"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Ôóíêöèÿ "Îðóæèÿ" -> "Ïîëíîå ïðèöåëèâàíèå" èçìåíèëî íàçâàíèå íà "Ïîëíîå óìåíèå"' or 'Function "Weapons" -> "Full aiming" changed name to "Full skill"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Ôóíêöèÿ "Òðàíñïîðò" -> "Òîëüêî êîëåñà" ïåðåíåñåíà âî âêëàäêó "Âèçóàëû" -> "Òðàíñïîðò"' or 'The function "Vehicle" -> "Only wheels" moved to the tab "Visuals" -> "Vehicle"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Èñïðàâëåíà ôóíêöèÿ "Ðàçíîå" -> "Ïîëå çðåíèå"' or 'Fixed function "Misc" -> "FOV changer"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Èñïðàâëåíà ôóíêöèÿ "Òðàíñïîðò" -> "SpeedHack"' or 'Fixed function "Vehicle" -> "SpeedHack"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Èñïðàâëåíà ôóíêöèÿ "Òðàíñïîðò" -> "Ïåðåâîðîò íà êîëåñà"' or 'Fixed function "Vehicle" -> "Flip on wheels"'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Èñïðàâëåíî àâòîîáíîâëåíèå' or 'Fixed autoupdate'))
							imgui.NewLine()
						imgui.Text('16.10.2020 - v1.0')
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Äîáàâëåíû ôóíêöèè â "Òðàíñïîðò": Ó âñåãî òðàíñïîðòà íèòðî; Òîëüêî êîëåñà; Òàíê ìîä; Òðàíñïîðò îòëåòàåò åñëè â íåãî ñòðåëüíóòü' or 'Added functions to "Transport": All vehicles have nitro; Wheels only; Tank mod; Vehicle float when hit'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Äîáàâëåíû êîíòàêòû â "Íàñòðîéêè"' or 'Added contacts to "Settings'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Óáðàíà êîìàíäà /z_at (òåïåðü äîñòóïåí ôóíêöèîíàë áåç äàííîé êîìàíäû)' or 'Removed the /z_at (functionality without this command is now available)'))
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Ìåëêèå èñïðàâëåíèÿ è äîðàáîòêè' or 'Minor fixes and improvements'))
							imgui.NewLine()
						imgui.Text('13.10.2020 - v0.928')
							imgui.Text('- ' .. (array.lang_menu[0] and u8'Ðåëèç' or 'Release'))
						imgui.SetCursorPosX(wx / 2)
						if imgui.Button(array.lang_menu[0] and u8'Çàêðûòü##2' or 'Close##2') then
							listupdate = false
						end
						imgui.EndPopup()
					end
				end
				if imgui.Button(array.lang_menu[0] and u8'Ïðîâåðèòü îáíîâëåíèÿ' or 'Check updates') then autoupdate(jsn_upd, tag, url_upd) end
				imgui.SameLine()
				imgui.Indent(300)
				if imgui.CollapsingHeader(array.lang_menu[0] and u8'Èíñòðóìåíòû äëÿ ðàçðàáîò÷èêîâ' or 'Tools for developers') then
					imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Èíôîðìàöèÿ äèàëîãîâ â êîíñîëè SF' or 'Dialog info in SF console', array.dev_dialogid)
					imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Îòîáðàæàòü ID Textdraw' or 'Display ID Textdraw', array.dev_textdraw)
					imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Èíôîðìàöèÿ GameText â êîíñîëè SF' or 'GameText info in SF console', array.dev_gametext)
					imgui.ToggleButton(array.typeToggle[0], array.lang_menu[0] and u8'Èíôîðìàöèÿ àíèìàöèé â êîíñîëè SF' or  'Animations info in SF console', array.dev_anim)
				end
				imgui.Unindent(300)
                imgui.EndChild()

            elseif act1 == 8 then
                imgui.BeginChild('##help', imgui.ImVec2(sw-140, sh-40), true)
				if imgui.CollapsingHeader(array.lang_menu[0] and u8'Êîìàíäû' or 'Commands') then
					imgui.TextColoredRGB('{0984d2}/zhelp {ffffff}- ' .. (array.lang_menu[0] and u8'Ïîìîùü ïî ñêðèïòó' or 'Script help'))
					imgui.TextColoredRGB('{0984d2}/zdate {ffffff}- ' .. (array.lang_menu[0] and u8'Ñåãîäíÿøíÿÿ äàòà' or 'Todays date'))
					imgui.TextColoredRGB('{0984d2}/zmenu {ffffff}- ' .. (array.lang_menu[0] and u8'{008900}Îòêðûòèå/Çàêðûòèå {ffffff}ìåíþ' or '{008900}Open/Close {ffffff}menu'))
					imgui.TextColoredRGB('{0984d2}/zcoord {ffffff}- ' .. (array.lang_menu[0] and u8'Îòìå÷àåò Âàøè êîîðäèíàòû' or 'You are coords'))
					imgui.TextColoredRGB('{0984d2}/zgetmoney {ffffff}- ' .. (array.lang_menu[0] and u8'Âûäàåò 1.000$ (Âèçóàëüíî)' or 'Give cash 1.000$ (Visual)'))
					imgui.TextColoredRGB('{0984d2}/ztime {ffffff}- ' .. (array.lang_menu[0] and u8'Ïîìåíÿòü âðåìÿ' or 'Change time'))
					imgui.TextColoredRGB('{0984d2}/zweather {ffffff}- ' .. (array.lang_menu[0] and u8'Ïîìåíÿòü ïîãîäó' or 'Change weather'))
					imgui.TextColoredRGB('{0984d2}/zsetmark {ffffff}- ' .. (array.lang_menu[0] and u8'Ïîñòàâèòü ìåòêó' or 'Create mark'))
					imgui.TextColoredRGB('{0984d2}/ztpmark {ffffff}- ' .. (array.lang_menu[0] and u8'Òåëåïîðòèðîâàòüñÿ ê ìåòêå' or 'Teleport to mark'))
					imgui.TextColoredRGB('{0984d2}/zcc {ffffff}- ' .. (array.lang_menu[0] and u8'Î÷èñòêà ÷àòà' or 'Clear chat'))
					imgui.TextColoredRGB('{0984d2}/zchecktime {ffffff}- ' .. (array.lang_menu[0] and u8'Òî÷íîå âðåìÿ ïî ÌÑÊ' or 'Exact time by MSK'))
					imgui.TextColoredRGB('{0984d2}/zsuicide {ffffff}- ' .. (array.lang_menu[0] and u8'Ñóèöèä (Åñëè â òðàíñïîðòå, òî âçðûâàåò òðàíñïîðò. Åñëè ïåøêîì, òî óáèâàåò Âàñ)' or 'Suicide (If you are in vehicle, then boom vehicle. If walking, it kills you)'))
					imgui.TextColoredRGB('{0984d2}/zreload {ffffff}- ' .. (array.lang_menu[0] and u8'Ïåðåçàãðóæàåò äàííûé ñêðèïò' or 'Reload this is script'))
					imgui.TextColoredRGB('{0984d2}/zfps {ffffff}- ' .. (array.lang_menu[0] and u8'Âûâîäèò FPS' or 'Displays FPS'))
					imgui.TextColoredRGB('{0984d2}/ztpgta {ffffff}- ' .. (array.lang_menu[0] and u8'Òåëåïîðòèðóåò ê ïîñòàâëåííîé ìåòêå' or 'Teleports to the placed mark'))
					if getServer('revent') then
						imgui.TextColoredRGB(u8'{0984d2}/ztogall {ffffff}- {008900}Âûêëþ÷àåò/Âêëþ÷àåò {ffffff}âñå ÷àòû êîòîðûå âîçìîæíî (Äëÿ Revent-RP)')
						imgui.TextColoredRGB(u8'{0984d2}/zrepair {ffffff}- ×èíèò Âàø òðàíñïîðò è ïèøåò, ÷òî ÿêîáû Âû ïî÷èíèëèñü â "ïî÷èíêå" (Äëÿ Revent-RP)')
					else
						imgui.TextColoredRGB('{0984d2}/zrepair {ffffff}- ' .. (array.lang_menu[0] and u8'×èíèò òðàíñïîðò' or 'Fixed vehicle'))
					end
				end
				if imgui.CollapsingHeader(array.lang_menu[0] and u8'Ñòàíäàðòíûå êîìàíäû SA:MP' or 'Standart commands SA:MP') then
					imgui.TextColoredRGB('{0984d2}/headmove {ffffff}- ' .. (array.lang_menu[0] and u8'{008900}Âêëþ÷àåò/Âûêëþ÷àåò {ffffff}ïîâîðîò ãîëîâû' or '{008900}On/Off {ffffff}head rotation'))
					imgui.TextColoredRGB('{0984d2}/timestamp {ffffff}- ' .. (array.lang_menu[0] and u8'{008900}Âêëþ÷àåò/Âûêëþ÷àåò {ffffff}âðåìÿ âîçëå êàæäîãî ñîîáùåíèÿ' or '{008900}On/Off {ffffff}time near each message'))
					imgui.TextColoredRGB('{0984d2}/pagesize {ffffff}- ' .. (array.lang_menu[0] and u8'Óñòàíàâëèâàåò êîëè÷åñòâî ñòðîê â ÷àòå' or 'Set the number of lines in the chat'))
					imgui.TextColoredRGB('{0984d2}/fontsize {ffffff}- ' .. (array.lang_menu[0] and u8'Óñòàíàâëèâàåò òîëùèíó ÷àòà' or 'Set wide in the chat'))
					imgui.TextColoredRGB('{0984d2}/quit (/q) {ffffff}- ' .. (array.lang_menu[0] and u8'Áûñòðûé âûõîä èç èãðû' or 'Quick exit from the game'))
					imgui.TextColoredRGB('{0984d2}/save [êîììåíòàðèé] {ffffff}- ' .. (array.lang_menu[0] and u8'Ñîõðàíåíèå êîîðäèíàò â {008900}savedposition.txt' or 'Save coordinates to {008900}savedposition.txt'))
					imgui.TextColoredRGB('{0984d2}/fpslimit {ffffff}- ' .. (array.lang_menu[0] and u8'Óñòàíàâëèâàåò ëèìèò êàäðîâ â ñåêóíäó' or 'Set the frames per second limit'))
					imgui.TextColoredRGB('{0984d2}/dl {ffffff}- ' .. (array.lang_menu[0] and u8'{008900}Âêëþ÷àåò/Âûêëþ÷àåò {ffffff}ïîäðîáíóþ èíôîðìàöèþ î òðàíñïîðòå ïî áëèçîñòè' or '{008900}On/Off {ffffff}detailed information about near vehicle'))
					imgui.TextColoredRGB('{0984d2}/interior {ffffff}- ' .. (array.lang_menu[0] and u8'Âûâîäèò â ÷àò òåêóùèé èíòåðüåð' or 'Current interior to chat'))
					imgui.TextColoredRGB('{0984d2}/rs {ffffff}- ' .. (array.lang_menu[0] and u8'Ñîõðàíåíèå êîîðäèíàò â {008900}rawposition.txt' or 'Save coordinates to {008900}rawposition.txt'))
					imgui.TextColoredRGB('{0984d2}/mem {ffffff}- ' .. (array.lang_menu[0] and u8'Îòîáðàæàåò ñêîëüêî ïàìÿòè èñïîëüçóåò SA:MP' or 'How much memory SA:MP uses'))
					imgui.NewLine()
				end
				imgui.TextColoredRGB(array.lang_menu[0] and u8'{008900}Àâòîðñòâî:\n{0984d2}Nyhfox {ffffff}- Ñîçäàòåëü' or '{008900}Authorship:\n{0984d2}Nyhfox {ffffff}- Creator')
				imgui.EndChild()
            elseif act1 == 10 then
                imgui.BeginChild('##arizonarp', imgui.ImVec2(sw-140, sh-40), true)
				imgui.PushItemWidth(150)
				imgui.InputText(u8'Àâòî-ëîãèí', array.arz_passacc, sizeof(array.arz_passacc), not showPass1 and imgui.InputTextFlags.Password or 0)
				imgui.SameLine()
				if not showPass1 then if imgui.Button(fa.ICON_EYE..'##1') then showPass1 = not showPass1 end
				else if imgui.Button(fa.ICON_EYE_SLASH..'##1') then showPass1 = not showPass1 end end
				imgui.SameLine()
				if imgui.Button(u8'Î÷èñòèòü ##1') then imgui.StrCopy(array.arz_passacc, '') end
				imgui.InputInt(u8'Ïèí-êîä', array.arz_pincode, 0, 0, not showPass2 and imgui.InputTextFlags.Password or 0)
				imgui.PopItemWidth()
				imgui.SameLine(nil, 26)
				if not showPass2 then if imgui.Button(fa.ICON_EYE..'##2') then showPass2 = not showPass2 end
				else if imgui.Button(fa.ICON_EYE_SLASH..'##2') then showPass2 = not showPass2 end end
				imgui.SameLine()
				if imgui.Button(u8'Î÷èñòèòü ##2') then imgui.StrCopy(array.arz_pincode, '') end
				imgui.ToggleButton(array.typeToggle[0], u8'Ýìóëÿöèÿ ëàóí÷åðà', array.arz_launcher)
				imgui.ToggleButton(array.typeToggle[0], u8'Áûñòðûé /rep(ort)', array.arz_fastreport)
				imgui.TextQuestion('##arz_fastreport', u8'Ïðè èñïîëüçîâàíèè êîìàíäû /rep(ort) âûçûâàåòñÿ äèàëîãîâîå îêíî, åñëè ïîñûëàåòå æàëîáó/âîïðîñ,\nòî îêíî íå ïîÿâëÿåòñÿ, à ñðàçó îòïðàâëÿåòñÿ àäìèíèñòðàöèè Âàøà æàëîáà/âîïðîñ\nÍàïðèìåð, /report Êàê îòêðûòü èíâåíòàðü? - Îòïðàâèòüñÿ ñðàçó àäìèíèñòðàöèè äàííîå ñîîáùåíèå')
				imgui.ToggleButton(array.typeToggle[0], u8'Ïðîïóñê äèàëîãîâîãî îêíà ïðè îòâåòå àäìèíèñòðàöèè íà Âàø /report', array.arz_autoskiprep)
				imgui.ToggleButton(array.typeToggle[0], u8'Ïîèñê îáúåêòîâ', array.arz_venable)
				imgui.SameLine()
				imgui.Text(fa.ICON_COG)
				if imgui.IsItemClicked() then
					imgui.OpenPopup('Íàñòðîéêè Ïîèñê ARZ')
				end
				imgui.SetNextWindowSize(imgui.ImVec2(-1, -1))
				if imgui.BeginPopup('Íàñòðîéêè Ïîèñê ARZ') then
					imgui.Text(u8'Îáùèé öâåò')
					imgui.SameLine()
					if imgui.ColorEdit4('##arz_color', arz_vcolor, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoTooltip) then
						local c = imgui.ImVec4(arz_vcolor[0],  arz_vcolor[1], arz_vcolor[2],  arz_vcolor[3])
						local argb = imgui.ColorConvertFloat4ToARGB(c)
						mainIni.arizonarp.vcolor = argb
					end
					imgui.ToggleButton(array.typeToggle[0], u8'Ðàäóãà', array.arz_rainbow)
					imgui.SameLine()
					imgui.PushItemWidth(50)
					imgui.SliderInt(u8'Ñêîðîñòü', array.arz_speed, 1, 30)
					imgui.PopItemWidth()
					imgui.ToggleButton(array.typeToggle[0], u8'Ðèñîâàòü ëèíèþ', array.arz_vline)
					imgui.Separator()
					imgui.ToggleButton(array.typeToggle[0], u8'Îðóæèÿ', array.arzsearchGuns)
					imgui.ToggleButton(array.typeToggle[0], u8'Ñåìåíà', array.arzsearchSeed)
					imgui.ToggleButton(array.typeToggle[0], u8'Îëåíè', array.arzsearchDeer)
					imgui.ToggleButton(array.typeToggle[0], u8'Íàðêîòèêè', array.arzsearchDrugs)
					imgui.ToggleButton(array.typeToggle[0], u8'Ïîäàðêè', array.arzsearchGift)
					imgui.ToggleButton(array.typeToggle[0], u8'Êëàäû', array.arzsearchTreasure)
					imgui.ToggleButton(array.typeToggle[0], u8'Ìàòåðèàëû', array.arzsearchMats)
					imgui.EndPopup()
				end
				imgui.TextQuestion('##arz_venable', u8'Ðàáîòàåò â çîíå ñòðèìà. Ðèñóåò äèñòàíöèþ è íàèìåíîâàíèå ïîèñêà')
                imgui.EndChild()

            elseif act1 == 9 then
                imgui.BeginChild('##reventrp', imgui.ImVec2(sw-140, sh-40), true)
				imgui.ToggleButton(array.typeToggle[0], u8'Ïîèñê îáúåêòîâ', array.rv_venable)
				imgui.TextQuestion('##rv_venable', u8'Ðàáîòàåò â çîíå ñòðèìà. Ðèñóåò äèñòàíöèþ è íàèìåíîâàíèå ïîèñêà')
				imgui.SameLine()
				imgui.Text(fa.ICON_COG)
				if imgui.IsItemClicked() then
					imgui.OpenPopup('Íàñòðîéêè Ïîèñê RVRP')
				end
				imgui.SetNextWindowSize(imgui.ImVec2(-1, -1))
				if imgui.BeginPopup('Íàñòðîéêè Ïîèñê RVRP') then
					if imgui.ColorEdit4('##rv_color', rv_vcolor, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoTooltip) then
						local c = imgui.ImVec4(rv_vcolor[0],  rv_vcolor[1], rv_vcolor[2],  rv_vcolor[3])
						local argb = imgui.ColorConvertFloat4ToARGB(c)
						mainIni.reventrp.vcolor = argb
					end
					imgui.SameLine()
					imgui.Text(u8'Îáùèé öâåò')
					imgui.ToggleButton(array.typeToggle[0], u8'Ðàäóãà', array.rv_rainbow)
					imgui.SameLine()
					imgui.PushItemWidth(50)
					imgui.SliderInt(u8'Ñêîðîñòü', array.rv_speed, 1, 30)
					imgui.PopItemWidth()
					imgui.ToggleButton(array.typeToggle[0], u8'Ðèñîâàòü ëèíèþ', array.rv_line)
					imgui.Separator()
					imgui.ToggleButton(array.typeToggle[0], u8'Òðóïû', array.rvsearchCorpse)
					imgui.ToggleButton(array.typeToggle[0], u8'Ïîäêîâû', array.rvsearchHorseshoe)
					imgui.ToggleButton(array.typeToggle[0], u8'Òîòåìû', array.rvsearchTotems)
					imgui.ToggleButton(array.typeToggle[0], u8'Êîíòåéíåðû', array.rvsearchCont)
					imgui.TextQuestion('##cont', u8'Ìîãóò áûòü íå ñåìåéíûå êîíòåéíåðû')
					imgui.EndPopup()
				end
				imgui.ToggleButton(array.typeToggle[0], u8'Èñïðàâëåíèå ÷àòà', array.rv_fixchat)
				imgui.TextQuestion('##rv_fixchat', u8'ÁÅÒÀ!\nÍà ÷àò òåïåðü áîëåå ïðèÿòíî ñìîòðåòü')
				imgui.NewLine()
				imgui.CenterTextColored(imgui.ImVec4(imgui.GetStyle().Colors[imgui.Col.Text]), u8'Òåëåïîðòû')
				for structure, tOrg in pairs(tpListRVRP) do
					if imgui.CollapsingHeader(u8(structure)) then
						imgui.Columns(3)
						for orgName, tCoords in pairs(tOrg) do
							if imgui.Button(u8(orgName), imgui.ImVec2(-1, 20)) then
								teleportInterior(playerPed, tCoords[1], tCoords[2], tCoords[3], tCoords[4])
							end
							imgui.NextColumn()
						end
						imgui.Columns(1)
					end
				end
                imgui.EndChild()
            else
                actEnterInGame = 1
                imgui.BeginChild('##helpCheatsByNyhfox', imgui.ImVec2(sw-140, sh-40), true)
                imgui.Text(u8'Select language/Âûáåðèòå ÿçûê:')
                imgui.SameLine()
                if imgui.Button('English') then langIG[1] = true langIG[2] = false end
                imgui.SameLine()
                if imgui.Button(u8'Ðóññêèé') then langIG[1] = false langIG[2] = true end
                imgui.Text(langIG[1] and u8(imgIntGameENG[1]) or u8(imgIntGameRUS[1]))
				if imgui.CollapsingHeader(langIG[1] and 'More about tabs' or u8'Ïîäðîáíåå ïðî âêëàäêè') then
					imgui.Text(langIG[1] and u8(imgIntGameENG[2]) or u8(imgIntGameRUS[2]))
					imgui.Separator()
				end
				imgui.Text(langIG[1] and u8(imgIntGameENG[3]) or u8(imgIntGameRUS[3]))
                imgui.EndChild()
            end
        end
        imgui.End()
    end
)

function funcs()
	local GMtext = checkfuncs.others.GMactor and '{29C730}GM' or '{B22C2C}GM'
	local VGMtext = (checkfuncs.others.GMveh or checkfuncs.others.GMWveh) and '{29C730}VGM' or '{B22C2C}VGM'
	local EngineText = array.show_imgui_engineOnVeh[0] and (array.lang_visual[0] and '{29C730}Äâèãàòåëü' or '{29C730}Engine') or (array.lang_visual[0] and '{B22C2C}Äâèãàòåëü' or '{B22C2C}Engine')
	local pCtext = array.show_imgui_plusC[0] and checkfuncs.others.PlusC and '{29C730}+C' or '{B22C2C}+C'
	local ABtext = array.show_imgui_AirBrake[0] and checkfuncs.others.AirBrake and '{29C730}AirBrake' or '{B22C2C}AirBrake'
	local ABHtext = array.show_imgui_antibhop[0] and '{29C730}Anti-BHop' or '{B22C2C}Anti-BHop'
	tBlipResult, tbX, tbY, tbZ = getTargetBlipCoordinates()
-- ACTOR
	mem.setint8(0xB7CEE4, (((array.show_imgui_infRun[0] and not isCharInWater(PLAYER_PED)) or (array.show_imgui_infSwim[0] and isCharInWater(PLAYER_PED))) and 1 or 0), false)
	mem.setint8(0x96916E, (array.show_imgui_infOxygen[0] and 1 or 0), false)
	mem.setint8(0x96916C, (array.show_imgui_megajumpActor[0] and 1 or 0), false)
	
	local checkFuncForGm = array.show_imgui_gmActor[0] and checkfuncs.others.GMactor
	setCharProofs(PLAYER_PED, checkFuncForGm and true or false, checkFuncForGm and true or false, checkFuncForGm and true or false, checkFuncForGm and true or false, checkFuncForGm and true or false)

	if array.show_imgui_nofall[0] and (isCharPlayingAnim(PLAYER_PED, 'KO_SKID_BACK') or isCharPlayingAnim(PLAYER_PED, 'FALL_COLLAPSE')) then
		clearCharTasksImmediately(PLAYER_PED)
	end

	if array.stopQuick[0] and (isCharPlayingAnim(PLAYER_PED, 'RUN_STOP') or isCharPlayingAnim(PLAYER_PED, 'RUN_STOPR')) then
		clearCharTasksImmediately(PLAYER_PED)
	end

	if array.show_imgui_antistun[0] then
		local anims = {'DAM_armL_frmBK', 'DAM_armL_frmFT', 'DAM_armL_frmLT', 'DAM_armR_frmBK', 'DAM_armR_frmFT', 'DAM_armR_frmRT', 'DAM_LegL_frmBK', 'DAM_LegL_frmFT', 'DAM_LegL_frmLT', 'DAM_LegR_frmBK', 'DAM_LegR_frmFT', 'DAM_LegR_frmRT', 'DAM_stomach_frmBK', 'DAM_stomach_frmFT', 'DAM_stomach_frmLT', 'DAM_stomach_frmRT'}
		for k, v in ipairs(anims) do
			if isCharPlayingAnim(PLAYER_PED, v) then
				setCharAnimSpeed(PLAYER_PED, v, 999)
			end
		end
	end
-- VEHICLE
	if isCharInAnyCar(PLAYER_PED) and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and not isPlayerDead(PLAYER_PED) then
		local veh = storeCarCharIsInNoSave(PLAYER_PED)
		if array.antiboom_upside[0] then
			if isCarUpsidedown(veh) then
				setCarHealth(veh, 1000)
			end
		end

		setCharCanBeKnockedOffBike(PLAYER_PED, array.show_imgui_antiBikeFall[0] and true or false)

		if array.show_imgui_gmVeh[0] then
			if array.show_imgui_gmVehDefault[0] and checkfuncs.others.GMveh then
				setCarProofs(veh, true, true, true, true, true)
			end
			if array.show_imgui_gmVehWheels[0] and checkfuncs.others.GMWveh then
				setCanBurstCarTires(veh, false)
			end
		end

		if array.show_imgui_fixWheels[0] and wasKeyPressed(key.VK_2) and wasKeyPressed(key.VK_Z)  then
			for i = 0, 3 do fixCarTire(veh, i) end
		end

		if array.show_imgui_engineOnVeh[0] then
			switchCarEngine(veh, true)
		end

		if array.show_imgui_speedhack[0] and isKeyDown(key.VK_LMENU) then
			if getCarSpeed(veh) * 2.01 <= array.SpeedHackMaxSpeed[0] then
				local cVecX, cVecY, cVecZ = getCarSpeedVector(veh)
				local heading = getCarHeading(veh)
				local turbo = fps_correction() / array.SpeedHackSmooth[0]
				local xforce, yforce, zforce = turbo, turbo, turbo
				local Sin, Cos = math.sin(-math.rad(heading)), math.cos(-math.rad(heading))
				if cVecX > -0.01 and cVecX < 0.01 then xforce = 0.0 end
				if cVecY > -0.01 and cVecY < 0.01 then yforce = 0.0 end
				if cVecZ < 0 then zforce = -zforce end
				if cVecZ > -2 and cVecZ < 15 then zforce = 0.0 end
				if Sin > 0 and cVecX < 0 then xforce = -xforce end
				if Sin < 0 and cVecX > 0 then xforce = -xforce end
				if Cos > 0 and cVecY < 0 then yforce = -yforce end
				if Cos < 0 and cVecY > 0 then yforce = -yforce end
				applyForceToCar(veh, xforce * Sin, yforce * Cos, zforce / 2, 0.0, 0.0, 0.0)
			end
		end
	end

	mem.setint8(0x96914C, (array.show_imgui_perfectHandling[0] and 1 or 0), false)
	mem.setint8(0x969161, (array.show_imgui_megajumpBMX[0] and 1 or 0), false)
	mem.setint8(0x969165, (array.show_imgui_allCarsNitro[0] and 1 or 0), false)
	mem.setint8(0x96914B, (array.show_imgui_onlyWheels[0] and 1 or 0), false)
	mem.setint8(0x969164, (array.show_imgui_tankMode[0] and 1 or 0), false)
	mem.setint8(0x969152, (array.show_imgui_driveOnWater[0] and not isCharOnAnyBike(PLAYER_PED) and 1 or 0), false)
-- WEAPONS
	if isCharShooting(PLAYER_PED) then
		mem.setint8(0x969178, (array.show_imgui_infAmmo[0] and 1 or 0), false)
		mem.setint8(0x969179, (array.show_imgui_fullskills[0] and 1 or 0), false)

		if array.show_imgui_noreload[0] then
			local weap = getCurrentCharWeapon(PLAYER_PED)
			local nbs = raknetNewBitStream()
			raknetBitStreamWriteInt32(nbs, weap)
			raknetBitStreamWriteInt32(nbs, 0)
			raknetEmulRpcReceiveBitStream(22, nbs)
			raknetDeleteBitStream(nbs)
		end
	end

	if array.show_imgui_aim[0] and isKeyDown(1) then
		local _, ped = storeClosestEntities(1)
		if ped ~= -1 then
			local x, y, z = getCharCoordinates(ped)
			targetAtCoords(x, y, z)
		end
	end
-- MISC
	mem.setint8(0x6C2759, (array.show_imgui_UnderWater[0] and 1 or 0), false)

	if array.inputHelper[0] and sampIsChatInputActive() then
		local getInput = sampGetChatInputText()
		if oldText ~= getInput and #getInput > 0 then
			local firstChar = string.sub(getInput, 1, 1)
			if firstChar == "." or firstChar == "/" then
				local cmd, text = string.match(getInput, "^([^ ]+)(.*)")
				local nText = "/" .. translite(string.sub(cmd, 2)) .. text
				local chatInfoPtr = sampGetInputInfoPtr()
				local chatBoxInfo = getStructElement(chatInfoPtr, 0x8, 4)
				local lastPos = mem.getint8(chatBoxInfo + 0x11E)
				sampSetChatInputText(nText)
				mem.setint8(chatBoxInfo + 0x11E, lastPos)
				mem.setint8(chatBoxInfo + 0x119, lastPos)
				oldText = nText
			end
		end
	end

	if array.chatOnT[0] and isKeyDown(key.VK_T) and wasKeyPressed(key.VK_T) and not sampIsChatInputActive() and not sampIsDialogActive() then
		sampSetChatInputEnabled(true)
	end

	if array.fastSelectOnDialog[0] then
		local keys = {[0x30] = 9, [0x31] = 0, [0x32] = 1, [0x33] = 2, [0x34] = 3, [0x35] = 4, [0x36] = 5, [0x37] = 6, [0x38] = 7, [0x39] = 8}
		for k, v in pairs(keys) do
			if wasKeyPressed(k) then
				sampSetCurrentDialogListItem(v)
			end
		end
	end

	if array.show_imgui_FOV[0] then
		if isCurrentCharWeapon(PLAYER_PED, 34) and isKeyDown(2) then
			if not checkfuncs.main.locked then
				cameraSetLerpFov(70.0, 70.0, 1000, 1)
				checkfuncs.main.locked = true
			end
		else
			cameraSetLerpFov(array.FOV_value[0], 70.0, 1000, 1)
			checkfuncs.main.locked = false
		end
	end
	
	if array.offChatF7[0] and sampGetChatDisplayMode() == 1 then
		sampSetChatDisplayMode(0)
	end

	if array.show_imgui_sensfix[0] then
		local asf = mem.read (0xB6EC1C, 4, false)
		local bsf = mem.read (0xB6EC18, 4, false)
		if not asf == bsf then --float
			writeMemory (0xB6EC18, 4, asf, false)
		end
	end

	if array.show_imgui_AirBrake[0] and checkfuncs.others.AirBrake then
		if isCharInAnyCar(PLAYER_PED) then heading = getCarHeading(storeCarCharIsInNoSave(PLAYER_PED))
		else heading = getCharHeading(PLAYER_PED) end
		local camCoordX, camCoordY, camCoordZ = getActiveCameraCoordinates()
		local targetCamX, targetCamY, targetCamZ = getActiveCameraPointAt()
		local angle = getHeadingFromVector2d(targetCamX - camCoordX, targetCamY - camCoordY)
		local difference = isCharInAnyCar(PLAYER_PED) and 0.79 or 1.0
		local checkOth = (not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive())
		if isKeyDown(key.VK_W) then
			if checkOth then
				airBrakeCoords[1] = airBrakeCoords[1] + array.AirBrake_Speed[0] * math.sin(-math.rad(angle))
				airBrakeCoords[2] = airBrakeCoords[2] + array.AirBrake_Speed[0] * math.cos(-math.rad(angle))
				setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - difference)
				if not isCharInAnyCar(PLAYER_PED) then setCharHeading(PLAYER_PED, angle)
				else setCarHeading(storeCarCharIsInNoSave(PLAYER_PED), angle) end
			else setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - 1.0) end
		elseif isKeyDown(key.VK_S) then
			if checkOth then
				airBrakeCoords[1] = airBrakeCoords[1] - array.AirBrake_Speed[0] * math.sin(-math.rad(heading))
				airBrakeCoords[2] = airBrakeCoords[2] - array.AirBrake_Speed[0] * math.cos(-math.rad(heading))
				setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - difference)
			else setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - 1.0) end
		end
		if isKeyDown(key.VK_A) then
			if checkOth then
				airBrakeCoords[1] = airBrakeCoords[1] - array.AirBrake_Speed[0] * math.sin(-math.rad(heading - 90))
				airBrakeCoords[2] = airBrakeCoords[2] - array.AirBrake_Speed[0] * math.cos(-math.rad(heading - 90))
				setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - difference)
			else setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - 1.0) end
		elseif isKeyDown(key.VK_D) then
			if checkOth then
				airBrakeCoords[1] = airBrakeCoords[1] - array.AirBrake_Speed[0] * math.sin(-math.rad(heading + 90))
				airBrakeCoords[2] = airBrakeCoords[2] - array.AirBrake_Speed[0] * math.cos(-math.rad(heading + 90))
				setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - difference)
			else setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - 1.0) end
		end
		if (array.AirBrake_keys[0] == 1 and isKeyDown(key.VK_UP)) or (array.AirBrake_keys[0] == 2 and isKeyDown(key.VK_SPACE)) then
			if checkOth then
				airBrakeCoords[3] = airBrakeCoords[3] + array.AirBrake_Speed[0]  / 2.0
				setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - difference)
			else setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - 1.0) end
		end
		if (array.AirBrake_keys[0] == 1 and isKeyDown(key.VK_DOWN)) or (array.AirBrake_keys[0] == 2 and isKeyDown(key.VK_LSHIFT)) and airBrakeCoords[3] > -95.0 then
			if checkOth then
				airBrakeCoords[3] = airBrakeCoords[3] - array.AirBrake_Speed[0]  / 2.0
				setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - difference)
			else setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - 1.0) end
		end
		if not isKeyDown(key.VK_W) and not isKeyDown(key.VK_S) and not isKeyDown(key.VK_A) and not isKeyDown(key.VK_D) and (array.AirBrake_keys[0] == 1 and not isKeyDown(key.VK_UP) and not isKeyDown(key.VK_DOWN)) or (array.AirBrake_keys[0] == 2 and not isKeyDown(key.VK_SPACE) and not isKeyDown(key.VK_LSHIFT)) then
			setCharCoordinates(PLAYER_PED, airBrakeCoords[1], airBrakeCoords[2], airBrakeCoords[3] - 1.0)
		end
	end

	if array.show_imgui_blink[0] and not isSampfuncsConsoleActive() and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() then
		blinkDist = array.blink_dist[0]
		local camCoordX, camCoordY, camCoordZ = getActiveCameraCoordinates()
		local targetCamX, targetCamY, targetCamZ = getActiveCameraPointAt()
		local angle = getHeadingFromVector2d(targetCamX - camCoordX, targetCamY - camCoordY)
		local posX, posY, posZ = getCharCoordinates(PLAYER_PED)
		blink = {posX, posY, posZ}
		if isCharInAnyCar(PLAYER_PED) then difference = 0.79
		else difference = 1.0 end
		if isKeyJustPressed(key.VK_X) then
			if not isCharInAnyCar(PLAYER_PED) then setCharHeading(PLAYER_PED, angle)
			else setCarHeading(storeCarCharIsInNoSave(PLAYER_PED), angle) end
			blink[1] = blink[1] + array.blink_dist[0] * math.sin(-math.rad(angle))
			blink[2] = blink[2] + array.blink_dist[0] * math.cos(-math.rad(angle))
			setCharCoordinates(PLAYER_PED, blink[1], blink[2], blink[3] - difference)
		end
	end
-- VISUAL
	local rCash = readMemory(0xB7CE50, 4, false)
	local rCash_hud = readMemory(0xB7CE54, 4, false)
	
	if isPlayerPlaying(PLAYER_HANDLE) and not isPauseMenuActive() then
		if array.notDelayCash[0] then writeMemory(0xB7CE54, 4, rCash, false) end -- for misc
		if array.pulsCash[0] and rCash == rCash_hud then writeMemory(0xB7CE54, 4, 0, false) end

		if array.dev_textdraw[0] then
			for a = 0, 2304	do
				if sampTextdrawIsExists(a) then
					local x, y = sampTextdrawGetPos(a)
					local x1, y1 = convertGameScreenCoordsToWindowScreenCoords(x, y)
					renderFontDrawText(ifont, a, x1, y1, 0xFFFFFFFF)
				end
			end
		end

		if array.srch3dtext[0] then
			local screenW, screenH = getScreenResolution()
			if isPlayerPlaying(PLAYER_HANDLE) then
				local posX, posY, posZ = getCharCoordinates(PLAYER_PED)
				local res, text, color, x, y, z, distance, ignoreWalls--[[, player, vehicle]] = Search3Dtext(posX, posY, posZ, 50.0, "")
				if res then
					renderFontDrawText(ifont, string.format(array.lang_visual[0] and "%s \nÄèñòàíöèÿ: %.2f" or "%s \nDistance: %.2f", text, distance), screenW / 2 + 600, screenH / 2 + 250, color)
				end
			end
		end

		local oTime = os.time()
		if array.traserbull[0] then
			for i = 1, BulletSync.maxLines do
				if BulletSync[i].enable == true and oTime <= BulletSync[i].time then
					local o, t = BulletSync[i].o, BulletSync[i].t
					if isPointOnScreen(o.x, o.y, o.z) and
					isPointOnScreen(t.x, t.y, t.z) then
						local sx, sy = convert3DCoordsToScreen(o.x, o.y, o.z)
						local fx, fy = convert3DCoordsToScreen(t.x, t.y, t.z)
						renderDrawLine(sx, sy, fx, fy, 1, BulletSync[i].tType == 0 and 0xFFFFFFFF or 0xFFFFC700)
						renderDrawPolygon(fx, fy-1, 3, 3, 4.0, 10, BulletSync[i].tType == 0 and 0xFFFFFFFF or 0xFFFFC700)
					end
				end
			end
		end

		if (array.show_imgui_skeleton[0] and not array.show_imgui_keyWH[0]) or (array.show_imgui_skeleton[0] and array.show_imgui_keyWH[0] and checkfuncs.others.KeyWH) then
			for i = 0, sampGetMaxPlayerId() do
				if sampIsPlayerConnected(i) then
					local result, cped = sampGetCharHandleBySampPlayerId(i)
					local color = sampGetPlayerColor(i)
					local aa, rr, gg, bb = explode_argb(color)
					local color = join_argb(255, rr, gg, bb)
					if result then
						if doesCharExist(cped) and isCharOnScreen(cped) then
							local t = {3, 4, 5, 51, 52, 41, 42, 31, 32, 33, 21, 22, 23, 2}
							for v = 1, #t do
								pos1X, pos1Y, pos1Z = getBodyPartCoordinates(t[v], cped)
								pos2X, pos2Y, pos2Z = getBodyPartCoordinates(t[v] + 1, cped)
								pos1, pos2 = convert3DCoordsToScreen(pos1X, pos1Y, pos1Z)
								pos3, pos4 = convert3DCoordsToScreen(pos2X, pos2Y, pos2Z)
								renderDrawLine(pos1, pos2, pos3, pos4, 1, color)
							end
							for v = 4, 5 do
								pos2X, pos2Y, pos2Z = getBodyPartCoordinates(v * 10 + 1, cped)
								pos3, pos4 = convert3DCoordsToScreen(pos2X, pos2Y, pos2Z)
								renderDrawLine(pos1, pos2, pos3, pos4, 1, color)
							end
							local t = {53, 43, 24, 34, 6}
							for v = 1, #t do
								posX, posY, posZ = getBodyPartCoordinates(t[v], cped)
								pos1, pos2 = convert3DCoordsToScreen(posX, posY, posZ)
							end
						end
					end
				end
			end
		end

		if array.show_imgui_clickwarp[0] and checkfuncs.others.Clickwarp then
			if sampGetCursorMode() == 0 then sampSetCursorMode(2) end
			local sx, sy = getCursorPos()
			local sw, sh = getScreenResolution()
			if sx >= 0 and sy >= 0 and sx < sw and sy < sh then
				local posX, posY, posZ = convertScreenCoordsToWorld3D(sx, sy, 700.0)
				local camX, camY, camZ = getActiveCameraCoordinates()
				local result, colpoint = processLineOfSight(camX, camY, camZ, posX, posY, posZ, true, true, false, true, false, false, false)
				if result and colpoint.entity ~= 0 then
					local normal = colpoint.normal
					local pos = Vector3D(colpoint.pos[1], colpoint.pos[2], colpoint.pos[3]) - (Vector3D(normal[1], normal[2], normal[3]) * 0.1)
					local zOffset = 300
					if normal[3] >= 0.5 then zOffset = 1 end
					local result, colpoint2 = processLineOfSight(pos.x, pos.y, pos.z + zOffset, pos.x, pos.y, pos.z - 0.3,
						true, true, false, true, false, false, false)
					if result then
						pos = Vector3D(colpoint2.pos[1], colpoint2.pos[2], colpoint2.pos[3] + 1)
						local curX, curY, curZ = getCharCoordinates(PLAYER_PED)
						local dist = getDistanceBetweenCoords3d(curX, curY, curZ, pos.x, pos.y, pos.z)
						local hoffs = renderGetFontDrawHeight(clickfont)
						sy = sy - 2
						sx = sx - 2
						renderFontDrawText(clickfont, string.format(array.lang_visual[0] and 'Äèñòàíöèÿ: %0.2f' or 'Distance: %0.2f', dist), sx - (renderGetFontDrawTextLength(clickfont, string.format(array.lang_visual[0] and 'Äèñòàíöèÿ: %0.2f' or 'Distance: %0.2f', dist)) / 2) + 6, sy - hoffs, 0xFFFFFFFF)
						local tpIntoCar = nil
						if colpoint.entityType == 2 then
							local car = getVehiclePointerHandle(colpoint.entity)
							if doesVehicleExist(car) and (not isCharInAnyCar(PLAYER_PED) or storeCarCharIsInNoSave(PLAYER_PED) ~= car) then
								if isKeyJustPressed(key.VK_LBUTTON) and isKeyJustPressed(key.VK_RBUTTON) then tpIntoCar = car end
								renderFontDrawText(clickfont, array.lang_visual[0] and '{0984d2}Çàæìèòå ÏÊÌ ÷òîáû {FFFFFF}ñåñòü â òðàíñïîðò' or '{0984d2}Push RBM for {FFFFFF}warp to vehicle', sx - (renderGetFontDrawTextLength(clickfont, array.lang_visual[0] and '{0984d2}Çàæìèòå ÏÊÌ ÷òîáû {FFFFFF}ñåñòü â òðàíñïîðò' or '{0984d2}Push RBM for {FFFFFF}warp to vehicle') / 2) + 6, sy - hoffs * 2, -1)
							end
						end
						if isKeyJustPressed(key.VK_LBUTTON) then
							if tpIntoCar then
								if not jumpIntoCar(tpIntoCar) then
									teleportPlayer(pos.x, pos.y, pos.z)
								end
							else
								if isCharInAnyCar(PLAYER_PED) then
									local norm = Vector3D(colpoint.normal[1], colpoint.normal[2], 0)
									local norm2 = Vector3D(colpoint2.normal[1], colpoint2.normal[2], colpoint2.normal[3])
									rotateCarAroundUpAxis(storeCarCharIsInNoSave(PLAYER_PED), norm2)
									pos = pos - norm * 1.8
									pos.z = pos.z - 1.1
								end
								teleportPlayer(pos.x, pos.y, pos.z)
							end
							sampSetCursorMode(0)
							checkfuncs.others.Clickwarp = false
						end
					end
				end
			end
		end

		if (array.show_imgui_nametag[0] and not array.show_imgui_keyWH[0]) or (array.show_imgui_nametag[0] and array.show_imgui_keyWH[0] and checkfuncs.others.KeyWH) then
			WHtext = '{29C730}WH'
			nameTagOn()
		else
			WHtext = '{B22C2C}WH'
			nameTagOff()
		end

		if array.show_imgui_doorlocks[0] then
			for k, v in pairs(getAllVehicles()) do
				local x, y, z = getCarCoordinates(v)
				local positionX, positionY, positionZ = getCharCoordinates(PLAYER_PED)
				local DoorsStats = getCarDoorLockStatus(v)
				local wposX, wposY = convert3DCoordsToScreen(x, y, z)
				local strStatus = ''
				if DoorsStats == 0 then
					strStatus = array.lang_visual[0] and '{00FF00}Îòêðûòî' or '{00FF00}Open'
				elseif DoorsStats == 2 then
					strStatus = array.lang_visual[0] and '{FF0000}Çàêðûòî' or '{FF0000}Closed'
				end
				local dist = getDistanceBetweenCoords3d(positionX, positionY, positionZ, x, y, z)
				if isPointOnScreen(x, y, z, 0) and dist < array.distDoorLocks[0] then
					renderFontDrawText(ifont, strStatus, wposX, wposY - 20, 0xFF0984D2)
				end
			end
		end

		if array.chatHelper[0] and sampIsChatInputActive() then
			local in1 = sampGetInputInfoPtr()
			local in1 = getStructElement(in1, 0x8, 4)
			local in2 = getStructElement(in1, 0x8, 4)
			local in3 = getStructElement(in1, 0xC, 4)
			local success, errorCode = ffi.C.GetKeyboardLayoutNameA(KeyboardLayoutName), ffi.C.GetLocaleInfoA(tonumber(ffi.string(KeyboardLayoutName), 16), 0x00000002, LocalInfo, 32)
			local capsState, numState, localName = ffi.C.GetKeyState(20), ffi.C.GetKeyState(144), ffi.string(LocalInfo)

			local caps, num, numLets, clrNumLets = array.lang_visual[0] and (capsState == 1 and '{00FF00}Âêë' or '{FF0000}Âûêë') or capsState == 1 and '{00FF00}On' or '{FF0000}Off', array.lang_visual[0] and (numState == 1 and '{00FF00}Âêë' or '{FF0000}Âûêë') or numState == 1 and '{00FF00}On' or '{FF0000}Off', #sampGetChatInputText() == 0 and '0' or #sampGetChatInputText(), #sampGetChatInputText() >= 128 and '{FF0000}' or '{F9D82F}'
			local text = string.format('%s: {F9D82F}%s {CCC8C0}| CapsLock: %s {CCC8C0}| NumLock: %s {CCC8C0}| %s: %s%d/128 {CCC8C0}| {F9D82F}%s {CCC8C0}| {F9D82F}%s', array.lang_visual[0] and 'ßçûê' or 'Language', string.match(localName, "([^%(]*)"), caps, num, array.lang_visual[0] and 'Ñèìâîëû' or 'Symbols', clrNumLets, numLets, sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))..'['..select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))..']' , os.date('%X'))
			renderFontDrawText(ifont, text, in2, in3 + 41, 0xFFCCC8C0)
		end

		if array.infbar[0] then
			local posX, posY = getScreenResolution()
			local playerX, playerY, playerZ = getCharCoordinates(PLAYER_PED)
			local grav, tCoords, tInterior, tFps, ping, aid, vid = string.format(array.lang_visual[0] and '[Ãðàâèòàöèÿ: {F9D82F}%.4f{888EA0}]' or '[Gravitation: {F9D82F}%.4f{888EA0}]', mem.getfloat(0x863984)), string.format('[X: {F9D82F}%.1f {888EA0}Y: {F9D82F}%.1f {888EA0}Z: {F9D82F}%.1f{888EA0}]' or '', playerX, playerY, playerZ), string.format(array.lang_visual[0] and '[Èíòåðüåð: {F9D82F}%d{888EA0}]' or '[Interior: {F9D82F}%d{888EA0}]', getActiveInterior()), string.format('[FPS: {F9D82F}%d{888EA0}]', mem.getfloat(0xB7CB50, 4, false)), string.format(array.lang_visual[0] and '[Ïèíã: {F9D82F}%d{888EA0}]' or '[Ping: {F9D82F}%d{888EA0}]', sampGetPlayerPing(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))), string.format('[ID: {F9D82F}%d{888EA0}]', select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))), isCharInAnyCar(PLAYER_PED) and string.format('[VID: {F9D82F}%d{888EA0}]', select(2, sampGetVehicleIdByCarHandle(storeCarCharIsInNoSave(PLAYER_PED))))
			local checkFunc = (array.show_imgui_AirBrake[0] and '['..ABtext..'{888EA0}]' or '')..((array.show_imgui_nametag[0] or array.show_imgui_skeleton[0]) and '['..WHtext..'{888EA0}]' or '')..(array.show_imgui_gmActor[0] and '['..GMtext..'{888EA0}]' or '')..(isCharInAnyCar(PLAYER_PED) and (array.show_imgui_gmVeh[0] and "["..VGMtext.."{888EA0}]" or '')..(array.show_imgui_engineOnVeh[0] and '['..EngineText..'{888EA0}]' or '') or (array.show_imgui_antibhop[0] and '['..ABHtext..'{888EA0}]' or '')..(array.show_imgui_plusC[0] and '['..pCtext..'{888EA0}]' or ''))
			local tOther = (array.infbar_grav[0] and grav or '')..(array.infbar_coords[0] and tCoords or '')..(array.infbar_interior[0] and tInterior or '')..(array.infbar_time[0] and '[{F9D82F}'..os.date('%X')..'{888EA0}]' or '')..(array.infbar_ping[0] and ping or '')..(array.infbar_fps[0] and tFps or '')..(array.infbar_aid[0] and aid or '')..(array.infbar_vid[0] and isCharInAnyCar(PLAYER_PED) and vid or '')
			local lenght = renderGetFontDrawTextLength(ifont, tOther)
			renderDrawBoxWithBorder(-1, posY - ibY, posX + 2, 20, 0x44888EA0, 1, 0xFFF9D82F)
			renderFontDrawText(ifont, checkFunc, posX - posX, posY - (ibY-1), 0xFF888EA0)
			renderFontDrawText(ifont, tOther, posX - lenght, posY - (ibY-1), 0xFF888EA0)
		end

		if array.infbar2[0] then
			local scrX, scrY = getScreenResolution()

			local playerInterior, playerID, playerHP, playerAP, playerPing  = getPlayerOnFootInfo()
			local animId, score = sampGetPlayerAnimationId(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))), sampGetPlayerScore(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
			
			local textNick = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))..'['..playerID..']'
			local lenght, lenght1 = renderGetFontDrawTextLength(ifont, textNick), renderGetFontDrawTextLength(ifont, 'ZZZZZZZZZZZZZZZ')
			local font_sizeX = ((ifont_height == 8 and 160) or ((ifont_height == 7 or ifont_height == 6) and 140) or 200)+30
			local sizeX = lenght >= font_sizeX and lenght or font_sizeX
			local posX, posY = (scrX - sizeX) - 4, isCharInAnyCar(PLAYER_PED) and scrY - (ibY * 6) - 10 or scrY - (ibY * 6)
			local text1, text2 = '', ''
			if isCharInAnyCar(PLAYER_PED) then
				local playerID, vehID, playerHP, playerAP, vehHP, playerPing = getPlayerInCarInfo()
				text1 = string.format(array.lang_visual[0] and 'Ïèíã: {F9D82F}%d\n{888EA0}Çäîðîâüå: {F9D82F}%d\n{888EA0}AnimID: {F9D82F}%d\n{888EA0}VehHP: {F9D82F}%d' or 'Ping: {F9D82F}%d\n{888EA0}Health: {F9D82F}%d\n{888EA0}AnimID: {F9D82F}%d\n{888EA0}VehHP: {F9D82F}%d', playerPing, playerHP, animId, vehHP)
				text2 = string.format(array.lang_visual[0] and 'Î÷êè: {F9D82F}%d\n{888EA0}Áðîíÿ: {F9D82F}%d\n{888EA0}Ñêèí: {F9D82F}%d\n{888EA0}VehID: {F9D82F}%d' or 'Score: {F9D82F}%d\n{888EA0}Armor: {F9D82F}%d\n{888EA0}Skin: {F9D82F}%d\n{888EA0}VehID: {F9D82F}%d', score, playerAP, getCharModel(PLAYER_PED), vehID)
			else
				text1 = string.format(array.lang_visual[0] and 'Ïèíã: {F9D82F}%d\n{888EA0}Çäîðîâüå: {F9D82F}%d\n{888EA0}AnimID: {F9D82F}%d' or 'Ping: {F9D82F}%d\n{888EA0}Health: {F9D82F}%d\n{888EA0}AnimID: {F9D82F}%d', playerPing, playerHP, animId)
				text2 = string.format(array.lang_visual[0] and 'Î÷êè: {F9D82F}%d\n{888EA0}Áðîíÿ: {F9D82F}%d\n{888EA0}Ñêèí: {F9D82F}%d' or 'Score: {F9D82F}%d\n{888EA0}Armor: {F9D82F}%d\n{888EA0}Skin: {F9D82F}%d', score, playerAP, getCharModel(PLAYER_PED))
			end
			renderDrawBoxWithBorder(posX, posY, sizeX, isCharInAnyCar(PLAYER_PED) and 90 or 80, 0x44888EA0, 1, 0x44F9D82F)
			renderFontDrawText(ifont, textNick, posX + ((sizeX - lenght) / 2), posY + 10, 0xFFF9D82F)
			renderFontDrawText(ifont, text1, posX + 10, posY + 30, 0xFF888EA0)
			renderFontDrawText(ifont, text2, posX + lenght1, posY + 30, 0xFF888EA0)
		end
	end
-- SERVERS
	local rv_tabl = {
		{array.rvsearchCorpse[0], 2907, 'Òðóï'},
		{array.rvsearchHorseshoe[0], 954, 'Ïîäêîâà'},
		{array.rvsearchTotems[0], 1276, 'Ñòàòóÿ-òîòåì'},
		{array.rvsearchCont[0], 2935, 'Êîíòåéíåð'},
		{array.rvsearchCont[0], 3571, 'Êîíòåéíåð'},
		{array.rvsearchCont[0], 19321, 'Êîíòåéíåð'}, -- mb miss :/
		{array.rvsearchCont[0], 2932, 'Êîíòåéíåð'},
		{array.rvsearchCont[0], 2934, 'Êîíòåéíåð'}
	}
	local arz_tabl = {
		{array.arzsearchSeed[0], 859, 'Ñåìåíà'},
		{array.arzsearchDeer[0], 19315, 'Îëåíü'},
		{array.arzsearchDrugs[0], 1575, 'Íàðêîòèêè'},
		{array.arzsearchDrugs[0], 1576, 'Íàðêîòèêè'},
		{array.arzsearchDrugs[0], 1577, 'Íàðêîòèêè'},
		{array.arzsearchDrugs[0], 1578, 'Íàðêîòèêè'},
		{array.arzsearchDrugs[0], 1579, 'Íàðêîòèêè'},
		{array.arzsearchDrugs[0], 1580, 'Íàðêîòèêè'},
		{array.arzsearchGift[0], 19054, 'Ïîäàðîê'},
		{array.arzsearchGift[0], 19055, 'Ïîäàðîê'},
		{array.arzsearchGift[0], 19056, 'Ïîäàðîê'},
		{array.arzsearchGift[0], 19057, 'Ïîäàðîê'},
		{array.arzsearchGift[0], 19058, 'Ïîäàðîê'},
		{array.arzsearchTreasure[0], 2680, 'Êëàä'},
		{array.arzsearchMats[0], 1279, 'Ìàòåðèàëû'},
		{array.arzsearchGuns[0], 346, 'Pistol 9mm'},
		{array.arzsearchGuns[0], 347, 'Silenced pistol'},
		{array.arzsearchGuns[0], 348, 'Deagle'},
		{array.arzsearchGuns[0], 349, 'Shotgun'},
		{array.arzsearchGuns[0], 351, 'Combat Shotgun'},
		{array.arzsearchGuns[0], 352, 'UZI'},
		{array.arzsearchGuns[0], 353, 'MP5'},
		{array.arzsearchGuns[0], 355, 'AK47'},
		{array.arzsearchGuns[0], 356, 'M4'},
		{array.arzsearchGuns[0], 357, 'Rifle'},
		{array.arzsearchGuns[0], 358, 'Sniper'}
	}

	if not isPauseMenuActive() and ((array.arz_venable[0] and getServer('arizona')) or (array.rv_venable[0] and getServer('revent'))) then
		for _, v in pairs(getAllObjects()) do
			local model = getObjectModel(v)
			if isObjectOnScreen(v) then
				local model = getObjectModel(v)
				local _, x, y, z = getObjectCoordinates(v)
				local x1, y1 = convert3DCoordsToScreen(x,y,z)
				local x2,y2,z2 = getCharCoordinates(PLAYER_PED)
				local x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
				local distance = string.format("%.0f", getDistanceBetweenCoords3d(x, y, z, x2, y2, z2))
				if array.arz_venable[0] and getServer('arizona') then
					local r, g, b, a = rainbow(array.arz_speed[0], 255, 0)
					local argb = join_argb(a, r, g, b)
					arzVcolor = changeColorAlpha(mainIni.arizonarp.vcolor, 255)
					for _, v2 in ipairs(arz_tabl) do
						if v2[2] == model and v2[1] then
							renderFontDrawText(ifont, (v2[3] .. ' ['..distance..']' or ''), x1, y1, array.arz_rainbow[0] and argb or arzVcolor)
							if array.arz_vline[0] then
								renderDrawLine(x10, y10, x1, y1, 1.0, array.arz_rainbow[0] and argb or arzVcolor)
							end
						end
					end
				end
				if array.rv_venable[0] and getServer('revent') then
					local r, g, b, a = rainbow(array.rv_speed[0], 255, 0)
					local argb = join_argb(a, r, g, b)
					rvVcolor = changeColorAlpha(mainIni.reventrp.vcolor, 255)
					for _, v3 in ipairs(rv_tabl) do
						if v3[2] == model and v3[1] and not missConts then
							renderFontDrawText(ifont, (v3[3] .. ' ['..distance..']' or ''), x1, y1, array.rv_rainbow[0] and argb or rvVcolor)
							if array.rv_line[0] then
								renderDrawLine(x10, y10, x1, y1, 1.0, array.rv_rainbow[0] and argb or rvVcolor)
							end
						end
					end
				end
			end
		end
	end
end

function mainfuncs()
	while true do
		wait(0)
		if checkfuncs.main.enabled then
			funcs()
			if array.lang[0] == 1 then
				array.lang_menu[0], array.lang_chat[0], array.lang_visual[0] = true, true, true
			elseif array.lang[0] == 2 then
				array.lang_menu[0], array.lang_chat[0], array.lang_visual[0] = false, false, false
			end

			if not isGamePaused() then
				ltime.mseconds = ltime.mseconds + 1
				if ltime.mseconds == 40 and ltime.seconds then
					ltime.seconds = ltime.seconds + 1
					ltime.mseconds = 0
				end
				if ltime.seconds == 60 and ltime.minutes then
					ltime.minutes = ltime.minutes + 1
					ltime.seconds = 0
				end
				if ltime.minutes == 60 then
					ltime.hours = ltime.hours + 1
					ltime.minutes = 0
				end
			end
		end
	end
end

function waitfuncs()
	while true do
		wait(0)

		if array.show_imgui_clrScr[0] and isKeyJustPressed(key.VK_F8) then
			checkfuncs.main.enabled = not checkfuncs.main.enabled
			wait(array.clrScr_delay[0])
			checkfuncs.main.enabled = not checkfuncs.main.enabled
		end

		if isPlayerPlaying(PLAYER_HANDLE) and not isPauseMenuActive() and not sampIsChatInputActive() and not sampIsDialogActive() then
			if array.show_imgui_quickMap[0] then -- qmap FYP
				local menuPtr = 0x00BA6748
				if isKeyCheckAvailable() and isKeyDown(key.VK_M) then
					writeMemory(menuPtr + 0x33, 1, 1, false)
					wait(0)
					writeMemory(menuPtr + 0x15C, 1, 1, false)
					writeMemory(menuPtr + 0x15D, 1, 5, false)
					while isKeyDown(key.VK_M) do
						wait(80)
					end
					writeMemory(menuPtr + 0x32, 1, 1, false)
				end
			end

			if array.show_imgui_reconnect[0] then
				local ip, port = sampGetCurrentServerAddress()
				local sname = sampGetCurrentServerName()
				if wasKeyPressed(key.VK_0) and wasKeyPressed(key.VK_LSHIFT) then
					sampAddChatMessage(tag..(array.lang_chat[0] and 'Âû ïåðåçàõîäèòå íà ñåðâåð. Çàéäåòå ÷åðåç {F9D82F}'..array.recon_delay[0]..'{888EA0} ñåêóíä' or 'You go to the server. Come through {F9D82F}'..array.recon_delay[0]..'{888EA0} seconds'), colors.chat.main)
					sampSetGamestate(0)
					wait(array.recon_delay[0] * 1000)
					sampConnectToServer(ip, port)
					sampAddChatMessage(tag..(array.lang_chat[0] and 'Âû ïåðåçàøëè íà ñåðâåð: {F9D82F}' ..sname.. ' {888EA0}IP: {F9D82F}' ..ip.. ':' ..port or 'You are logged on: {F9D82F}' ..sname.. ' {888EA0}IP: {F9D82F}' ..ip.. ':' ..port), colors.chat.main)
				end
			end

			if array.show_imgui_fastsprint[0] and not isCharInAnyCar(PLAYER_PED) and isButtonPressed(PLAYER_HANDLE, 16) then
				setGameKeyState(16, 255)
				wait(5)
				setGameKeyState(16, 0)
			end

			if array.show_imgui_plusC[0] and checkfuncs.others.PlusC then
				gun = getCurrentCharWeapon(PLAYER_PED)
				if isCharShooting(PLAYER_PED) and gun == 24 then
					setCharAnimSpeed(PLAYER_PED, "python_fire", 1.0)
					setGameKeyState(17, 255)
					wait(50)
					setGameKeyState(6, 0)
					setGameKeyState(18, 255)
					setCharAnimSpeed(PLAYER_PED, "python_fire", 1.0)
				end
			end
		end
	end
end

--events
function sampev.onSendPlayerSync(data)
	if checkfuncs.main.enabled then
		if array.show_imgui_antibhop[0] then
			if data.keysData == 40 then
				data.keysData = 32
			end
		end
		if array.ainvise[0] then
			if array.ainviseInt[0] == 1 then
				data.position.z = getGroundZFor3dCoord(getCharCoordinates(PLAYER_PED)) - 2.5
			elseif array.ainviseInt[0] == 2 then
				data.position.z = getGroundZFor3dCoord(getCharCoordinates(PLAYER_PED)) + 50.0
			end
		end
		if array.rvanka[0] then
			local result, id = sampGetCharHandleBySampPlayerId(getClosestPlayerId())
			if result then
				local x, y, z = getCharCoordinates(id)
				data.position = {x, y, z - 2.5}
				data.moveSpeed = {5, 5, 5}
			end
		end
	end
end

function sampev.onSendVehicleSync(data)
	if checkfuncs.main.enabled then
		if array.vinvise[0] then
			if array.vinviseInt[0] == 1 then
				data.position.z = getGroundZFor3dCoord(getCharCoordinates(PLAYER_PED)) - 2.5
			elseif array.vinviseInt[0] == 2 then
				data.position.z = getGroundZFor3dCoord(getCharCoordinates(PLAYER_PED)) + 50.0
			end
		end
	end
end

function sampev.onSendGiveDamage()
	if array.bell[0] then
		local audio = loadAudioStream('moonloader/resource/CheatsByNyhfox/bell.mp3')
		setAudioStreamState(audio, 1)
	else
		return false
	end
end

function sampev.onBulletSync(playerid, data)
	if checkfuncs.main.enabled then
		if array.traserbull[0] then
			if data.target.x == -1 or data.target.y == -1 or data.target.z == -1 then
				return true
			end
			BulletSync.lastId = BulletSync.lastId + 1
			if BulletSync.lastId < 1 or BulletSync.lastId > BulletSync.maxLines then
				BulletSync.lastId = 1
			end
			local id = BulletSync.lastId
			BulletSync[id].enable = true
			BulletSync[id].tType = data.targetType
			BulletSync[id].time = os.time() + 2
			BulletSync[id].o.x, BulletSync[id].o.y, BulletSync[id].o.z = data.origin.x, data.origin.y, data.origin.z
			BulletSync[id].t.x, BulletSync[id].t.y, BulletSync[id].t.z = data.target.x, data.target.y, data.target.z
		end
	end
end

function sampev.onServerMessage(color, text)
	if checkfuncs.main.enabled then
		if array.rv_fixchat[0] and getServer('revent') then
			if text:find(' Òàêîé êîìàíäû íå ñóùåñòâóåò, êîìàíäû ñåðâåðà Âû ìîæåòå ïðîñìîòðåòü â {10F441}/help') then
				return {color, '{B31A06}[Îøèáêà] {FFFFFF}Êîìàíäû íå ñóùåñòâóåò, èñïîëüçóéòå: {10F441}/help'}
			end
			if not text:find('ãîâîðèò') and (text:find('Âû íå àäìèí') or text:find('Âàì íå äîñòóïíà ýòà ôóíêöèÿ') or text:find(' Íå íàéäåíî') or text:find(' Âàì íåäîñòóïíî!') or text:find('/madmin') or text:find('/makehelper') or text:find('/jail') or text:find('/kick') or text:find('/goto') or text:find('/getcar') or text:find('/warn') or text:find('/mute') or text:find('/spawn') or text:find('/skick') or text:find('/unjail') or text:find('/sethp') or text:find('Âû íå óïîëíîìî÷åíû èñïîëüçîâàòü ýòó êîìàíäó!') or text:find('/freeze') or text:find('/unfreeze') or text:find('Âû íå àâòîðèçîâàíû äëÿ èñïîëüçîâàíèå ýòîé êîìàíäû') or text:find('/disarm') or text:find('/mpskin') or text:find('Âû íå Àäìèí!') or text:find('/unwarn') or text:find('/agiverank') or text:find('/setarmor') or text:find('/explode') or text:find('/unslot') or text:find('/givegunrad') or text:find('/giveport') or text:find('/givegz') or text:find('Ó Âàñ íåò ïðàâ äëÿ èñï. äàííîé êîìàíäû') or text:find(' Äîñòóïíî ñ 6 alvl!') or text:find('/asellbiz') or text:find('/asellhouse') or text:find('/setskin') or text:find('/setskinslot') or text:find('/givevip')) then
				return {color, '{B31A06}[Îøèáêà] {FFFFFF}Íå íàéäåíà/íåäîñòóïíà äàííàÿ êîìàíäà'}
			end
			if not text:find('ãîâîðèò') and (text:find('Âû íå ñîñòîèòå â ÑÌÈ!') or text:find('Âû íå êîï.')) then
				return {color, '{B31A06}[Îøèáêà] {FFFFFF}Âû íå ñîñòîèòå â îïðåäåëåííîé ôðàêöèè'}
			end
			if not text:find('ãîâîðèò') and text:find('AFK:%d+') then
				afkfix = text:gsub('AFK:(%d+)', 'AFK: %1')
				return {color, afkfix}
			end
		end

		if array.arz_fastreport[0] and getServer('arizona') then
			if text:find('Âàì íåîáõîäèìî ñôîðìóëèðîâàòü ñâîþ æàëîáó êîððåêòíî!') then
				report_false = true
			end
		end
	end
end

function sampev.onShowDialog(dialogId, dialogStyle, dialogTitle, okButtonText, cancelButtonText, dialogText)
	if checkfuncs.main.enabled then
		if getServer('arizona') then
			if dialogId == 2 and str(array.arz_passacc) ~= '' then
				sampSendDialogResponse(2, 1, -1, str(array.arz_passacc))
				return false
			end
			if dialogId == 991 and array.arz_pincode[0] ~= '' then
				sampSendDialogResponse(991, 1, -1, array.arz_pincode[0])
				return false
			end
			if array.arz_autoskiprep[0] and dialogId == 1333 or dialogId == 1332 then
				sampSendDialogResponse(dialogId, 1, -1)
				return false
			end
			if array.arz_fastreport[0] and dialogId == 32 and report_false then
				report_false = false
				return false
			end
		end

		if array.dev_dialogid[0] then
			print('[DIALOG] ID: '..dialogId..' | Style: '..dialogStyle..' | Title: '..dialogTitle)
		end
	end
end

function sampev.onApplyPlayerAnimation(playerId, animLib, animName, loop, lockX, lockY, freeze, time)
	if checkfuncs.main.enabled then
		if array.dev_anim[0] then
			print('[ANIMATIONS] Player ID: '..playerId..' | Lib: '..animLib..' | Name: '..animName)
		end
	end
end

function sampev.onSendClientJoin(version, mode, nickname, response, authKey, client, unk)
	if array.arz_launcher[0] then
		client = 'Arizona PC'
		return {version, mode, nickname, response, authKey, client, unk}
	end
end

function sampev.onDisplayGameText(style, time, text)
	if checkfuncs.main.enabled then
		if array.dev_gametext[0] then
			print('[GAMETEXT] Style: '..style..' | Time: '..time..' | Text: '..text)
		end
	end
end

function saveini()
	mainIni = {
		actor = {
			infRun = array.show_imgui_infRun[0],
			infSwim = array.show_imgui_infSwim[0],
			infOxygen = array.show_imgui_infOxygen[0],
			suicide = array.show_imgui_suicideActor[0],
			megaJump = array.show_imgui_megajumpActor[0],
			fastSprint = array.show_imgui_fastsprint[0],
			unfreeze = array.show_imgui_unfreeze[0],
			noFall = array.show_imgui_nofall[0],
			GM = array.show_imgui_gmActor[0],
			antiStun = array.show_imgui_antistun[0],
			invise = array.ainvise[0],
			inviseInt = array.ainviseInt[0],
			stopQuick = array.stopQuick[0]
		},
		vehicle = {
			flip180 = array.show_imgui_flip180[0],
			flipOnWheels = array.show_imgui_flipOnWheels[0],
			megaJumpBMX = array.show_imgui_megajumpBMX[0],
			hop = array.show_imgui_hopVeh[0],
			boom = array.show_imgui_suicideVeh[0],
			fastExit = array.show_imgui_fastexit[0],
			AntiBikeFall = array.show_imgui_antiBikeFall[0],
			GM = array.show_imgui_gmVeh[0],
			GMDefault = array.show_imgui_gmVehDefault[0],
			GMWheels = array.show_imgui_gmVehWheels[0],
			fixWheels = array.show_imgui_fixWheels[0],
			speedhack = array.show_imgui_speedhack[0],
			speedhackMaxSpeed = array.SpeedHackMaxSpeed[0],
			speedhackSmooth = array.SpeedHackSmooth[0],
			perfectHandling = array.show_imgui_perfectHandling[0],
			allCarsNitro = array.show_imgui_allCarsNitro[0],
			onlyWheels = array.show_imgui_onlyWheels[0],
			tankMode = array.show_imgui_tankMode[0],
			driveOnWater = array.show_imgui_driveOnWater[0],
			restoreHealth = array.show_imgui_restHealthVeh[0],
			engineOn = array.show_imgui_engineOnVeh[0],
			antiboom_upside = array.antiboom_upside[0],
			invise = array.vinvise[0],
			inviteInt = array.vinviseInt[0]
		},
		weapon = {
			infAmmo = array.show_imgui_infAmmo[0],
			fullSkills = array.show_imgui_fullskills[0],
			plusC = array.show_imgui_plusC[0],
			noReload = array.show_imgui_noreload[0],
			aim = array.show_imgui_aim[0],
			bell = array.bell[0]
		},
		misc = {
			FOV = array.show_imgui_FOV[0],
			FOVvalue = array.FOV_value[0],
			antibhop = array.show_imgui_antibhop[0],
			AirBrake = array.show_imgui_AirBrake[0],
			AirBrakeSpeed = array.AirBrake_Speed[0],
			AirBrakeKeys = array.AirBrake_keys[0],
			quickMap = array.show_imgui_quickMap[0],
			blink = array.show_imgui_blink[0],
			blinkDist = array.blink_dist[0],
			sensfix = array.show_imgui_sensfix[0],
			clearScreenshot = array.show_imgui_clrScr[0],
			clearScreenshotDelay = array.clrScr_delay[0],
			WalkDriveUnderWater = array.show_imgui_UnderWater[0],
			ClickWarp = array.show_imgui_clickwarp[0],
			reconnect = array.show_imgui_reconnect[0],
			reconnect_delay = array.recon_delay[0],
			offChatF7 = array.offChatF7[0],
			notDelayCash = array.notDelayCash[0],
			gravitation = array.gravitation[0],
			gravitation_value = array.gravitation_value[0],
			inputHelper = array.inputHelper[0],
			chatOnT = array.chatOnT[0],
			fastSelectOnDialog = array.fastSelectOnDialog[0]
		},
		visual = {
			nameTag = array.show_imgui_nametag[0],
			skeleton = array.show_imgui_skeleton[0],
			keyWH = array.show_imgui_keyWH[0],
			infoBar = array.infbar[0],
			infbar_grav = array.infbar_grav[0],
			infbar_coords = array.infbar_coords[0],
			infbar_interior = array.infbar_interior[0],
			infbar_time = array.infbar_time[0],
			infbar_ping = array.infbar_ping[0],
			infbar_fps = array.infbar_fps[0],
			infbar_aid = array.infbar_aid[0],
			infbar_vid = array.infbar_vid[0],
			doorLocks = array.show_imgui_doorlocks[0],
			distanceDoorLocks = array.distDoorLocks[0],
			search3dText = array.srch3dtext[0],
			traserBullets = array.traserbull[0],
			pulsCash = array.pulsCash[0],
			infbar2 = array.infbar2[0],
			chatHelper = array.chatHelper[0]
		},
		menu = {
			checkUpdate = array.checkupdate[0],
			language = array.lang[0],
			language_menu = array.lang_menu[0],
			language_chat = array.lang_chat[0],
			language_visual = array.lang_visual[0],
			autoSave = array.AutoSave[0],
			iStyle = array.comboStyle[0],
			typeToggle = array.typeToggle[0]
		},
		notifications = {
			notifications = array.notifications[0],
			NactorGM = array.NactorGM[0],
			NvehGM = array.NvehGM[0],
			NplusC = array.NplusC[0],
			Nairbrake = array.Nairbrake[0],
			Nwh = array.Nwh[0]
		},
		developers = {
			dialogId = array.dev_dialogid[0],
			textdraw = array.dev_textdraw[0],
			gametext = array.dev_gametext[0],
			animations = array.dev_anim[0]
		},
		reventrp = {
			fixchat = array.rv_fixchat[0],
			venable = array.rv_venable[0],
			vline = array.rv_line[0],
			searchCorpse = array.rvsearchCorpse[0],
			searchHorseshoe = array.rvsearchHorseshoe[0],
			searchTotems = array.rvsearchTotems[0],
			searchContainers = array.rvsearchCont[0],
			vrainbow = array.rv_rainbow[0],
			vspeed = array.rv_speed[0],
			vcolor = rvVcolor
		},
		arizonarp = {
			passAcc = str(array.arz_passacc),
			pincode = array.arz_pincode[0],
			report = array.arz_fastreport[0],
			venable = array.arz_venable[0],
			vline = array.arz_vline[0],
			searchGuns = array.arzsearchGuns[0],
			searchSeed = array.arzsearchSeed[0],
			searchDeer = array.arzsearchDeer[0],
			searchDrugs = array.arzsearchDrugs[0],
			searchGift = array.arzsearchGift[0],
			searchTreasure = array.arzsearchTreasure[0],
			searchMats = array.arzsearchMats[0],
			vrainbow = array.arz_rainbow[0],
			vspeed = array.arz_rainbow[0],
			vcolor = arzVcolor,
			autoSkipReport = array.arz_autoskiprep[0],
			emulateLauncher = array.arz_launcher[0]
		}
	} inicfg.save(mainIni, 'CheatsByNyhfox.ini')
end

function onScriptTerminate(CheatsByNyhfoxScript, quitGame)
	if CheatsByNyhfoxScript == thisScript() then
		if array.AutoSave[0] then saveini() end
		mainfuncs:terminate(); waitfuncs:terminate()
		sampAddChatMessage(tag..(array.AutoSave[0] and (array.lang_chat[0] and 'Ñêðèïò àâàðèéíî çàêîí÷èë ðàáîòó. Íàñòðîéêè ñîõðàíåíû' or 'The script crashed. Settings have been saved') or (array.lang_chat[0] and 'Ñêðèïò àâàðèéíî çàêîí÷èë ðàáîòó' or 'The script crashed')), colors.chat.main)
	end
end

function onExitScript()
	nameTagOff()
end

--others imgui
function imgui.TextQuestion(...)
	imgui.SameLine()
	imgui.TextDisabled('(?)')
	local id = imgui.GetCursorPos()
	imgui.Hint(...)
end

function imgui.TextColoredRGB(text, shadow, wrapped)
	local style = imgui.GetStyle()
	local colors = style.Colors

	local designText = function(text)
		local pos = imgui.GetCursorPos()
		for i = 1, 1 do
			imgui.SetCursorPos(imgui.ImVec2(pos.x + i, pos.y))
			imgui.TextColored(imgui.ImVec4(0, 0, 0, 1), text)
			imgui.SetCursorPos(imgui.ImVec2(pos.x - i, pos.y))
			imgui.TextColored(imgui.ImVec4(0, 0, 0, 1), text)
			imgui.SetCursorPos(imgui.ImVec2(pos.x, pos.y + i))
			imgui.TextColored(imgui.ImVec4(0, 0, 0, 1), text)
			imgui.SetCursorPos(imgui.ImVec2(pos.x, pos.y - i))
			imgui.TextColored(imgui.ImVec4(0, 0, 0, 1), text)
		end
		imgui.SetCursorPos(pos)
	end

	text = text:gsub('{(%x%x%x%x%x%x)}', '{%1FF}')
	local render_func = wrapped and imgui_text_wrapped or function(clr, text)
		if clr then imgui.PushStyleColor(ffi.C.ImGuiCol_Text, clr) end
		if shadow then designText(text) end
		imgui.TextUnformatted(text)
		if clr then imgui.PopStyleColor() end
	end

	local split = function(str, delim, plain)
		local tokens, pos, i, plain = {}, 1, 1, not (plain == false)
		repeat
			local npos, epos = string.find(str, delim, pos, plain)
			tokens[i] = string.sub(str, pos, npos and npos - 1)
			pos = epos and epos + 1
			i = i + 1
		until not pos
		return tokens
	end

	local color = colors[ffi.C.ImGuiCol_Text]
	for _, w in ipairs(split(text, '\n')) do
		local start = 1
		local a, b = w:find('{........}', start)
		while a do
			local t = w:sub(start, a - 1)
			if #t > 0 then
				render_func(color, t)
				imgui.SameLine(nil, 0)
			end

			local clr = w:sub(a + 1, b - 1)
			if clr:upper() == 'STANDART' then color = colors[ffi.C.ImGuiCol_Text]
			else
				clr = tonumber(clr, 16)
				if clr then
					local r = bit.band(bit.rshift(clr, 24), 0xFF)
					local g = bit.band(bit.rshift(clr, 16), 0xFF)
					local b = bit.band(bit.rshift(clr, 8), 0xFF)
					local a = bit.band(clr, 0xFF)
					color = imgui.ImVec4(r / 255, g / 255, b / 255, a / 255)
				end
			end

			start = b + 1
			a, b = w:find('{........}', start)
		end
		imgui.NewLine()
		if #w >= start then
			imgui.SameLine(nil, 0)
			render_func(color, w:sub(start))
		end
	end
end

function imgui.CenterTextColored(clr, text)
	local width = imgui.GetWindowWidth()
	local lenght = imgui.CalcTextSize(text).x

	imgui.SetCursorPosX((width - lenght) / 2)
	imgui.TextColored(clr, text)
end

function imgui.Hint(str_id, hint, delay)
	local hovered = imgui.IsItemHovered()
	local col = imgui.GetStyle().Colors[imgui.Col.ButtonHovered]
	local animTime = 0.2
	local delay = delay or 0.00
	local show = true

	if not allHints then allHints = {} end
	if not allHints[str_id] then
		allHints[str_id] = {
			status = false,
			timer = 0
		}
	end

	if hovered then
		for k, v in pairs(allHints) do
			if k ~= str_id and os.clock() - v.timer <= animTime  then
				show = false
			end
		end
	end

	if show and allHints[str_id].status ~= hovered then
		allHints[str_id].status = hovered
		allHints[str_id].timer = os.clock() + delay
	end

	local showHint = function(text, alpha)
		imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, alpha)
		imgui.PushStyleVarFloat(imgui.StyleVar.WindowRounding, 5)
		imgui.BeginTooltip()
            imgui.TextColored(imgui.ImVec4(col.x, col.y, col.z, 1.00), fa.ICON_INFO_CIRCLE..(array.lang_menu[0] and u8' Ïîäñêàçêà:' or ' Help:'))
	        imgui.PushStyleVarVec2(imgui.StyleVar.ItemSpacing, imgui.ImVec2(0, 0))
	        imgui.TextColoredRGB(text, false, true)
	        imgui.PopStyleVar()
        imgui.EndTooltip()
        imgui.PopStyleVar(2)
	end

	if show then
		local btw = os.clock() - allHints[str_id].timer
		if btw <= animTime then
			local s = function(f)
				return f < 0.0 and 0.0 or (f > 1.0 and 1.0 or f)
			end
			local alpha = hovered and s(btw / animTime) or s(1.00 - btw / animTime)
			showHint(hint, alpha)
		elseif hovered then
			showHint(hint, 1.00)
		end
	end
end

function imgui.ButtonActivated(activated, ...)
    if activated then
        imgui.PushStyleColor(imgui.Col.Button, imgui.GetStyle().Colors[imgui.Col.CheckMark])
        imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.GetStyle().Colors[imgui.Col.CheckMark])
        imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.GetStyle().Colors[imgui.Col.CheckMark])

            imgui.Button(...)

        imgui.PopStyleColor()
        imgui.PopStyleColor()
        imgui.PopStyleColor()

    else
        return imgui.Button(...)
    end
end

function imgui.ToggleButton(type, str_id, bool)
	if type == 0 then
		imgui.Checkbox(str_id, bool)
	else
		local rBool = false

		if LastActiveTime == nil then
			LastActiveTime = {}
		end
		if LastActive == nil then
			LastActive = {}
		end

		local function ImSaturate(f)
			return f < 0.0 and 0.0 or (f > 1.0 and 1.0 or f)
		end

		local p = imgui.GetCursorScreenPos()
		local dl = imgui.GetWindowDrawList()

		local height = imgui.GetTextLineHeightWithSpacing()
		local width = height * 1.70
		local radius = height * 0.50
		local ANIM_SPEED = type == 2 and 0.10 or 0.15
		local butPos = imgui.GetCursorPos()

		if imgui.InvisibleButton(str_id, imgui.ImVec2(width, height)) then
			bool[0] = not bool[0]
			rBool = true
			LastActiveTime[tostring(str_id)] = os.clock()
			LastActive[tostring(str_id)] = true
		end

		imgui.SetCursorPos(imgui.ImVec2(butPos.x + width + 8, butPos.y + 2.5))
		imgui.Text( str_id:gsub('##.+', '') )

		local t = bool[0] and 1.0 or 0.0

		if LastActive[tostring(str_id)] then
			local time = os.clock() - LastActiveTime[tostring(str_id)]
			if time <= ANIM_SPEED then
				local t_anim = ImSaturate(time / ANIM_SPEED)
				t = bool[0] and t_anim or 1.0 - t_anim
			else
				LastActive[tostring(str_id)] = false
			end
		end

		local col_circle = bool[0] and imgui.ColorConvertFloat4ToU32(imgui.ImVec4(imgui.GetStyle().Colors[imgui.Col.ButtonActive])) or imgui.ColorConvertFloat4ToU32(imgui.ImVec4(imgui.GetStyle().Colors[imgui.Col.TextDisabled]))
		local text_circle = bool[0] and fa.ICON_CHECK_CIRCLE or fa.ICON_TIMES_CIRCLE -- new
		if type == 2 then
			dl:AddRectFilled(p, imgui.ImVec2(p.x + width, p.y + height), imgui.ColorConvertFloat4ToU32(imgui.GetStyle().Colors[imgui.Col.FrameBg]), height * 0.5)
			dl:AddText(imgui.ImVec2(p.x + (radius / 2) + t * (width - radius * 2.4), p.y + ((radius / 2) - 2.0)), col_circle, text_circle) -- new
		elseif type == 1 then
			dl:AddRectFilled(p, imgui.ImVec2(p.x + width, p.y + height), imgui.ColorConvertFloat4ToU32(imgui.GetStyle().Colors[imgui.Col.FrameBg]), height * 0.5)
			dl:AddCircleFilled(imgui.ImVec2(p.x + radius + t * (width - radius * 2.0), p.y + radius), radius - 1.5, col_circle)
		end
		return rBool
	end
end

function imgui.ClickCopy(text)
	if imgui.IsItemClicked() then
		imgui.LogToClipboard()
		imgui.LogText(text)
		imgui.LogFinish()
	end
end

function imgui.IntSpacing(int)
	for i = 0, int do imgui.Spacing() end
end

function imgui.BeginTitleChild(str_id, size, color, offset)
    color = color or imgui.GetStyle().Colors[imgui.Col.Border]
    offset = offset or 30
    local DL = imgui.GetWindowDrawList()
    local posS = imgui.GetCursorScreenPos()
    local rounding = imgui.GetStyle().ChildRounding
    local title = str_id:gsub('##.+$', '')
    local sizeT = imgui.CalcTextSize(title)
    local padd = imgui.GetStyle().WindowPadding
    local bgColor = imgui.ColorConvertFloat4ToU32(imgui.GetStyle().Colors[imgui.Col.WindowBg])

    imgui.PushStyleColor(imgui.Col.ChildBg, imgui.ImVec4(0, 0, 0, 0))
    imgui.PushStyleColor(imgui.Col.Border, imgui.ImVec4(0, 0, 0, 0))
    imgui.BeginChild(str_id, size, true)
    imgui.Spacing()
    imgui.PopStyleColor(2)

    size.x = size.x == -1.0 and imgui.GetWindowWidth() or size.x
    size.y = size.y == -1.0 and imgui.GetWindowHeight() or size.y
    DL:AddRect(posS, imgui.ImVec2(posS.x + size.x, posS.y + size.y), imgui.ColorConvertFloat4ToU32(color), rounding, _, 1)
    DL:AddLine(imgui.ImVec2(posS.x + offset - 3, posS.y), imgui.ImVec2(posS.x + offset + sizeT.x + 3, posS.y), bgColor, 3)
    DL:AddText(imgui.ImVec2(posS.x + offset, posS.y - (sizeT.y / 2)), imgui.ColorConvertFloat4ToU32(color), title)
end

function imgui.ColorConvertFloat4ToARGB(float4)
	local abgr = imgui.ColorConvertFloat4ToU32(float4)
	local a, b, g, r = explode_U32(abgr)
	return join_argb(a, r, g, b)
end
--cmd for arz
function arz_report(text_rep)
	if #text_rep == 0 then
		sampSendChat('/report')
	else
		report_false = true
		sampSendChat('/report')
		sampSendDialogResponse(32, 1, -1, text_rep)
	end
end
--others
function translite(text)
	for k, v in pairs(chars) do
		text = string.gsub(text, k, v)
	end
	return text
end

function teleportInterior(ped, posX, posY, posZ, int)
	setCharInterior(ped, int)
	setInteriorVisible(int)
	setCharCoordinates(ped, posX, posY, posZ)
end

function getPlayerOnFootInfo()
	local _, playerID = sampGetPlayerIdByCharHandle(PLAYER_PED)
	local playerHP = getCharHealth(PLAYER_PED)
	return getActiveInterior(),
		playerID,
		playerHP,
		getCharArmour(PLAYER_PED),
		sampGetPlayerPing(playerID)
end

function getPlayerInCarInfo()
	local _, playerID = sampGetPlayerIdByCharHandle(PLAYER_PED)
	local playerHP = getCharHealth(PLAYER_PED)
	local playerCar = storeCarCharIsInNoSave(PLAYER_PED)
	local _, vehId = sampGetVehicleIdByCarHandle(playerCar)
	return playerID,
		vehId,
		playerHP,
		getCharArmour(PLAYER_PED),
		getCarHealth(playerCar),
		sampGetPlayerPing(playerID)
end

function nameTagOn()
	local pStSet = sampGetServerSettingsPtr()
	-- NTdist = mem.getfloat(pStSet + 39)
	-- NTwalls = mem.getint8(pStSet + 47)
	-- NTshow = mem.getint8(pStSet + 56)
	mem.setfloat(pStSet + 39, 300.0)
	mem.setint8(pStSet + 47, 0)
	mem.setint8(pStSet + 56, 1)
end

function nameTagOff()
	local pStSet = sampGetServerSettingsPtr()
	mem.setfloat(pStSet + 39, 40.0)--onShowPlayerNameTag / NTdist
	mem.setint8(pStSet + 47, 1)
	mem.setint8(pStSet + 56, 1)
end

function patch_samp_time_set(enable)
	if enable and default == nil then
		default = readMemory(sampGetBase() + 0x9C0A0, 4, true)
		writeMemory(sampGetBase() + 0x9C0A0, 4, 0x000008C2, true)
	elseif enable == false and default ~= nil then
		writeMemory(sampGetBase() + 0x9C0A0, 4, default, true)
		default = nil
	end
end

function autoupdate(json_url, prefix, url)
	local dlstatus = require('moonloader').download_status
	local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
	if doesFileExist(json) then os.remove(json) end
	downloadUrlToFile(json_url, json, function(id, status, p1, p2)
      	if status == dlstatus.STATUSEX_ENDDOWNLOAD then
			if doesFileExist(json) then
				local f = io.open(json, 'r')
				if f then
					local info = decodeJson(f:read('*a'))
					updatelink = info.updateurl
					updateversion = info.latest
					f:close()
					os.remove(json)
					if updateversion == version_script then
						sampAddChatMessage(tag..(array.lang_chat[0] and 'Âû èñïîëüçóåòå {0E8604}àêòóàëüíóþ {888EA0}âåðñèþ ñêðèïòà' or 'You are using {0E8604}the current {888EA0}version of the script'), colors.chat.main)
						update = false
					elseif updateversion < version_script then
						sampAddChatMessage(tag..(array.lang_chat[0] and 'Âû èñïîëüçóåòå {F9D82F}òåñòîâóþ {888EA0}âåðñèþ ñêðèïòà' or 'You are using {F9D82F}testing {888EA0}version of the script'), colors.chat.main)
						update = false
					elseif updateversion > version_script then
						lua_thread.create(function(prefix)
							local dlstatus = require('moonloader').download_status
							sampAddChatMessage(tag..(array.lang_chat[0] and 'Äîñòóïíî îáíîâëåíèå! Ñêà÷èâàþ {0E8604}ñâåæóþ {888EA0}âåðñèþ {F9D82F}'..updateversion or 'An update is available. Downloading {0E8604}the latest {888EA0}version '..updateversion), colors.chat.main)
							wait(250)
							downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23)
								if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
									log('Downloading')
								elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
									sampAddChatMessage(tag..(array.lang_chat[0] and 'Ñêà÷èâàíèå çàâåðøåíî. Ñêðèïò îáíîâëåí íà âåðñèþ {F9D82F}'..updateversion or 'The download is complete. The script has been updated to version '..updateversion), colors.chat.main)
									goupdatestatus = true
									lua_thread.create(function() wait(500) thisScript():reload() end)
								end
								if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
									if goupdatestatus == nil then
										sampAddChatMessage(tag..(array.lang_chat[0] and '{B31A06}Íå óäàëîñü {888EA0}îáíîâèòüñÿ' or '{B31A06}Failed {888EA0}updating'), colors.chat.main)
										update = false
									end
								end
							end)
						end, prefix)
					else
						sampAddChatMessage(tag..(array.lang_chat[0] and '{B31A06}Íå óäàëîñü {888EA0}ïðîâåðèòü âåðñèþ ñêðèïòà' or '{B31A06}Failed {888EA0}to check the version of the script'), colors.chat.main)
						update = false
					end
				end
			else
				sampAddChatMessage(tag..(array.lang_chat[0] and '{B31A06}Íå óäàëîñü {888EA0}ïðîâåðèòü âåðñèþ ñêðèïòà' or '{B31A06}Failed {888EA0}to check the version of the script'), colors.chat.main)
				update = false
			end
		end
	end)
	while update ~= false do wait(100) end
end

function getTime(timezone)
	local https = require 'ssl.https'
	local time = https.request('http://alat.specihost.com/unix-time/')
	return time and tonumber(time:match('^Current Unix Timestamp: <b>(%d+)</b>')) + (timezone or 0) * 60 * 60
end

function rotateCarAroundUpAxis(car, vec)
	local mat = Matrix3X3(getVehicleRotationMatrix(car))
	local rotAxis = Vector3D(mat.up:get())
	vec:normalize()
	rotAxis:normalize()
	local theta = math.acos(rotAxis:dotProduct(vec))
	if theta ~= 0 then
		rotAxis:crossProduct(vec)
		rotAxis:normalize()
		rotAxis:zeroNearZero()
		mat = mat:rotate(rotAxis, -theta)
	end
	setVehicleRotationMatrix(car, mat:get())
end

function readFloatArray(ptr, idx)
  	return representIntAsFloat(readMemory(ptr + idx * 4, 4, false))
end

function writeFloatArray(ptr, idx, value)
  	writeMemory(ptr + idx * 4, 4, representFloatAsInt(value), false)
end

function getVehicleRotationMatrix(car)
	local entityPtr = getCarPointer(car)
	if entityPtr ~= 0 then
		local mat = readMemory(entityPtr + 0x14, 4, false)
		if mat ~= 0 then
		local rx, ry, rz, fx, fy, fz, ux, uy, uz
		rx = readFloatArray(mat, 0)
		ry = readFloatArray(mat, 1)
		rz = readFloatArray(mat, 2)
		fx = readFloatArray(mat, 4)
		fy = readFloatArray(mat, 5)
		fz = readFloatArray(mat, 6)
		ux = readFloatArray(mat, 8)
		uy = readFloatArray(mat, 9)
		uz = readFloatArray(mat, 10)
		return rx, ry, rz, fx, fy, fz, ux, uy, uz
		end
	end
end

function setVehicleRotationMatrix(car, rx, ry, rz, fx, fy, fz, ux, uy, uz)
	local entityPtr = getCarPointer(car)
	if entityPtr ~= 0 then
		local mat = readMemory(entityPtr + 0x14, 4, false)
		if mat ~= 0 then
		writeFloatArray(mat, 0, rx)
		writeFloatArray(mat, 1, ry)
		writeFloatArray(mat, 2, rz)
		writeFloatArray(mat, 4, fx)
		writeFloatArray(mat, 5, fy)
		writeFloatArray(mat, 6, fz)
		writeFloatArray(mat, 8, ux)
		writeFloatArray(mat, 9, uy)
		writeFloatArray(mat, 10, uz)
		end
	end
end

function getCarFreeSeat(car)
	if doesCharExist(getDriverOfCar(car)) then
		local maxPassengers = getMaximumNumberOfPassengers(car)
		for i = 0, maxPassengers do
		if isCarPassengerSeatFree(car, i) then return i + 1 end
		end return nil
	else return 0 end
end

function jumpIntoCar(car)
	local seat = getCarFreeSeat(car)
	if not seat then return false end
	if seat == 0 then warpCharIntoCar(PLAYER_PED, car)
	else warpCharIntoCarAsPassenger(PLAYER_PED, car, seat - 1)
	end restoreCameraJumpcut() return true
end

function teleportPlayer(x, y, z)
	if isCharInAnyCar(PLAYER_PED) then setCharCoordinates(PLAYER_PED, x, y, z) end
	setCharCoordinatesDontResetAnim(PLAYER_PED, x, y, z)
end

function setCharCoordinatesDontResetAnim(char, x, y, z)
  	local ptr = getCharPointer(char) setEntityCoordinates(ptr, x, y, z)
end

function setEntityCoordinates(entityPtr, x, y, z)
	if entityPtr ~= 0 then
		local matrixPtr = readMemory(entityPtr + 0x14, 4, false)
		if matrixPtr ~= 0 then
		local posPtr = matrixPtr + 0x30
		writeMemory(posPtr + 0, 4, representFloatAsInt(x), false) -- X
		writeMemory(posPtr + 4, 4, representFloatAsInt(y), false) -- Y
		writeMemory(posPtr + 8, 4, representFloatAsInt(z), false) -- Z
		end
	end
end

function isKeyCheckAvailable()
	if not isSampfuncsLoaded() then
		return not isPauseMenuActive()
	end
	local result = not isSampfuncsConsoleActive() and not isPauseMenuActive()
	if isSampLoaded() and isSampAvailable() then
		result = result and not sampIsChatInputActive() and not sampIsDialogActive()
	end
	return result
end

function fps_correction()
	return representIntAsFloat(readMemory(0xB7CB5C, 4, false))
end

function getBodyPartCoordinates(id, handle)
	local pedptr = getCharPointer(handle)
	local vec = ffi.new("float[3]")
	getBonePosition(ffi.cast("void*", pedptr), vec, id, true)
	return vec[0], vec[1], vec[2]
end

function join_argb(a, r, g, b)
	local argb = b  -- b
	argb = bit.bor(argb, bit.lshift(g, 8))  -- g
	argb = bit.bor(argb, bit.lshift(r, 16)) -- r
	argb = bit.bor(argb, bit.lshift(a, 24)) -- a
	return argb
end

function explode_argb(argb)
	local a = bit.band(bit.rshift(argb, 24), 0xFF)
	local r = bit.band(bit.rshift(argb, 16), 0xFF)
	local g = bit.band(bit.rshift(argb, 8), 0xFF)
	local b = bit.band(argb, 0xFF)
	return a, r, g, b
end

function explode_U32(u32)
	local a = bit.band(bit.rshift(u32, 24), 0xFF)
	local r = bit.band(bit.rshift(u32, 16), 0xFF)
	local g = bit.band(bit.rshift(u32, 8), 0xFF)
	local b = bit.band(u32, 0xFF)
	return a, r, g, b
end

function changeColorAlpha(argb, alpha)
	local _, r, g, b = explode_U32(argb)
	return join_argb(alpha, r, g, b)
end

function rainbow(speed, alpha, offset)
    local clock = os.clock() + offset
    local r = math.floor(math.sin(clock * speed) * 127 + 128)
    local g = math.floor(math.sin(clock * speed + 2) * 127 + 128)
    local b = math.floor(math.sin(clock * speed + 4) * 127 + 128)
    return r, g, b, alpha
end

function Search3Dtext(x, y, z, radius, patern)
    local text = ""
    local color = 0
    local posX = 0.0
    local posY = 0.0
    local posZ = 0.0
    local distance = 0.0
    local ignoreWalls = false
    local player = -1
    local vehicle = -1
    local result = false

    for id = 0, 2048 do
        if sampIs3dTextDefined(id) then
            local text2, color2, posX2, posY2, posZ2, distance2, ignoreWalls2, player2, vehicle2 = sampGet3dTextInfoById(id)
            if getDistanceBetweenCoords3d(x, y, z, posX2, posY2, posZ2) < radius then
                if string.len(patern) ~= 0 then
                    if string.match(text2, patern, 0) ~= nil then result = true end
                else
                    result = true
                end
                if result then
                    text = text2
                    color = color2
                    posX = posX2
                    posY = posY2
                    posZ = posZ2
                    distance = distance2
                    ignoreWalls = ignoreWalls2
                    player = player2
                    vehicle = vehicle2
                    radius = getDistanceBetweenCoords3d(x, y, z, posX, posY, posZ)
                end
            end
        end
    end

    return result, text, color, posX, posY, posZ, distance, ignoreWalls, player, vehicle
end

function targetAtCoords(x, y, z)
    local cx, cy, cz = getActiveCameraCoordinates()

    local vect = {
        fX = cx - x,
        fY = cy - y,
        fZ = cz - z
    }

    local screenAspectRatio = representIntAsFloat(readMemory(0xC3EFA4, 4, false))
    local crosshairOffset = {
        representIntAsFloat(readMemory(0xB6EC10, 4, false)),
        representIntAsFloat(readMemory(0xB6EC14, 4, false))
    }

    -- weird shit
    local mult = math.tan(getCameraFov() * 0.5 * 0.017453292)
    fz = 3.14159265 - math.atan2(1.0, mult * ((0.5 - crosshairOffset[1]) * (2 / screenAspectRatio)))
    fx = 3.14159265 - math.atan2(1.0, mult * 2 * (crosshairOffset[2] - 0.5))

    local camMode = readMemory(0xB6F1A8, 1, false)

    if not (camMode == 53 or camMode == 55) then -- sniper rifle etc.
        fx = 3.14159265 / 2
        fz = 3.14159265 / 2
    end

    local ax = math.atan2(vect.fY, -vect.fX) - 3.14159265 / 2
    local az = math.atan2(math.sqrt(vect.fX * vect.fX + vect.fY * vect.fY), vect.fZ)

    setCameraPositionUnfixed(az - fz, fx - ax)
end

function getServer(name)
	return sampGetCurrentServerName():lower():match(name)
end

function getClosestPlayerId()
    local closestId = -1
    mydist = 30
    local x, y, z = getCharCoordinates(PLAYER_PED)
    for i = 0, 999 do
        local streamed, pedID = sampGetCharHandleBySampPlayerId(i)
        if streamed and getCharHealth(pedID) > 0 and not sampIsPlayerPaused(pedID) then
            local xi, yi, zi = getCharCoordinates(pedID)
            local dist = getDistanceBetweenCoords3d(x, y, z, xi, yi, zi)
            if dist <= mydist then
                mydist = dist
                closestId = i
            end
        end
    end
    return closestId
end

function split(str, delim, plain)
    local tokens, pos, plain = {}, 1, not (plain == false)
    repeat
        local npos, epos = string.find(str, delim, pos, plain)
        table.insert(tokens, string.sub(str, pos, npos and npos - 1))
        pos = epos and epos + 1
    until not pos
    return tokens
end

--Font Awesome 5
setmetatable(fa, {
	__call = function(t, v)
		if (type(v) == "string") then
			return t["ICON_" .. v:upper()] or "?"
		elseif (type(v) == "number" and v >= 0xf000 and v <= 0xf83e) then
			local t, h = {}, 128
			while v >= h do
				t[#t + 1] = 128 + v % 64
				v = math.floor(v / 64)
				h = h > 32 and 32 or h / 2
			end
			t[#t + 1] = 256 - 2 * h + v
			return string.char(unpack(t)):reverse()
		end
		return "?"
	end,

	__index = function(t, i)
		if type(i) == "string" then
			if i == "min_range" then
				return 0xf000
			elseif i == "max_range" then
				return 0xf83e
			end
		end

		return t[i]
	end
})

font85 = "7])#######l0AT?'/###[),##0rC$#Q6>##T@;*>mLbZ1U:g1pu?'o/fY;99A<H$$E*m<-R?^01iZn42Wr%emq.>>#CEnB4aNV=BSkbN3Y`+/(83NP&'a(*Hlme+M)Lh1pgb5&5#-0%J2NYvCGU`i014MYPc,d<BTt&W7rq.>-Q@pV-TT$=(=O($%&cbA#[LXm/<_[FHIpSb#4.>>#?NJM'`4JuB@)JHYRwrx+ZUfi'kH[^IeUkA#84S>-=l=o0+>00FmTtm5Zf4J_@Qj[$F$S+HOf7-K[;h(a]o[f1g.FC2QjKRn<%`g+odPir0P5##NMsfi03QAN@5X8vr#um#`??&M]em##]obkLYX-##:Zh3v;7YY#iOc)MenY8N]Q7fM_X7Da5Rq#$4aP+#OCDX-/Mi63-CkV74iWh#HWN%tZ4ZV$*9nJ;sM$=(h^QcMEY0=#l?*1#6Y0Z$C3`eMWs5/(9.^e$HBr<9NN3<q8J=WMQa7C#pPf7L's7^.`7ND#>xBW.F;cY#u.9;-k]5@.w(>##=eU_&4saS7bLo+MU)m-M9GpV-o81`&L)###W-[0#;V>W-p[6w^.[DW%c$V=u2]#x'/dU_&DR'[KvrxV%#%dw'89Sw9h)h:DKQew'#w+F%aW2B#bD7@#H$)^#uLbA#*v7/$Cn[R*B+/FIv1OcMi_uGMZ$.A-v/vLNJrJfLIgMe.%[h3v&>8F-IlJGMg6$##:($<-DW*CON;#gL46n]OwLDiLE^e*N4PZY#d,PY#H09kO&0>F%lG.+M/(#GMr=6##K%pxusWWjMl<]0#%)&Fe_bO_/tNJ2L3Ip-6A^4m'sJU_8G,>##)*-xKt*dGMSLT_-gtx&$Q97I-9wvuPl`Z.q;Txp7kMF&#jZqw0tr[fLe[@`aNN/.v/#@`&U#SRN+T0<-=hPhL=SN>.lV(?#wUb&#(HqhL><+;.rY12'*P,:VCKs9)*^FW/WFblA%?eA#B3f;--%9gLjsJfL%%HtM3jBK-:M#<-9t/OMI7$##nWs-$)2(F.vU'^#)MgGM'07#%[q6W%jjE_/P-<p^05J'.ZRtGM&<x,vXRwA-;UfZ$S@+?.)V>W-YX<wT06b2(av-K<=5v5M6t&/L'n]j-p0N2rQ0gw'iiAdO(L>gLIHqI8uhF&#FSk9VW$s;-5@P)N?b>;-@]Ewp/R,,)n4t;MGxS,Mi[@`aSW&.$H,>uu2F(&O1OJJ.)PUV$4?7^#,.m<-Y;5]))t3Q801O2(gxpP8BXO&#^a*s7c^'^#[@:dMcqs.LPGa-Z2d_-QwaQd+g1k?%2)[w'g$_-6EYZ2r3gDE-7t.>-WEnR8Oc4?.Kvw/&gXk9`jPF;-IW1RWq`hQanDdpKg]<Z%34cA#Sjf;-S1NU/$2YY#D,>>#L-ZF%Un7ppVKDiLmM+kLRV.R&7<l>[eoaZ%JZeGMr5kf-S:ek=BsL_]vTJX-3s3kO+WW&mY57#%gTs;-wPvD-xh/k$a^eHMBm^g-#'LKEDqQm8SR&:)>liEIed-Audr+_J(hJ2LLF/.?w`%/Lw(>##e^f8.`_Y@t'sOk4CC_,M'p[m-R>E-Z(V'^#AC1:2Q,^:)_Fp92;](##bX^&#.&Uw0i/968-I1_AM+gxu'`'B#_h0-Ma5GDNj;nqMe1eQ8WrjpBRU[F%sP*B#;pwFMw0#,M>b%Y-.b@_/fbr8.Jk+Y#xYE^#c-hHMuJ<mLv9T;-xL#<-_+'w%D9x;-cDQe%)G_-6HqC_&vTj-$DecA#dcN&#-%(^#9jw>[MK.FNJr`f'^gJm8`po2DCtC*NZiG<-ldb(MM3`EN[4?uuwE8T.Zq57vfcve%HxG9i@RcxuLdFs-'00%OYsJfL35KV-9#QQ9D%72LKT(W7cIEdtPCZY#Trl;-,KpkMJ($Y#02#M9_ldd+J%RXNJ2$##PoT)N4AwN9/Pc>[.cv:89$u1q*/>?.QwcHMCY^@%.-.^#CQ*-MDKT_-$QX_/7@cA#+OvGMRUfZ$tqlw'2'`&#YZdwB4cxJNHvw/&iBXKN9PVU%N_C(s/):m8K@I2LdPWd=d$4CMdNu$Mq*E'8=bqkF`']N9GRjp^]*4,%*0W2iwn&L8n_'^#`ddA#H<X/:I@>F%YC%9.fxaS7G09kO:v'W-mU_?@?:H<-Fv?u%Q%s&-+;QQ9?a'^#W1+.$)T*q0j70[%I6vR<;to--VuFgL:9?uu7AZpLE)tnLO2&,;SiM2iLv-tLMUDu$Z`J_&t0w,v'%H<-:_we-9@e_S[VT=uPM:@-1,u[&UE)B#tRak86Lx%uLCw92p`R+M68T;-7QDiL7YHM9>@Z9MI2ckXwOlR3nwl%lbh:_JO?YpKP=6##klpP8MYs9)4^+REMqPpBm7qT;K0X>-V^f;-OY6=.pp$crr9rDN1sJ0%uR-Q8r'3.-t:CW/?n;J:S8@k=LbJ_&99*kbO]4gLJ+N>Moii3vYqZm%nd)l=<fJKjsLbw(Gf#EN(xG`-w[-?ew;x,v,P1&&CsFu#XGKG.q6YY#HwlA#dS[I-gcPhL]+YS7a;1g:pq4?e$1#,MGf639[YKd4B$JY-bB/R<Goup7'/PR*r-w,v$(?,MrOb(M([_@-)(0k$$CvGM^dMY$Uw&.-J?_KEQ@$##E,>uuGqVG;hR4AuNHRe-&@%Rj2KNgLuE*b.tcxX#qS=oMsw=`Nwrs49<KF&#PpWDNYfVU%?p`kk<3*dMLgY1NAc]F-F)l?-@o4d&SmaHMNqc1%3*/F@*:W<-p1Dj:qc(KEWi$A-'S5s-nlRfLZ?45&m5FGMm8#&#YgxnLNheNQ-lQS%Q;=t#n[)h'-q='*:mQ<,bYD67B^NB<j3XNAE'40KbcDBNrhXWP,t23S</(*VU016[10CNfatLZku#+9m;4Oarf7?k&&C/e(A8<t,W0E*2nGY?4*`N67<q(h9K#XB<j3bNAEQPEM#LZQR4BsjS>/ldUgpqm[w7GE`J&MNffk>Bjx>06n@O9Bs^88X#qR?k&?2Et,mJ([46q-e:`eN3ABUiQIe44wO)XH6R9dxgTL.3$XiDsg^)PPE`4FeZbU`nggw5tpm1/QNo?4+*rO9??tdcXq$5jMt,lSh<5o<X3A#$6hB3>V?X7IR?bEN,qdUY[KgugI<l4JVKpYp`Wuhu'7%QBX$4(ARt53+0R7<_Gk8D9`-:Q5tB<[rPw=n9b3A$'?hB6Jk?FIX)UH[&U-Lm4/_N':CtP9Q8kSY6:qZ&AG*`7C@$b?tW<cZuE-ht^7wkPA,4&>/:eUYhJwXv`W0^0rL'aKmuQe[r3hgm*dBjwg@wk+NtTm8J2koQWrWu4$>F)IV/:-c^Sb2/cEU6Atu09Mgn*;]i,@=je@U?'0QhB8DF_EC(_wFQ's6I]mk0KkrDbM13/OSNxZ'Wc95XYwu]-_64rBaA$k<c^rwKgfL9ehn'Q'j)Bb9m62?nnGLO*r_#a<uue21'66((*HMst,_'IL0*Yjq6Anck8R2t'<hRit>#h^kA=SO_EYj9LKo(NbM(1(=P>Z8OSPxHbV]kA[Xn#r6[/]c*`<R[$bF99XcWM.Ofb.Fhg*Wg6nE4]-qQ'U's]mMwt,OSI(=QLC*Wnmh0-i877V8bb;d4vw=;Y9@Fb,CLKuLS_N>a]kS#),##_GoT$rt`H(13u^*?23t,h(A38H&0$=oN90BKQKHLl`?^Q_].?R:sFHUIuZ^WwUq#bW(t)itpesl3Y7HqTmi<#$7jH(=,<t,K%5n.k2#_3&M3q68e(h9Im<'<^ReQ@?95*Mt0$qQZF8T%P`=9Zk2RN]+u$$bX7^aij-v#k(jGNoL*q#tcS+U$*t0_*DSAq-uo_<5ATE'<rJ<$FIwI3Jx$lWP/'E3SA8udUQO/wXJLA^QYZf$rLvJ&r0K'd%0Y''sWprsul7h3&QO_00EM$U?wC2T.2(4=r'UG2,Pg:[4%+=^QrMZPr#D9Qr1o#RrGb;SrWB8TrimxTr&NuUr,:0E8@/=2_TeA^QwF#secIB*i$-4tltHt'*BGqEV_3GtY$#9h^44._aO/V3fiHB^QkjcL81Af%u%]VT.w^F.s>n>&'E]@U?&-QhB4,f'E-UTg1ZN]5shs=6s/GR8s@'6F8<gIP^sup;-ro>&'g3Ftl62?nnD7oHq_#a<us_vk&5-cb)wC2T.j3fHs>n>&'cVDMs0C)OsF$&Psf#PQssG1Rs3ARSsFxNTsUF0UsbqpUswd2Ws5?&Xs@^SXsL2>Ys[](Zsi1iZs=p>&'Z=8.(<H1(*VeQL0-7JU.h5ums+/+g$&Raw#F=%@#B+rvu=f($u7A,'t.^NHr'6RKqxpqjpo6>6ofRaWm[rH?lS;lajMs4*j=CcTe*A/wc#vM?cn):*acExg__-A0_P.-q[LlK9[HSkWZC2oZY>m7$Y6<vaW2$?*Wim)eMBo3nJ7AR6J2vU9Ikt-eDd@P0CT><q@>k+_=:RJ'=*/Y39tSxQ8m&a97S=oE3IJZ01<NFq..[i<-b2)O'K:2?u7G>Bt-ZEHr$-IKqiOwvlW`$$lQ5cajEH/-i,G&wcvf)$cm,LEadN4-`VRvm]<6UHVam7'Oin$eDcI(hCXSY6/ZmY3'P*b9%D7i?#)N<Hrn-gpnLv=EjB-*0h^%B?Y7KDBX1'HEW,bgdV(I0-VueRNTo@VQSbDB<Q[&bZPSKIBOM'MENEFpgL?(90L7MwmJ35@6JnkugCQ5*q@H^-t?DEL<?/iZH;%2C0:_LaH21'oT.-e7t-'@;w,#(Z?,ue#_+qLB'+f]I-)aAiK([vlN'R<9q%>V#BtaIasmO/Paj<RCQfwuMZcj)UaabN=H`Ve`j^QCdm]DGOWZ=vRZY8Zr#Y.t>EW*[^dV$7bgUiY9<QVZ[^OG_cdM8D76J(KYWHx&^ZGaI1-D]1PKCXoojBN,wp@FW$t?=tF?>,fmd;sD&q7bB-w5TFoa3C8?01+@Q?,pI9'+cG`K(Q?K6&GXnW$2>>^tsTl2pfqo5o`FWsmOAC^kBE/Hi=*Ngh7[Qjg(Sx8ew+&<dsiDZck8-BbgvKaaTF?Q]?2+<Z7Wi#Y0*QaWjuGTR_AKWQJI'0L$k<BFT]JNBK#np@xl439WnB?5O=+'47KXQ/4b+/(aE.;QLJY##$;-<-lZ37%$kj1#9(310p####x->>#.5T;-47YD3/7YY#2>uu#.H:;$0PUV$TZqr$E<pVek:0T7a-w>m>U$HD<?(0(eQ8Wn?Y$H`Ur`mJJVd-->'O1#e.R(#t463#nbE)#&<IiLJGm50xE%##AO)##Ofl-$[o:N(&tbf(E,L/)%48K)l-CG)lbRg)D6_c)hY_g)dA$)*@QP8./K?D*_@*d*'G.d*`Uj)+mZv%+Q@]E+8oV]+>wrx+/VjfL9xRiLBD=JMpvdiL'c1>ZdZW>-Z<m92Y1[3#?)'F.[Ze--b`K=#<^e--GK2_AGeL:#Z9nlL1PF$/e**##Jsk-$9Ln-$Uv;s.`U,t.Wsgo.d'-5/(K[8/Pju8.#1HP/fg;T/,:dl/[HM50l/s50tA)20T9iP0pFGQ0HT`i0*YlS.U^%/1.WjfL/(1kLJIkKV)&BkLCLnK`*,KkLLoMqSx4VX.,8^kLJ*^eEl&GpoR8_'u.DpkL7QqkLKY=4U@:PXn0P,lL&]-lLVd6lLa&bL`2]>lLHpHlL4pHlL1vQlLp,elL@_%sA7%mlL27wlL?9.5h;C`MM=Q%N2U*5dNxY4N)gS^-64+r=#F4v1#Y+KiLO^g5#.q,wpcOa'#L#9w^AC6kO3m.+#*(O7#]K<kF;V]9M5o?_/85EwKNt-.#?3+R<WLt7#-^olL.B@;#1SxE7-_<kF4x(=#px-_JZ?-wp+@%RE]J?wTl(6-v#EN:#.t_-#&x]9MSu[6#Kftjt:,a*#2&Ik4.1d9DAUM=#;mfER(V_#M0#jE-4T]F-5Y`=-EeF?-v<D].K;$##PMXR-,+Yg.K9'##4M.U.PE'##5A;=-](LS-*kw:0qF%##fx$##o*k-$AF&pAR*B5BS3^PB*k'mB36C2CUUo2C5b4JC&WjfLg/AqL8DfQic(IqL7%Q9qd.RqL.=SqLuB]qL@B]qL1A]qL8)0x&f:eqLq8s9hg@nqLOMoqLDSxqLjRxqL4PlF-5+skWjR3rL;_4rLXe=rLUkFrLFqOrL;wXrLwxXrLZ)crL'mZlNpwjrL_3urL=4urL.:(sLs:(sLD?1sLP?1sL0F:sLJKCsL^r%0#vEKsL1ZUsLspS/l4JGaRxMB<1U6(&Pe^+poCv]T;'9mV[%e#tL]w-tL3x-tL=120cd7/U)8a6w^[iw9)j>[EeI>89#X/n,#Xd_9MvGYw0@jk9;Z]%)#%;-R<$cL9i[P`w'hP:3#3SbE[<--7#>+J)#3ppoLS^B5#TTU+#9YV(#oHc-69DP-QjHi;#*-Y9VaB6_AM;l9;19`9M6f3R3?[c-6_L,:#/<Y9VPDl9;E0%F7Ki/wp'9]<#s>_6#L.aw'-pO=#<CEk=)7>*#DwP:#;(.R<DRKk4i=cE[vcG2#hM+F.g$^-?-sD-dj2p-$fK<0#R#7_A>MZw03nc*#7$+_SF.M##EF.R<R]=-#bS8<#'+s9268E-d<hoEIDU6wgq89-vwhcE[+v#2#-:ZkLAKx>-bdEB--=Ov/E,*##7S&##oXJn.d++##Zq-A-?s.>-?)xU.'k(##k#Tv.6;&##iij-$S;/2_w]W2_iYxI_fwGM_]dii_j;//`?f'/`.:HJ`G/FJ`?#kJ`](:c`]&+,aSqdGa+C6`a(^k)bcJQ%b0Vm@b4x_`b<I@&c'ri=cR6S]c'o)^c.-Juc0.wxcRD:>dmBSYdi=rudlJ1;eZn3;eX''WercBoe?VjfL56GDqu@H&MRSR&M8UR&M/Y[&M*A/-'xRd&MH0U^D#Ym&Mclw&M.lw&M;r*'MU_#wN%f)'MYw3'M4XP-9(xD'M4lDwEO5@2h)(N'M4:X'MuAb'Mu_<_VqI<:,<I@&cab*.BF2Lk+2+A-m(ub9M)&I5#a)]kLGreQ-+A:@-:GtJ-LW^C-LRZL-kgRU.Vk(##[O#<-4omt.Zu+##@hm-$k?eumrb6vmoD@rm:#u;nxWwRnDa<oniLdrn1W'8olaASomj]oofgF5pf8pLp#jh2qbRlIqN[1fqY]v.rg4<JrvfQfraCSgr8,I(s_4eCs+VjfLjH<ILQ-0%4$VlQWd7cQsBRY+#fm`<#m@Z-H4vBkFZq(F7g?17#n;/=#?rt.#;WL7#V'ixLF(q=#]),F%$bk&#lm2<#nu53##<niLH0t4#020kLDb*4#LOC/#pQUhLnNvwL;8X<#pORqLBa0s.n>F>#:5l-$GdS5'[JT5'dcT5'7F@Q')SSM'XS>Q',_oi'594m'xwM3(qe4/(;pOJ(`VjfL%'Ib<d*ChL59MhL0:MhL),Z0hf6UhL&3P=$g<_hLAfeU7aY]nfiHqhL>F/1_jN$iLTGM=Qq5&cNNSn1(_a.R3?32_AI1t9)Fuw(#&^IwBuN_-6h/[9M9.Ak=fgCwKp]j,#lYmQW*N)7#R%9-#*Q2_A[-:*#I]>_/IA6F%CKrS/<A=T/6?ml/>GO503,kP0JsnP0xU5m0nE`m05e./1SVjfL2,:kLa1CkLd9LkLR=UkL=>UkLsD_kLuIhkLtJhkL`QqkLlt4(PEbhqo1S,lL:d6lL#R=4q3`>lLtj?lLpC*MMP_&5:6rYlL0+elLx,elL)1nlL$9wlL-8wlLp@;g*+XDAd;:2mLMI<mLIbw51p`?s]Ag@N2C6gVe?RVmLB]*6L@X`mL'`-6UBermL(t&nLs#0nL`V%tf57j*,&Wjt&F2Lk+`)]QsE/i5#n'?jL/65O-qM#<-pHvD-m0QD-,aO_.>6B>#fU^C-l9.:0DBB>#*E>>#b(n-$D&G>#ZJwA-s7Af.*9>>#'bDE-9r.>-j=9C-kUus/_'F>#jC@>#]2RA-KseQ-VdQX./5D>#JZ@Q-3ufN-SA'k./+A>#2s:T.uMC>#q%kB-LXkV.xO@>#HG6x/gqE>#egB>#ahj'/IhA>#9tk-$ArC>#=$jE->)m<-qe2m.0i@>#dW_@-Km+G-GaO_.1gC>#uX?T-k%61/u)C>#TZl-$`X5&GCY4&G/$RAGut1_GQ0JYG;<fuGYD+;HdVjfL:UP/,s0'sLJA1sLx@1sLfE:sLvE:sLILCsL-SLsLBYUsLaWUsLQ^_sLW;%Hdt$o#KRI=_/7D#/#:_YhL<>[./-tB>#*Pj-$PF3/MmXwJM)*4GMGRfgM6=k(NQD0DNOirGNrNK`NYDrDO4`,AOCPe`OU6(&PCW-&Pi.oAPF0DYPavH#Qv7`uPVTH>Q?w1ZQ7I@VQpSwuQu/<<R-f<SRWnWoRKVjfL.PKvL<RKvLhVTvL%*?WM+Ewp*1voE@liH_&6Cx4#JJ1F%Y`l9;-'j--j@cE[)N-kb+Y?kFD5xQN3G]Ee:-2+#l?S4#^wx9)OFr##TRW(#ZQhgL3NYO-d96L-G`f;1UrE>#pgC>#jP@>#W.OJ-QX_@-%Vi].4PA>#$7T;-i9M&0<_>>#1:>>#we&V-SG*b.>]A>#0cDE-7*m<-_spk.:DA>#6hG<-w>9C-TfF?-h:Bc.p,@>#=*m<-oKwA-.p,D-Y*Xj.v6C>#UYkV.ABD>#geQX.&CC>#bB'k./[C>#)53U-IB;=-`*Xj.,MF>#DvfN-=EsM-J=8F-.Rr&0.E@>#jME>#Un+G-SZ`=-M85O-/'kB-.)Wm.QND>#Xi(P-@(KV-OBRm/M8A>#asD>#<dP[.h+B>#n*Xj.BfF>#W=8F-.BqS-+;Bc.k)E>#ARZL-&fQX.E^@>##r[J2#F?>#MrF>#+]B>#Qv@>#qTh`.T(G>#rOei.<+C>#()l?-]j4g.0R?>#s+MP-Rwre.kPA>#kB;=-)5v11r_>>#pZD>#lF>>#IeEB-n85O-ENdl.vR>>#NeEB-_k)M-+1PG-Bh'S-=A:@-u:x#/F_?>#A7m-$5eTcsa?l(t(Aj(tnm1DtPsQ`tuC4&uwpf=u4]tBuk.GuuE/5##4:P>#BL1v#kd6#5KUL;$wg-s$GpH8%$#eS%96E5&2?aP&>(.m/+H&m&1PA2'2q]G2gY]M'Kcxi'8l=/(AuXJ(6(.m/=)uf(K1:,)?VjfL;v(=Qh?_hLDKihL]G6o/NXEI`nlmI2lW-iLad7iLniwURnd?iLoXG1qojHiLVwRiLH&]iLL>nV%r&eiL/P)&PcBI&,v>3jLIY?W.xJEjL2[D&l#QNjLQdbjLpikjLp[>q&n79?d(p&kL@'1kL1iMq8'bE3h+,BkLe8LkL9)3ej<j8@6.>^kL%f?LMg464Ci.L2U1P#lLE%CLrNOa4:]um(#P9o^fWSu-$E/cY#p'xU.?([Y#9&wX.E4[Y#s5WB1mK]Y#'%aY#1?^Y#0eF?-WWJn.f']Y#u@;=-iTi].XL[Y#N`/v.m1`Y#v)l-$?+1K;(H*)<Jd3-<MQED<;Ya`<-#5e<dd&&=Nu]]=T'##>B[xQE3^7R*^0l^oDF@_/lM]QsOHJ##U2Ck=1>B;#(Br^f6Yg;#a3/F%6Nv9)*2sE@O*Xw0hS(_SG^,4#-Qr^f<oiQavTC8#@L]6#.F)F.IYa*#Eh<-mDI+kb#V%&#/0N=#Zgj9;^mp920a[9#k9n-$Ub)F.1Al/#dS79#]O@wTJCjQa]9A_/0Q,R<:On-$6&Dk=nn%kkONk2#t)poLeugK-:3>o.>&`Y#;3>o.RZYY#*p8Z.%'_Y#6^Me.6W_Y#8j@'0`%aY#b'^Y#fb0s.M>`Y#Lrn-$+mg5KiODMKspkNLfs[fLf'x+MK/=GMjNtJMB:XcMSb/,NC8MGNnggcN4s6dNJ_p%OI^LDO'^2aOZ#mxO,nGAPXph,;n^>>#4;Q%bBY?`a:i###t.NF3?DXI)Q(P)4u3YD#1h;E4k&B.**gg95DjD/q6u]$5270F*_*uL(B7-wa[$FT%8*c$i2JM'#66ND#9DH%b@lVxb?x###OZ'u$+dfF4*%C(4&P%`&$-+c4A^#]#9TF+5N;&L(9TPd259s5(3;)ku)Ods.<5HJ_<Rkb%jpvD*K_X,)XqoE@]q;##C-C++D1$##,grk'&VW/23ekD#7Gk9D0Na;%=-(9.;,Bf30d%H),(*9%bEB:%els4:q3rGZ9eq6&0=?7;)VY_$N+J&,=wRu-AJ0kL1(Jg>]6#9%6&k0;9->>#Wfc=l#SE`Wo+`$'?@l(NW3OG4qd8x,EHuD#(9$x$4=HB+vNTw$c'R@/2c2HEJQmpJ+m?6&gR#$054QK)h$w##3+rvuh[QC#*N$iLKBa.3i;p9;E<M+*aKA8%:q'E#;lm=7143p%(EM#RgZ<*Eq1kM([8)=-cmfX',/qM#%s$IMp7OQ'GvFF*j:K<&HrG;Dpi7)*vOlo.%&>uuiA3L#PMc##ciKS.Gu7M):EW@,bkh8.uAOZ6uqU%6N/ob4ZXtWqTW)J<HY.cV/Fwe4r>;@.-1Ud1?0<S0.+CJ)97R7(a3n0#.LPb@(xs.L8rju5i=M]=C`0DEt+j+M^((##,R(f)$_Aj0d,;o0eAGA#K(;T.oNv)4LL-]/3xWD#`bZV-`tk_/wSJR384$Z$>tWS*^m@T*'wD_JWjrB#2muN'jB&n/rA'%M,$rDN=%PS7YL72L:Fgi#eHPn&-;0i#`*IM,5[qB#f/)ZuULnH)(bq-Mb;_6&apg@':]X,0KQ+?-E;`5/aQ/n&t0=ZMf<nIQwq$##'&>uu]4>>#(*V$#r>$(#d,>>#AH-i$^>W8/v?jD4]q@q.oNeF4Qc]:)k-;p79_8:)=Rnl/)vTDMkDPKNqLba*-.,r)K;YdNS=/GV`Rl<M7c#W-a@Au(YjN.-Numo%X/j@-@_(58-<;MBniMfLa1(##fg'u$)=HtU*aVO'5L2X-`;5]^6/WO'j5O88`gJ:)cA'ZP'i7^Pl`&ZP[h7^Pq?C^'UeSN'1#oP^LX1gC8%0I$X0Z7*s0]8%$1cR*o?+x0vcaa*EXlA#wX@FNVB_6&^@e6&XEvA#KWPe-qr.Dt9C%Q'5(d<--vRU.AIns$7RD=-g&9gLPS$tNV_D=-7JS>-SFS>-qx8;-INm2(Ln>PAFfUu7i*s22RK*78FfK/)eO)W-j$QR*Ij_`3gF`T.mNv)4)-+s7V2rC&ha*6(/j+?Mj+b]+#Vb]u:Hh)N?MYM&@*;o*5p:E,)TOrNl)_xXaMW]uo.dW-x1G+.EHDr)rFkA#&uT^#N$R0#.;:L09`Z=7Vb7%-8Y:I$0tB:%P(-vZS^Qp.c2T#G_T_hL]tdYu#g5r%CST:%;S&:)HW<jL);YCju#`902[oi'ML2>GjCh9;nB>$.[E]s$NXp+MBSZp181np%g/Zr%et;B+%=c,M;Fm<-jcvhL+6]jLUfZM9^.+b+@@KV69<hc)?2(.$QXkD#DPP8.tf%&4U&p,3QtC.37p+]94:-%-u597/PDRv$+G[C#N[hr&O%,)NYefc9.+:3C>L>+G5n<J#L;:<.>c^Fin2l9.rNj6f@8'd<u3se.SWt&#UCmtMr)7d.7,m#Y02AuL$I)=1,P(vu;`fX#crB'#iTBb%)Bic)-<Tv-g<7f3%[*G4pM.)*ARIw#@]WF3J29f3Jc7C#MPsD#I:w>'k&T@#X'7]Q.RR]8?l<s%Qbw<$W%^'+<`fW9fI*?-B-P/(UtVW'f>QN'0m;Q/<YhGEFqRD8OCYK;.f7W$cJVg(t)tu-^-tpB;ijm9Z<KU%&TFGi;Av1q(x9'#@aZ`*N#JGDFgNW]GjH+#a7s,FRM^)(v34e+,jgW$(xn921gC5S7?<O%mp'H2qprc<+`bA#?=BI$;wuU)$fdJVx`9@M8VY8.I#BmA7x/I$n2:9%<ET_&o&Z;%<b%Y-32v$':bh$'9'Ns%xNd--P=$##5e+/(,Da.qv-5;6hE%##lq[s$aY?C#YlWI)(#;9/YmLT/eMXV/Z?85/1c<9/SP,G4[^<c4OJ,G4osFA#0j5F%0v.l'Gq[s$f-;Z5(BcJ(-@Sj0K]N^4KX7a+-fd5/k3AN0-)TKM;9BN0n()a4,K:V%52HAk[x):8:%]5&7C&<$;mqd2G3,n&m*(r&_q[8%:'TW$-u9N(U<fY-D5ti,p;E&+o4:kLKM):8MGf#v[-Zr#[A)4#hC'k.Vb7%-T;eu%O9ki0j_p>,Y]3?%J+(f)M7%s$CY@C#PVvb%,J]dFp<xR9`?hB#K..<$]`J#GiAGb%@aYp%1C_B#v%<&+4lLv#7F>=6r'@s$GOV;$_=f5'mQD#5]w./1e4OpWC[ws$M'-p/D]0'%74'aW'dMQ0MeMv#Wh)Ab#9*/M_Bag&r=F_$m?m]O7v2;6-V1vu<`fX#8Oc##Lqbf(0k'u$OR0]$Z%AA48p<Z%,L%EfQ+;mQg2>9%:]BT7q)pW$pE'=(*IF/fe.A9&D[S%'7hw;$3,,B4xfo=#l'^E#qFX&#@]&*#eM:u$U=cd3B4vr-N9K:%qaVa4S3YD#:O1x5m4^+4rf^I*iIbGM+V@C#]=3H*uo%&4V])<-YA.H)xl)`#5?@L(Xg39%x1@W$l'Yh('Qv,);gLv#GC*j0NU%WZ51[s$Yi(?#LqCp/8)pgu[Lns$YVjfL3iNN1dUC'%9xq;$_:&@#<bb=$HpdD*FL=[$e<S/1=H0T%gv4T%9DTkL#rJfL.<J%b<G?`ad<ai0<(ku5jc;F34tFA##Af3M7XXD#oe+D#qeZi&P]<+3(Io>-_P[#%x+3T%r56Li9^R<?1,HmS-,-mSFVI<?s'hR'gIF:&2gt8RG+:n'UEUN'skPn&fs4OMeb@`aRop7+0dRt1kj-G&)M?1GX01I$BDEk'Po*7M)WO0MIFZY#%(IM0<qt.LWuSY,>Sm/;F2Qm8NY8a#k&B.*$*$E3-,0J37oOY%s(>V-qg[)EK?t9%RYNE*R#kT>OJ1G-xaX,'9u,%,9GRw'3'g5&jTSj0OC]5L':*/1+P(vuE:G>#v9E)#3o%7&(d``3EWEI37F;8.vu/+*KG>c43Y7%-dCXI)+%?29a)w<()TID*2+`kLj;sFr;:@W$&h%T%pNg3*PKZ3D4g_o8Du$W$PkV;$aNLk10N@A8/SXM:.c[8%qi5=NYCX[$(>*j1I6@L+9Zt?0hrUv#d,$7&-]jmCc1aH*-/e8%%/5##4Z,T.dxK'##2H=MGMXD#jD(&&Sbi0Y27Aj0LNv)4wBuD#QE>wT+]$[^`%j?^<-Tv-F.lI)fgJb.t6W299hP<.k7H>#nVO,2kV'K-LZsb0&^([#kjf8%F,H5MF]AR5)Hnw'9_D'O;fY+-wLBu1^sMG##w;M-8cS(NId<+5bE?5.rxdrLd`rR[c5gG3)7gsOo7$##ek5qTs8K%#jd0'#@Ja)#tPUV$iAx3%M@Jgss$mr-0S<+3x>tYP#*-M;*n,g)DF_B#hsaQ)qNJ@#pg(T._#&H*?PK;-#1Tg%IuW>-5ABR3MV7R32D3RMGshHOdw2L-hu7p&H/>p7Oo0B#PYL7#<KV&#&EEn':;gF4Z9Q<.*/rv-H4H>#9x<J-G.QT1pktX?v:vU01=l:,;<dq)128N0^vp`?gj:b,3822:$),##Cj6o#;^U7#K,>>#.,h.*]3B:%?]d8/`$e29g8P)4?s.[B+'PA#x=XI)v$%`%Ef?Q2N/]P'*i%KDiA&S'UdPN'67U+*iitV-1Xho@oG[h(ZW&30qO6?&J=D?#A5dc*e;]Y,F:E5&4^3jLFrvA%xb$##T`Im-l=t<SBv3+NDdMu&]Wgf1Ac``3/4;E&'Pto7IwY'A^]Q[-q+Zc-w%gW6Ls_M',D.GV]$aX%mE+K1+n3T[`,:^#OC<P<-ir$'i0(=%q81H23v%$4vcS=uT(4GM4V###B_(f)(-Y,29;fO8D^W/iv@aS&vLq<C6OboIIL`ZuPVgQ&%Lx;Q=`YY#S$CDtf0u-67,0g65'PA#J@[s$k^<c48Llj1D#J]O2d?$*s5hU%NXEp%)B0I$(NCSIUsG1)]3570KE(K(vptg1X>IL(a+4@R%@Yp#mXx5#[d0'#E8F@Rj;Z)OQf9a#vrGs-QL-.M$<NT/JC[x6348C#po$H**J=9WBO158$UFB6NqI<$A8>F+Eh8<$B=XN1n3XX$Hg$-)&]l?,M[W5&uJ=6B@Bbp0H=I'P+nC]Kf9Y/(:4hX68UKMDn;71(IJgg=OF*T%QBKm&#Lu31mm_,)X8W&+BS)o%Z>###qDG`asw$v#5FNP&EQ(,)^O18.vsai0bFjD#Rbmg)K20J3scf+4<H$&4Rb5s.E6@['Lr@['e)ahLM]XjL6G>CL'qx$MuwoFMrq>;-YImV7YsY>-S+l%ls$BW7O->Z7/CMiLHq8Z7:<LjaY3]>-S.`$#v_B^#1s<0P5.p%#$gCX10WH(#@2<)#>4Xc2%5ER#r6kp%li`s%uMdr%98%E+;-`-Mac`g(KU7U.a$[guR1E29[e9N(<o###w5Ks-tvT]=k;YD4J.&N0490^)xw&O'S.bjLT%m$0Jg4',:Y/%,Ot1p/BRg*%RBCX(+xjg;l?R2Li^l+Mikla=lWPd3sJ))3W`lD%`=[s$/#,G4f/DD3>SoA#.]MQMOmh[M4X1)3C-CvZN'[x2(G9DkkQXVeQ=JrLV^JP'%BcG-'T7U.R)Oe+Y)2.MwAVe$aL.T.v>$(#2kab.Xg$H)k4Ll%/J%F<ac5g)gbC5%*El9.`bE]-d77J3Fdxv#GB^6&;>4'5x-*/:Pi?%b7A+aNY$w:$lGKJ'YrI<?vPda3Qd:0(:j=_/D&0'5i8-S)I9'u$([L&4d^W>-d9&%#$&>uug5wK#Cb($#FM/7NV?+',mFgJ)AH6E#@^r%,,:t'Gc,`3;ucc&#S;p0M'%OZ%KtRm8vvfG3-iGH0oi&f)<H7g)oZHR*,0P=$>_?Z5-Rjs%%G34'XeO-)3idp.`_`?#%wXg1D*_+M%il-2umGK)bDVO'eKRa+Y)TmAYPvpAj%Si+_VN-)TD,6'qxqvAeH`t-jQ4nL9AoH)p@>'?n8g%#pvK'#)w*L:Cfr7:l_Zx6=k_E[.(B3irJ(u$+dfF4/mIfLbk%6MZ^7v&Pg,7&$oKu$cM+%,Gx$X9(d]d3r0P4:4FR=lJE%C#?3OY-Sm:K(Ek7ih,klP9.D+v-HApl81P*N1E6[i9#L2rT5RXD#sP6^=7>[#6w0tD#)i*I*c-pU/:^^p%f&pE%7j5K)U4#J)U=JI*p@gq%rqnw#sm,62t4u;-FO0I$N>Q,O$3s(EO?9q%v4SYL8$cf(4&<GM7c=>,2Gd8.on@8%W'J<-u@0[%I)V:%C:OF3;X^:/5ETe$:jic)SVk%,`_vI4dkrQMaKGS5LhVig,YAc2>t)d*LWF:7vcAw%k/Yp%dMeuLBp0G5%45-,G`Q=lYk8&G$),##Zw>V#4:7I-OC.q.(_Aj0a)k1uV1gA#(<h;7's[eOZQ49%/lkA#0DRe-XEGColxN&#sL'^#154^#sMo'.9$Dn:GS^;.WUYc-g4,OOSIRs-dCVI;?DO0Pj%d;-31WM-o5M]$#TG&5-HtJ-mH#W-9JFUM)NrS&2BiC$8Z*]%AnGL23utA#c@dU9jDG]uQp8N-NesNMk,8o[>H.`$>I0H)qWY)NAvqU#beMP-[SMP-UeHV=YXc8/PYx6*6c%Q/8tFA#K;gF4A-%gLR5Km*3nEW-)u.@T0Y=)QfIr-M,`>4MC2H$GRu=&G3Fq%%*RE4SwgYU&>.sY$&nuY>pDu`4pL`<-7Lm<-l>37'`xJK<IG^C%:9#X$9cl>#(M,W-]c6`&Ho>hP'^-6M@4/GV;(ApA/dj/MDD#W-dl-`&bOVW-,46=h6DgP8iK>F[&6+#(XAl;-@OnR8ctwA,*%Cp7l[9AT[Ah8%OGE;P6=LP8n,]CS:=(?%R%)@0vOkxuNOup71f-g)b*kxPe2Iq7K@9T9GO+DW$pBq7O4l%lAk@Q8]772LLd4<-9]_A&(o((-4<9=[?JMN*V_M^O2Bf?&a9tq`A:C'#)&>uum4>>#m1n]%[v$^=QCIA.>ec1%#3BW-v[`2Mk21s.7ljp%[BFK$Te]CMsL@%bxRbA#jcx`&]4cF7e*O,O#we6OCpgD9Fjv;%+]FgLPu]GMb7$##%Nsp'_33$#j&U'#VPc'?K1m,*[*'u$l4;j`U?F=>BX*x'f2$30H<1W$^gNI)mONgEB)0p$m06&O``r=O$d_uADu&mATFEaaBxL*OTXUA&cIjI-guKw$gc``3:N.)*#`DefW]WEeKi0wg%im_YdFiP-P1+R-3L=W='>Fm'(N,H5j*9d<.'$Z$okn5/iiqO)c&,1:2PuDk2:Pm'FO%nNC-iJ),sVK(K0LG))IDnU&>uu#,Cq'#QYr.LIv?D*E4$##%$ULN1@;W-`[lm'P?o`<c/,IWmC4j1.?v.Lj:6aN_Li/:6[vcMUo)/:Zt9Z-1G+PN7rJfLLL-##9ZhR#=Ft$M-K<)#N]R&4+gB.*`6+X$TlK>Z`VYu-YQ&#GDTN2'RN7Y6=ixC4M;f)40f+M(OCNl<0XZ,*M5SA.,qfx=J:o5'2`P1Mcp(u$:5TF4S]<W%QtgfQhMUhEdo<5Mx=pc7nrA7M1c?uuFuRH#K6i$#W$(,)1C_hL.bv)4$2f]4iwGGMx>+jL;f@:/uiWI)M-$C4ksR'Rdw`*4)n.I*C_39%5gHN'pG@YY6s)P:e#<RDjCR*5v?B[us[rX-nsNe-d<(*#SxefLA%/o#'Ojl%k2<A+Zt$##au.l'ZS6C#'b<c4^nr?#*e75/w0`.3IS#lL==O0((VUo0W&lA#uH$9%mn2Q&fupDj?scQ&-P4gL6.BT&-3BI$j=pQAIFk',_#dV%ZA6$$P#WS74I-I-,TK?#]?OW@x]Pn&LpjJM^@Tp&;-_j$ZKSs$Ow-%,8aGp.dGQ?$jKH*[Z),##?S^U#Kg`4#OH?D*O-YD#UsZ]4EDIg1#mqB#m4WH2(sKq.I2C%Ms;K@#?uET[bn<I)torh(K%T)'jpqp0vrFu#UN<1#xWp%4prr=:p9cq;3P+q&1uEjL&Fcm',RafLe<W?#<EdmSai#D-PH#W-h8_-?=^i9MD6u&'WC'DN^73$#rjP]4iE(E#8wqS/>0Sp&*p9@MWoS/NU/%G&oIPwLfIBC-'<mW-WooE[#(b%bM8UP&_tu,*I7Is$fF?65p_^xXHf.cV_S0i)`j6S'9Ei%,QH7)+k.LLM_C@V#1I24#g6_S-M:bf%R:.W-FILxR<xEb3ntTfLK]x%B.+CJ)wObA#@hh$'xF=iEkFmt7ISI&,f@56;FtlcaQs6_AC`-Q8P)Ux7F4/GV@8FgLF+-m'N4Dm'Ele2.2WNbNE,sFr^O`<-W=vt$G^4N)NI/B-QF(q7,VhB#ulqB#5wA8%-,CI$3&vglGg$&4kV:I$`o8^#Goca(f1Cfu0@tg&iusSgClH>'DK/+@sJnA#faq]&0Hgiu99G)%Q,A^H]b$##sPf9v%DeS#(*V$#drgo.E#'<67%x[-^#hv-k%AA46N.)*d[@`anxrILdD24'/k8g1vk>)+w]uN0fB;(+F^X2MNm?#5h#`baqTjX*]####?t3xu0g9B#(H.%#R0+qB#0=m'5)uV$:`tL%[QT:%cYv#U5dG,*CR`Dbrm$M%A&hJ)WfUk+D'a*.Ds@s.cO3^-m?VW^pOm-.=SZuQ(,SJRf?>l&R%2AncG8f3W?#6/1BGA#oYY`<(vfG3Swn6%8G]T@BMl-$V`9MsW%#OOjeXT@FQX<-F`XZ/v1h[6Gi:Z-+xFR<s%`S%3^3%ts0kB-(1Xb$F*]^OEo`a4%1IM9D?Zv$x=4gLIKI:7l>k-$N_ER<Y+5A8H+Wm/bh[v7*Gp;-K*2*N9WiIRI<I<@WmF&#+$t;-`i_p2pt_qQ996Df#[2n&<,$6SR6g*%rtV[&9n^q)a4T(N_XNE*L0;.Mmpsw&,m?8@+?@m0B.CqD+8g;%jOY`1#dMD3?DXI)@I.[#&^L9L8n9a#`di#?=kZhG84Zq0_cVs%VGeH)n7ol'lu3I)8UUB+pEpB-Pp#8/0O_*7qZ59%Z9,3'[2MO'O696&ej==$EIwo%0$AE+ZIt*MX,$8/NV/`S&]HP/;17<-)3Dx$]`cj)gV9K-DcVu$RR/N0+XZ(+#0?n&Sb;mLv.K;-<R.N%Un5R*mS[YmceMw&<-.L,Ch_dMnc?uu<4>>#bl9'#w6D,#RXhkLdLrB#OgHd)^7Ds-/wepA15Ev6gdKdYlJPA#&j$@'eOEe-[M5Q'9ulhM5t[JMd1kb3FM[,21e4n&u->.<<P+q&MQfZ,5'/T&a1'%'p7m<7oS-n&mKd51Nde%'3Pk.)_QB(M-eg-<t[Oo36p.5^[0t'8%`Oh5i&UHm'WgW-ukJE#5^,g1c&?A4(vZ]4tYLv[]We(B7&I>#]&&vLK4H:v6TH.%v_dZ&'Rp%4?YPs-1M#lLN`?>#_C@rm,=WiT@%$##7p0W-kIcd=hG:u$SuE6D8<nG*E>cY#]EB:%r]Nh#3Z*E*U8$TI[;QN'r1mXlQZ(v#pQ3o817t#Hf]V8&k^1H)0/x&#`?mV#D7/b-^n_a>s(*/%gK(E#(FOp.xhkj1*7U]BShoCMrP#v,*snA#rSc?/`w>V#Z?u<MPQIoB.'#nC%Y@C#0KT8%]@i?#C[bB->,`d-M$]NkNxx&#)DluuZcDE-reDE-'Mm`%:`Z=7:d8x,-:V?@A@B_4Vd1JUsYO]lf*-?7GhF<%,'X>#=%YY,T1OcMo)J_6Ij_G)(@*Q/g<7f3&Xe+4PZg@#2QwS[l[rq8(1]<$Au&K2fXYh<+uV?#IQT:%7o1k'KK/'+pTHq&R(f@><T.90AnW`<x'l,MXPH##2fh4)bTa$#wP?(#xhFJ(UQB#6Z_$q$Halk0J?Qd3K$.gL<bkD#`D#J*>?BW-Sx0O+8vjI3Ia=?-^CpgL)ZE.3x@WmJFYgu&#p=;-oTTN'%^O&>V<)*N#8S#OGYQiT8'q9SCRT(%P`cG3PTkJ)#$aGM?I$i$n%$Q8M$^,3SKjR8#(,d3?/(lL[>Ol]ikT]upM8ZMdnTK-JBGdMZ7-##Vl)d*QxPp&8O<hl7bO[98c:J:5<T;.7uS^=ObKi<dn`&&eVN-)<[G;)q(J-)hv><-9?2eMHMXZ/vOD`a#+oi'o/:La&45GML9r]$^s,@9q3n0#^'(,)(&e1p5%[D442]`,B*TM'l1JD*lAqB#Vq'E#0o&02kkm=7d0N*%8=RP/H04r$7HZ]4j&/^4iYp@kIQU,)%$3^O@3#R&dLi?##W;H)4X?Z$(Vp4Orm9Q&Y+Sf2bLpq%Y=Is$3$`N'3d)4>jl?['W<F)<>7vhL=k<o8>OFm'N)t&d?_QM9S8iT/5xWD#K;Kf3XZlO-*l/0%>P_a+/hUu?t*uq&xCtS7q^*-XviA+iURxa+HU+`&owr8%Q7DE%^2>>#uHY##_8q'#Jc/*#jusI3N]d8/(YPs-]:S)=4*:+?[dv)4HjE.3:=tD#?D2h)=xfG3B-Tv-T,bQ`Nn]:/J6]v5V]O[VDc,##$$V<-S'49%RWXp%$Yo9&s:oi1PDL_,/L*ZuM'<Z-^jGR&BQ7F*i8`K((q^TVkRp?LU`EY7Eme@%7<9a<l7be)krqV.kX&Y.F>:c+-Nr<1:T_:%nF?>#4)U(a;P#BIvt'f)M:Am/?@i?#sMYx6[gG[$FUP,MIDYD#NP,G4B[3^,oe&>@6dYX$e0fW$38],=(al9DvnAiH6,+i<j%3Y$0qJH8c^[-&Sqx21s9B6&7p6.2h(Os%GcGV'obv729>jfOl4s7#W$(,)$6Ud%JQk;-VbqD.jO4@$Yn%<6g>Ig22xIrUJrdZ,Nm#8/+x0/)cYv7&aol4,V9qh;/f-JG[)tr&[K^f+E%>M(FNku-jBdm'0>uu#(DNfLUV]0#Oqn%#vrgo.ShdTiqO=j1PTZd3wS))3SNRF4bEoq$n(nH5_J8f330><1kO^V6A3upS+,<f>_f]s6Mu-U6CCX/>jp/'5=9DA$pt(%,eh>N%A3K:BYQfLMIHTsp];Ub.-4Me-e0?6'iFBJ)qLofL2C^(/gWGJLIe:kOnZWf:4s'-3Euh8.#/^3Ox76J*X.cJC3m[U/_V8f3x9%J3_cor6K]B.*A'#k-*]4hY=;Rv$wlGb%adIh,#x'f).qB:%)SR3'Vaw;@A&<v#`R1+$@FGPAE'bX$2;,>u40DT.x64c4kk,a4jrPL:,I.j)`tGb#nNjQ/>p)%$^_mj<O3GE+IuGZ6;3d05mTTu$v=v=NgB*[&ZSD21nH-@5E84)>-(^]$OL9k.='qi'b0dh/uG<%t.W8/:Y@6T&U%@c?%Ui8.oaVa4ao^I*cnth12k$_+%7I&,Jr)h'o6jR8$B&X%_Yge*Jq:c*3][gET=Huu=wiU1%XL7#N,>>#0k'u$w^P0+5e'E#W$t/17GU%6w(ZA#7Zkv6BJNZ5f'@88`9[oD&kUZ%rI)1D.xVm/Uf=;-%JFgL`SdZ$=6UC#3%r;$2i$dD((,-3nJ)3'mj1#%fBvkExx.Z56?es$j)+$M9em##I(Ws-o9_hLjhi'#LoA*#9mk.#kH@X-(Kp;-?t4@*0.rV*rP2B,YG8f3G6k&m]0jeNeU@`aWf$T.CA(n//AK;-v$_K1O5+%,=EDJ).5u;-KkNM*bZ&@#7++b)d90_MYO<e$YoRa&XRg-6V**%,mkjp%:Yhe$X5>##Vb,r#v_V4#U3=&#.sgo.HZTp.CY@C#NPK*[Af)HE>'b#-tM^Z-4.Ep.&wA%6e8+Ui_kuA4$AP%t7)'Y&0nj;$I%o@-Yl].C/:tRM$r>;-)W,W$T3)$>`uQ#6w&YOM#8cA%mhbk1liQ?$`?mr/]-%-DLa)-M@;KT$gZfoo2=2=-B0Us.$,>>#3qv7;TVCI;L?g;.3$t2MA^&w6c8w)4Y5OKS:/;J3b9O;$>B1K(*AED#fH=GJo6wY#vrme2iB@b>eUV9ruW<##6g1/(Qfr;7(n[k9d;#-3l5MG)cU._6^9Hl.2$L:%SD#W-0RPn*CS7C#:qM,b)41+*u?lD#vXx'T?'On'^@4x#5)bA%7J&e)Ks]q)DCw(<,uWP<I&B]$v=B/3_or<%G-?e)ENM($=LnW$r%r$'4GDW$k`]BHUj&v9fjf8%;XpO1_OWJ1/8###)AP##rB:R#4vA9r1YK+*05wi$8(Ep.#&AA4ZgVIF>`SV6TZ9[Pq^BW$NR$v,jjOp.M7%s$GQK;;f^Fv:R/5##%)Yu#&D*1#)hCN;Uku)4CY@C#HMx90M5J3%E@wWA3UkD#qIj,;lixi)VGmrHUFB:%Lr8Q&oKNm/VVu/(?GOHr;,bjLgdF9%XrM]'.gRx0qMtB%N4Be6iXw8%rYr/(e,_6&OR:X:O#^_O_VK)OXhGl$8lAE#?(BkL7Wi8.YIK,3`s-)*VB4W-eiD(&S18B-oJYA#[cg=%LmL,)Z>'?#KU.[#C@4j199ka((0(<-+M^<&[-r,DCR*p%s2hN'Bt;=-icIl'JZ'Z-s]i0(I$Kg1Wplu>UQp6&ra4K1o:f+M)K$##QYr.L4V###3TfmAktlG*a(Kn$3g+%,4iLe7?BDJ)3$,9.f/5##$xg^#>+[0#*'niL(M6N'52Cv-snpr6rbX_$d0pi'&%pG2a]B.*+Z[V6N2=m'YK#O'5[<N0&T$O'RV'=-d*/3M]mJX)f]H?'3U(-M>Zir&jwqJ#AKIiL;T.(#vh#Z$3)J&#RJ'DeulGoLf4-`'jHux'X>^,M2:(u$R-%s@M,FwpPR(f)5@nw@nJ2W%IXE(&;YN0RDgjO%;ccYud-&49gG2W%VjNb.RX02Wlv83M4A^;-N*KgLE&Ob$h_`?#XY<^-?ws7MwP#&#0dZ(#XI5+#0p</Ma67*&/mQv$(h5K1f2g[6T*gm0VBs?#Vbp6*AK3OBZ4YD4#G%Q/+'SF4K)'J3Ob=j0-8II2J'.%,^la1B+B_s-X&Y;Hq(OS77YG>u&j4DO<_i@CZw$X9(d0f3$]#Q'%L1-Mv'q7/GA]E3^ns5&I9'u$04.@%cr`w$EK3%tCavP9u`j34/t7t%Sdpq%%e@E+8S.e%t'K<BkG(u$A`E<%8_uF-Y*xb%mE(E#F.@x6J]B.*]*1T%Cv:^#:W8R(^N9Q&3Ijm/a?/A&9[0+&s#HO:*Kio//sUB#<3w*$#2J9&7F</1>sN=&YWn%,;-p0DYtux5?####$d+:vhD3L#x3<)#AF31#-On8#O.>>#qB+<-(B^(/G%V%63p@oDYV'$&oaD.3))4hY*VO,Md^]s$+V)Q/JESP/7+h%O3F5gL0g,`-'W0r_e;W*'BP,G47,m]#202k0<E6C#?@i?#(DA]$X*A`#:_a5&PUIW$KKc/(7c_;$E0Xt$9X[6/Rn[W$=7J0U;%Pi(7%lgLoId0Dg'Xp%+lC[,ndkT%.0LQ&3`OM(bT=9%b6Ss$i9'6&)f1@,og'q%%C]8%*?xB/fK-w-ew.=$Mv/.*$YkA#0[41X.itA#>Irv#FnWp%WZ,R&bvlj'Mhns$CL<p%Gq+j'Ctf2'rFWt($Weh(WmcN'FWKo/@XIw#I(I9.p[rS%cG)7&2@(n'_8dR&]Ci?#@hSM'n4od)uQ&R/m2MK(YTe--H=um'],H7&3%lgL#OJs$]`.T&c&;0(^T*I-`2^.*<?uX$3Gg;-[UB(/Nn39%F8onNxJb5'o/%uLDB*^O4j$##$&P:vInAE#,B%%#N####`;]32o.,G4?W8f3`I(+*CX5r)a95T%NBic)S;wEJj<2o0XJc>#L2%l'fA5YrNCV;$`)nH3v1fk*4IPHPQ5%F#bw'0+FfhV$1J`50Kr'du7(G=$@CpC4hH8P<E2d'=+OO*I)vV20[R@`a0J###Vk(jt1,IA4XxrYpR;jv%,E/J:F)kI)P^Z6/'xjt(^Zm&#fQ>JL6]G31ggN^,Tg'u$Ap7bJiA^;.[,MP-dN08%%REW6%SMM02JsO'$Hi`*I&n`*p#UN'ZZ^N0SQ^6&hATe$)>i/'>Gn7&H&pY#6ObG2HqRX'JG0m(7=CH2K_0I$m=np.8&*)#FDppTW<]s$FHq&nGY:Z-cc``3vf%&4Km:9/X+/%'Q<1T%nX`V$HYMT/?*tq.3Fo8%twF`#Lr9t6+>.s.Jlfp&,J1q.+KqM'SFMX-=$CwK'^S`uQLvR&'_A`a2<NE*0os.LV8k(5X5@a3eGOD+21ei0PB?b#sfh:%8Ml(5rq],27@xT%K1(F*K+o60R<f%#veg>$ts3R%=bx+2DX,87l>,<.xR6[CJx#K)sox7;..YI)RJ))3vYDD3,09P<'Lnl/lK9X-lo8P<NJ'f-nu#Y-$xW:'CPu4<uVT#Gc*Kp./Z'Z-XZ8P<W4U=u;9S;$bZ78.;JT)#In@8%V)iO']No8%;Ve]4r<jv6WG=c4JcsD#lW9S/_&l]#'^E.3HWeC#0jkp%6fCZ#2KCT9FkPn0PkN?Ql0FM_>XjP&,jgX'/fLv#7@R<$G-Jf_7vd3'Frh`521C9&eM4W%,=gY(sidP&FhSM'whS8%9Lsl&X?&##RAE-Z^t;##H9(J*:E-)*pF18.Fe75/d/Z%-E+]]44.ST%Y$_1p<?t#bWB0Y$nBTn&[D@g+O*(H2<IB]XO2MnuM)17)q]6N'gW>d57KP$GjUW-?JJms-lGOqAY<W1)J29f3C0g;.[7%s$m#YA#(&;9/B)?g)ob9jEbr3XIr/9E#QixY,sP,<.D4f8%#$@w%rv1n:.xsILUH;w#/UG'$#5]$-hMnv$PEX5&tpds&B]J&#k@Ds-_NOa=A7I#6H/'>0gPV]$cc``3xe=S2;*(*@f]V8&BaJA,>qHJ)#`*JMR[=_7&>m5(SQ^6&QU4n0xP$Yf<4YS7iss(<bB[m0bFjD#$['-%<[$(H49eAOgMic)&#7:2k&B.*@BDJ)sQ)%,/@@%'K.R2L[2egLI@6##@$eA/5>0%,mJ=#MgY:2<`t'B#lnUkLTbCH-i`'d1riqR#wNc##pJ6(#([/Ae;mneM1p?l1g_I9gFx$`,U7=C4Vep)4%^UOhkCA=%SPL/>Ce<9%YVUsMYgUPQ/2:^>a<?'6n&*t.Wrsp%P%Z)%C3n;%#oL['&S.#NIwvi9.aSp^UU$##<qt.LP`SY,x5^f1*.=U.?>n;%5Nxa$j`ir?rUP8/u`Bp7uQI&,1>Y4/-vW2('tEGHom/t'A;+.)HhBSM'w*3&wrpVQE0g2'#c=mALh'i#o8r>RQU*Y$c)V`3[[5K)Yg'u$CY@C#&7&s$nRa6hD(<9/fg-M;+@8N0x9%J34tFA#Hb[s$Oa]I*@6Q2(G&)?>0G<>$n]w-)Nsj&+2&_r.Q>u$MxXxt%9L-U7poSOEujbn(9]T:%h`j0(N'o9._]=5()ENoA2:Ar89`m2TsZ(D+`/3*#G`e/1@jh7#.sgo.fgGj'$`uS.i$5N'wC#W--,CI$`eRs-)u6lLW^;E4s*Gi;qQ1a4#2Nq2mGPA#%:?&2,oK97[&VO';d8#,:b^t%;iKt6[p1g(,+'6&uW]Y-EgwL,gNS*Ohpb9%PZe;%%Xg$.XLeBPkK$12Qj(a+)0GT.P0e0#33_-%9_Aj0Gtn8%9d9R's=iB#a%NT/;JjD#ed-e/KjE.3MFn8%&(-Z$$b^3'D?h,2RiWi(RIlf(Kke<$r2,A#VVam9f+5$,d(2I$7v28&.eYv(95]W96X$9.hjPn&Iqoe(/+Cn'%GOa*$Eh#$<?i;Z40cK1AW8e*i4Oi(AK]_%WFew03v1tK1af0#*jd(#u$(,)u.<9/(J%H**V#D.,thDNixQl1F=qi9Dx#Z$(2`<-a<Gw$p*g)&i*;D+C=m29@M>s-xe5jLZWaT/MEK6&RR:0Cmv4A#JJXG%F?nIMb+WS.*^:l087u6'Z57,&X(hS.Bb[p.'ub6'%Y5C+C<MZ%P-b^M/O$##&,Y:vg5wK#BY]C%PQA.*83f.*MZh]4k;ic)Xj-H)_2qB#Fc7C#/W8f3Hi^F*3KK/)dXgpBiY8(8RZ5<.v6S8%R54K3wU@`a&Pds-e+$t7;.6Z$af*WS:rJfL$e_`N8PA(%D4Tx$Q09tUpHuD#x3YD#KU%],5d11.2Jo+M>JRM.Lq-0)>`6<-JreQ-/1x9%n^Nd4oBeq7oxoAe0;v&#pSc8/+gB.*CFGH3]4_R1dl+G4*X#?Ke[gJ)6p;+3#C@f3AU9mQFgDSj?^VN'?AeZ;CeE9%u>>F%1KgJ)^S:&5(DkZQIY/U'UdPN'`O_hL8e1dMlNkfMXo-g)eVtgL]lG?%l;Y:.jBFA#4(XD#$2YRE:3UZ&;C4AAX;V1H(4AW-b#Qw7=mneMAv?T-LLs%DH9AgQ2af3B772H*eT^:/[B,T.L@Gm'M0k5@B45gd09-mS2m=u%A7xUd$*o._5R/2'O>w%+qdai06SR]4a0%##1btD#Pa6a3cLcI)@S-<.:WPA#-M4gLvoR)*Ht<R/g@F<%B>m8/J^<w$'qj?#d_^C4Au@T%g8K.*khH>#`,RH2>9H2$I(Yf_7S?u'#^nbuWctaENA9DEU_-,$D9fYGKe1p/.AXVR61P]uO2HE42l'*>Gn,B-DMJJVcmY-;@_+N3ZZsiLR5=v6px(v-B%'Z-hFo>-(]`=-vvR/2%5YY#8A6`aF.s=cdhLS.Ygc.*?@i?#$;Ls-iE(E#JC[x6Z&PA#G`HX$']u2Vu'BE#XXc_+8,$NhNN%0)5k1@,_q+<%+TEX&pD`2'+(XO'Thi?#UFb*,5/>KhN)b1)8/qF,^RVZ#p^^t8+<Ov#TdIe->_UhLulrr$H$cj$dsdc),s:D3e1M]=1N&##xLbI)5^F9U4b'E#,$gO&CX?v$=mgDE=[dYom7Pc'I0?k0r/;v#4oW5&_Ba;$-I?$$2QP5&?7V;$7kKO05Cs%,Kum=lTMWa*U@<TRY2e?('7D/:jEXG2&xvm'+CH:7_d?hL/39oLb78<$S#Xt(@/k.McHbaEZ0#<6vi4:v=Rl>#I0`$#mp@.*XA3I)*e75/Yj:9/wK,SnYi1K_N/b=&YuC0(d*gS&;<S.(#+PY%nQ?e&$_bg$4+Zr#p@)4#^d0'#trgo._C.W-+EsB8N7BZR`Dj.31sD>(Q?Z)4GVOS7i>&[uu*?caEfKB%BO?@,R+0/)D@(IVj-[5LVVx<(aYu<Qmkjp%v$t_4)jEJ2.+1/)>EG&#$,P:v:t;##w*pu5SA_s-ntTfL0OPO-G?6[$Oa6i;P5gG3JGBn$[7%s$=Bi<._]B.*0b_@%fWonLss[OCMd[@%MaR?,.?n3'Y+`8*Xp&f-54:HMAHH3'/e](PWsK]=XA[2LwE<8%HWg5/P+^*#lXZ59`fWdXg%F_$PKgf1aV&J3FOHL,CZ05)'Lj?#pZa3&u%a:/OYDB#'Y:a3AX-0)4]aG)/i>C+At-<8kq(K27*fa$&b$u%.W,/i[eU58.-AE+6RB(McC[M0uTx=-/dlO0:OLhL):EZ@llDC,.+CJ)o.:6(5c4[5>ClgL:4MM%iPZ%b>9s+;:E-)*5`KP8E?lD4)-4L#e*TM'Br:*%m4NT/981<7Q3UC4^#A['P(A['tT.29YAZt1G*ihLr_i=-^/[W%faV61>opQK+#=<%A(wo%OD*e)5UC=6P*ve)5f(?#ecw)*fn8>-hbj>.,gwQKf6sY?>uhT0k$2D+VJ3e)b*ihL9#-j)8:wS%avG7&JODk,iZ.C8WfS'#[*Zr#EB)4#:_l'v@D:Z-*W8f3GF%lL[2E.3_F6lL,j4j)qw$A,Boq-4C;8)>$/+?8rZrb*)iJ+kK:@`,4v-D6[56X$HZ*91cebr/5####p>J9v^U*T#Tsn%#EE)a-x*NJ4jeDu76tG,*RSGv5DxnU/Ut;8.T=)?#A*]Q0CQ>q/le*6&p8Emf7?SX%h/,x$d&m<.A,&g`vCXd;;Co9&+'/4<wX+XV8Vuu#7BrA#S7@i.$?$(#rI-]/^q[s$'LA8%V0f;-jvhL.I@+w$UK`.&vG+G4th'WIXSr(?#A/)*IOWa*e`A2+@TF+5;R]s$s?o8%hIa$'8>[=HM.Jr%2HNQ+M9;i%hM[+&&l@xG9n$IM6iYV-V4Xk4?X:hL&m6V%v03@0adLaMEak%=DAqB#PYL7#WKb&#H:n(<HPduSu_4I)>:GI)AMaJYAwL+*D.Y)4KNg@#%/)Zu:muN'X>oG*L87HD3*c&Y`^0'%5v&0M-EkxFiAxbi`S2;?qiMcs*w6N:Eu8mAj7X_$lgqR#mR?(#A6;E4w0`.3:u]K%OO'$-Jtr?#.0ihL'iV:8wpP,*jRcdM7a,w-Q90/1ACSa-3IR<*:CS@#5*lQ&6H+<QDX*9%]+)O'G/`W+eRQ=ZC>n?ZdN>L1uFh3.=G]a-$_SfLIP7:R[52o&tCr92*/uB(%3Dk'@qq-4[A2n&VpET[Y_D&dn=jR#*6i$#ej9'#Oi&f)[wfr%#IL,3eigH4?.Xb3<:`d*C4*9.p,Ja'#Li#5@r;3T/[2E4E:Iv#sV9/'%2_?#-l.[u9gRA%6ODuPbNZs.k=R<$L#^p&N;;$#SkE<-XH-M(;lo40&&>uu8dhR#U3.j4]2),)g*s;-xFLp$a@sfU'LaA&I#j<HdxBB#B(Nm/g)BI$-4'E&b0T;HT4Z;%mxHH*,5R]4#@Y0tg-cX?B7v,*0Zc8/ZF%D2Pg4',+PkA#5KEf-Z5JVM1,,OO>>HJ.HvS=u9)7T%SYNY5s0br?06OlS#)H`,Sg'u$ax;9/[<+J*)v8+4,EU]=DC(a4C]x#%A3GG28BAvPm[;tHuulS/?@e)4'K8f3c/h#6urGA#SG5s-:XP,MU6:a#'sUv-aY?C#?2'J3,_we-D+s0XjrOv6pb5c*Wkns$@_E9%M'x<$4S(v#5q2w$.p%?5+>IcV+/sP09Su/(<4[S%qd?.MI>+t&n7)R<aZ=p%Cb<9%j`7-)WdlN'_Y`W%ruM,)eGZr%Fwsp%=Xap%<F<T%dF+gL5OJ<$$>`JUF9:WHKc0<1]dB(MdWDZ%NZ1nW(C+C&^nN<$f#-n&;FwS%?U<T%_)MO'x9u,Mc3:U%qx8;-C$dZ%vYhx=T0,7/w^v)4jOx1KrjXTU2u7C#x)Qv$,R7x,0h_F*7_?v$Zj<j1ml<<^-$&],SlQ=.>U^:/bZ5T%*UXp%WKt6)+F_A5BfhS8=(wo%`IW5&TGr4'NDOi(QVA7Arb(/:4fsh1Kn?1,a*pm&-XHh,QHM2O9H/A,5[hA57^PA#u*o,*HjC0((nBe*Y$*w&o&qD3_%U/)E6wv$S>aA+S``C=pwa/2P?DP8URD(=H&WEe@(7]6f=)^O1=Ms-u6258'afBf+c>wg-J):8dXrT.fHEH#rCnR8,S`WBYQ49%7bnJVoLR[-J096/nv%?A::2]OTtHt&nQ(,)U]W]+2&h&ZK7t'4kF?lL'_:)Nr-.i&:O1XVtxG9M'GSq&'7C$BXH,i#LY5da<G?`aeI9@%$P$##PF587Sdpi''`>W-moq_&wsB:%l%+K1o0`.3J:=V/;J#=-.*k-$84l(4NKk-$g-+0NnH@$&tFe)&P>tx%rIwqL7`'&?d<dlAZYc2(C<kw01(W4^vlDGsMu?X1%-PoL[Io31#BOM3)<G##;j6o#_,7$:qjQ>6,(AQ/j*'u$ohj=..Xxx]sSGA#S)ZA#IXdi9QSYF%;k,V/#esxFC_39%jTF+5`RUA4*[r%,7^4N)8JWO'l./J1V5do/wPqPM:5S<Ckf69%&.am/?`(0ML5:w-[oTkLE)UbEW`O8&pj70C>$###$5T;-(B?A1^)V$#Pe[%#k^''#SbZ#).O^:/9/TF4-.1u]4;I&4BPf_4Y?B-*P?L-)W`6%b?/$4(j*N`+f1TN8H>'32gZ+C&Zx;B#nPDZuF3rB#-c%[u`RwJV,a)*MB]Mf<`T-=./.`r.C1l'#-9VG#^&###A$(,)`j]2&uCdY#p[+KLl[fJL7G,##K+TgL>gI.M($TfLY``pLX[c,Mi;LZ-J./9.C(-uub<'pAwtEH*ab7`ajEv9DAt.OV?%RXNV.lo7-K(:DNV.R3PhOR3x5U/:t&A73]@kRWH>uu#Fo:Q8_JQ8)&GJL(PawiLn2PL'h'^TVI:j9.$&5>#)+L'#2I/2'P<KD3<F;w^^i###x`TU'76w,*0_PcM<cQ409WgQ&hFB:%^AV?#YsC0(&lQJV]tlhL8M_fD0J;C&J&jA#s;R&#&@R+P#7ggN.G$##1rC$#ibYLMB,io.jK]W-<*B+I]70CA;2gZ,@0k<CQ2>>#n4=&#_,>>#aSjX%uc``3Hi^F*U'D.3(e*G4']R_#Wp#H5oBF4:wN3T@Y=Us-+6R(s^@BJ)^i+%,s9,sIa.O**^p_g(b2D0(xn#k%eN4A#LJq#,BKIX)L&+7KeCkE*,]U;$$W/%,$S'Q$D1b=?MZ,3'AtSm&;ZG>>]9[d)c3Um&U#$p/ptm5/RRKQ&jqw#1A7xUd58H`aNO$##ppGj0YZTC,A]DD3Q.i?#j&:6/,87<.Ral>>2%.2h%f+^%Y9J9.^KsEQ'M@[AJVhs-SlC:8/^=U:jftOBmL2#lYU1,'%*qm0k#2mQdhd--=>Q0DfraZ-p:?OC$KF&#*%3W-9qsBI:5L.XFKAg:`1e['%c7%-=FDNCg,PJ*/p^I*,(*9%mC9:%NC[s$V8Qp%oSW^+;]-+%s2Eu/rQq-M^dhsLkSU:%$(k7M$P&+M*dTE%G>$K):cr63jR/R3cd$+%S^@v$KA_/)OBne-b`'=%$,Guu:dqR#)XL7#(=oT%K)V:%r;Tv-W$<8._C587JU'v5&r/l'[@bQ'EH$K%NbIw#1xWm&KEbA#v&S;QhYtR0i+Eo&g0,h([`dm&+xr5&t6YgLPo-<-OqeY/hcZ(#i$),#]%@:(e/G:.SrU%6tO4w(q]B.*D.Y)4i<dPKC)Zm:whN2KlMe2LdD24'0m:p.mr8l'M[m'&`^rp/D:eI2:7)hN`aX`<6i%pA@iGk4XCZ_5imO,O[@2K*xPIL2>?)Y(f>H9iJ&5uu(w?584*xO1gB%##6@*Q/`4n8%M'LK2H?Tv-EB3=(8iZx6]j%N<qh0g,=E%J3@GXI)?]d8/ZktD#DfWF3nn=`##cjT%nFm++:(V;$B$BQ&[dgq%,0,x#.c4`41h^m&%WVc@k$CU@A]W*(.^_-2:`&X%eX#G*>[E9%;Q,6&wWR9.dLw8%NK#n&bevP/)=Jj0#66;%i5K?J].oZpA;w5J:;ugLS9ec*^dgm&Je39%CDD6&*j8>,5Vnx4KSae)^Ias-9<4r7A:Tv-;rP2CCulG*OsFwn<e(e3UDjc)DpSi)6gE.3/111L]kuN'0xQh:I(SN'dWrP0hVnH)HNXX'e=bn*eppZGE]<9%v1[S%%@D?#Vc_<-Nk%0:e<Eb.Sad6oalt;.moQN'3pe8/3b@_/q3n0#X,###D'hlAH562't5>G2p7A(4WQJm'A%Y$I,sq`3SU0@1Yk[s$=pF:.+SNT/6Jub$DF,gLbETF4#lDrA9J#7&7A`q%TS.9CLT':1]Hm$(M9[DK/ICv%p:sw$,qXT%t7gB+>j'm9*jn<8]%JC#]&R-3w1]Y-?/d$0q_d-N<niR#xb''#9(V$#BJpU@9:Hv$%)%X$H2QA#g5A718hkD#/&Ui)>W`qMwa)*4C]<+3.pFU)f?($-%@'E#bOTfLpoV@,li0gGVb6lL_Mr9/vd&+Ep,97;LGVO'FafV4D4&[u+>3V7GbwX-EY+i(;OL]5FGc>#;RDw,.r:T.I0HL2<(DT.;we&,m9wx-ZQiFM_<<T'H66.4B:)D+5$11;I<i>,:Z'Z-p8_Y$/AN5&^wef1H:/218Jc>#D@MZ#%nD)+%K:>$D0t9%:eA2'F]<[$%1^j0<d_7#Z7p*#ucp_,JJb;%JX7W-0pxa[o4A-dUiSBf1((hLR1XF3hm1P-n9Y[$P(lo7a>m;%3c+7*7iZx6't;B%4J-%)/g9/Ds$[e#b5dT%)`@[#<h&q%vwaT/:wTQ&oFXj0(Vk87bC?e4>c_C,afmA#k1WO'L9Bq%M,+@,3Sv?GpHmv8]WQoTGn&m&exP2(kf4w$9QL`5xu>Z#Cp]x$?U82',PDjT1kr^+)h6p0<+AE+[i=b73+ugLhv)j9nBCW-9rC$#[?O&#*PEb3sJ))3c9fw#cx#J*$_Aj0END.369WT'MaV0,^'.%,A,K7,V5OL)wShpL)`><-4EL-%FWv.L_jm'vTg=A#[p(c`,SSfLQp^L4%,Y:vRiqR#>CP##e?$)*)NsI39T[RA).9k1pC,c4&R:a#]nJr8/bOg1m?`[,Ln)Ct@Fj^SKRMZuo70U%>exi'tbQ*533kq.NDSL(DOXv.*$9A&'ULhL@/M6&N`8b*#gX`>d]I-)`^K:%9_,31;7Sw#&8Yuu%$9YAaTj$#dd0'#e3@r'GWsl%1lh8.L.OF3;X^:/K`)T/?2'J3.q]s$o%8+0u=D?#x/t3;.@cr/b&w/1JB*-*OY@p&>r1v#+&q<$5::T7wouM&2,97;OI?;-$)^:/0C-d*`b_@,Jeh).D9/^FGG%a+-,HI3PW[i9;`G]F=T6d)>iC%6wU(gLA&sm$s]B.*YND.3*f-gD+Im;%UQnRAqwcG*j`#H3OK5cOAR6UTW0,V/WtUhLvUkD#TUnRAa[Gq;sQLnu<?VO'H1a6&Y^R<?[2vn&ER-n&;0=ZM>a/#0(t[LM>VV-%tj^u$^^^u$1xo*%U+PI)MI;@&<cRN'<s/U'qlYN#.ShlLtk#4%)<-$>j>[mM:n(-MFp+HrZTK_8lH/<--7ix$;JM]=VP>F5/rZ1M/LvHKplLZ@HkPY/H=g#565l-$m%12UrhW?-9Iw=.qrR<,ebBp]YJx.#vBm]%n9GJ(dnho.mT%###ELV(nkiU8msHZ$TMrB#uK;T@w99jEriE.3e(KE-^/JX)lQbFL$.81(cWx[um]sfL%%?;-mUxt%ZTXp%COvAOpPcA#2c6W-N*;QUwKw.Q4ME>.$,>>#j2c2LIZ',2NeEp.-/%E37npTV+:k=.TW)*4SMYS.ADg+4A;#s-'6shLhndLMOJLK*:AG;-?R#U2C4$h)A<(I2FkbT%Yo0N2FpxS8Asvo)C70m*`d@+*BDqTR0N$r<1p^w#aBjv#)``a<uwKTRf14,M,W@`abf2*+t)^f1pvm+D<:Qv$VAkg3QQv)4-t@C%I_B(4TMrB#VE_x$'T(T.jBFA#Ib@6/:;R/2NLdF>Nr0B#6.qT7@gpa4PGHq%EA`v>2X?C#U^]ML;qRT.tjuN'B,/;MOTs5gnEY/_9w6w%qC`p%q-H+<eAFm'heI+<cN5H3>)V:%rT[I-^ZIj%FNXp7O65d3.&oi+*ICJ)`f+%,Sh+n%eooLt]*<?#GIRX)avBs.>g59%+x64O#$:lO*H5=-bUQF+O9O<-AL8jM.Gs''CF)V7BtQ_#Z.pu,0@,2Bc3EM0Sn+sg%+cI)ik$],4d,b<27Z;%w*[,MUNXV.S`V&lN$Ii$eana$DgQ)*_E5dNGg'9%>kd;%7LVX-dK1UTHs0<.W2eD*W7&a+PWe;%9P5W-#LP3r*8WFMKiDxL5V/%#N#(a4-7*<-ptCH-riWm*#PRT.Uq@.*'TwqM'O0(/Bqjp%<7unNDr1kXbUc#$ueYM9/0&dsDgM`N+V-V;(X`bR+UgU/ZN:]7g86N'Efk/Mok>u[6S.OOl'x8%YMQQ'7?3?$CaH)*g]QlOoI$##XZN5Auw'B#lgH7ABbd;%r3F(8RUhTN9a:j0<TZ`*,h=onE[bc)i3]=-N+'h(NFm*NO?6)M%@VhL+QOD)0EXq7pXL'#$)>>#jc8E#kaNw99@;jVjvLu(u>ROX.S*dNW3n0#TalV7ARp8B,Unn(QJO,bXIZY#vJg82kD>&#<a-e%A&JD*^IcI):2Cv-DrU%6+>Q0N7CfC#iTJ[#*[r%,PSc0:'7l`QsZtaa8XUB#4[8E#iA/[u[&'K2+LugLHr((,7^4N)5GMO#ogrC;sC$_#fXL7#[?O&#[vko(<%.W-Y#BqDJEf;-<mq&4PF[p%co,>#ta49%r-lW6]:w@bf?VRUIEl`u)P49%DY29/^$Xp%dPVk'DU:o[3E/eQr/F==*KF&#^YsA#SHuG-+m,N=q2/H#1hLARfU_R+wOk.)Mg,pAF)PJVXa_>-vQOp.%&>uuUCI?pt4%S<pMqx=#6`R<fn0L5VX@I$;cI9<]NVZAg2#&#fYiU%-r4Z>:FTv-`Ye`*L>Q?P9qwq$Vr,%,+w(6&Q'XT%ctwAMbf`t-A5VhL9[CJ)nMOW'voQN'5j)^Qp#Ep*3uugLdJ&r%FZBGR@CcA#??uhPTG[eY?bDX-H#P0QjwK&##+d;%j?EE%?M-W-N8^Y&QI$##0Zc8/m[x_#k+W)<4Wc8/k'ZR*U)u;-c?S>--C7Q/Crdo/V(&q/=JI&,fR,W-$*qt(>Ar$'b_.NM@5SCs%]kA#tW5W-(:Ze-e6fe$mJ<;RQ;UW-Lts$'^Wd`*YMba*1/@Q/YtgfQ=ck._`)*ZQKI:;$of9dMB`E<@^%_>$3VmDE72)H*bTHe<ekjj1G^LG)]=HLMwfhM#d;+.)3?4ZMTW^L$@I@<$1h'?$@1r;$wJOUDqmDs^-U?C+&^E9%YnrM0LVY8.pDZA40BVBnmrcw0JESP/#@]s$ZZ*G4C?mEOFO.W$ffew$fhq8.#_G<1];P/(IK$>%i'/N0*SKV-A;KV-=%%20w#;o08%FF3hv08%u/75^L?v>QjkUC(*8E/%BEwcMTp]M-<YX9rDL$)#r6wK#=)V$#,WH(#`,>>#0k'u$^]?<.m`(W-b&6'Zn%lO%UUlB#Xw%?A4JCX@wLRb%=epa32sk-$h;8B->H<x/Jg4',h&1QMeoUkL1M6TOQSna3q-fu-v*[LMk76L-/YlS.g_/E#i%Tt;F@>=7qneu>K:H]F&]+DNV(e+Vl1eeOK9AG;Aj,K)T-xe*9>0EWWs%sZ9Z:@-?F0v.Tr=V-0Ga1+f,#]udO+g$NNpSROg7o[/f@1,uS7p&GmNh#wKnBA/&o]u5j=A#qOiT(4g4&>#T3KU$O<;$A]H%b=PZ%bX-]f1Z1*;?TOU[,)2rh1o83oA1Q[_#8#wA4&_D.3m&p8%mFc/M&q*Q/f?ng)^0Xn/h#,J*E%B(49S,<-uTtr.6(j3&>tNh#[brF(u@D>7^(Lu6*q10(vgEu-qf@l'Ko'W-sW-J2veH<.g3A<.be(t6bFT_4b>hZ-bX7<.c%jP0CDlY#S_`mLl_XL%LXAe(83[,*j>J+'sXkE*UN#n&vIb'$f%GBOu[V/:#@pa#6agW$rtRO9,FG'$IGeB4#:oO93[lB$%2Puu[-Zr#@$Q3#mABjC@55d3$hX?eP;$^=:MGH3LR(f)2Pw_:vlXPT>Vc[$sK/?#]/)ZupluN'iL=:&?/$FYBJ(@MW;4/MOQF&#wYs[tj)%)NH)UP&jNai0OLvP/u$:C4a?T:%YV)w$a,v5/a&ID*v_tcMKu;9/B]@m/*.qX6j)K.$?<P)3atep%X@x;Qi:Jt%AWW#&'HAcNR1_KMbiTm(`2Afhfsf*%68Fq&05qDNp`ub%l,PT%*Bdp%g7KgLDer=-#p5X$)b`S79VAA+S_$##e+h.*cK0#$Ynn8%hu+G4QPd'&EJ(d3^d%gL&E6N')?WL)1uSfLx-RdN/k8G3VXlJ2k<O=$>sq+,aO3TIv_Sq)ss3`%YNW&FN`cY#7o1k'dw=40pgiB>_Q>n&.Po#>7;QmSeS?;%6U6L,mu9B%j`ja*q74hLXl;d%[^8xtAj0p%R`mi'Zg>A4QtfM';1TV6:]d8/O(Ec`:e4Ea+_QG*hn)8&YVo*'#/b1Bc]sA+8XBN1pQCp0$&###BaO8%#oW]4nYJO(>j(:%.Amd$/w(B=>Wxi)o&[)48(]%-Jtr?#,NtM&rHjm/vh=:&f-grLX_VaOiR@66]82o&7d4D%>-]u-U.0vLZ*]S%ooOX(lfFPRMbdgL^7#w5RcBK-xs(64guC`aBLgr6ccp(<83LG)=Fn8%e^/I$ro=Z,/S3x$j+]]4`LTfL#(B.*=?a<%9C[x6uU>c4?>jt(m(lO%'/v;-h;7#%O:6h,_pC4'jFt+3Y/nD*5>'32u_^'+Mej/1WXc@5#aH;%Zx+C+@h*R/gUIq%ZS<E*pY2Gs@WjD#Jc&X%5)f-)8:*T%c9&30gK$1261?,*x%6N0QE5-2U8^;Q9]1v#]f&b*qt0j(^sE/2llXs%>^iUM-)[]47qQ(#&2P:v;'W>#R:FD*<@,87_tu,*c3FW-'KL_&PS<+3[<+J*/Tk;--.x1*Tq]:/lD$X.0d(T/(b?a$96.)*pEFG291k31T'*O1euiW%BPZO0TfAX%Lw/<RH&BP%/cc.:97Ep.Ag'9%ib^-6IlssLbe(HM;nhS05e_cjnKS:.'w&9%fF.K)w3P,Mf2D:%=WZ`*`k*5Jd/020Tb$##>R(f)ffS>,c:RT%nH:a#$p%&4nGUv-7SW]$WP[]4`fJ>%%XXJ8KKds.Hk%0:h_:w,%rp+*C=;@,`v_,)bEjv#>?xa5+eur/*u*^7Ne:J)Snj5&S996&-Dao&bV%l'vrI-)R^=?-s+aq/23$A0=ESB5wX15/%&>uu'Dt$MPL5&#+kP]4:ALH'=tuX?TebkO38OI)K-kT%,/CHMf[^vLw[q@633iS05hoT%Y%vW-8bWF%)okA#7Ab7/4.%##cq0hL7C8#Mefd##ZE=VH#mB#$gkr;-8Fp^$c=g>2[x):8W2'6AEuLQ'2PRN'jHg01O-e<&J1)Zu8^P3'q<9C-r5Dx.Y*vu,8N2fF&B^4&j,qZS+nV@,E%o-dAE/(OH[@C#opFc%ex[]4Z*Mi%L)ZA#pXfC#-njp%h*<I$vHt9%BXw<$n/Yp%jGi9.Wfn_-n-PT8&>'i<[M`#R#Y>;-fdgp.B8%<$kC-U;`8h'&%V9&G'H:c$3uQD%IZNx'OJJ'#%&>uu<4>>#bvdk@n*@#6YqXR-1T@ORJks.Lrn-#(tHb20qF24#Rke%#gp&='>>Cv-X7Yd3lp-lD#^Ps.V8xb46o1JQ,slIU_e`W'@OJM'^<Q_'^3jm<mfnlP;'dgLYl'0MXD7+3J(nm<g####$&>uu&b/E#],JnLDsq_,vgIq$O.,Q'Z)YA#.Oof1p:gF4>04W-D9n--+V65/??-I2=4Tq)xU(gLQ?CV%i%?87bj]s$lhF`#di`o&JPee2Xw7@#7CN5&Rvb#-<d#<.(JOM(Ptl)4hb?U7Ln+',D$Rg)h(@w-^Vn-)'a&1V*+H_+Qdk:.dbR<$2r-s$,d-I2%5so&+4iw,llNI)0l_;$1VVQ&R<]I*?Qi?BMfAL(H[8m&&cG29U8p^fB5o^fh'hlAP.QT&`-%##ddbV$XEW@,IUvLMWBo8%&p._'ff%&4;JjD#;n$gLE7_F*V[J['VSTw<rTF+5v,`v>lvN4Bxk<(5wJ69%0o#68@rlx%@Ver/R;e1Mk^w$&UmXpBDN%1,G=^v-We't/]%EW-(dWC$4f=M23>###u]x9vhcaL#fYt&#oPUV$O7%s$Q0lNDcV8f32Pr_,J<Ie-Gj6XL[^o;-IFO0(@CJH*q%K+*p(5$g)wk#'V^pm&`@)+%`Qhr/3sCY$RjMqM0jHeOI)Lx$>>.;%0c&1(^rA'+VLSuc[?cDO31IlL*-R_'$1mC+FZ]Eelco2LXup<%Z,uB,N7QP/Hu.d<FR=6'NO$##J'KIE^^Gs.$,C9;WU$lL(DGA#lJZP3&+(f):3d('NL&T.ETAZu-5`T.>P+q&be6#5/h=A#+,K=u.+CJ)aZ=01t*6K)6v-n&UJ5s-+MJfLJLQuu9dqR#xb''#FPj)#h_fgO)f@C#bTIg)PxRR&SGg+4cU*X$hHff1tU>c4:jE.3RB%f3.8/Rh`S-C#AZET%Ypom/lJQR&+VRD&()V>$fQKu$R-9q%PAeh(4X?>649/&,<IC;&:7Lh$WN'P#Tqvc$J6X]#e/2g(dOhasSQ^6&$h5Y%Ir6s$Y)mn&Ngh,)MW7_+W4#2(`DqdOW_6##:d-o#;WL7#W>gkLud0`$vaGj'p;Tv-0&V]=Ko$@'G7[=7IOtu5T##H3agabNcn_+tf@P5(FJLs$[,Q7&.r=u%a6<@&k+j[$-i5@/$S]@-D[$H*usf@#mA=4:$.9='vu2%$f/HO*@`pkLMVjO'F(,jBiwnV8N+GwLOH=u-*pL['aw`ik<0:ZHo3DMk+ug3%t%LpNUpl/(S.xTCK99U%xVcF%<:/W-@g%x'As?nMHMZF%.>@MNfL3G<d-$Z$P9t;-9Y,g&)^PIXCp7FQT<A3%S.xu^f8::%_h.aNULqv-5$1sQ8]]i$N$ccI=B1Sa8H'<-0`rU%VeW,*m`D-%xR/&Sa7ll(UW'Wf<C:58h11BIM[ax-HlvP/lAqB#9;A(4J&;g:B22H*lYWI)VBbT.Y+]]4';*u.%Kc8/umpHOc4x5'%f5m8'Xl^$c74Q';[Dr&NYLV.9*ja4G40]$k,-a3,W^9.tp-@-P,LlPNg;A+wOk.)R+_h5tLgg2ri,n/q2$*3ORFD#M%)$-lIe8%]Nf8%@k[U/=W.N:rA/F#qkMm8-?D)b&Zu(3?t9WHR7UKG]eB(4PDRv$lf/+*iCw_F1aF?K-V<P*66Oh#gIXr.jA1F*(<9I$>CT'=#W4l9j2l?Kfh1Dfkuoc2AM%lEl@j6Ep,97;`S39/E-KjM+xmXlK^)dExn;R*qRZbHg,&:/W####.Sl##A_fX#']>f=nwLS.Kv'W-$sk.#0mK8%iT)U0EjX?6AQ>s-F;d]MWjg_MF*vhLFcAGM[*pwu@$8P#(g^C-u]r]$,2%#>Zb0^#YV#<-Qcn]-t`*&Bd7_5D`?W$#aUOE=X[1?[FMGf*>:p)3-5^+4FE#w-[5MG)7TID*X>buPtX2u7*^K41V5do/o>c8%KQM`$rYND>?s2uL+'*aK;b9jC.)[dD>Dq<146A=%Kc,d$]f7T&oFtV&`o+B]j>3vQK?j&HSjsn8pWjv6XN(02fW/_S+oRr88#vcE%GPS.f^5c*k,h-%4x3m&TwHDEmPjmfMc*T@DR%a+o5Tb*fAc#P&<]S%3^3%tGv1L.m^hr&s@F&#tV_20rchR#(*V$##p6xG:%qU@%8Z,*Bj`MjGU]x*A*8b*r+J30UT)n&=2-6SS9g*%oqV[&+TJiX`?W$#P@aZQ%F-j'WsOA#x%AA4[RUa4c+L/CFvxc3f%>R^g2R8%A(iI$v5E,DdEB:%>ols-'0E#PL4gf189$C/GHxB/76>p%EB]'/0M/A$T`hJ)oV<Z%]9u=c,lFS7+i?8%8ekD#n2n`*aq<9.K;gF4`D_K)V+-J*+2pb4/J-W-kFWcYBZN$6t(V:%b6Aj0X/1^#juK?,*mkh)PN#r%b:AM1U%<C,2%/aa;+.W$Kqj5&EF+T%W7bqIWrFZ,upgD3urqi'(uC0(_-pR/JZH3'ffN:0s5+-*;uRn&'H2H)Xn1?#1%I8%JP/7AUigj(QNX=$vc9t_H?cY>i,=^,91)mLB@(u$[UUP84Jcd38:8C#g7+gLMZI:7k_eLi;'MhLnX;<fQ+;mQP4`8%+]n`&/o&H)-Gp;-[,]u-j1xfLv^2DfCt<X$#m(Q&/M'u$c2s&-v&*SA8K-Z$C>o^.B4vr-ZTu4'g2<'K`Tjd$0Phn%OeSn&*ILR*IvkWQ4);rAXT4ZeK7ET/`7%s$RJ))3f4%Bn`k#/C:Fw2(`f+%,P5B&O3<2?['ihs*x3Jt-<n/V8MWaJ2cHST0NAMP-/-Y`3$&>uuHkAE#_pA*#v9L+*v;Tv-(0Vx$R385/gU&6/stC.32x]fLA9<HEUXC_&&7&s$a]B.*[EH`,n1pb4Eobu%ng*#-hMY[,P>wd)jEhhLGgR,*e3=`+/GP>#R,nd)UMb5(gj(?#tAt8R3Z`qM23-`G3)H8/r];o&*[/w#$cb?%eu[H)df+Z,pI0`$2u_v#auL;$(Oos$u.BF*W/mr%$)N4']GYCF,AYD4eLZ,3kh^Hk1IXD#3`HW-vj4t_2]&X_uv+vGJ@Rm0Lv@+4Fls20qu-n&ih3n&&--n&Xt)d4*px>,m<i`+Vd#R&9Agu&[FDE%R:LHD8K7@%'4Vd4Iht5&ia_,)FB53'QU;mL(LkQ3/8###wfS=ueATM0&_ho7#)H`,:@i?#:EQ+#G?lD#Fc7C#[<+J*RJ))3GQR12%kRP/gI+][JD^I*R4r?#?9c#H4D_s-f;.O1H@]Y.Z8Z;%3%xv$W]i8&<n)78i#+.D&@a;$)9KVQ%61q%44>S1dNAG;Jjg_,^ICs-NdLK(kC5Z,`H:g23=Au-+]'p7p.#d3bSW<.aaD.3+$lk02Z11.k?.dD3Qx3MJA*]H_$V3XU[9U)r%>/M?`jD#YdTW$Vp2'4Eb9VS5T>^=*4oL$MEl(-P_g''Ts940;uSm&YBW?#Z$Zn&+i<S9qsKj's0wV$/)u;-KX@U.xBoJ1;o8gL?iAwuut'J#+qYlLp-B.*FAt0P<tv*N8E`hLm+<d*`[`a*oqQs67GU%6x1v]#xK(E#BuFPA/tj`<#W@<?gt/n&V2HlL3PcaER7/n&cgT8%w2kv#.C'm&u#pS%,09t$Gw7p&?T0I$fC/n&)Q5W-?s0I$K$Pm&_$Pw.jMg##ka/<-9?;E/)Q?(#]tH)OZ4Bj0_DOJ-IfG<-0n<f-H+2hPwj'u$R;nW%<29f3dplm@)BXdVwW-s&Ngma3pI@W$Gche7Z)7t;fuH<.D1SKu0tf8%`N2p/'B4O1a0r,'vLPLj(RUv-tWaB/)&>uutE;mLlOC*#ohc+#7*]-#7->>#b;Tc$#@A8%2`h;-KgGsHPn2E,3aCD3T$bBSE>QF%@EXs-Z45jL2(.x62$<8.H<SP/DM[v$FF&>.6Elc2$=CU)sGY=73V.n&Y_F5&=%si0g[3N0d+/n&gtHs&IdDhLfr^S0XjS'FoBx/1]/5CFlZbg1D?1,),-CoIgd+t$)G(v#KZR%%pD2v#6o1v#9Kxp&+;G>#F/U&=Yre+MZ1F-&k($.$0P+q&+af)=;)DZ>#HpV-f2;U)^m&G4Mh_LLxsKQ&q[]jK^7la*J;KJ-Kn?a$%4wK#J6i$#P$(,)XmU'Fb%O(l'Jw['<N)H&hEl;dT&o5&?),?#s:MZuApw6/cRWN'Q(-tL]@$##(&>uu9]%>/jpB'#*wL>Ra.(:@eC'(.4LXD#lkV=-j].e%;`3W7slXZP9N.BRg4e=PK-kT%ZR`e$%=4C&%9DRWO#pXuqDG`a/pdc)gfFH<vp%##fn$c*)uns-wH7lLX;(f)L2B.*e&rk'4dx;'`/]/&+a'o8uNN/2T87^$nisXIc62H*56=W[-G#g&#5u;-b1SfLB_YW6ukjp%fw[p%)=E0VMJa&+)x1j9OS/'+5w'%6hOxT&6hP2(TDBmA?`KB%j?=g$[M`j7S#DO'B[`t:/gbA>LA,U;uQpQ&8]uY#?pCKC+4n0#x?S/)FjPW-u-iOBO*$Z$H%W2(oM-pAb6e0mBWJGNUJI1gC_39%*fogY/Xmuu4?W5%%Jho.8c`-%VQEq'0x/ji7q<n%0I/VUM7O#(cDg;-USZL-_a3U-J9woDn;Nq-g#BI$Mf68%A^ixuV.)cu$RSv7<7V@GT3rjtqqSn3wUkA#.-3#&%+1Inf.F,kvlNR'c5t%l-@6&G,ZsA#M7v*(RRmGnY#pXu`bYo[9utu,@@KV6ws%##2cXd=*hV@,w_@q.vf%&4_Hq6*thi?#0o&02cu+G4NKO]FRCZ;%@idX-m4Pia^LJw>EH:;&mJlq.V@%[#KB5n&0Cg9&#+P2(WjPn&oW3K(_%Ua*[._^4Cdmd2U1^,3Z7.s$Q<4X$r%oV6,UZV@kxKp&sl(jr1[_%OFa8%#'b?T-&;sP-^-RZ,E@L+*MS'L&3=Es-1QiBQ[iF#-fjG&,J=NU.Y:HT%+6^+%(&gf`W-Ucs9RRp7=-R#67fMR8qN,qrT####&&>uu=:G>#H*V$#I5S^HJW`H,mfMG)@0D.3jpB:%jtn8%,UD<%`5qB#klOjLd8lD##IuD#SP,G4S,m]#]kuN'ZO;I$7qUJ)bDVO'HLeA#-Dh/)=tS2'Ek3t$/j#[-g.*4:d_e8%+0e4(_MnH)l+Jl'V`VxfE7iN&M1/i$t.`oIPHs8.'5JL(JB540l]DO'd%O2(akGn$Bf#r'H3h]$U.Slb6L%##_+m;-SCk/%pi0M)JV6eZGlR_#Ku.T.S%V%6$b+g.vI>Z,u1K;-)Ru[$'Bic)#lt(NN%DP-`/7i.HxcY#<N2Y2'oF2(DEuJ(m9,%$8wMd*W67^2BUwS%tg`)+dp3m'07L`N1AW+Mw:_6&Wx6M0r$>51=lwm0shQ<_0fq<-A9pQ&19T30sVY959EX:.FZ[(+[oP##*VUV$5I-]tAQ=8%$Ej<=];Gd3(eAj0dF&*&[]d8/7L0T%u)/J3=-]LC/[2E4g2mM'*&`6&>;A$5qgXG2E3BQ&+tbT%IM?`adZms.()c+'cllBS(7gn&]lUK(MY*T@),@lFM'Ra**^_t-:jKNMFa@S)hp10(0t$<&YdPN'CJY3FKLgGE+t3-v-w*Q':6Sh#2MFM(c<,8&(7x+2gCnRC)(cI)axJ+*A6d%RV<]s$'l#U/iE(E#qI[%-sXme>xX/l'?Q@f30d%H)ct&Z$d2B>&ZwN#$&OwQ2r,P,2Prw<$8Ndt(gB,R&C@VDNgQM6;p$v3;xSMf<Q35i*(K[A0Cjk2(*t3@M,[77;XIVS%:qV]+#N1SnR@b`*JuBs-g<7f3+g^I*W$5N'dL0+*X5V:%O#a]+fv7<Sp?$V%>ERb4#bHT%t)6m:e/kY9*j-Z#[wc7ACh^s(X.5Z,q8lL:uAAt%^[ho.hEmO(/0FBI=YdFYKeov$l&2K18S@`anxrILE9q''rkNh#nQ*iCkS$C#060J'3HSl%O9^m&&GhK2C_39%th%%#jqk)Qi(N7#RoA*#cA(u$]pZE0lLbI)&Y@C#c%mZeK1*T/#Zc8/i?85/Q-Tv-dTsl%&g%&40dfF4STCD3.gB.*]jhc)I?B%#NwE:.n3CG)^EvW6dSv7&l<;r&M:4r/;5k.)Yw'_4eG24'([)4+mM7:)r#/8'f]uj@HS4C'-q[A,1QZT/&]n0'&c'a42XO?6-2Jh(7+lw5tHiIMrob$67C)78GqM@IU)C&=OwfG3'#rX1QIVv#PNXA#X?lD#ER)`HtkX'K`Tjd$MsY7Cnm9D&28m<-a9t(&CFs5C#Kib=/Mq2:HZ%12S(i5%Z8Q_&X'Z@RQLQ>#O$@vT8tL+*?7%s$GI;8.d.<9/w?uD#qSID*OP*5A0mrH*iW8x,R+h.*[_6q7<D(a4#1]T%2N0+*KG>c4&iQw#%*es&dH9)Pd1G;-*%q'+o]J'+m,,F%aY?pIq&?K(6:ov$kNQf)avZ3DFU&W$wYam1&7Hs6UI@w#`-gm&Q5s>liRXM(c6i)+eNS[#u4u;-_crS&fq`[#Tmm12EZBe4'b>S/^nxi1qlD'#crl;-6`=g$o2B.*s-ji0/XkD#>BNZ6CE(E#VsRa*9S[p.e&rk'-s$hcl4D.3N;gF4&fvc$eQ?WCbP/x$F4vLM9%0$5?&d$'SQFI$S0aB%JjFW$q;n&b1s@^.ee&m&J1DT._^QE3PX`X-DJvb%0a77:.8###%&>uu_s,tL+NJ(#/sgo.Zk[s$u?o8%6MU8.^?+u-&E,eZ7)B+4eqR3O'w@+48a[D*?qwX-pNRF4gG+jLRU(&=P[S79kL`p%2]ep0b'd2(K&oiLq/=',Kh1a48His/Xt(?#vfJo'R?0U%uiS.*SX3T%N*e,*e%Wa+g6sd*3c1p.$0f2LQ5Tq)dej5&A,kW%?/-e4w%Ii$&Jho.N<]:p$FDH*RN1)3xE[F4?U^:/:5Rv$]-tX$B[e<$HweP/DxXI)kHL,3Bic]%2j4L#UEg6&LU.@#,JW=K%DVB#F'-F#[&Mk'@^4R*cXkO'H6p6&;>DM']]2X$D*#N'Fvm7&cl&'+=/a'4?hNp%:Fns$wT)P(kPM=-%(IM061%wuL/sW#^GqhLHbcf*U0AgL=3)*%j:>jj*a:)3^uu`%?A#c4)w@+4-E$9.?VYV-t-YD#5WVa*^db#'17OSnhh*SnX&QN'c7fX%_+DY7JhuW.E(2w&C9s5(eWn0#pt<X$*<J>#HSkReS?9U%;d1l-X+(1#)vNI)15YY#xbLP/,Y8GMu,^f1b'UvGYb@W$`B&s$jCXI)^#:u$BKc8/j@u)4QV>c41m+c4I5ZA#6n'u$-s4c4lT<AF0=F4o)_w@)^=gB+ni`#5O/EA+SHPJ(#%8@#sMZ7&)EwRVT9#g-tEMs-9GHT%93Z7&mJcvGI$O9%nEIh(kx%l'8x/HsVkar.VW+;1cA'g-Yg/I$?l&/LfQf'&Pc^l8,K7JCr>4J*GY/)*nFre$ECuM(4R6I2()MT/a=.s$n&Cu$PNXA#QukW3P'I:7R_<9/@50J3:afF4Tn@X-?89w$)>WD#t`DD37CEs-QNNjL:L7mShvbT%]$`K&H.)Zuo?jl&W@1hL2rZZGR6OT%ARw8%J-TQ&Mkws$Npqg(1nq-M'/73'g)_Q&Ap@a'E[R[u`X=w50rq;$OL3p%hVjfLjdE>5XP;s%G699/rg`B8Ve'B#o15hL+5[M0k79+*G[ns$`F4gLR*lp%LN#R&PdY3'8]sfL;F89.v$TN'Pod6&l1@W$t73s%:$Uf%D[)AFg:o?nbIg-#O%(,)YQ&e'22ww'D+sp.oi&f)rB'`=5m,K)A]drH7B[m0j_p>,.1m<-n2T>-vP:W$nN[U7dD24'AG#W-nUZe$wmfe$QLAq%nZ&Fcv/(a)N8C3($t;mf/x34']QdA#:ZZ>-^Il%l%>/U;D)2fUK8:W-EAH(&cX^;)IgcpL-BC2#(LMW%9DH%bu:#s-03k%=[RjZ6mU.>>/H&##neg@%P0FW-tVj5E6'D4+9_B7Jlf#%f4^oA,RhaQ&`NS^O[AOl]O1ah$Nda=&(<IxEX7,d35uY<-6I.a*Wt`dMK49p&X[V?#hluN'f(ED#99`w09_ae$4KJI-Iolu&feDSO`QViLe<>GMj]xK#@Oc##_qbf(L28^$QUcI)f(YO%Eff`*R[AW-vAeHFSV5Z0EjX?6kE9QAavl3'%H^e$t$(-)Y8`oC4whr?ejrP0,l<n/.aDL'rJ,$G$m.T%Zf/6Ad5qq%0bx##(DluuW-Zr#$`V4#R'+&#)WH(#Cb5A4od=<-^@1p$;Q:u$`S6C#ZktD#vt@T%VQ,G4pxJ+*hWTM'5P[]4CIFg1,I_Y,<RIw#:hW&7&&rI;Yb3.+nCV,+lciO'f$+T%1am<29Vgb*qMUu$E,jI)Ha*L)fw$],E3oh(G&%r%fXpb*x/;?/8LZ(+6^ATAISF[$[u*M(<C??,#fLd4]Uh<-(pqY$Vu<8&?fg'+7G3^4#&k^4+;=M(LZ^/HgrV7#'R-iLx7),)*N57%0gt?#*e75/wHeF4*eHd)T$Y%$1awip$h[d'5pp#*5$;M(?qhtaqv0XV@ZXs$IN@l'C&SHDY-8='JT@b*.n>b#lk7Yuw?CC8#lhl/*&>uuW4>>#/EvT1ld0'#(?$(#8pm(#O/l=A6S]F-C=(D.x<7f3[(a5/(0Z&4?Dt/M@9.$$``Ca4nE'Y$D^jD#Gm%1Cjt9RDgd'R)m[C1Cdv#O*#89sCWq(@>wJ,W-Z$&+%,_$/&vNT7&DBHa3D0h)3v4a1++SN1+]6/W$-Q,cE,In59[<I60V`K._+FnqT7fiQ9,u''##mS=ump%_]*i##,[x->>Qt+M;MrY,*FBxCmJ[=j16HSP/ZI(eZV7#`44,p/3PS+o$$,h.*B.i?#O$/F.7MbI)_2qB#^s'hl;)C9r9)TF4QNNjLXNTN*O>gq%EGjg(-v-n&f'Zu%E[9t%PhZ(%ad+'&i6kt$bZ=9%-J8.,;v`g(L3bP&Px1w#g79&(9^NoAE2Bu&EI0H)^$-7&rRqs-NJ&I&KSM(=39'n/npg#.SN7d),@g,;4#Tq'`Bxs$gx=?,.r%-+Yj/BFL&3&+ZljA+7/Co0-?cT%<f`Q&9%BQ&[vc01OB0u$1>cuu$8YY#Q*[0#FVs)#*n@-#mp@.*,x>m03^(l-C+Tq^JopcNaMOZ6^H'>.sw>L/xx[]4x(dlLDZYA#BauS/Pf_l/7m7Z5F%8&4&5*T%xGSF4nGUv-[YWI)*>ND#&iv8%6C3p%qre-)q(J-)X##+%3Fc**I17s$n%f;6kRl_+L9N*.#SiZukh,##dG.P'Y>l@5C'0Q&U(1s-e$8@#N^[h(bYR1(nIs9)p65/(SmGr%Fvfe*6lJ-)x*?h>nr24'_GnI2ulWa*ln9n'+C36/](o*3/K7L(.O1v#^_-X--K*R1#5'F*9oUv#&&###d(N9)0r7(#I]&*#=sgo.IR@p7;eYD4tr4a*OuC<-$AYk2'Z#t$7MN=(-tx>*2O_Xq5KA&,,kJj0j,24'$xPR&ptdYuT<+.)1PwC#Ub<5&cc>w#qL3=(@<]8.L9r/)/XDI0_@9K2bPQ>>$8E'oNE8a+taJV/FV<Z8F/96]YNo^fJ^8xtjvUcMki(,2T$t,*kiic)AJdp.o]d8/CtSI$LY)C&gS))3pM.)*V5+KMIqYF#nh(k'->=p%Ixmp%3@Fx'S<G(-AH0E<[URs$Oc:s$K*EAFH6Gj'O`im&M5xW&:1gX%%<Ld2g:os?]=2W'_wH,$J^XVHO+O9@Y11hPmrbK&r2w%+F7$##b1e8.;JjD#Ktt20YAOZ6rKdG*1/2(&9N9@Mbi/F68SBj_wp))3#X'+%F?Bs1LH]X->:@m/O@ul0ZQXn2iod/:Io;Q/guC`a5Ljl&^b-5/[;t+;sg%##i5``3NsC:%^wn8%#q<c4&p;F3&+/T.)$fF4IJ.^0HYMT/Zc7C#dI+gL)Oj?#a^D.3JU@lL5R(E4iSp.*D.Y)4^FP.)=MiR^/l-s$X8)o&bK`C$]qjT%WwZqNtQGT%6aJ>,E+Mv#VR.s$x02@,lK>N'ZJ'Q(,K?7&>p[@%f]<9%<D[m0i_nL(U@Tl'ROx[>e>mj'3AG>#TiP%&8x`C&j2KU.'e#R&-co_4X0X6/:mxM)e%Ns%u=%6&ZugYu0N%@#Ppe,MLNj$#S>c^?c0-w-laA7/GMrB#*=Z;%1Rmv$?l0x5V0q4.]<7.M<n'E#VF;8.M$C40(e-)*L*+p%'*Ke$wU[[#S'o8%VNF5&m)w`*>Q-d)`(89&Ob)v#+1i_?s&k%vYJ`-,c[np%o:2SA:R5#YOUDw&O`mp%0*%<$bx6&%(KgppaKj$#(qC>RYQ^C4EoLm'RUO*e:sj;%NY:xMn%e12M.OF0rCw8%vC-p.)tf*%7pR;6T_^v-NB==$]Yfoq[:d6%&4^E#+f<t$lU+C&W6EW-FP5W-;kj']tt)W-&H[KWZ?a$#PThd/bIcI)55%&4j_)<-`-O;(e7?1MqD/[#FN)E3HAj`#58lF'i=#_+/vS*%$X?S'R)9<6H@B)=/VuY#SppY$Kaun&j2mn&_?M_+uYvI%ZdwI-[)0c&JG/n-YiqV$O2l8%kFa`#_7g'+#@a..sW6iL$ei'#]6E:.2Y7%-/C-Q8j%3w$vu/+*,&qI*4,xh%1Ds.LbBj;-5dmM&VL.',$E.JVokh,D.+Wm/#F6kO4(+H2]pgQ/>g4',W;A9GNHUJDG_:p/Oo9W&hECG)&B^f1-tmKPB9x;--3<b$qNv)4[_Wu7P@Qg)q6_=%+@-_#g@AC#U5%&4)v`Kc9jGg)kR2.NWE]s$(]S,MWLE[(jOY_+MXG&8hSvKD$aoH-<DV>$W,***Gflo.>Klu>%6(kbb^mK%Ra:0(R9p2'Dm.Z&K'v]u:AGx>e=n=.2Q$k*rXN6/t>$(#>uN<82''&$m-mm'1aoA,uwWD#iG=c4*vZ]40Y<9/7%vW-Ox-+%9fSU)KGnU%Em5X$&--n&x5?j'pPWa*c;ZR&TX39%Hqgu$n%ES&$w830;Ol9)S(#lN[I-T.BZfT.s?LV&b)[d)0@bT%bsh,)$4g*%(L9+,V6Fp%OD(F8/5d&QXkm##_]U:88#+WS?Bi-MhOh9(2nE)4pnv;-;NwB&>(pd,(#`6&0AUHM69DV&p/7#%hj/^dMFnG(B=x:/XPYQ'@EDV&,S'58Zq@E+H?[i9>hIveN]<^4GQR126BP)3H7Gm'^q$x,J^D.3%WE.3qV>1MiFq0M0oke)34q_.FW+?-VaOZ-d#Te$(Yv`4_MO[5X#dY#w[Q>#=JuY#jZnY#kM1v#_Gc>#[-*JM5PLwMa>')Oq,AK)S7w[#MxTS.>EwQ1<rG>#iS(Z#AsM@$l]3[9,?,+%B#3:)O8h%0KGY##Ifo-&n^_c)`IPV-*(=fOFr)9/*A#c*Bfap.o/*E*#lx<(ueNT/>w?['SNZ)378n:77_Op<rTF+5]-RU7B_bRMsuMaMDkp0%BMr$'4Nf*.O?hnh&tU[0P####+P(vu;`fX#(;3jLs%gF4oAic)j::8.rWdd3LC.q$'p2T%X5^+4v.<9/650j(,<;@8''9bQ?W3Y&$hGM;6+jR;`sp1TUs$d)`oPaG`NKe>%JgM'WEOX$wwxM;2p7@7Wk:g(I[_(#$,Y:v:FY>#TT@%#q2f.*<4i?#%)Qd$X*:C4'cvP/5&3D#(K=]#7XG7&aC<<-$..<$'xmX'FSCc`IUVZu:fnW$hirQ&Vmso.0;#>u%*H;%,JB_#HF]:d-Eo._*/R]4A/-K)FG+jL*r'E#:#K+*&6An$IQPm/wHeF4W9%J3J6fs:ewUNtSW3`sd+-v8?eAQ&vJ_)3TZIh%MctI3$HFWQNKB:%iKH6DjK^U%7q10(m7sW%SFQP/mj0>%'Hbw6iI`dE8gYI3N*49%$a*9%T.I+`hspD3'luN'8bqiL&>?>#Vt7F%cJtjtC%-_(eH,^Gb]hXQQN@m0XtLfup5Aj/bha;%2feGV@iW>-f:r8*iBpj*9=E<-Xngk&:_e7(Q?vhLiT5;-F>q;-IulW-'U,sg96V-Mwm_>?t>?NWc[@`a?=XA[Ep3b$ce%<Ag(nQ%@#juLgF&VQrEqA#F8r5/*Z+CA%17,;I(d<.+m/DE%ro,3/oSfLrc./&9IT]A0IXD#)%QmAiAM3rK^=Z-#N^F.Golw9GnsW-JffRJF+V>9Ng7o[k^%d<_;xc<(cbA#.]O]u=P]vML_`=-gSx>-i>ieMZ)%^$<P*=(He_k+tUHJVq-4:*G####T4$M3slu&#;5UO3ko8f3UOi8.+dfF4,7$`4.4OCM^oUv-&saI)#c*D#r>l(5jtdfC?8Hb%VTsD+rd?['^1[b%ZR72L7*8T&ZPahLNN[U7?MHX19pG,*5-17`D-K.EP,E<%TbCE4NC8V8fd>w-jUKF*@GUv-%Vw<(kAshLG+=+3D;mL:iua?Q:Upa#:nc**UC4j1H`,<-TkYhL2`?,E_5GpoqG6N';ED-M%Q_:%EEWt(^X9L5#p=s6<G?`aY+pu,$B#,2DX,87sg%##X4K+*^s-)*>%Cp7]5XG4`l487@cmk0X;jI3DsGA#BXkD#PT/<7*(0l'[puM0`NXA#pY?C#Gi4a*3w[gLj+CB#2O.;%shj6Jq*Mg><E(:%7VAc3Kjsa*.Bfe*.,Wg(Vv:K(^_;I$r&DK(p-Kg1W,FE+C_39%E,IN'n1RqLQNC:%6d7_>:rU90Tkw8%A7ua*?V^$9?lJt%'CU-M1?rHMf+q'+mLBk=3wfU+(;n]-L&5[9F####<I+8&?eEM0r[=kkE/`:%jVU7/K]Ps-?r>lL+FLF*,r@8%,D:<7JOQ1MxrV<%(o9Dfw#wGBZ&^t-7/H-;7%(W/Zf$H+w5nx.1e4a,wV#6/,o41<5B$w$gGMC*@rSA4TOoQ09ia%$`WF78'0cd;p%oh('>5d3I0n(57sC$#;j6o#e)Pv*R2aT%hGOcDpi2JLJ5l1T%WNo[uqgt6hbK+*]1h8.Fe75/J/gb4BvdI2<4'Y(R@iEmg4C%6qh(:[Ws%sZ[96US6U7m86CO<&g&(Q&6GgY&Ej3'%6W=v#bPQ$$a(M^)t=<r7s8lD#x)oh2oUD39Ss#?$;xR>.;T:2'S0]S%%D*T%Il_gc0`sb&^*gcN*ciS*^u@g1]4>>#xZu##uVH(#@@5Q:m)OWS&C>,M_XA@>dLWZ66E8p.K'J49=ACW-6gE.3Duo,3%i:8.K)'J3_`0i).F2$&%aYp%8G74')[k-$rq@@#b;)4'eZ5,))f4GM1m&pAB(vYuQ_FgL<qC`7kTLL2_Sq8I/u+XVdD24'-hC80Ya]x,N/X61_hn6/&iLN'.aO,Ml:6>#H2wZ^@L3)<HT)<%rgai0[$IwKvuPaQq(Jd)U78C#N;##^[qZ1M7:B.*L'(,)F%@hGU-xK:qp1P:U'7*.^:?mL5BGG2Rv4G-n+of$SS9A?U],[&;`^ZR29iHMa4$##`o?q2<qt.LQJ<A+&Zu(3V&Xf:W:=5i;IXD#9&uG3ZP`<L=mW%?V.tY-UhlS//0*:2h2Cv-3mDF3fVQN'%rm10t5_6&N+@20D+n0'5N1n&mZ&+%i*^%'0xF]u89ED#f/)Zu=5OY-U6p6&QKPN').$as8$kT%/AK;-N'vd26O&n/2>uu#Ylc=lW3v7[>'aQjq-2wg9grk'xx:9/*[X,2al+c4%iw[#G?+W-sQVO+[HVO+u[x_#v/Cs-Q+ceu)naQ&Qd:v>#nO]4t'Tu.w9cn*mg&J7xvjVn[)qM'VHG2CAin6/kqiF5t?P)MuT2E4<sOn*>g;B4:]qs-sddJ;Ap.n$mahR#H*V$#r>$(#]UG+#3dS%8L>gG3/Gf?(l4,t?hM0/-@75dPetDe$D7G;)p<&[ursCp.Q]Z5/ncGJ$b1xx'VP>V)L=/CMPxSfL@V@`aq)(pAh#eA#l,R]ug[KC-Zm5<-fu;=-g)[2MOh`V$E8p,MI4$##fGRh%D6#,2>^Fp`uH#Sh,Pjc)nSID*&V'f)>V%u.XO=j1pC,c4G=<u-qVkL)]2W)[&F<)/KPk.)teTL(>+wo%xLKWh690U%]]<**64o2LwS`/Y^(Vo2f]I-)d,dR&#;*U8NlY>#=i(v#Y5Sq2salj'oo82/)PXM(J>DQ/PYL7#[?O&#PD2`&_+oG2x3YD#w:H>#XmgM's3vr-3V3Nl9;_&&f2uu'0,gXu$>Aq)JFL*sGhDJ:?V+u%ZTXp%dDI-)oXV]=R9DC+@GA6'QkML338eA4>^c8.`LU8.Q2ud3+g^I*ZK(E#f,8U/G<Tv-q?`[,sq-x6_V@#%J2X+$MB0m&9e]2'v9@9.dY-W.O7.w#?DY>#N)rg(GF1t6[B7908<0@##,;mQR%rP$Pu0s--Gc>#?Oes$k%8m0E`L;$QlqV$3+nS%=1r;$t(I98rw`$#sL'^#`j#30NuJ*#mp@.*RgZ9MIq[P/X<TXUc=(&?q/v,*Yo%&4M%$]%`d8x,Gtn8%(00W-U5hQa0G`,DdB]@#gYgu:P,'F*lKfN0>jD+=Dn8@#wrdN'EUrV$)G6,EAgxkE0uBX%L[<9%cK,m:TxA5=+DAL(tgJ@#Q1iB78(Gj':4P@5Xd52*q:npIDu(v#kI?b>],kI,>nSm&pEEm/hCg^uO^C/)@bL/):/5##8nhD3Eh1$#0^*87Ht[s$(]2Q/oRS(#n[Is-`/e`*Q-`B4)ooZKb)]'5c$_xX'jB:'boV<%gh_tMQ>ud;UXq--o?;&5x4blAOM5I-PEEe-P-$+%;FG&#._m_#9JQ%b<G?`ac?&/1r>4J*/BI^$q:7`,o1pb4eAgkLj26N'5pS(%krn>%;(qL?:BXY7)=G3'JejP&W6r(Eh.W?>cWqm&v7[S%%9TR/c9vi(W@FZ#7VfY8@qjp%#:TE#MSF.)BiB*$3'$r%elWE*ZB2&5>wRu07Mu$MPBd&#AJa)#n$),#;cd8/>Zc8/<@i8.M[,<.SrU%6Q$';%_J>-3#VYV-Hpa.3=uL5/'cXF3D]OjL,BW.31QqD3DU$C#F3002L0jd*%T?3'40]p&NX-U709t2(=cOo7_7@L,`h>6'm#T[uY57=-s.;[Gm@sV7@D58.4vq=Q<J[&,B0GQM*mcA#<*mN'KG)9/HC;T.%5YY#xbLP/QYr.LMDW]+5s`j0.QB%6'(^L(_d8x,<A%d4-@XA#1e4n&R#-n&8-$&49)rr?R&<)$usK]799Jp&*cOk+VM9S$PM6[Dkg_V$n4n0#QmS=uZEiV-C^XS%YC18.N>V.*=@[s$I'8M)55%&44`%`,V.K+*a1f,;(&MT/BP,G4aT>/(A_sl&l%o,VHU2#ld,>8LUc?h$]E>2;pY?v#]m;Q&)`5^=goRgUV`M#le=J/LoLCj'T_H>#LniGPAONT%annJ)gaR<?Uu],3#WpBFGwEbH&[.q$C)ZA#/R[I-^vgs$XYJ-)Z8Z;%puUG%v6D<-]9v7&]^$n&@Lvm8tZ-N:ksC0(%:;a*5#*6/TN49%85cgL1nkp%*:dgLl9339saHj:mN4&#tUB#$+=h'#<qt.LAE(,)@%$##FS^c$oEZd3E?e7_M(rv-(,Bf36s.)*kor.LOCNl<H8G)3O-97;Y`*@4vV=i2]Ct.L'DKrLTlW:MOQ?'v93ou-fuZu76p__A_QevK8m>lMTUT_-uRF[BJDluu*FH_#&,[0#B8E)#kbY+#9:6]1a_QP/g<7f39O]s$WOHdba6'>.*W8f3I>WD#4tFA#P:-6U<bB]$57=<%2p0F.tNil8oY8<7e(f)*Hh%o8%5Z;%/[GT%o%%],]d#&4g(%,;VM+:0Grr2')tD61$Rah3H%kf2M09Q&<PZp%4p]=%'V0T7F+@1*9eAl0]R@o/D@xN'j,cp%heP'c*(+V.&]],32t96&]u6s$FI@w#goG>#H4Rc;ZpBnL#QG(5Ml@`&Zt7I40>3H2Lt/Q&JNl/(TD/s6g@&3K]Y+-*8/?(+T`6,2n2P^IQ`cqACV1Z-ut.nLnRGgLQx7h*85`'#l4^l8#HYd3V29G;]^x2r<Wa'%OmAaNKR&v$ue.g:%TO&#Kf#o$&UL,3j_i=-3'$[$t^X=$F9@C#2muN'OQ>n&jwU<-38U[Mk.J-)KAre29htgu<<+.),2IC#Vi*.)dj]e$/1hHMJ=PS7@)b=&G8%k'H&OsB+OL/)l?17*vw=j1MP._uLb/v.lNx5)sBh*7:<.&G.rO&#lumi$xYr.LY[HP/CEvWStJCu$HsYCCW-9k1SiWI)2P,G4gb4TS3NIlf.+CJ)a6We$g^jY66rr;$Rs;&+IS5d=XK_G)=8'v66oi;$x=&:)NsCf+@n<=$XrQq2'-Dg%o;=G*B7qb*NZ0#$wVq`3g$C]$c;&^+16@T*#?UQ/#&*)#;C]:/oR]d;oRT(.L?)a'n4=a3'K+P(eiQes*_j%&k/Yp%r1g45(JIQ/<DKa<r/VN'PGF'GlQ49%uvwX-(0^p%jl+pS/[h0,bGgK2a,xbioo`6&$`ew'd`tG*]mXp%vsP93'nAE#mXH(#Jsgo.YIK,3:%HM9Xl1T/'>P/MU'lj1iX?x6[lLA=$1g,3c?XA#OQRv$7_qU@$;XZ6*YDB#f(.x*&-IT%?hR=-`SoNg/1:f)Vkf2'nL^<&[-r,D:u(?#nxH%'hl;@$AVS/.q[FgL5FXn-ofLC&ImnH-icIl'IQb>-tfr0(v;lA#dcdR&M(v>#Mq10(IhEp%s%IR&x6^vL0W49%<4sFO%rJfLHC6##Erawp3qw&qI4vr-1-Tv-`M.)*JOoX[xLYv0)9#k0.?X)Y#tLk.M9.n&6]UsJK1$##U([5/fXL7#&V`mL0JPA#f<na$_f)T/WEP6WGkRP/xIj/%;)TF43h;E4muEj$0uB^H<raX%$'PA#FXg_4V)ZA#YS2h'OdQN'vEsf4RD&2L'p-;%Ewgw'm7Lw652mT%)534'bKx;Q3Ew8'$QCU%.4A+IX51sHsUlQ'UdPN'Sl=m'eeDMMNx6w-IK?Z$3pM-)='Rm1MH&$Pg%o5'S&b^#U>c]@jW`dao1%)3>(OY5m'=kb<+^>>D>cB][385/=W8f3[C[x6.WAc$_Z^qBfi.H)<)II/Dql12JL?lLb`+c4DEJN/nQDI3<*ihL72<q-k`-F%-pAc4M1qK,s3&[ufITr.i6X5&c,AU7D0-;%niIP'n%+**DBjN9d[lY%9quS-xw.]0iai$%99%l1:[NT%^%OI);:.[#d5:u$]_GX6K_?C+L];X.cbuY%)i]5'3j$e2X4.W$M65N'XFhs-3p3.))lfP'b$[#0:feO-Yk@v#Eh/Q&Ja5V%N57L(S;%l'cL4gLFOvu#$HGT.n0;,#aHxn$5@*Q/2ffZp*U/[#GXvM94tUNtx4-J*J.oN:KsQ#6_igO9kZ(a4wkxZ$a+Nq2B1B]$0&vT.s=7<.xI6M&/M0+*58G^4P[J1;0%Cf3gPJ-)KVG>#FJKY&l?_1;JGX03i5D0(>2RN'dXw793n778C_39%I?e)*3hOK1GL7G=BNX4SiYh&=p?j20*SN/2G<At#0XFT%6]q5%jOC.*mu%m0NiTh3Ga',;$*og)K2Ke*G6`E4x0G4:@T$H)_996&-Y<s%J$Xp%21'X%f]V8&@M+mfx`Do&6B(:8HEV,33V`2'Y1%O=*s^=-$(nY#;1)rTg97##Ve##,2(GS7ggN^,Sg'u$*W8f3it_F*a2n`*L%fm/sfd8/+gB.*@PqwMA+=+3H0$$.Vf-]-^u*O4:MlxFuoY>hR9OZ%FcC(,W4Qd67JHI4t'Tu.5gu$,%[s6/qh(%,d224'O>[tHLldo/-g5',kL7<$b8[-)2Z'Z-m5-;%?lv&M3w2E44h#nAdEFT%lnD<'Atoc2CJ###$&5uu^>tY#(*52'+F?']H1^=%&Y@C#'BshLcxV[,vl1T/&Cs?#HF#<.kK(E#A(hA4X]OS7dBC0%L$EHA=GjG)r34?$ZwLiLB*)i2&+O=$(Ck>$4J.EFT,HS/[IiD1OCuf_R+op%k4HgD?Qlp%q=46&0f$%/<55',T$p&G;8'?-;1UV-Q=#B#_@Gms:`7C#Jva.3@/H9%WwM;7;E-n&S&bjL3HfT.ap8]Iu90:8pHCE#kLlX&x0vhL:6)V&5v4)>1+Vk+ht7hGG/5##(7$C#%,[0#[9F&#tYTC,lHI/2LL1S'*T&J3:=h@%wN4#'DvY'=FiK<0Vi[<.:VIs$_t`q;0BL$'087W$'e0Q0R#TWIE>)S(Ll?%b`6;(#%)###Z<D;-v'pu5gB%##9[:4.*pXjLkRU%6.bL+*e/ob46B@^$)J+gLE,@U6.DH5/61[s$[rL;$S4iK*D@E5&Yi(?#UtDv#Vp5X$.UMT'/8op0#AE/2M#.-)j`rk'MIIW$#Y)Z#u$`<hW?=2L[+?g2hpk&-,C`3,of^I*Prh)5/lk%(,ha<-rwjZ%;Ut&,*76$,6PafLP;(*<'PGd=fdB(M1oQ+#4;iK-g/1h$Ie75/Qf3BG=a3x@Jq#`4:N.)*+D]C4b=+2h>f:#P`A_G3%&+I)Y5mr%diIL(r*%[^%Q3I)eu+?,WD71(LEBH+q^Q-0Z30#.?M+I)iFqLMFL4T%.doF-DO`t-J-E78#OdftsVP&#&tboLmV(F,aF;<-7]nS^:SR8^I%NT/j4X/%<Dn;%`J5H3?DXI)/#2J+i8;KECaWD+'X<u-oLR[-'jnd)cr4)>5L6/,ECo)P$>/H)NfR.2xdf=-AE,D6?*&29TO`)+rtJfLd0+g$:4MD(>9=<-oHl[$iEq;.LLTfLoo/499aWj1D7ww-PO,M84(LB#?xs5&V1VU8B-KK2GI3T%XJMkL,FOl]&Uqk+?G(<78[*^,K`mg)qT,j'>54JM4l@`a5pg8%U+MU8c$Kg2G1VZu<-Fs-`.6&OxDJ#6Z:r?#OK$12?XZg)x;)g(14^NkV5>##;j6o#%XL7#<+^*#)h;EG[&l-8RDRw^=$A.*+m.W,Z2+x%+jh`3@dl>6ZO_5UIlZ<.;Hi]uL4(>8O'9g2jY<E#j8S+1>_)d*15_e*<I?,*rp,W74=FB6t8()P(?NgLBV+L#$(U'#:Yhl%,LA8%atr?#rt,]%C.@x61`;Y$g%AA4]<]29v=>^$O^uJ(U*kp%_B>N'nH7]I^3MW/<,ak'X2ZV%;$j39rd2<%0#hs$ZCSn0YTkp%;S.Q0D;.D6dLe,*#l=gL=4w39qpn'la$Xxb.)V`3q5o.*0Zc8/6diCGGLcd3vf%&4io0KMMI:u$c^p#A#x9+*q'=W-X*.eQhlvo/JFw8%,3%iL_4QY%p&Ts$/(XX(/1102HZ%12FqV/>7=fB,Rt@W$p5Ea*8T4C/E9eIMwxZr%0T%?6?]$##%####;@dV#Fk9'##sgo.O7%s$Ut;8.^WQl$vEo8%Q4@E4Di^F*J1F(=2BcD4)][Y1iCrp%2g8b**76$,FwaeHE]@['sH4X$Gs*J-8tVe.x)pn/a)p$M;EGO-D'V=1%&>uu&HbA#*6i$#-fT%%/SK3Dx?Q&%QwM;7Y,f#/ap8]IG/cj2C.xE3wF'''wG,*<;we+>V:hDNm4oiL,nd##Dqbf(>83/%/+6ZIcXE#.TxJoLIt5/(jjm`F&^F&>t4n0#`cT-QtlIfL;AW$#c0;8Aq5h#?-B&##vF?(FTt*B,e0e5/t)rl'+.`B#Ps)9'W_`?#<$`5/13vN'n#GOMOho%[)`>;-gPBX:xcK>?u5)i#FgJ;*w^bm/fXL7#r&U'#8_)s^Tx1g*61Td;3w^>$=:Ha*BnlN0Rp;+3)c2D%:W5^=t7jV7,YO]u_0D8cU7M3&ZTXp%djDC&Cpg3M6NXO<`n)%,`N%b4r6E'ONLntL7l@iLUj?lLp198%agi*'*(]%-3iM/Uqs^R1^5vR&@'HU&^s,n&aCvW-OhYMY'61^0@k4v62b6^#%(IM0'2w.LUh`i0E`Lu7<SY<0B`d8/#?H/;8?kM(0SDT.K)'J3;ps7%o8sv%ZTXp%hA];o9#g1&nB[q$`Fcm1QeWp@eXVs%e`$6M]2.QQRQ$l$3[YfLac@D*$B#,2N-Gm/$rh8.wS0<7sn+@RpvK['xgwVow?A`a>b$B$Q6H1gp(O87&R*l2?EZO2tvIaH)Q$w1`rH[-/H8>#dn=%$op9)3]7TfL8dp=[G5?W-`M+I-?Gr'##%?Z$WRp@Od2o(#G]YQU#`6wHSJu`47PUENqvW/O7t//.__SjKfZi8&8koC&Pg4',s@O]u/]H/U<;IaNOuSe*DZ068tLF&#P,)T.K?O&#g%BG0Z_G)4;3<a4rTsR84m,g)p'Bp.wHeF4Se)I-o9F]uE:,S-.u(%,=2b>5R],>#.+CJ)TNh1BEMqh7jYFJ)1Kx;Q5<a*.[0T$l4A)9Lbs4G-#IGSe$)veuEcIc-J@Jmk&l?+Ue$f4]P'1f)Tt^V[wV#G-inlt&1vjo7mR9ZhWK[hL]f?>#72hCa.9Yxb8c###oNac>qkx=%@p*P(PZg@#o0ff1$l8s$pVq2'fnl]%XF)?#tPq8IoSIw#G1e8%gm26&@WD)'eJt_jlO;R<gk2##.K&/:83LG)13<d*K_Za*/6u5/BS7C#W?BA=$)hI;B3,d3Egp40)<>x6SOr_,p`p*%1CS@#.N>#>.+eT.5Gw8%5`RM1>)L_,MOYdMh38s$/`U;$S:kC4h'j8%M(*n/'QUC#]PmZ$P2@L(#f=GMN3vhLN8r^#jed.N]'Pw$P#o)vw=`'#B+Rq$Z_9m*4XkD#nU.+%d-YD#QG+jL$KXD#W85dM:>.pI9&Hg)>f=%?NY=_/<#;`)b/bf-)34I$>k6IM*=PcMCH^k07,m#Y'kZs&-l%0:&VO]u*#>?-%FTK1#aZaNW8.#O:cRN'gqvU7BJ-_#ZA)4#VTr,#0`wqVYF0sV>d<gLn]oFO_bbn-kLW@G4>@m0_l?nC>Jmk0I48a3dh(D+(P5W-.x.`&DtTX(Sk+`MIRx['0JRN'Vt$HDV@72LNUZcaiv;C&Y,g6OP,8[%7DKn3;Ijw0l3NYJhZj$#crgo.jBFA#LB[+'[7%s$&Drg)%(1;&WG@FMup&;QOC#NBf@J/L>#PgLc(b303W3%tDQV/LbR[k=ct;##IDmi'As3b$Y0Nn8sHl)4')'J3xAWq-cb&`=^t>g)o3))HC:<`)@JKnfEks8.D+A`aTH't-6as0M5l>;-E4bm-*4n0#N8P:vgQ,/LJa#h)pAU`3iHUiBOnjK)QNv)4H;gF4_7ni0Di^F*lYWI)4D&]$EuucMM'qA$4E/l+^T70)@C3X-+2sD-ovEH$.;)u$]4n8%+xq+;VR[Z,DuO<6&X%A,1pZBQ:2O#6h3:U)^_&Q&mt9)Nim:PQ6%Xp%=Da1B*?mV[WBZ9MM,A5+Iv/;MF.Ib%`;R/2'+]S%&k^:/`B2*4'P;?#%Uf**MCpq)r;ed)1n6ENTVY<Q%m^W$&5u;-[OQP/>YZb%=S]*-0nL3()NQfLQ_6##:aqR#fXL7#vR]h;%W,<.co=Z,1(j6Pm`fF4kD.&4r``,2K.rv-Rk:GDSQ^6&lkAr8#PO]u39;t-v%,/MnM6/(JKmD#br10(?T:KEK=g[8:.BI$9<Sp&]wrKM=(Po7D;r(6LN&aN]4X@Z`m7C#fah,)qK.K)?=jA0NAK@6(gAe&<13CTtcr21u@-##Ng4^,Fe)aN:<?>#'m;p/TEW@,Ghi?#=pgg-JFFW/i1c=&t7$r>^$$/L$Wv40UQp6&RBt(6h11u9)f/k$'fCv$gTk$L*S#aks.IcV:+*W-S<9-m[7%s$8Omm0TAOZ6Ir@ddUX61M=OB(4p+[b%fq&d%qe+D#$AD4'jpfs$0;hN&'o0G-.%v$,Rr8s6d;R**1&sh(k=xw#I<,N'W5`O'h)Z98/1LJ)gd;:MDIXJ2QNN/2IucW-)#J0YPpoXuP9F`atesx4VB')3+d'Q'#upwL'gtD#SQ=D<AtY,*aeW<Uf]DD3O4>GM@2N#20/3-)PEkx#uX>J&@kgsL$MEs%OLit-,4>gLgVv/(S53E*L)7'42b?W&CH@T*$BIe)Gsi`'jE^2'&K`t(uVX9[7q7T%i^:0(pj)B(k`tT[N=S%#$&>uu]4>>#K:q'#N2fF4&vUv-M$CRh1=7Q/]Ve]4-@XA#A>a9`]Cr?#7dh-/DH%=-'H0I$1#U^)@JKnfJp[w#gkp/)wW5?,`ham&$QgI$=x`q%&j3E*S-$),f<N39cli4'B$],;ZOe8%1[>7&;E=x#i3.I-^uL=1ZA)4#NPUV$h:AC#S[Y1%2gk,3%&AA4m$Z#>k&B.*+=V@,[81_&A$C9R&wRa+honw#Pn86&P[xP'1WN=&I?2%(@pc9%4=^6&xkfp&x.*0(v#q6&F%vYut-x=H$,P:v><8v#t_W]4A2SY,MdL]$e*TM'Ae-a.-E6C#]i2b29Zkv6S+h.*HfnU/BP,G4O[7:.xHuD#1-[#>pn+D#+m4=$i/aA++%rdi+2%%'hCAp&7l2v#Pau/(q]r8&$-%1(Sw7[#EAE@$vd+=$($U>$V&j#,8BcQ&mleW?&uSNKivo@#dh*(ZQH9q%MGU[-I_Ih5h*Gj'8DpC(j%42(;N5hL>W;;$1T$K1g4h'#4dZ(#,sgo./o>F[UktD#*/6N(WIE:8Tp:G%;nHZ$q2xb4-4hB#^YB#$,?T^)9bbp9KZ3r7[IPF%OoZS%`[dh#,_ra$$WvK(nGdp9eSMG)t7oL(G7Ue$^#A.M&G#W-i]$1#I,>>#n0n(<2G*N1vGW/MRAo'0-K?C#kK(E#C%Ei-nbc1YY62DNubvER^F4N'$C(?%IS6/;.#HW.EEI$,HIY,M3,,^*@$e0PfF[W$rKvr%2pTU.]`^6]*gX589?tM()vgW$,jelA.FZi97pX,3qM8E[bN4,%@Gr20C0(l0wX@C#6ZGve+o[_#mtr?#8b@:.u$:C4]U8r%4/Wm/C`Lv#4u?8%4&CW$f^l>>==rZ#1_VB49f:?#V^0#$jWWZ#WrcY#iH+U%V*p8%H*XP&F+&j0EONT%FY^p7;;alAZw%j0&j=q$(0DJqgLFq&^CwQ&kI%K)1el>>kmweM<cl>#3GAjKc*dkKP0E]Fg>_n'ML$##3mqB#)^B.*Gkqhj1^07/?29f3GK^T.V*fI*sd1g%H(C>,4r0f)nl8Dfo/>Q$5vl,E<wCk'[#QN')Q6N'I&AKqVvbQ/1rT[QjM.c#*RwV'.FXN',80e=F*,_J_WZ`*Q;v;-Sx08i<E`hLT36X$1'LB-PJ+P(mXfC#iTJ[#k[r%,&%>C'UODZuMN,W-NeMX(d.`ZuVTF7,a_v[)77?C+18gV-C44uH'#C#$:*>Q/l&U'#l,>>##[51+#6MG)=#tZS,:#gLP_-lL1ZoA,Suv;-:_Ha$>v8+40]7V?:MII27XgKOB3Ac;RFk+&+eH<6qR[>62]5W-mPfLCf_,W.xPfLC:I(&P,m<u1E-GY>.l0B#PYL7#]I%a4Z#[R`FnqwLRNK*'1i_K-X:G%M5DK)8Fev`4X<Fh*VecTW@ixt%YNbp%?3PT%'6p*%g-ZZ_S9Cs2YH+F7oEUpB#4&v7T83T/2Mo+MU/32%SXnY?IPW,E:`FgLd'Yx%a7e/U(.3-,#e<72l;/3/:DHT%?bN-Zg[$AIi&^%#sDFf*c8eQ/Rq@.*YZ*G49<ED#2`.P'gIF:&e)g#G(V[%'bmPV%/qYIqbgxH;HUI&cJeuN'&O1A4ZWL7#=4i$#xjP]4coTi),VW/22>^Y&>0.b4$sUv-/J*+33QM(G$Vk**M&I)*a+h+>7I6&'N`Gf**2?v#A)/W$M7a'M,-8]IJ_o:/*Zco/,&=#v5m6o#0/]^.bQk&#e9cK.O7%s$*cC-'gX;H3OZ6&44EI#%bDLT.dE/<71DDh$U(W1'rYHN'.%TgLq=i+&ZTXp%pUM/qo+d;-sp[U.dKFq%$#8N1j_8DEoISt%@)b=&(hFJc.8<Y5:.g'&6[QIM8K#01]kb>-s',f%_,###Dj`S7%e85&K8<A+i`Db3MV&E#h_d5/cU1F*F]?`,_(4I)B4r?#HF[W$PuBN'UL./%nfh$'Yqh$%tG)#5:@b&$gfHC#ditIL>68v#,f&]X9I(B#'nRfLn,jn#:WL7#9,>>#9sg9;xAqB#b,$Z6lO5^]/ggU+pI`=Qj>#nA7tZC##/g[uMV&9A4ZP#>/D>;-TAq&Z9h^RJu2Si+3ac-(EB;mQS1QcnRwRt'YWXp%nPXGMft*u$PQCI%w3I)%TW6hG__v%FTJm;%LnaOW:KSV',pnA#-h$BQG5$##MRRb%p8w%+L:1jKqVGBZ-EF:.:fcs-x:]8@)0?v$@+C^447T[-S;V/2/-97;jd^d3W5[O'[S96]7wmC#TK7q-N,mA#)kT1;9QY>-rNXvQ368HMi3Sr#]M;4#.jd(#_O>+#rqXI)]?A8%x&9Z-Gpe$?;6([Ii+O?%=muX$eY^?&fn8`&U=8`&ACYS7^]/B+S5)o&9FU_+RQ'6&7=HQ8rJg+*mugto@qH)*Iuf[83d3%t%K3&GZ7l%los]WnXclj^doNE*ZPd6&uC#=R]%#C+jb2]&]$tP&EQS6Gc$qMKt'V(&q3n0#T/P:vrMc%b^eGP8kN%##MLbn-:#3kD'F5gLF`d8/es+dN4:V9.xx[]4W$%gL=@,-MXr(rAv-=m'jvmi20l)?#829E<=m,T%7F<5&=o'B[nmdNBh*/30@qoi'k;^;-r*pJ2p:qN*dXo/Ld(J9&<PRW$,m8,MXJ;I2,W`0#%sS=uT^^xbAQ=8%9Twa$qSwFu2O_@%;7?QUDkF<%6cYB]@YP'?9G@A4Mt-<8F+Vv/Jg4',lePH2sWvN'nxhG%n]vN'O_2D%#mkv-M_OpLYGdo/UJTK1Dr[o&w3CB+ahCK&o6,'$eG0,.-RZ`*8Pv;-v^[I-@Wm;?u,SI*<E6C#$d(T/op-)*&PkI)tBxT%wm?A4P50J3p&PA#c]jj1<h+D#q[xAJiW8rd996Dfo0m3GuQ%]f4Fi[,B)q8%+O`/:u5;Q&i;Q&4Yhj5&FTY3'FwW5&I6K2'CFE5&PKFA#@QE#.p@iwL7=2Df^J<#.P:fmLh&Pj)F)vl&J3YJ(Jto2'@@R<$j3`b*CLIs$DJ(Z-c17W$duW.)BuH##'&>uud5wK#Dh1$#Qqn%#kPUV$HXX/2=U4I*4<TR/`ni?#6Zmf(dcUW$%$:u$mxZw'cGUv-m#YA#%%ugLop'E#3mWI)m[+T%f%V%6oMg@#SdhV$ZOMW$)fhQ7ebP(+uBrS.@6/E+M5eS%V$;gC+Jc>#K1,a*.NdA4U996&,sUm&@Vk87O%t5$er*I6b)@''^E#n&;)mlLgv9V._A'u$GrIPL,DP>##q2*'^D`4'Tn_b<TZ#R&9Emp%UuIfL^-7##U1vr$O]SY,LK[i9r>4J*@V>c4%:ikL<FrB#HP*SCY6L,36v:9/+&Fm'JQk]#e?T;7psOp.#IIf38aG6q]&;+&J]lY#R0D(+<f/YEf]D^4J'.%,Sui`#[0jv#bG(v#Q,vr%kh+Y%PgB>$QU2t*WX^]$pY`>5wkop,[w86&Jf3f2p*T=l).BT%h(X<Y4Lo1$9=3p%n6SW$sZtl0DF,#YdrQ(#r>J9vh;*L#aAO&#Dc/*#8I?D*k^<c4QuSfLGAhD0^i2T/T#j.3#:(Y(=AbI)iQ+,2cu+G49d0<7R<q_42O?v$:UZ;%D/w5/v?Mk1dx^T7Pa^>$j&vx4G4=D#T+Y;-r?G^$uI@)&?FeW$a:ofLtTu#%C%KQA:6(6&_hZp._IRW$4-N`+CX3T%YmB:%w1ov5Ptaf7cYmZ$/q/&=>-=&@3HV($^t;m/.-;@([%m>#0vTw0U5:[0eVc>#sQ2P4DU3T%OScV1B[Np%N2SA.=Es<%L@@H+AXNp%/l:$#v_B^#3KHb8vr1T/W4ar??4/H</0?PA'Z6De?[$Q8&E0j(0#k5AI*NE,>h`=-u))/V$QK'//[2E46;+.).r=,MG08mg7P,>&0xbA#b,xcMdf=gMfWK_Mp`U[MpGguGdanlTbZCAPTao`=IkG&##w'<-)&>uu<4>>#MB%%#FPj)#wg7-#jkP]40Zc8/Jva.3uca2%?DRv$OxlW-g(t8ThofF4I5^+4xu.&4%[R+N`[4<%&@w;-LYUE5;E6C#[P[]4Dr$],TdbX$b1eLi5v_-2rDLe$5EVO'^'kt'FL_97'9i0(%@QG*T?B6C((]u-&(MhL2mbRMK=6##?<eC#u,D6&9Uap%Aa1oC4G:-.+El?MuRO/2S26F%wjuN'@_He+:A4.)qj3mL]t6,*E^07/P/iT9o?oY-o7qQs:bae$RELX(Y8G>#Fr[=$Q_Ep%E&j]+jJ)2^&CBT.'G:;$:rIuchPKf_A[co7poMfLJ+65/4bL+*?,B.*]::8.Ko/k$p+JA4Z/QA#=Fn8%=2m,*`ni?#r0manHHn;%AOB&Ajx+G4c<w,*4NX$0KLTfL&i?lL[hNT/k+]]4iN+Q/sMYx634p_4tg;E4w]OjLNPgI*iq_F*Y?]s$%ES]%])TF4_YDB#pswY6am1O'S69Q&`]EZ8hBA/1Hw980<Cp)*Od6H)04gT&<Y_V$c+0f)7w=9%hT&r.guwH)]Pw)*V87L(PfQY1D^+@PZN<^Osq?V@6<IM_^&];%2P?W6LtF/(3CC'+'(D%,Vw%W$E1Nq%x%iG5SVj**fCBF*C6#R&A4;?#QDed)QN96&@$ve)UEBU%&-_`3GV-A0?0s#PTHN>Pft&nLIPxH)k`wH)+_AG2#j4:vARl>#QB%%#Ji8*#8GPn4ii,tT_`0<7sYg@#?oP<-P;6X$M4h)4H8qp%Rpo#,>D0#&f2L8,#5)K$e#p*%i'JjMkw+e%mf4W%h&Ow9m,Xw9A2)K$TNbp%/Ii^oW2P:vO6F`ao1%)3#T/DE5,vb<x?rc%e$GX([q&oq)nV@,F=2S([#Wa43#>c4:*YA#+uhP/_<WL)G<7f3a7c;%kkaI-ajRU/IV/)*]hx3'R-dK(Y_[ZT5P4K1SS6$'RHPn&O8A<$$YNmJGmga<fE8x&St4<%PMWa*GU%[#A7NL'XSjp)VtXt($b^:%1ZT^%PG<E*1o-d;;EJX%HrOJ('J]p&W^Yn&q20I$0Wl'&3sj**XNxw#Jhkg('#][#9NVNp?f-mLL)@R&Z.MZ#pDCH2[1xs?[$WmLoIav#cQtoIS*x8%XB<H$6#)9.A$aK(%Ks(#%2Puu2a$o#'e_7#@oA*#swbI)?SEp@d:iT/Fah,)HXX/22U.:.#qVa48mHm/:*YA#*^B.*lb-D%*ZkR8UQ$9.U);u$mk=>%3I$s0@'#3'Bl##upw$%)4^G405d83KDgEk'F,`s-YjnZ?_a3d<KYX.)I:q'+aJ%h(bd:g(,G;S&:LdY%t[OgLSL?JC*wueqd?a%ZxMd)0C*9(Op%p<&;hMH3&Ir#,pCFi(h19'+PoL,+WE_m/)5###N`./Li2%&+lBel/4MR]4%*&##w(ZA#9f@C#3`<9/kjhc)[WR'2PP5c4,lbF3J]d8/_PHVH3w#Z$s%7g::`vZ$R4r?#cJ?C#5i8,MAD4jL64*2M&erH*-V&E#C5?q%JqwrQX[[W$=5^:'gH53'`rS^b95K-)m*kp%NS6%b&DlgLA5aV6+k*w#XcJ^+[D;s%rM@L(/(Jp(p/2$>L'VG)D[*R<s#R^4ertrHWenW$&a>5&^bhW-<80^%?8k(NaA`B#$nP-)Z$m[.Z;;S&9+.f4^WS<$X^0u$ITKu4sG<=6f)`G)@/5##94Wp..uJ*#apZMj@0.b4Trqw6SOr_,.b_F*&:n5/hg'H2#0Tv-Lp:9/+Os?#jUKF*sAL>$o3hfL4d]+4+P6##jXO)3L320,X6FT%6XPoJOb>B$n/B3M#r+>%dG.h(Abx;%5f1v#Pu8)*rFXI)t.O**=@j#$ft(%,[O@8%o<-v?W9^Q&gMiD-<0v#%M@qkL+g1Q&ovBD3V',N'.]Cv#-aZJ(FORs$MeI[#wRV;$7m1P-JUu%2Q6F`a$B#,2hE%##ggQRA9UcF%7'0E4k&B.*&REp72&AI*3+gm0tc(T/x<j?#UJ7@>6i7p]dj,n&YWe@[Uqoe%_Z*%,N)Gw3u'^:/FpUY$#BYX$tc)4'LD23';s[s&3$t-$/Xj;-;weQ-^:2=-$%_-3Xs=A)nWFT%q+f-)A12$#Av;a*Mu<N0IXI%#0pm(#,,(%Ia6H,*PnM&O8B/)ZESPf*&Eba*cO7r7MIO]uts3J-#G,k-L$/[^kem;Q1SK;-Q$B;2:R9KO=/<d*smTZ6SQu/(Xk@f$CsI#$9<G$'4H^RLff0X:mJRl1qCn;%Cx;9/vBo8%BA$vL#u'#,r0P4:Jq7Q53GD#$$hvg))oxc3rsb,%g^2O+vm_au+lGY-3l(?#s.*c<S?=m'T'Xu$Diq;-5_S+%^&>u-1L5l$n77<.5,w*&:H]p79n'B#Xe;SAC`%pAR>Lo%k<cv.>9X=_'J<s%jaNh#tfu,+V7$##CYM2id<w##U3=&#0pm(#`hc+#M#n,Zc`fF46i?X-wds;-7?tYJ#?GA#XOe8.P4vr-9Xo20,%1x5_a5V/>XsDYh>?/(h77%b0>e_#'Nei.ug=A#H*'d'k]88S]T-]ZGY1g_=..s$v>r,)wa>N'E].GV;X1hLR<k=G$aI1gm^A%u'm4eM@hhFXK0kT%`<FT%B`###&,Y:v;1>>#K<r$#Dc/*#bL9+*vkh8.j]d8/NAg+4+gB.*o4^+42ZL&=)HOQ'r?`[,GQYHtdT.Z68@f$lpN#D#Pj<&5-;ga-]l-s$8=nS%/g4',cGc'&_0<Z#uTZg):(Tu..Pk.)q@wAeNEU1;N+XX.2@l(50QT[-I6KQ&?R<p%@lU9`QIqU#?Cns$IkE9%o@nb<NgSa+QM$K'@<_pn@0#0.-<E/Mg7xI-$?;l-7ZUoaaJ))31O*.QTdTU`Nj5v_BAN/2:URI-Nc3+.EgIbO-x:^u)DZO-[dO[&UevfD9dvfD:wbM-N_AN-2#[g.Dke%#h7g,&rDQw-[gG<8-T*<@/[2E4R9VZ%,Vf<?mu5Q8npB'#8&*)#X1g*##=M,#CH4.#dSq/#.`W1#Nk>3#11[s$Fe75/i=8C#qGUv-sZw9.')'J3dvf.*mb7%-Tj'u$)]i8.+va.3J@9v-HhM)NBLk`#,#h;-ERTpS#K/d=J]tk4?93D#d63H)D[w8%jfW.)s1?X7h?v70hVJIM'Rwq$4THN'EP7w>eJSSSTdA,36nDs%Uk3_Oi2aMO-mq@-x:)=-Buc8.Wp,I%acZL)bs>(-'jG]ual/%6Y'CQ&DRM=-pgDE-iwmJ:#>Mb7Qdww'';v`4ej<s%]Ehe$F####wh]g%[d?uBa@Hd$vl$t-KD.EFSYGH3e),J*r?]c;07A#ej>GA#hr.Q/lp10(;P5>#V6Z@-QjuN'0,Q[-PBf&,GwjT%moe,Mcpx<$Xv(4'+rPo$Y8lB,sA4KMYQ]A,<F5</&-nw-':>gL0o9QAoRMN(2d[-)WHO6a7VaT%'u`i0#=FV?.xHs$Fc7C#)W'i)%=2-*=@[s$/W8f3:'PA#OWcH2i.<9/O29f3`@i?#ufm*3WaOZ-p=Wt(<-+mL](o$$.m@d)%cK+*35T;-E2/h<>x@Z5*[7g:jh=0L].Ms$A(%W$uHaD5S:OG2A-5N'1Lqx5S:=`#i5X?MUk8s$N.qo.XP7m0&*Z3DL:gfLB/=&%kf4Ec/[2E4JOhF**=O11lCo@[EHlj'EjAw6eBoY#q;x51JEg6&rJlo/4CnY#TJrB#I5%?8[PM;$oqgb*G=$)4>?f-DT[xh*T+#(+H/j]+L#4H,?;Ss.x-8>G/V%T(7^S_%_H7f3DieA,;N>jD9W&;Q4<wp*-*?q.0-/n&&-CK*YCXlAh*L6$<#U^)3M8g%,NEJ)V@pgLVr?]-o,9eXbfM7#wdx+%vZ'u$d<7f3Kl:p.5IL,3sR$23If@a39OnA,Yt6##^*-12EKIJ)aOih*'V&h1ej0/'[2BiuZe>of&lUkLvMT;MVGqW.2j-n&wbCH-R-%*.jbuc**Uop.2.92#0^.RNOHad*(W>T.9alk0xI5s-)_KIEj(M3Xw$Zs.[jTv-9[A<-;tj9.JeGJ)R)II$lbFg(U7ujL<@?W-P=6k,hU7@#'saQ)qNJ@#t5@m/4MRs$fdSs$G5$<-Bq.>-=t.>-ED-<-/-Y`3uc+:vW1IS#6ki4#hPPA#iHX,2x<h%%9&sc)<wUhLRUX/2-MIe%Zh#Z%+#77C&Y7C#2X+ZGfYL_&QR$v,+NZa=fbLE4[j:9/d/Z%-`(3v6+uME4dHt]#/UZd3h`P)4X(iJbqH4S9i=Xm'$='E#CTFqM3(:BH8Z7.Mt*LR'[KA8%i+h.*`69u$BWf._?$G/(`JHv$@6Gj'IN1,)Le/W$DO[<$h1l;-uNUhLedoW$[Ch2)'nd--R[v>#apb9%ln?t-Lo:Z#:RE9%062T9:oC;$LJ&B+61:dMF+sV$B[wS%v5rt/n_8m&Vd#r%tmlw.E'9m&N;g9;*f'-MBu.s$pcf;%E1v-4JSwW$g).H)P4iZ#64[s$hF7.4Qn[?T6efn/C_39%5^.OXF8j[.OM4gL?x4t$fTp2'g&r,))Xx+/e?jq.mq'L5lWV'8hHTU%:<Hq;e92?$0rq;$'GCp&,'$`-3bNR<)bdT<X,Guu:g-o#L8I8#8,>>#T35N'[iY;f1Mr9/%IuD#AobK)JG4#/bo>r%?aO,iE4Kg2#jJ_0e]#6'w+VT%)h#V%0Co].twGZ%S5YY#9DH%b24a%b4l/;6L]&+*Ynn8%,eAj0VS0<74D.&4L)b.3BV<+3%v.&4;#Q,*I+TgL9G`h1T[IX$Uc4Z5aGUq.a-pi'1Snj'f6.x,sB8/15.i?#Y7+,M*F5gL4H9/1Sx_/)Tln7&,/s#5)BLV%*V''.&&4NpUZg6&biLP0#Oss'qCqY#]gYD#'@U)Nqh8>(p+8^>85_pA9*q3(.),##J;eS#-0c6#A&KV-=PAmGor=c4e9.aN[=g[6Xt[%-[w-##X0H^Q;Jh<&ejFT%:KG9B%Mf<9vk#U&%,MC&)[[T.g'^H8('9bQewDe-@WbQBjXqH#0_#U&5Fh)No$[T.dI>PNa0w##Y?O&#@oA*#R[P_HgVic)a&SF4_Ip8/>WT5SR%:#&?Vd8/'YvD4o`>lLF+7%-5O-29:btA#%C`NV##e.%:2OS7IBr)3fFPj'`xWp%.XPbuv]r%,GH^CMP%_;-C_+a$qx24'qIJfL`7G0&K/NY5J+65/Qj2^1x3vr-kHuD#,7$`4#qoO90(%b4N]B.*'#WF3oXGhYtd5N'<pM5K+S[F4aP>:8tG1[#t2p8%oj>+@4#Vs7/<_^uH2Un&wt;:8rd$u%S<rB#aRI*5<p:v>ApUs7JlcsIN.kN1/LW&Pj_$##51%wuG&cQ#[GX&#V?(;?x;cD4&en=&2mqB#?e_K,d]7)*-27*&?nXD#,G^GJPHc6;%#RTI:@l%5&IOT%o%5?,SD%K%]Nf8%IP5<Qp)Mg>jV1t-5iNh#D[IT.mro#,OGm50UZPK$%^plS]3n0#Q)###p><`sipcc)_7tQN5+Rp7JT(*4X5ZA#kV3a*sX'<-EVQ0bB(N:%q8T@#<thZ,'luN'4,eS&EHoUd9c0'59Yhu&NqK-)N]gu&=%)n&VIa6&QP,nA96a*.k#w('m79+0BvGd.gFYF'mDTC/q4>>#BiZ.M^JSAG.8YD4x?q8/I6*jLUnRf$3:*Q/##0a[4afC%0c%H*lH&iGN8G#?U6O@Ta@5p/g-fYd4*Ih,tNd'#+f68%;L:`sWBRS.#+&32TW(E#G`wv$7QCD37(]%-Gq[s$nEZd3jYo.C#v7V%Ko2:8%eJ>#:&(N2e(/t%;0$6DVek._L@&30&cH>#vgYTBJXHh,w2)^QucE4VYe6##koCG2J3`l8p^%##4I*r$YVd8/*b&a4]c?#6/X<j0J29f3;jE.3jpB:%7<_13G[^C4B4vr-KSY,3@8I?A+`kbbSD(_,P`ZP0RGMP06*K7/HoN/2jwDm/,EsA+6u([,TO^Z+wOk.)Xjh;$3Xl>#1I.A6;bFU%m>5m/[LoQ035R?$OiVP0>pp7/L1Cf)?E)n'<9&A,L>C;.d%GS0xj*H$Jd-d)Hr@QM.a:d%W<AqKUU$lLmCG7%9#-T.@]WF3a5P<'=Q$a3TF.W-A/nqn=@8=%5&JJ)(u,%,=j_-2(hjVN(xSfL&(A%bJBs%,F[clAj:6aN&8(<-b([5/$c>ofG5?4MOxSfL+=CJ)4':<.@]n'GF[G&#1wV@$65qCa=J?`aI,w%+mEel/8_O$.aOLp$pL[%-o'5gLkY0<7H8jhL=6mm'/+x;%RhxC#U/PT%(lXg1NeY<6PT^_&nW^OJY,7)*8d2NT3C*j0BOM<-pI#l1W$E`%vW#C/cD+JMOlk[tYWcn&d''F.[&.KDkh9p&$0bf-=l,.Q^'GJ(iYhG*^NRD#^nr?#?)b.34*R2L6[*#'B(`?#_R]?52Ld?K+j$qLkBa?#^ULJ#aL>-M=qugLe_p$.qHFgLQ^_%O[(Zv,h-:-MlfZx66HSP/Rfh8.*N<fq3Ea/`_Lp1.X^FtC[]`x-D5E[&^p,n&skkA#L$aa-C]Ge-X*$gLfwC_GZdshC[2vR&4ifgLvi?>#f.?xkdY6GV6]###-p#f*M6NB4Qh%i)l'Rn&J[0H)B+&n&PF0$56O_iLDE,h1'Sbq&0,GuurTPF#G[PLMZ1qb*s[gm/?]J,3#1<:..U1@-p7XnLEsJfLrS(%MQ-0%#]S8f3BA^Y,:Cr?#M#ZJE9xoG3x.X'8Y`:v#R#fZ,cU3n&K''$.n'cgL';TSNofB(M0Hv<Mkq4:.Vq'E#V)ZA#lAqB#ulqB#c9$)Q/$FA+s`/L>]kCgL]Q*4#JL3r$Vaf;-kxCE%J@i;-jmfC%7Tp8%TWad*kNOg:VmZC#m+g#Go$[T.)ODT&eQ/A&5Y`_&f2JT*rlLI.c,uq0jVGVHan3B,LI$##?Ro7&h]``3bR(f)KR,x>w4sae4j5j9Sf9(,7&]d3u5+%,`4vN'>6V$%cYNh#OXPbuf]r%,WtWQ)PY29/fI$lL3PoH)RfRs$),bo7?&U^#XYH(#inZN9<]vU7:-aw$X7Yd3Z3f.*vcdC#D`;B%t,1c%HUD78K9mAQJi1e$lc-`a//d%bGa'iLx>>)4caoW-CdX^9:&MJH4eAO3,OHc*Lsps-%eDd*QZas6d<7f3sQtA#d,;mQ_7F#:Uj=vGW'3)%/TEt&413AFYZjJM/g=,Mp2?j'm'4[9&[QWUS=@<.m-mm'JNXA#X?lD#r3lD#C5e6Mb.ilOPg2YR:@-D-O2K(%XZ/i)8@'E#Ze75/<dx6%k<TP=MHssWuZrF=ZQ:a4*hgeEWc;w$5Djc)PJ))3v0+B-AsJF-m`$i$?`/E#NN7%#V,>>#,-Y,27D?W-d^om(@*WJ:%ViR:JhK,3=[%W6jG8f3ffDa,M42R%]W^:%NAIT&u]lB&YthZ,kkQpK:0D3(Q9t9%&ZoX#j.^xXU/;t-qr<gLAaC:%e9dZ,<=/2'3$kG8h`w],Gqc]uACfa*Z876/0C)4#CT+T8G.^G3Sq-<%8rPv,E?H$-%@'E#o(6]6'jN4Bb1U>?VSHx/oMqp%mU/^bJg6l*]H0t-HXYgL2(dv,[hcx5eQ/A&1####%&>uup4>>#qM7%#`hFJ(K)'J37-bD4HXljr;5Cv-C9xe*JvBQ8>.LR'`S[e,7)$9%FI4]u'1v^=JHO]u&)oq.V&q6&v9.eQ[I0H)P5pp&UcgZP3L>;)aH0<-E6lk/qJ6(#iYl]#Rqw8.N>Kf37mX,3u,G0NBMGf*sF%hL:UPf*1nse2txAQ&Oq'H2**IW&Rqi[&=4k_b4emgDaB3D%W^J#GVjt;.%)###+:BW%l`NjMQ02x5u'7]6fM+J-78%I->u/)SL[GOMduBONWsJfLw?,gLu1Rha'_A`a-l68%?3GJ(Wo8>,;NHD*R<*H*'k$H3@.OF3(@*Q/P$8s$Wt'E#4`d5/v5qSC2OCau$$4n<Ye&[Jreci9rYtL#<iBWJI@,@')$s<MpYg%u*85##<vHo#e37:voutNFK,Guu7^hR#(2(D.brgo.RP_8.QvQJ(R30(&)o]L(JH^@#7C:H)T[sm&xbT`$k&Ts$^.WN'cA/$5jbS#G]g5/(tr?j'HjfI_)5Xk=/hFk=3XPfLHQ44%3IIKW/5+Z/k%AA4R&WY5,1nQ'U/ls$jasV$iOTC-Eei62?EI?,HcVN'tR8A$]fVS&*p[&#'):K*clV7#pKOH8H0.O=gc``3?;Rv$1<gS%5J`W-9#L:RInsJ2IVr;]>a7V#x,:g<SQ^6&<V4n0dWDJ)[GMiL$qoZ7#WR&#L5ZI5f5wK#PZI%#YH?D*lK7f3bR(f)QUe8%:k=-tUlB>Z`VYu-YQ&#GDTN2'RN7Y6q40J)[x):8Yai>?`&5u-b`-wboo)*M$M):8B/pcag[4_AYbO/O@=d;DPu:a%lm]c;Q+p,3l5MG)00tV$0=rkLnxlhLq9Uv-pLI#6$PDG%U9X`<5.sd+=;H+59i,D>l`-MNI:-##,qxs;Ift35LH3'5F^v/(*s9.$jX#_fL,###%_US7Q@Mm'@DXcQi9Af$pipm%w[Fb31]>g)/xWD#ode[Y#;[>Q1aigLk*II'Kp]`RVljG#s4;ZuMI###.diD3%,[0#n2h'#7pm(#Qi8*#<sgo.b#@N0tf%&4HXX/2BY>f*LYVa*2xZ)N%9=F3+IZ)49Ck=.PK;2%EB(*&m]g^%&^GT%<`U;$4lL;$M35N'T`Ab*x3e-2xdm(5sskxF9X8Z7Vs$0(bfBX%mbfM'.]Cv#<&r;?2s@Z9b88o[)Ro*/+&058aeEZ@qHn<aZhZY#,N=f_pbWucX_dl/o-sD4^'k9`q%AA4_EOA#aU)Q//oi$'_^<c4'w5T%@DXI)FK(k'@3J&SWB0Y$nBTn&v37Z#Q^pm&?26q%OC`?#DVu<6qL]X%mb:LCbVts6c%JT%.GA=%wNX2'XjK6&W+<3'PxuYu86q,3mG_r(W/M,)r?NfL53;m$&[a>e+JP6Bse_/bX6IcAbS:^[`ZbA#UGK%kwRa%XC.$##e+h.*dTK>$Ynn8%phZx6('oP/MZt87X7Yd3Y';$,&O*13J@9T&KFns$6cni1NJjo&4UcY#7o1k'A?s&+<-d31Rt>N'Q[J:/f-xW$CRf3'85j)*ii(T.FHLR#1j8m%e5pu,B8]Y,[YVO'Zh)Q/iB7f3O]&E#PaGx#l(=V/k-^0(;x_D58B>O00A/$$>Ons$^S^U%;n6e#F6-c$R2E&HCIqT&2U2R8R:Q$%G[*9%(Qb;$0=Y,W=.ViB@rdd+Avx_%dVYs-x($lL-Y]L(iHL,3>#BPY8E&-'H]2n&gM]Q8*?G&#]bu&4N-4&#x8q'#]C,+#4rbf(?DXI)lpHwBw^v)4W4,Q',jU-*t?(E#KvEi2bggI;-9YD4M1Em/YCS_#0BHj'H5_W..8^+4+#T-u=>Uv-@)gb.OcAWYeOrZuTFEQ/[8HN'UQ9q%8SP>#)V@X+wOk.)*3*Z5=xG>#<UW5&9)L,+r'W%&L4OK(dD24'7S>hMbawNY;,vp';N<@I'iUT0f(T#,4FaP&&3.]E1^I+4@Res$:_jp%rAr)+dD%L(78@w'=[1^##v'<.&5>##v_B^#hn,tLxc>&#f$(,)Ip#W.t$F4:7%wY62v2B1;;gF4k&B.*5T(T/6YkMEB^Ph1f&#L#$_qR#UD)%,.'wiL<#f.M/xQxk/)gL;@w6o[SQ^6&7%SN'$$MOH1qXQ)EU/pADc,<-r*A>-GI#W-t545VT_d##1D(kdl1Fa*S$Y01Ne4D#+,h+>5cY'4./fi$V76c4V.gJV12c&>;'u-4GG)qL+#j0(]0`-?-*=##)9li'di[v(OX_a41SU:@_CWK;gvlp%Ju#68'u?#P`:;='a;]ORJnCdM.cp.Cnnk,2j^''#urgo.$uh8./&>c4(cm5/gt_F*3kDE4$xn8%i.q.*6)MT/WFF<%(ffx$Z,u874w#8)U6U9ChXD@,hPxF4*Y0/)G??D:.G42(s[Mc+L^;A+1o'f)km7],ulEY/CaC'-@hI&,vksd+BEX^,R$m8/Fv[.M7_Cj(aQJQ8)kOe$$0;*#:1c/CPYZ?$<tfi'SVW]+q9x'0b$(,)8bCE4+V)..-uxfLnSB]$J(-xLlM8j-^kp6*2:;H*Mo_D4);IW-mF9q#:Z1iD4pU]=Rb9:<^QF?#a>Jq3Nu`v1EXt@7nMdt(7m,]M>2Y?M<>1M^x.C71pxbTBwNO,<,vNWS-m8d=E<:>(`QlDM>l;i-,/L6VhgJ%#xOMQ8*USCOwE3x'7*;mQ8')HE(f>C+B,UW$8)V_&:Un;-Ze7u-/;`PMu7nSFH,$Z$)=t/1]nl+#h`-0#ClP]4=C.q$ZYq8.t-YD#$fnp._R(f)de9u?OI[m0s&X:.,WZ9/gc``3ORp[>Jx?['4ljr?8clS/='lw92&SF%*OxG*>0>8V+BMp0D7xo%.S.V%[,v/(6B]X%/KYp%WZ=9%LNl/()Bm0(1vel^^Il%lHx7I*0==I%p&6S&cxW&+:Gl-$$O0Q&B#H92d9Bq%bR+?-bXv50O@M/q5)R8%&Ffk=F70?-9f:v#$Lix._U%?70M[b%Q:a5&godX.Nq@<$EC6=0:aL7&#0Ts$5Z0.$H/`6&PueC-`Q+?-q9$U8KS6C#%XL7#$WH(#p@gF47fVg*3LYI)^7^F*dq$x,VxG=7dCXI)BkY)4$j:K:-m[J3RZ$U&<ChT7]j#R&.%2f#:=I8%2Df%5E>ol/B4h;%#:s'35'bFOeK>R&dD24'b+5v,tkDb._flY#3;wT8HK.O(?]p,&P0/s7b5dq9`KW$#MXI%#5wdiLD.Udm?0e#6P?DP8aJt+;qUM]=+b'8@;mViBKx0DE[-auGl8:PJMM'##&n=g.@#G:.YM#<-5M#<-S`/,M4Gp;-]u:T._DsI3WYlS.N`0i)5M#<-0o8gL=(OF3GI5s.@[cA#.IZ;%#lI_8I[lS/SPUk+_uL/)QtlS/v@v`4xN0F.TMb9D`?rI3<8-F%E%t9)5jES7:D]5L1(5F%Hn,tLaR@%bO8s9)u$0W7&.qFMWPqh7qksV79UYHM^2eTM8e0&v*xY<-.6e2M]L8Z7MPE[0xkIC8l082LsD/R3_3_w0Y8.U;f#'x9$c)rMvx0L5N$-F%[KMq2p5o6W7h0&''r$##=TuL'^2))3lYWI)BKoS8CqLB#xljp%M4u<MxckxFD7;?#8xP';:RFHV.+Wm/65l-$a##t7@gkA#f8Hp/0#*'iM,I-)%[`iL<)ge*(E;H2@f0'#<Ja)#4=8C#*EY=7+%fH?gJ^Z-w?uD#$5)mLkB]s$dNWh#ff)T/>d%H)+,Bf3'P4i%lEBQ&CO.[#/iOFGXhbH).M<0(OO3p%H$4t$FBc/(WjPn&QnhGMgBdV[udZ&OYlo#,Rmx#GP8j3'%>p>,+,@*3].cZ,?f1Z#'1Sq2bL`Zuik7Q-r+TV-tUl'??L*4#9t*W-'h9LNXBo8%_/s=g3QX:.#%_g%sLd[P(O74*e`Z`6u;q:%LNl/(jXb1(i;>Q80qq&lQ.Wl09)6b+bwX$KtD8r0(3[GMe`7uOmJ_P8Z;/=%.R;J:EVkr-;va.3=Y_gG@1sY$*X+W-4q[tJ.0&],hcWI3dv>t$huc-3W%V%6,R(f)%cK+*eh3n/+Q-i1`rH[-+5WN&^8;J%[XK1gZZx>,U,[)*C01,)revP/O88#,eFvY#cT+T%SF%W$S9k5&XKxnL&J4j1>.leZV-]S%8x_;$',Kv#I09U%D1M?#cq*T%jIB+*JIIW$V@Z>#^*@78EYM=.4fju5VB')3_k@8%PncD4H19NiaT+(P5@F%$*/rv-3xko7$3[C#9^BT7#ZgJ'VdV#5m[xt%Y_`e$x5AC+m7?7jS'99%?*go:?wSV[0]0w%bkB=%LXFl7dD24'*YBB$Ns0&=[;2H*PJL]='81v&Kcvs-4?,d;bwPg)jAqB#^;hs-<0@QKO3Bv-64x?Q(Bt_2,oSN'vh=:&Y9FT%UF`Z#qo/gL@LD=-)/8>-eVPHM.7rp.GIa6&[RBO+<@4H2dO*B-Rml8.L-5/(HCZcaU8/&G$L+&YvN,W-Giv_&1YWdt]8Hv$E^_c)um%###QpR/hK]@#X&U7/+^tv6+(tO'E?9:%Em_h$61?v$`lh8.tkc12].I,*MKs9)WC3YlZmvQ4RQ_%4;aTj(cSsQiBQvkCht7W$VVf>,c'Ss$VVS#,5CYGM2(d<-ar650hvM+4-p&U%`EJF%e71cQ<4r-$bto+,fGov$#E_Y$.Kg4M_WoW$.W)G@_JP(/>=G&#7Tj>50YL7#[Kb&#3vv(#GkP]4F_Aj0j_p>,4&>pUFVOjLEums.NCI8%CWgs$hNRF4us3-*(C_F*6KXQ'?@XF3Hq<iM>U*30/]94'`)mn&8N>F%['<T'T0ObjWcoGZtDX-)rFKJ)9YvX$ZTtT%FXHU7AUGb%6)J-)d/vn&xY,F%:Bn(4J=H$,3w+>JAIQO'teC@,1QAI*Y/Z7&IA_e;C)$K)l,,BZ(+t.L<0cf(a@aD#7EvJ1Jm?A44h'u$7#N:SicSh#gKSldt;Nv52em(576:n/KRAEF93dr/&,###k2@DNXLFD*c4@+4`';H*OIR8%cJ?C#%&AA4x8Ow9d]DD3=W3b$F.@x6^i.l'9%0T%1mZx6&#[]4ro,##DX1k'FT<fMDq]8%:vq;$[h``+E%xo%:x;U8;(V@,li9TnR%@s$&/[x#>/WVn:8F>F-2dW.+d[L(_*[=-Jd(?#[TM+*1/-:8_huM(dbV?#-tNp[a.V?#.;N]$['A9]f4JfL4O-29l.<%$Il'W-W=6##$25##f)###BV.tBfrM7#L3=&#st_A2(l2Q//p^I*O1[s$4BT7/'vC9.8A/A$ZK$30$,ra2o/M95.df22?18Q&<$7Z?vYQ&4f70C.`qR@#xbm(5e.IK-bS'F.?72OLG/2@,-wJV.71&F.fJ%W?,BM%.BXV21Vk%##'vF:v;`fX#sW8O4Qww%#(Q?(#EkP]4hEFg15ntD#p>XjLZd;E4XHT7/S4)=-Jc%b/iJ=c4]_d5/B3e;%CG*X%p^d8/]HW[,Wj=A#<f&K25+c;np_Fk'j_GnA4nWv6GL8k9@sus4[l[u.D#0f3qru:0gvOP913N-2<+.M,eA%/;Abm]2GC(O1u_PseI7Co'ufsaG8Q$c,R7UCQ<7h2%t7?_/JL[bOMVH>#Gm*h)O8?O0Ow.(+CgU-2^HRn8hCE;$P9/3Mqx8;-a&0w3PchR#t-3)#Z7p*#%CV,#EN=.#T^Z9%SVhX'=;gF4N`i%G/-Xa&ohsH;+Ym*lO#9wP]Y#8Rqo/^+n)mZc'HPB&n7Es%&Pk.)$n2^O0pFe'(H>g$j3_M:sWLUUB5*Z5?R44'p32@G_Dx<Zk&YX$PUnK'D`mmSp2F?Md+4h%YI/x'EEFZuU&6D-$Hg;-c)H<-QlG<-cL%aE,JF&#x$Z;%&*(<-r6wK#7Zu##MXI%#jd0'#4pm(#I#fF4>uv9.L4xC#%3A3%kKPJ(;YN/OMb=J%fqbF+$;s7/P.r7/nY8duKL>M90hQEN>QdLO,7?;-#]@%bex,##>9gU+4Mj`u5:T;-25u?-uGg;-%L_^=vtB^#hDt$Mp=t$#@,>>#nqY)4R#QA#DTF:.U4[x6*h;W-',])3Y,GY#i`vg(UsT*qvhO&+d'SVHQ%nC#O]&i%t&dca9AEh(%r0%,S`###POi;-fm7^.apB'#5Gw5&ru_5/VAf_4v6<aO76N'%sa24`IGT(%(];@0k4EO:=>Ad<30I1g>OGb%FlU499<l%l'rQJV4tgVI$ute)V+T['/Rf'&C3[['Ct[kXC&.GVYu8>,sA/DEt)7#6:<Gm/)7RP/cx#J*sK0UB:Kpk&%tDJ)`(6caYZa#5<VA=d?r'B#Td9FE?>^K2.+CJ)_gX>-?j4Z-)7&Xf+^xK#Cb($#I$(,)^M;Qh:k1e3)qRF4e7+w$c<VR>f1=VED74J4PkB`aYr6;ASxSd55W'54XQ`nD#.w.:Wx'm9p]iB,x;#,2_tu,*puBxnIo9KM-okD#HjE.3iJ=c48scG*l5@>%q4=V/@Dn;%Kn*]#K60R/n-9#.K^^582pbm1JgC2'dr8[5`&lo/a4oD=I/x1(TETm&WkQg+/%1I&#>GkL-5U(2Fi7[-cBk$QtUM.0XSmu@xNA30,qs/'$j8>,RP)KEo]fF4oBWR8ctcG*YgkW-_*]:p&8]=/s;0M)bDVO'YNWa*IRnW-+J'<0axQZA`#)d*TMPQ'#5VT%TakL:?bK-QO;###p2&t0HPFjLf,](#]I5+#GD)'9WGrO`x#$M;kTT/)GGLA9;MDU%ibXsHAOhKcI?*Hb&(Ni-IcRX(ACt(em'ln-%>m8gYuko$6ITX(Mn(@(K99U%=mGs-XCO,Mdw&/Lqti'&:t9D3L3DP8u<'8@#)Ya*`#e,2Vg;E43/q.*M,'J33T[)*L4JI*R4r?#*j:9/ckY)4]_d5/LmJa*fZ5H;F<[AeN>on$;IfC#;-kp%uwV?:^I;h35m5:%Q,rg(ingo:u3e;->r>G*MQLg(+s$*3O+_i2*jZ]4n^7Ni)ZxYMwpZ.qC_39%JMYe$&lQt:Nk.k9qq&9.VD8w+V3fs$$eRx,@9k:.W2mN'lLT^+Wf4Z,U]h5)llFv,1dB<-[%7A-0Ts/'`5P:vP?b%bx35;6Vj[i9qa%##[7o]4ZG)KX#4L+*;*^_6wu6N';Fn8%/kDE4<ZRD*lAqB#e4NT/*VO,M*s(9/rN'>.RWR,*Qtb%$`i?<.ZL_<-Wfm98UiY>#cxnP'*>P>#lE(a3c^t5&NuXZ,Mm;41+l`<$mv[B5U#Ls.7G(v#>46+.i]Nl..6<`X2hom&aI>Y#oF6EjL+8.2@aBA,Jvbh)K6'U%ME>N'pd]n/J4j,+e*sZ#qdQv?gel3+o$0q%FCM?#+u5c*gEi0($%7I$RC$##&&>uuxmAE#NN7%#@>N)#@+<9/MV&E#%Qaa4CM,v,OgGj'N6.thk*TM'%c7C#kfPf*oc26/%]^F*j$%c*TsJ^4+4xC#m(4s65vxY66(r;$ip/s$69O[uW.'E<lYVQ1#b+T%b<eA%W^J#G(+%U1(;Rm&Y2D*0Jg4',%j&T%Mt_kB[+V@#.cLv#C?rZ#D8W<%OgV61?=S/1GP)B#i4u;-Hh@[ug.Lm9lx$&Yp<T&,NpF3)wn&/LR$tK)f?%##-Ov)4uZ+e+up#i;31T;.f.2W-UkrR84G(a4]Cg,M.Wg88nf?#6MGC@-=kMI.OC(@QMQ6hGTW5^=6c+c-wnde$TDZp%<=xt$2r79%4IWp%g3oiL$u]+MgZsMMRf49%.+CJ)o`lF%<1^4NCK&VQqR:?@gBn##tid(#W[U@,ZDsI32H.H)nlo^RTpAO9=xY)4h>Ia*q^#=-bqIV'>Or_Oaj<JijPJgL^D[#%cahR#i@$(#K5,POo7lD#a]<+3X)aF3;X^:/Gj:9/000I$(FXkWcS8f3WVJD*66%B#K&5%PbaqQ9Tx_Z#)pkA%mq0dMo,g[#qEJT%<Fl;d)h=<3u1RN'HcVN'*[8`9um3;1r$c,M)]R?$,bkSn)r<RMe;McDg#ss%Yh)20xb0R1)loL(:IZg)L'q+M2:74C[3N?SkDGA#/rFmD-crB#?MII2Y9i1Le<7>#`b@t-&LIiL+9kxF=cOo7<(mcarEuaGW.jb903_B#AUl##;j6o#s-^g1bWt&#<>N)#'0f-#X:[Z9A,-+Y<O-29iNdG*(su`4g`-P9^Y*`#mdpq%fQ7P%x050LgFYF'NUm%Fh,ge$&fa%'xcsA+n5k-$ad?>QE_:B#MPDZuG^(p$aDm'=MTb]u1)dgLIQx7R@YHTOVGtA+ZWsC/>j(N0<G?`aMu08.-HKe;R$$Z$8]];.[#>H33xWD#A'lg$mhM`%>m_pL)]5W-+TMR*&k8n%93w]%N.c58bN9dOb^&%#m8q'#2Lct(nv@+4`nh2K$j2<%0EN1)`?@I-tFuG-w6FQ&8,nb9-RZd3ISI<(aw)Z#SuS?L;Bw8'I>C='Q0=QVs2w8/&9_9%,/8j0E:`?#<UG<'M+;;$2k/t-4Br#RFqT-'>owctGUkD#QNt/:9]C2:o5>t-gTCgL.t]J.NgAE+/H0W-MAb'?/6JD(K99U%]C:_]66,Q/B8E)#EkP]4,frt-i]1.;T%tY-J+n29I=cShiD(u$@TIg)G(.m/xljp%q:;Z7@dYs-KYfn9pq__&)Z_pL]B$YY;)^TV*U2#loU9%%BI70<t4[;%7%?<-l`JcM2J.r#_A)4#A@%%#hd0'#md=@7_>bJ-][&v$]qL+*a]Q_#cI_Y,_&-T./@EZ@&-E;6$i4',F`(9%%wR]%ch:r=[?f8%3ab,255fm1XR<j$*ZP*YE$Nlg[VVs%#9<=%5V2I$(lYN%rsH&m,4t.L[<VV-Tb$##LI@,EFRt,Od;E.3l:9o0:u?F%J8=`>9#q?-/x34'CvH-)$U-TIHHcof7d_)&;jES78YN-)6kCZ%q/B.$+@6b*K:v,;EYbm'rMq%4`GM]$3*&gL)I&J37Cvk%>2J90s9;GDK=$W%'4I3;Z67E.NFblA)[<AcUv90:cN`dai(`%b0r+87>2*LjrB>&>t1mS/lO>a3[Z*G4STCD30k'u$(QD<%&Y@C#^1>4%ocAb*/0j'4'9-aNqfYf$p[W@$isNiCC_39%C<V_&HE_://;N&l4v3O>)gkA#CXld2`T]p%o:9U%gBI$&%)IN'8S6F%riRfL#FZd3vl1m&iLe;-Ldn./0Zc8/Y&Ue$-m])N@ZkD#7*Rh%JI^;.@FhRAew]G3k#U-*xWB)3+/rv-wxYF%2k,V/#esxFR7[&5Yj.tLBtfd%bfLT%lRg;-(4ip.7OJ@#3Kuwl)[N6jlip`N?sNL)JMII2g)3b*%/^X-q-'eta93$#$WH(#SO>+#_do+'F4qY,=^?+uDjj#&HrB58,VHZ$<kS@#8d.]0)*1R)6=+`#1u0H2&jC50QYPs-[sRiLos3D%Xgf>GPvBB#=1bS%GC9U)'=nlL$AMPMqwLQ;Jhv5/JIXx>-LFT%i.HN)LQ2Z%tp3ZuPFS/LdFBJ)YS`%G<@258i7>/MX&^*+SdOmL*OVQpni](#xo=:v<Lc>#]5=&#u$(,))u[s$X5QX$[HSP/KcJD*bqeW-hiOTDh++E*'lB#$t=vD4TlY1M(A-J*n4T[^<no;8?RnW$w;'<$@FT]$@IRs$jcHF%u++gL3rT#,PZTs$bBuJ(IeGF%t1d',PY260&.Qq7-tZY$nb6C/Fpv;/khd1MEJ3^4S]>W-:f_q;/%Fk:`IwA-g$Tv.V9Ss$.mwE7,S#[$'>cuu;m6o#Sj9j%l/<A+v/^f1hSm*3m#:u$ZVd8/qSM)3^ki?#C]R_#=)'J3ig&o%WUd=%;Ve]4<^mD@6fUv#P/#W$4/KkLHYmD6joG',2VuY#n>09.`qcN%#N93MABC8M[O-##_q8s$u_doBxD8h;UiLC,CX6DE$9<=%I<.Z$i&1w--ec,M)rJfLt35GMK)I>#el9'#N`aI)^8v;%PEZd3%X3c4+[C<?$^Gx6&CcO.QN0b?SHb9%7f9x$@IRs$k:T,MY>.l19&x:Z[`_@uPBnH)m1Lq1Ji4R*c$9@Qnfqu$]3M_#Fw>lfj6Vl]QDw%+Yc(]0iHX,2TCh8.d,<TJCq_a41mp@k'B*jL('kt,cas`+E@@k&:*WW%NC/N#%IUO+37TD=JG1bRv*/W$;dZ[RdWx/'#-@D*0Yju5c6%##v<nq$S=J&=w%pG3C^)liYk<:%X#dw7dXSN1Lq2mf%vQ.2ZlQX76/&U0QS2;?kqR2L;'?gL`o/q->I)2q=rk7@LcbA#=Bnpg1_YgLf_c&#4N=4%0V-W-c?d9MOU5s.gf(*4<C9u.c:o<?fZHh,[UBd2*-+c4so^I*-4NT%nQJT%(W5G%Z`1?#t.Ca<KUMZuIYLhLoMPA#CHFL:8qqZ^G8Qq`[1Q<-1HKT%Ol*.)&*D=/RW:p&8mcM9@*:'#SI'&+wJu(31E_n/iL0+*J29f3`:A;%l4$dN%5,G4`4n8%%]v7/8JsILU'LG+j0tNG/l+CAZ<,QV/'=u-j#:^#CU7w#I?e*.Sa.C#&DFN13f-JG(&/$vF2_W.X?pf*_oDq/IdKE<?=.W$gKA0'dkfi'vM:D3KG'##X?Fs-F9%r@$5p^-=XXD#8N9R/gcVU%=39EEV:6g)2p@^$bYDD3FK4d3;cK@%jZAsnQHGN'n@de$-`061ZLklAiPpK28Yg^%$-IT%&51hLej%HDG3[['eZ*%,o2FV7<MR&,pio--l1>T7s(Ps%'^^e$.=t5=[NF]up7RQ/$?1cV$R(<-x7-b-;@5HMlEK_-u-k-?:)[p.&8YuuXwGr#IN;4#]EX&#vrgo.UPjc)MCr?#2Wgf1$]JD*Uh=X(U4p_4N3OR/t&#Y-+r@8%(3Ss?chBJ%vpb6&JUUHiviP+%?eqT7gpoT$YRu+'75Q1'l&]p$7#k&%Y5ls$g)bP/Jsew#B0ZA4J8t5]$'TFEsL3D%pI8A$=dgA#Xi=;-XX;#5:xc##T(ofL?uHl$%^sx+ts&/1nc$i$if)T/?]d8/[t9a#?W8f31M_EN+)Y>hHe6.5;peb#1rH8%:Jj>5,<+.)o__POC=/GV3D(3+eNI<-ujGAP[K.DE%64m'O:p&#v9L]$-cq9MAV>c4/0bbHoJYA#F/Mp.^`,29ssl?KWfCv#@Ya`#>X..GisMU:iF6N5'ZA%u(@Y:&krfB5?N)x&KUU:JQ[5)#AYJ&#%(q^#%,[0#n%*)#jhg8/KwvBR6aF:.jBFA#]2B.*SW8o8Sf-IkD8xiL;[LLVg-;&5`hTs/g#q7//n4GV7S<s%%aYp%-Q'+%ZWe--lq@@#OAj#lS`xZ2omAE+YlCE+0w/E%LNl/(<R<j0Cx.E+ue#nANi%%#+2iT.qtJ*#qL=(&+Lj?#,R7x,lw*$1x3vr-`7%s$&i^F*.,@G$7htD#7O(02f'5Q/Z%AA4i4NT/xw$gLD?.Q'JM/)*GaoA,7iv[-]%_87=/RY>r4rGZkPVu-DERs&ex79&Mew<$]>Hr%Fts5&IM?K)(fws$j8VI2S%^b*CLR<$3rDL'UODZuoesJ1wf^<7OnQ`ENQm51.2Lt:>C6Pcx?Lf)anww#M'96&&`U9&FBPJ(Eh<9%^,(S/3SPYu@h#nA&E2I$#puL:K=_,+M8Yuu9g-o#=jh7#UpB'#U,>>#3&>c4GcK+*;I3u7Q@m;%m*(tq<04mLeNv)4RX%q$r)8f3_=5L%H?@;--L&=-InE5&P;4G-R^vw7(n*r1r&f;QeBBJ+_4#Z,8m?F+QHGN'VMe1(h4OW%[16*5<U/F8qw/<$/V@[#eAZ'=_$eu%%4$a$f]YqANdEs%m7Iu19DH%b<nk.LH=$##'d<a*lOQNBo+s20e-ji0ac%H)RJ))3w0`.3hjW?#Dux**#w]p%D-m12sDn$(N?UG)fWgw'MWrL(pcjUI#PRpILxAmAtd@E+ds(k'En7Q't*K]=3jfs7Oiif(O0sKG)h;E4qd8x,EHuD#1rSfL>-7Z$-R%D#ihIx#QA5j)6=L=6q`w`*P>i?#Vd693hDS1:iDR)*VNtX$XF@h*&?kWS+G$&1[WL7#r/f-#SD6C#3=QT9<geeMNE<9/1]>g)v@^Y,X#:u$mh]g1vTZd3[<+J*RJ))36DYjLDm,Q)7>u>@qKeY#Q=2v#h349%Ug_g(:YC;$G=IW$XEos$*$mn&<$s=-Wk(Y6XHos$qN<5&-&8[u@jjp%S4M$-XAW-)>0GN'^T,=(E0D1(Fx[@#-d*M(uAvf(C_39%C%rv#o?c808C*9%D6gM'DNe5+E%@K*g&_m&<KwF'S2w.L5O$29r>4J*l5MG):@Es-AiE^Goh*B,.]<+37q)=(GV/)*uYk*.Vjlu>.%a*.rnpr6glCSIeN=_/or8f3Mk[r%ik;w#KbD@&ihbt?G6^2'diVW%Wa+A#>@67&Dg:v#o-]p%C@1B+,lOn*mS63'?>.s?CaBm0Z1gm&x7R@'/[P-)DC7pED'9q%1@LB+<3`<))='4'u$$p/=WKw-9@P/(UN0S/DIIs$12I$#*FH_#4)U(anC@]b3+GS7X6oF%1jic)Sv$.$#`d5/p98E4x<7f3x?'o/4(7]6fM:u$9(m<-jd=?-=K6*MoWXD#iq_F*TVkA4[;M0(TPK:DJp9a<6N^a<?YY?6S&K0M:9nG*,^vG*v4Jh(XH;21<'^6&V.qT7.Qp7/0g@/2/o^u$d9r/)cpYP0ttfu.RUX',p3jS(6C#OK^mG7&q/j?[ffM7#a?1-/lAqB#q%?(FMmY#>rJUv-lQ:a#CFE:.W3YD#;ZfF4NwE:.`f^I*.(#V/D25##>hWp%q4GN'xJM-)j689%a3+g1?iR),%GFG2?-p/=wOA8%1)a>7?x&:%#%@Z#6l@$6qa<h#(kA9%np2R'X7Rh#(BlLF%KafL=i'%>^[T&#jOB%%oQ=8%L;<A+L7-AFWndt-CFe;-+c>W-e,J5`PdCa#X0^M'8Ah;.=V&E#lHSP/@Cr?#$dl8/-INh#&5K+*FgTw0_rWEeGk@5/u@)a4d:2=-HFIb%XOSI*Oq@8%bD6C#3'9',/N>A#pu7T%4<)Q&QvZ)*rH<208q`R8E0GN'<XJ2'A(%w#tJ(:%vqAx$5*0t$wnw8%pdAw#KQl3'Eg$h(3G10*c@>Z,7ox5'Nt39%9V(0($h@a+eCH>uOLk]+ef2S&LBpj*cvZT%M4ox&WHUG)dPh3C[-fw@A1DZ#a-4Q)kw;k)i5h>$JitV-J^ok9)`KU@WQ>/(G>-.+lKU5'%0^R/boKB%GxAmA63ng)lbU<-_='49^c&'+/####%'Pu>JcxS8F]s-k0H/(%Ma=<-UC)_?(]R_#=%Rq$NaQI<`0_R'G#[)*IPsD#S$]I*GqA8%XvM[(x@n;%.e2s^PeA:/QAp0Mc7D7'0V0T7&F^*#'?/2)<'8*+['YJ(VRRs$;[<9%A<,R&Aeoc5-Ku?,E%_b*[[Eq%9+xGV6mvx4g<gW$?FS/LRv(4'6.v-&7#vQ/W9&*+Z<4t$KOEp%'JA_42QmJ;VC=t]f(J0%QIml/hrVB#sbDB3$&5uuJ3'AbC^XS%LI$##pN'i:&Z.u.OCr?#,K#g1B?uD#&_<c4;x`g*D7Ds'd%>c4#@]s$Qb4W'0Btv#>?JZ#;++4'=*O9%]iVw$/(>+-q--O([OjG<,%6v?#]sH?mD5$,O3FT%hJio&Vvhk'0jdr%,)6t$bKKm&5v1K*7p7#%B76f=cw?>#``''#72<)#6sgo.0k'u$*j=c4XTKp.+dfF4?C5Q:$CoF/-d%H)Wv`-McYSF4N$A.*9.Tq)jWjf::fkA#c'lK0=J]f)=l*.)w&1@'3a]'5Isge*0KHX(:an.)c3&[uTV%:.,^.c=WC72L_$(Z-`*)iLV*'B-lnEd*.eIiLT7-##6ap/)K?hr/=Kfp&5x@o/Iqqk$UjQ7rj&g%#d1F$%ox.T%,Ov)4@m(u$a]tv6Gba5MZ8Z;%d[?L#CNNJ>As^30G@clAF7YG%x)];QEu;a>oXM22AFYM(T.e5/:WL7#^)169LQ#<.pZ'u$$vS8@QGIgWC:t'4K9Z.qgpQ]ukB8F-WiG<-[4VT.0]/E#4[)<?CP8f-<?%7l)X[F%`Va.q99=8%T.lr-2[1C.>uNb3>F0T%%rL+*]un$$vBo8%*@'E#d<o5/`xJ+*>hp:/9xmYQ996DfEPk.)bM*H&:`G>#_)?7&aXZ>#M*TQ&v+Sg(<4I'P(3m7&6.I-$f+b]+vaB2)JU3T%PW5R&])hq%Chjp%Y:P/(N#Wr&F;90M;Z?##[*Zr#s/PwLKx]%#.^I:&7-cm/+gB.*$7n5/E,S^$)bc:/OYDB#cmjp%Lf`%Ai_]?M`TK+5:q>D#iti;-:Oa+M>EZ'Ak^CmC5(h#$65qCaEGpcan^x?72oPu@oqA,3VLGa3rqYV-rkh8.BYeZ$*e75/p%Fb3Hq9;%>rxh22uq;$6sU,+*/@W$[]ZC#f9;O%'OGF#lA;O12['SI<4%[#DF[5)cCs%,kh#n_7r:Z#V8Eq@AfqV$G5?Q&isJ8%h<n=GUS+Q1sOOg17j@H#1c%[u7W?X.hF$##'scT%LZYc2OXkr9x@N/%nth,M.]N/%EsU9Vm#,W-t9_,PMT*r7Fjls.dU<9/5)I@':h^7)GbR[#qn]_#pqP[-Ng>o/>D34':VN-)v3&[uLK%f&UeQs0aFFGMGMUB)NMZp%.VN/2SO>gLMwO/2_uQ[-?eK-)b9=6)YgiOBwP,seOD2sHx<=KNCip9vmqEs-?KNjLMuPA#iHX,2si:9/d/Z%-b-ikL0NC(4g_(f)Unn8%/U&s$ZVd8/Qo5Z#Rg53'0fb(/nAGb%QB0Or7rMDFs]Zn&oU:AFw=Q=lb-A<$[;Vo&.J^V-prA'+<VH),6P>(OIa3I)Bm-h()j/tu^8e.M+dHuu6dqR#`WL7#XH?D*(]rO)0f7C#+<>x68tTfL33SI*[sHd),,$V%$cnL(ppH^$B(%<$#T(0(WY]4([$FT%xA>#'j)Wj$<I*9%qD.v&BO)E-0f&Y%(>PV-*Kq&/kMYA#<%_4.2LugL-8gI*2Q:Z6kmN.NG/C;%4hod;N*'5)KIh[2]@AU)?g/Xh>7c,2Mp=)>&D8:/?AH7,sW(J<Kr-W-5[pEeTA7A4h?Ds?q^?hG'ZRD*S``p.%Kc8/BQUF,W*^:/x)Qv$8t?6spq@8%Nw`f:Woob,m[p>,B%,?%qh=+3=Fk/%_5B.*wh%+4RaYp%S/7h(?;8i1(3HN'I3uqA-GY%51K/'5M$dV)c5gT..tj-$h^5S3>pZb<&ph?'b5+%,<*m'GR*kp%JucV'6sf1&ElZp%UOL'+B;MC&^8]??)>l(56M0F*X:Pb7T)hpR^A[:&Kpw8'AChT7Ld+H37Tmf;CUV6NWkB=%r-bm/kXL7#Eqn%#u6Ys%aA77/otr?#Fb158OSCa41-ic)Y;hC)]jN]%vNfp%Mso#,vX;hDcE/u*V<ct-6Z=gLv1>]%YQkp%u4ep%j&LA7T_d##eQ[I-N3E(8HrcG*vv92'_ZRK)5Z,9%JM/)*GmE.33Npv-KW1T%sLKgICCX/>..89&*G4<6j&P<.M9.%,3nx9.YW?R&G]^KMXfB(MJW8]I]m;B48g<=&oKfh*`N%b4?r@[#n-vHZB?ckLv'pu5]>t+;D2'##'-U:%Zm:[.rW>V/CV>c4Zp?A4PD,c4cZQm'/kiDNmmbe)T8d>>>Y-LcZNjL)ZM[)*apvD*P#ID*gMAn$0>KMBM=<5&^/N&+pX1W-pGRL(^pdD*N/W&+r^-iL%<c=$8-D4+u[i;$Ku_V$I/L%0Jg4',d+EQ.4O(k'-Iw2&t;K[#3]U;$B+2?#B3K6&[]io&OkNT%0&Uw#g>u=$I9b9%O%@8%OY4Z,Ie7[#gf?v$`7te)-EbJ2O5`&,9=j3M3[E.hAO<T%k#6T%Rc$s$S&$;%4u$W$xsjQ/W4i;$&####'&>uug8wK#@Oc##dQk&#kf$^&G8^6E+rxd2B19l'2bUa4,grk'6t'E#E($?IdvC80,,@8%k6^Lp+if)3hH>-Ou1M?#K-x8%kjAp.24h58Pgaj1lPXW6X*+@TXA>x9lMWP&ZR1I-j#wB$3uK)NHbw>%0]18.4+%cE?I<9'`]`4D:XYI)4,``3wc``3h3YD#<pfRpaeEZ@QcMU8]^Ev5lkMW-:]D;$4HNf<Quv98[?5Q#2HC>$<K_ba>a):8U=MN27[r%,sOMU8;WniLU/Nf<Ua=L)EGc>#iZDn'RTx:HQ?;daMV2/(^6/uQWpVH*k_Z=7%5ZA#.T*w%LD,c45P'f)l4K+*_2qB#Vq'E#XeRU.$6tG4i?5g$'@7I4rr&O't;b*aXe`W'2RNU'6huj',YCv#X`1Z#t_fjK^Vw:&xqTg1^Snb#,%M($sf2@$sRF&+wm7A,$Us-4LcW'4K0kT%pxq;$xE1Z%)5Sv5lIpP89T.a+FxhW$agRj2veXI)x]lT.NvCu$9W$i$ELf&FB%?E56+2VAk6s&HvI<s%%dh2ij8(U%e(J-)R3^CMKbF/2b#7K+wOk.)*a+p7*G(aO%T?q7J)U^#b;24'G:fjLjM)`-HL'd<++C<.t7mm<+Ksc<6w9N0fXL7#IXI%#2(;YPoGBx$AkAN-o8_p%jOQB9?bcOKoaaJ2RK9bExYkA#[/[a.XWt&#4F4))6p+c4sl^I*u$D.3<kda$Y``x-Pm%f3^X-29bh4mhT@wn9Sa7(1NP@;%9Oh/)$Us-4f37$,Kf'IV=7Sh$7tnK)DmPO0em*gCXuAA,TF?_+OGO0Pruu^,[wP3'5g,t$0F,/LfDlj(Y+pu,g[T3OADXI)A7[s$Y>%&4#&AA4+csD#BAr8ghi.H)b+)')?@<Z#'pl$,0T?R&qH<o(c@^Q&9R(mA7nMnLcCv`4Q7dm8YaaD#1nQo[Kv8W7@ZU:%_iqwGcq+K1'Gv,(8RMN(F>x/;^I(-FTt`AdQn%s$IU;ftobC2)WwC.3.Nav$;Y#lLn/)W->bX4:1X5=RM_N]-O*::/j4JG3b0=]u6ql3)aVe>%r%^D4Add70A1fM-g:IAkWe1Kav[/o#fXL7#Q'+&#9Pj)#swbI)[(Ls-G27T%]J))3]A,x6248C#-d%H)[[=j1o:gF4R#QA#jSwD*8+S=HTh?T.+)0J3;T18IFi^#&`[Ip(Xt&f+Ml2Q&B[*t$v1cghDIS/;YcuS.)_wo'_W-:&jo`_=Tq3s@kWdI3XbK-)8,;Q&O<,N'k>7&.WtT1;?K7aF`,92)1%Dp7&bk&#:aqR#sCO&#VsBe8w=NEc]KbG%#F$`4uWe29(xa>-%:u<%$]@@-9([>-8'b8.k56.43K:j0i00DaOCBfN)Yqr$`]=&lIY2GVw3/T.aF31#)%?89x0<W-5BIek.hVs-(&;9/v?]s$k.+E*[M$f;[ji-*G,^F47*YA#>r;=.l@X_$-_pU/UTd^X^oqc5e1H+`-RZd3Zr$:8e.UW&.uZS%SjYn&JccY#NCUc)g^qt%oqiV$0u?s$S+Xc3#25$,[);0(b)(p/5:K-)i4.H+C6V+,+:@jL4.[d3^KVk1D8q*+AY_V$pgNu-PY?6&k%4_$Oih;$<8dk(@l/p&#C:[51xU<-;.KfL]6nuu;m6o#he_7#:]&*#oH`,#R'6PJ-@$i3B%NT/As/C%;W8f3+g^I*qd8x,OgGj'BN1K([^We-L%o]4dbL+*UtGH3'2^F*lYWI);cLs-1(VkL?g+G4B<*<%:6?/((jwG2po(,%>+%w#]EwK#dm8I*5PxT%HlG<-LgI#6&85=&[*p2'*PO<60-J>#o/caupY%A,k@^IMcVmkCbt59%]kjp%0N7)$`K/s$c;sB8)=NZ#nXaT/6)w5/V@.w#(+NZutV4r.4,mA#5?7s&r./P'ZEuI%+f18E%8-/*gq1d*x'ks-a$go7L7dPLhGgi0M*do7*Xbr?o.&c3QvQJ(RWgf1Mnpr6,KT,5aZMi/C7.[#a4n8%SEx;-5wm5.a]?+<3M:a4`3I]OB`rU%Ra1rAY*xM-kh`s$>e&m&:^1i1J=t.L:wHC#pW`YP@X39%u*TmA#%:J)E;xfLeYq@Qw+35&DxEX(<_@],OVn'4Dx:?#PMR21V(>Z,XLZP/H52^#,OAk=0r%W$ZlD@$+_BJ%R1w`a&lF@5a$*D+/'.s$Nmxg2?v>V#[Gx+4X<)9/^V%V%2LD=-MRr*%,/7Ks1C=)#Ut/o%P`u;-gVm9%H0oA,uwWD#8%EG%X)=+N.r5Q8.4AW$Lv(B#mV$0)RubF'?FSxG(f>C+9vGT%iEMc%4&?[GXNXU(>Uh,D.+CJ)ZMpZum)PN9oW+>-dD24'9dSpA_+i/)2jSuCP.pW7TC1IVj*[5L&5n0#R)###Cg`S7,NLJ(^c[`*9FHa3eQ=g1IUFb3Xcf)*dZ'u$e`$w-8O4U%snL+*f1oH)sb.S<AXw8%WITj'j)-A'F%WNT-Zqf(@TM)'hA-$$4fl>#wUF,2_`uYuxA7<$qjcn&Ah9h(Z+JfLw?,gL=.Fr$3GLS.Rvs+;N1L`EXtmt-dFV0GkJ))3Zg$H)$rh8.pp-)*?kR)NS^w,*p6Aj0vR7C#k<85/ZktD#Sjn;%_X>7*Cv+G40h;E41s&+*?7%s$GI;8.iQ+,22`NX%kwu)4tS))3lYWI)rS?TSBOET%]]2W%>LET%@u/QAY8eD*][-9.gh1D+_iVs%Ll`D+1_)w$EN6)*q0cgLCEi8.m'GP4(Gm-$Rv,v$OK(:S;cbgLaSdZ$p2ZK(=.YM(%rKC#)uxC4^0tT%,phU%$(#c3n^Zj'qjGK5pkF,Me/:Q&9WtJ4Q_E9%DP]N1SZ/2%@4%[#q(6)Id5Gb%_uu>#=gRL(,$Oh#'2AMHfRXj+x(D'#BlR=-O[W30H<lm&*p?X-/WXd$b9NZ#[TM+*]G?q%OO>r$3R<Z#e(o,&G21O&#vOV-G/IL(K^0s$9pc'&M(T-25?sI3EB4K*7i%e(']g@%S<m,2K8iR#DHMO#0^gF*hasL#Qw/t-&(LfL6[?290_rdaQPW]+Wk$##cR(f)@fm8.HjE.33%/g:HUbA#)$(T.GmLT/r_?A/H16g)$f-lL#B4B2v0T$loSs22hjxn/)Q@O;ccY`<.+CJ)7PHJ;.50cV>:CJ)^^+1)H>%.2u:w8%kIO_$&^+?,g*ax)lv3V7bVA,3@3N@,.u&LW%Di'#n$Zl$:oSfLNNqv-+]>W-l'S49Ue6#6D*m&=+R;h)'@n=7)jTv-L<Ha=5iC*4f]EnAY`TpALfTf=Nf8<6+?gT%gG[p%Y0tq%n.B/&J*ug+>ENoArNZm8A*-x'l,'1&'g7eah5>b%WxZp%?[qr$5vs(#Cdto%Soou,&N>G2[w$##qnu`4*r+gL^&co7>HZZ$RtC.3Scxq)+goF446+Q':oJ4;wT[5/_?Kk0nm&s$71tNGo5uNG(x9^u9SVe59(%N)<9wC#2)$Q'orG+`En$SV<;B'',@%c4Wh]c2NgAE+jJ[d3w;PRg%;ka*RqFX(x)8W&*m)0(Ue];2[x):8kA(Y$NwM[,WH7_+w5fF4_rRv$@W#(&INP3b0t2Dfd5[M0lC:K<axI+5;%d%?^XkA#IGb7/KD9E-rCbpL8WMf<M?TT.d8wK#ovie$@q@.*ilWI)CJ;(=k@^v-?ArB#Sh5<.6Ou)4_;?kM_[8%>E7Q@-1tim;CqtP&vBJ/1)>P>#Vr`_&'mt#J]wV?#e/wS/SOXO'Thi?#jsx1(,BQq(UPwS%ipvSDnh/[6[DVk'hnYg)1SD2:W]cQ'7####%&>uu`(Ds-0atf*tBAX-s<,wpbf)T/#S*w$BYsj$EtUhLo^m=7`h*9.a&PA#5NQ*5rBc1BC_39%5%;',[IrV$3_a<:[L(%,2j:>$Btgu$igc'&_)]%%@tuB$v&PW-Q^Uq)v//:b,L*N0hK96&hq8Q&ZohhLW41+*)UJ9%j;:6&%6&W%42h2((P0E>:nk)#g[P+#C62[%%BOZ6EHuD#tm$>%M`:tonXZ=7#@*u76t9sfgYAf30d%H)=RnDNXgb`<9n%(lCO9u(M^_G)bDVO'Z&=9[o%G9['kTYZj#`]P7O3eMX=-##h9$I6S;ih1[I8.*iQE#.'K08OEcEB-qH;=-[Hg;-UA#dM[hrr$Erg&l1k4GVIv?D*O5Ya*-4Hw>sOl7aecSB#_Nds.,KB@M'mn_>qWK/)2Z&dM5K.IMR4/GVM-;B#MNu]u(TM=-%Ig;-VA#dMU1$##^/x/&]Jbj4uJG4M='aUN*#Kq*WoANT9`PWOjsJfL11uo7;.3NP-$@;R'5kxumuCs-b?D#PHE7k$PxVMNx.:EV:c@Q-V`f48FBwf;Mqge$SFm]O,rJfL-^A;Q>%?$Dc[b8T^vdU&G.M68d[OZ.Dljm*`o+t-n>gfDT>O-XEX'g%a$Nq7.rhSEc`N&#wZMhX=+xe%XvXE%Wj*CRPn:Cc/[2E4-+ae$?#+b*k;-<-<Y%u->,R`M^6/5)[Yxn$T-&496FV)+WdP?.;IXD#X)s8@Li0^#XZ1&&?)FJ)uN)%,cu:m8)%%BP4Fqf)a5Sg3?wLw%sV2/(pZEM0h3@n08_Y)4_R(f)E`5lL;;Cv-gc``3r4PG-RAjf%%*@?Q$B,%,39][uQ]&$0hFh)NhVnH)UNSV1W..E,>X=Q#a:71(0Ott('Rug(_x:voW[$##%)###k-A`a.Gii'/G&4;8U$&%I<FW-<x5H49+lo7vo?>Qot2<-OBTgLRM-##;j6o#to^%M)O?>#R4r?#7bj-$7]?5/$;Ls-ak4D#:Os?#JC[x6[UiS%T6EigNT</MHY&<R-=U99h3;?%M+)?#T2vR&#Y150P*u31iP$8Rm@051HVPF+T4@s$9BnH):O/m&,Vp84?PMs-[qU/)Ne__#Ylc=l]<0GVHqco7r6[c;O:Om'c0bO:VX@U/ZkRP/&Cs?#*@'E#9Co?T1-s^oC.@x6X/bf-U#A0<#=&DaaCYM(d,cK4S'49%^1^J(IZ4P9FncgL*om8/8e3:.l31V%@KUW+8CX4:3h^/1FR8P)bDVO'X,3+*-F)[,RL<7)j7/NK+Qut$rYv7&#luC+H%[d+m^#l0F8pt@*28?$#&?T8`f5Q'.uUJ:TGXm'RK`l8*E<_45]U@,f9*Q/;JjD#TMrB#IoEb3sJ))3WcKEu?.=+3q-q+MYu;9/@>?p.BTIg)Q8](+%?i*kLm/a+#nBU%CFHE+bKWW%$*-_JNa,8/;FR<$s.]WV-w^T%s5]_+QOR$$6T&&,hk:J#?Z29/V<,Y.jjuN'F4:v,u[PjL5XS<$$NQ<LXTbg$<`/E#ed/*#&Ur,#E(DE%7Y542q4f#%]p6d2R4r?#cJ?C#f9Gj'kiE.3JM:I$f4NT/Q'na$@lm=72q_F*O@7<.3H/,lOEm)4A;vG*bfaWqDtF`#,qIN2gW$'$Ph;v#>@:K2J>x9&K'Yt$2Y1Z#U,7h(nwmP/=Jlc4_KD802BQ/(X9Ft$*BLV%s?c/(>$+Zu(Ap;.JXqf)&tOA#qV-<.jD]Y,:wi[,x;2N9TAS510v0[69K&[%,%ss.%epC-A=iM3=[Wp%J(YB+J-mZ(=+r;$@6Gj'<'b7'`mveq6=3q.2C6G*6bJ30o#,&#&+hB#ulxXu*Ps+M5#bp'W3AW$[[%<-`n#l$>R3AFFicYuqc9Y$L-gm&EX@q%UMN&+;6Zd)ckew#nonq.ljTu$0kv9)S*Mk+8=H)#%&>uubchR#DaR%#_$(,)?]&E#)4'Y$l5MG)Z/uZ%Yj->%5JcY#]J%5'+_hF*uA3_+F0^2'WtlI&H.)ZuV0*Z5.&qS%`(5Z,dMhSIiC'F*_nEm&sO'b*ndR4INwm$$8GQ%bixC`av#'/1kVbQjLlw$$g3YD#STCD31A$<-je5h%SnETB7Eng)Dg;,)Zle8@/+a*.SZg@#oDMZ>C2xo%aNJW$,S+K%=r(?#',pG2sU):)U8YE%<]]k$mSc]uS4m11C9vR&$D^`7Tf3t$;-*I&&E['A'-W*KC8d]u:Xe<$r4u;-T&mR&qx8;-u0hpTdTj$#ipB'#Xv3wn`F1p$)g^I*uWnb4G.,Q'dL0+*cKU&$rF&@'kq[@#^#1tB.WumL(`>W-^oo0#C1qJ)R^st&aBb9%Sl[w'_g5?AO=[L<f0@'l([E[,%8wv$^&?7&of24D5ERr#i@S5#x,Sn$DrXI)<;Uv-Vh^<LS]dNW3xc<-`:X+&b<7f3'b*G4dbdlL-uU)3OR>p3]]WI)''p8%t>tZ#(L%g:)m@O;SY1W$q)0[#d649%pQx/1sX0K26^;V9DGeg1W-ZO'I[Ep%Q<OU($j11'e)tL#N;fv5C_39%<3mA4-H_s-j_*j3()$',sM?I2=uLU'OF@s$8U>^XK8v##$&>uu=?%C8=CNp^G+ws.gc``3#-Xd*8G)<-9g80%(Fa&)jaBD3Y-&<-%a/0%7B0ZeH38G;eP6dbdmA%#+kP]4'(1o<I>KUD^m9U.+eff11xS0%lPV3'TY/^+#H<ga$^%N8paOq&t3ts8ktuZ,-fT58Q3F9.(AP##;W8a#%,[0#Www%#hQk&#m,>>#^`WI)1heX-wf``3nq65ji>lX$o.OF3*.?Z$3&IF<O[P8/>=@#P9['/LCOIW$muiILdDDO'0DXS7Mia1BR,:L#W#xd#PEIN':Wb.$ES/a#N9'U%_b,jBn.7],r%o5'LRFHVPshl/k)pg+C_ws$.svV?66,HNw[w%4LP6.`wPN9``v3?)QQjL):2Gf*>?B<-*1Zt&PrU%6378C#Al$],34p_4]sHd)*aFH',gRf<o]]/&Q+=[$Xe39%[GWa*6jP-2DeX<%0iJh(^rA'+VLSucY3PDO@CtYf,(pP'$1mC+oGGs-#EeTMvtJ,2Quow8`>JB5P7QP/MKX&#$Y_s6GH24#h^''#.^Q(#HPj)#Oi&f)Whi?#ax;9/GOG,M;a*P(^m6d2G#'J3Lv2+3lxw:/,;.i1j50RLL.J&4Omd)*2`NT/]bv%FV60U%5I5h2+gh>76E24'7g?T.;s;**fC_S.*TuA#?jRN8H>'32bxb[,xKdC+dEbA#vf@[u#0G8012Y/**>SV6$gc'&a`+Z%Q[iZ#qF6w#UF^$54HNf<%/u]+QS1&3lNa:.'E9W-Ucm-dN-V&#R8[i$.1U]uj8TdR=N@%bUp)?7>8#L#xZu##bWt&#<>N)#F4Xc2%M4I):2Cv-gx[B7IFKQ_C-fu-$Z8:JgK1S*.o+oJ/fQ_#mG)?uZs@@#T$BmAg)BI$q'N`%'(U^u2JFG2X<H1ghWR>M,aPG2]fiILu+OS7JJU[-ZGPIiEJRmKSQu/(cw`e$5Rae$<O_v%aeRt17Z3Z$xRS>%PLr+;3TViB6Pp'?Gow*3Dg.2+4UL+*lx3V//Z8f39OnA,NG9;'X[lm'W1K+*IFuw5n@5c42MSG&w4qV'P[o]G5qB^#)rHeMa[34'-Y5R&xDlK1TSJ#,:(r;$L<>N'BWuk-J?vV)*16<&IEYe%VeWh#Gj9n%D$9U%:D74'#P2O=wdJe$7.`k%Wgcj'PF@w#>1.<$<[E9%0N]'/aO%@#M<V8*(-:U%FPnh#s)mG2$&###OZ>YcuI@D3l>,<.;PZT%nH'R)c[wJ;u@u`4dSPH3&(]%-Jtr?#M-2B#u.5_ZW.+HsPpA'+Ogwb4WX*jLfxJnWd]t=&fS,d3M<gK1?054'#'k*EU^#r%XnW_&;oF&#8NS]$+QX+`GUk7eUi8>,v)BJ1Xn$##6/QA#xV_20]#:u$a]Q_#emR7A1gD7:3s<v<IT_a+(x_N(E+=/2h-R6'?w@F+wOk.)vRsVHat21`>FI6<rK^#.13g8%_fb^8Y=dIhZr_/)4bae$OJ_e$vh`e$F+i;-Gi>d$<[EM0Ej9=-o*V`$HqA(&tiB.*jAqB#wd@u&wS4'5@uLB%]4u;-q*:7'1^_H23bWf'^CTf<LS2#lpYkJ2r4ea.g8Yuu9=C`.&2e0#W[ie$sA4Q`kPl]#LZ1E36tB:%&VW/2al+c4No^I*$)Tu.NS8GjR9Vt.'#)Zu@;v7&N1D?#5V>W-9w,7*snHF.WQCX(d@.L,TBRh,e2dEnBm^s-2vK7BAd6$$N#G:.#vm;%xOr8.Rq@.*=M3e;o&72LBG[W7I=EZ.d9'6Me#Y*<;1(4+@lVL_5/CB#)d/N2KGbX(Mq:o*P;G##7NUR#W'M+9x6_M:lAOa*@m>gLT^]s$oUFb3[#[]4l]UI$DT#BZMx1g*/9F^OlEZfCWdKU%9?c5&<]CI$]wtx'F,1n%7C-C#Os/6&Ujtp%1+f$$1`jfL7xQxk5oO]u1oDF&^Dl8.+lQS%I+es-%-wiLDLi'#$)[799;Y)4v=(&?xBu_d9IXD#ox,-3ZF)v#(b<78PwcG*^;bDNcqZ1M6^(u$Bh`1)(fS5')8am-NYtm$jn8&GoHZnAVCvG*rY&%Y>,7(&N0Q-)pPgeam9R@)+;E/2Nb#[+5<,A#o:HX7%=BW7#M_>-sgH=.b`KJ-5LCC&BJ34'4D6.3xooXuw>),Me1W]4:E-)*(C@G;&_9Wh>Q(V%Rq_F*YRr8%G65R&DNI%%b[MB6BqW9%c's(,Bta9%R[?lL5r:T.bA;>$CX,hL9[=89L-mA#9D#W-lxm34Q54'+i9%C%94@s$]G-LMK(%%-E;nS%#%0#(rRn92PY[,2<4>>#]Mb&#LkP]4ERu)4V#Oa*k_e<-A.m<-iS;_Z_&aa4fFuw5?3lD#0:WKV9i14'1do$5GI`.Nv=DSIdD24'k)0s$Gqjcus#1C0wKP>#Mv.>-YkV=-GS3^-9/4c7WXC*[slRfL;-La#OSj)#ahrR8goO1:HdO)StE6^#sjwI-wCg;-/@15N'xSfL9bwuLU=u]%lQ8/$31wQNeaqR#:WL7#4kP]4aT[O%?v]iL1OUv-S9`$Y1EqpRY6kV74=JT'm`-aPW]fB&hvv%+&jca4e<%##05Hf*jp5ZG$f/[6?-YD#UsZ]4-[w9.$o7<-rb6I'W?VAR%fo-)s[g@%H7Z_%;'?gLuTe_'j#BmAml-['=S^U%$+,[$6qL-)eZv*lXx?%bc4o+M.j:T7Fp]W7t<HxO-IBm/`E'7&?0T]t3jXkL2UZIqY#mV7E,fd2CXI%#BE^:%'W6C#iHq=%V*ecGEq4D#nZ&'7CR5R&6t3u6:6#^&7=1V&EQ^O0hG=0(ta#p^%_*mLEO`X-?U>'$6X'/LDZ=8%S%PV-Wk$##^EZd3UDjc)%P,W-upJ3kvnn8%P'(02uw-x6Ofk1)LBkh:%@Tk1`i4c42.$faNgSa+TIr-$:T&a+UP?nCpGFe3u[.),Kv?I2i/[03_a<M27QO',6L$H3JK2E4Xf2rm'-(<-k)'://c@<$n0P0LdRL<-;*n68THEh)d6KQ&n`%[#QaCx$hG?`a*gu(3^'%##V5/.M'M]s$h)iO'2k21&)lIm/#T0<7ZQlj1aSE.&`^Lg1<TGT*)Rfw#3VL;$iWB=8cho-<=@wo%@$Z-3*T39/>WZ`Mn'A`ahVDs77Q7-)u.@W$S)7>%Kog58g3-v?JI[$M2^VS@KOx*+p##,2nW%##O;gF4NIqhLsT+<30Zc8/mEnb4SiWI)fwbF3J$vI<<qcG*i_@T.Te_F*Xo[Q-Umhh.BS7C#;wHm16'PA#T0e)*`Y[p%GqQvLtU-C#<XA_u+IWxJbVLV.SGL/33,]p%-De21dXd>#:t=/(?*uf(l@FM(?3cJ(3O[Q/YbYp%p6Z]4P9e9SGwFk.IDg[6pwbO-=t8F%E#-'&Pc.j1rro@#1l-s$e1K'+j=+gLe3[Y#.)Q%b[PC`aq>:D3:E-)*YCh8.Mq(dM8Qu)3=V&E#5IL,3QKnb4eRYI)EAxiLODlD#DfWF3nsfX-vJrr?DF9=%<g]],tKOh#Klaw$D,BE++`7@#V2c,Mq$&-)#Lhv%Kof_1S&iK(ae)@#JGP&%uM+1#^#@s?'@Gk'j]O>#bqO-)h;GBc,PC;$EkJ##NM7+M=FetLJDE$#dWt&#[JsI39tJp.]H/i)nf=kO:ZhtUHbUk+[4vr-v@7Z7CM5>#/=0E#N]w-)]*lh(HIFK(*Kcq%d9Ql$SKn<M>M34'cv7wq2=c2(jGMZuQ+`Zu#D+s3&>uu#YfY=lr%.GVQiou,R[$##sG/mcGsiC$>_pg%,W)#(S_iC?mfwGZZFblA1xF]u#SbA#xrGO+r&/d<plUC&2xnC&Mr$N9sv2%$5FNP&<?.S[-C)##JI3Q/cSafL>;2)3vbLs-dreA4jS[]4Ze75/s?id*O,Oa*8HjgL&RJq.`M.)*Bx4b@wcE_&EIg#(=wOw9r.7.-3wtkO8FiHQ9>F_1IR?wLw1K;-cmbo$lwrY#hq.W$VSS#,5'ct$@IRs$7Vp;-14;t-iS+JMQ>b+NQF6hMLqq`Nb6]Y-SD#C/g;&Z$I.roS[>(5pcU+p8)T.5^wXtA#d]H$^7%<s$qsRf-_o$:jK`/kXO0XT.(?$(#,BhW$:^KN9fNc)4#&AA47NhQ/ekj=.cvrI3s&Ks-`$UfLL*2x5l,K+OGJoCsnTFY$ii>l13&C(,^'.%,KXZ&OMog9)'q)9'`>Us.w(m^=>k;r7hov4(fwXg1W5+%,W>Fx%(l2sf_?L-)-fs/Os[?>#8GQ%bj%D`aLcDV?3UkQ'%e75/[5MG);/5)%ab@<-;U0@1/.W)%gI&&$w'YY%xaNr$B/&?5uOWt(&8j]bR;6@7A/4*$Yq))%KN9>$c1oFMo:x4&OHtx#;0XR/S-tm)mE8%#$%$$$6)L(afV-_J4EMY5>bSlJ5(mG*9Px^$/LA8%q)YA#oU65/iXSh#9'B8%+ULk+fC587%C[x6g-ikLMS<^4?F#7*?Zc8/M$uU%>o;',]:]i1^i8'+gD?r%rt=U&MBK2'js(g(0)cJ*aYVo&M5<a*O@Rs$o`.d)RaGN'>[U&5ps8^)gs+X$6RCB+&rO:&0bQo$l@^&+jb`V&IEj39uu*X?ZWg2'@uIn&2[e>6KEYN'u5*XCF8oP'617s$SXMM00Brp327Kp&/f&-)-l4u%IOBdkj2#&#09)Y(TG[Y8<;Cv-1]WF3GU&v$p;5j@.H6d+4?5A#xZmr%[gxE%=r(?#Q;+.)<POS7Sc5>#G0i0,s+`r.E[1O+-3<mf*a4jB)g>W.S;5D<BfST%;S0+*J29f3b>dc2L;Bf3-K?C#]@[s$dBXA#?t-u6>]qv-Wc]Y,uO,G4sXA['9B$j'J#ID*'dWI3UK-.67*;mQPefcN?+:_#447w#/fLv#^iXgL`8h^#T>D8&?/kt$vF]E--YL;$:(`v#<'E'%2f$s$1Qe@%:R/m&Tu[fL?@ZjBhkm$?dD24':FI<$3Sc>#I.Rs$;Ko9&6t3<$2#29/:@Rs$2]T?$A'gP&5]u>#LsAT&=(Mv#bf,Q'Y3n0#R)###&e_S7]Err-l,/DE9XWZ6L.rv-Wh>JC7wAJ+'q@X-c4Dt'25A=%2feGVgdLf<b+Vp.EU@[#vtAU)Q_fCMZT49%H+i5/4H3'5/A=s<Xs9B#$HMO#]D;iL:rJfL=WI%bt1^V-`MC_&t/k$#Tqn%#+,3)#Z7p*#UKo8%h$<8.X)hR/(FW:.p1[s$EM,J*e>K.*q=@8%<:MH*Xg$H)ZM3EG3lY:A>d5g)De,$%$G`:8$pdC#McXq&v@i^#b+KD$e6ff1-a*jL;g5K1,9h^#1lj9%77gHs;:E5&L)G+`93v70NWg=H9B_s-060J'G)&0qZ/250Ibhf)&1*:.-8._#2sDUSgwJ60KnP,MY^h#(r9Cr&RaPn&M_#Z%N#ta4ooi0E#+@eu^Pn$,9G:;$52qCaoUw=cdB&/1u.j+Mq5o.*rE->%cJ?C#]S0<7*<7.Mi.S)*%cE<%*f@C#xUME4O,k.3wB[F4ms)T/[tPn*VC0=%qwkj1SpVa4jJ1I$['UfLoYvp/d]<+3qa&],f6K$.pmseD:BlBA]Fn8%Jp+98T`e,;B-Tv-viti('mdJ(6tGu%kXbq&BLNp%L^K#$:r@u.r>q`3%+6,*3=<p%,MuY#;a*=&mVWa*_J28&2l_;$8F3p%HkRs$NBbt$FrVP(C7Rs$][MZ#jC'f)j+fL(g.9+*6([S%/EW.-dgO5&5xqV$V,i.<d^oE+jRJ7&`/7s$bq&U%Mdc>#/mqV?b[?5/`7]/L'>%@'K8G>#=%8R3XCn8%)4-?$,DcY#,[Dw$i))0(kDQ7&8jEtCfN]NkYOWP&E'=3(J#e)*rqtgLDA1f)k.fL(i7TF*fE-i20l$W$Xdm(5VgxE+%5YY#T^8I$J2w.LL/[`*&,*n/X7Yd3x9%J3$$ubdf$ZS7NgSa+2oo.)ew,QSp1^Y,c>.n&9fts6J6g*%>`*A'N$J'/Yp`]+Q@4E&Fw(<)`rO,Nx7$##M.*Yf&/2'#RI5+#c=G<gx1gF41mWI)kFq8.hY%>.$3Tv-ULit-8=C>?23^G3#<Dg1]&>^,/>m8/j?lD#jX=MKRTb05s?+>'be#nAn-5X7MFf*37K$e<TM[-)b??P..RRp.AR(^#[5Es.SH^k07_VV&M(^x$_YgJ)@LlA#hGnmLvBu4:Nm8<7pOSr%h_Hp.Qf+i((BSY-u_NX(<ScO2NadN'=.A[u0BSY-R<3-v5wYucm%`c2_*%##?f)T/>;gF4IJ50&B)?T.G7#`4F]'n$WJ'Z5jCXI)^V)w$Kk'02<TIg)U5WL/Z9U41Bgc#>joT3(%A&t%QB^Q&B`_e$W64b+Q-;1/J'(,)VG[^7-^&f39c=*&ZWk5&iobPTGfm920jn928Eft%:gsI3/E%D*?>N4'SPnWJm4jR#fXL7#Gqn%#3bJ&ZA8xiL4BF%$MfXI)-CTfL@fd8/Q-Tv-XZbA^k*clAn4sILejbA#$%=V79>CW7:oMGB&*)daZ'@:lQnvcaWs[.MQ6S>-*qbr$cjLN0BPj)#ihc+#&*a?8?J14FJU5GMje4)q+@g)=gxxc3I@nRAI#ra4N;Rv$lf/+*mb[q.gc[:/`-Jh=5k+Sn'Idu,xq;GcVXiG+wOk.)TrL-)XYJVM-;Y+H1+lA#P%_m$_&+5(K99U%AA]'8%CHr@5$XW-hv*tTd'Iuu;m6o#<WL7#Nsgo.Zk[s$L$e,*0g5F%g4NT/Ilo^f&N#)<.j(9/?Fbx-F@Zo$YFS_#Xirr(lSl]#Lu)C&u+]]4lT&],fCke)&_*G4O2T$9pCI8%;J64&f7^w%@+Mv#7lCZ#KrbjL($*t.cY$@'Y*sV$5_7K:<A1<-L4,U&8%DZ#OU+a=.TqU%A@`;$_8m3'pN1T&g;X<7_Hoj0u@#a$q_>,*I@@W$6-<V7:fd),;.e8%sH7x,Eo8N0`et]>UclY#6YcY#tVcx#G&bx/C:@W$-IJR9csDA+YVP>#B$KQ&Zq3m9N#rjtfq;##OuIG)JC$##12-p%0GRY>g-)H*SLHdN-,ZA#O7%s$GDhR%_$DO%Cn0J%08h*%oQS6%xCiUm.(YK1rY)^4'WwW$9?WmfGBPJ(oTu?0WihJ)_i^=%=d)9%=#kQ&<B)^4G>oJ1j+2KAqJ6$v7m6o#%XL7#h2h'#R1[K>L+<9/5IL,3Tj9g)7r=$%$:r.*H,Bf3?;Rv$7btD#u'1F*;N;E*w+Sc&Z?3AFJ-)?Ytxe+>$a6W.UK.'5uri11ic5h:dmBU%&L>4Kkce],WsaK#kDX/>Hlj#511i+*0+[Y#)Laf1QYr.Lf6*20B8]Y,I;5p8Qs5'Z'r>;-#[Ro7Pgv9%4)d8.jG&nf&YO]uI7@m/@<CNKU(x^&R'2.MOW4?-IuhO&SG:;$3jX+`H:8Ycr,sjtf@KV6vDEjLHZ/[#iHX,2.hPcMYpv)4+opr6E%AA4#o6x,F.Ar70Yel`m'.YugcHZ$Gk)39(cZR(I_$8'I.rZ#)@DW->@DX-T%+=(NuBj?&XMS]Z&l+bo>S<&wk$T.LF7w#3X_r&b)==&ZJ,595[Y,M'oPv,B%hf`[/u?-ZHg;-EwaZ%FG0[$c^78.,s:D3ls(nb)'PA#w5:.;'qq4baKh,)N5I5bFGiB#A'rauo121.%YMmTdW$lL)j9`Rca6##;j6o#:WL7#qpV[?^4Oso<qjLDqp0B#J#G:..17.'>;gF4Rq@.*b&?j0><CH2hRN3l#DQ=lMwUp/SQ^6&=1&pAVv3=(L=<tACM5>#$%iI_%ckA#Tb5]5+Sl##EK'^#Zk7-#Mqn%#(WH(#X=#+#2A6R;GDmRA&muS/e#K_/l:9o0s-UF*AIbXZ]3Q7A+]Kh5&g_T.sn;#l(JG8.,<9U%NvT;Q*+0t%ai_p%bT)u1S$4kk+j*.)>F/2'>oZS%eqB2:O$EdMsV,W-DHIe6D8#sI?RD@.uVP&#0eLj;QSm%-$:tD#tMYx6Y?&s$+j:9/R?XA#OHOA#cIap.D#,G4MX-P+GcJD*8YoYQ^SSh#d2D;%]Y]#,Ko$s$V`]>,CWA=%NXGjB-RZd3UG#&,G-0U%VBV_&SJl;-*btr.?Res$3G?x0RqhVZ*Te8/a-H15i2j>$/)IW%Z>uu#72hCa<G?`al(FS7lQ%##ug5N'6PIA48AC8.'Rs?#%S7C#2=#;/;lm=72nL+*l*mVh',Du$NCww-XFK=%*)TF4[5ZA#`f;K;%=LsH,d2>%p`vA4I6Cf+18le3+[c%$==e8%P-Gx#TJio&=-jn8ETF+5bE(K2H>TP8[kw4Ct1>$,2I9Z+wOk.).BfY%OhcRAojnZ6>iJQ*2xq;$nwnu-IBG/(`lwh(Eb>o/)Btd*o)%6'3hm^4vQPj',<Td8Do^d4GQLE#j4h'#i,>>#a3FA#l05i;-,?v$O[Y8/ofE_4gc``3+g^I*Z/QA#hpK)3FH7l1XN]s$AU-Q0L37thJ0+s41dj?BGgtmLt9wa57i0H2WZO#0g7PB+Ax:Zu$hv.-/qUF&QC[s$7^bV$MG'MP_N1C44V%=.bj*.)kqrw#@mu8.x>j6JB-1rAJV+740aKB%a;_u$#X>m'gO^2BhuTT&RtY12dU0]ACOYS7%kSP&Y15;-.57A4H/Zh'`FZqA19;H*.0ob4S9Z=2qA;^4RMn;%?S<+3[F9a#xufKct;8@Y@GTh#+kHj%t*]r8KtD=6Q.Ms-r1Fi(ZKnV7o'^:/)ua]-tFTl'(8.GVD*F:4Sf%T%,mb`+@C)-*%d20(m1,(+3TA?PC_J2'LUj)Fk=fl'@a,01ug]%#b-7KWD8xiLf2Hj'A',T.?@i?#FX%M&XC[x64%no%pv/V'gM?e5BusA-SjWnigHN;$O6<?@K:'C#Zl^14`Hmh2lGV>5CZ?N0ZJqG3NgTe*&)bo7xslcaO1u8i$;D'#*Ur,#^vI1CR^u)4/rU%6h(vmqHn#d&O5)T/pnmDEo7Im0%OG,Mnec-3[cJD*_Qvh2w%AA4iX1x5l+Bf3@r'+*D.Y)4+0q$l'Jw['<N)H&hEl;d@V?1%u2@gLn5;)bb<]j0hOLs-F_nS%Hkjp%[ljE*Fqew#=1@<$?FIw#R1h0MekIh*rIsQ/cRWN'6xET%%'7?%b]$s$tNA30.:>Y%Sj(0(7_P:&B$Ot$&G%@'hE^:%wh=n*U+_)Nix1'#XMpn.i0gm0p['w%;rPv,N/ob4WeZL;*upp7Z8Z;%+scT%I7&N'f0qlXHFtI%%oN0caxD:%9Zl>#kLGP4&&>uu.6pE#AUl##nVH(#]6E:.@.ikL;AL+*`Ld5/Ga?['B;gF4jr/+*3ZWI).e(6'jGA>.bhR@#4&o5&OgF,`MuKB%wq6N)n/F2&3;IgEkG_6&m_^p%B`5-vtc;#cT>H']`n1eZ0l[p%'luN'_hCK&4o(9._jc##_<Js-inIfL7mv##oYT,.Z^NOBTG5s./6$9)cYDD3jZqL5E+Fb3Pm6/(u<M?pCdkQ%f]<9%Ik8o%DRVKuGwa2LOJB]VIlHs-odOgLmKvB&mpN?M0[<:Mn/x2NJ2]S%P1H*R^4%_S^aqR#A>^832l:$#lvK'#F]&*#Esgo.%^mXR.$eR,m)tp7qmmDc.1xC#tO0&+_&o;]T7-##$HL)<UZL&l4^ph7QPoIdtk:nA_RcofS-8Q8??/X%dt-5/n>f%Ffujo7RoL`f.ivs-bk)mLH[7C#mA$3:Eg9'[:W64*$j`''Y%u'+Sn1KC^_cA#L0Wm(<w9g1FRu/(qk*onZ8-7&UCPJCZJDd*#e$iLI(9$($w)c<WZbA#<7*T.Lc/*##%<Z)(Os?#7sB#e=[kD#QdWfkI<?1%_@AC#6gE.35v2^4qGKm85U:69$$bY-*`Ec<eNOp.ECbS&%`8U)=^0I$$AcZ,UII2Lxmi0,o'q&HA;B[S#HIlfU@sXcc9CZ-F2_r.uWo8.dL'p&iuTp&Dh(-MIn5Z%P1=s%,Sr,%js^B%';G##;j6o#&XL7#EPj)#cUG+#$2QA#1;)u-Uc(69G[X^,E%AA4k1G_fVT4J*33w,*obQP//p^I*$sun&SB`Q&f:_298cv,*@wfM'[.X$3dew/W4Rp:%Qe3*,`lNa*e6_HkDeoZ$H@aN=/ELKEdNF5&bOml/=:*ToRAj6tVH6I6-9D60g@AC#&Cs?#n)=-vU#g,3$)]]41$B=-oN/(%e>XWJ)@6%/+xSfL=?/cVNSka$G,xvI3%_h9[`Z_#8;-`aC1Sucak-5/SgRpARFa;7f8$G,o7,G4bxS_4)5K+*9VW/2Bl;d%INnCs0xW:,w7G/,Va&v&]ggQ&EFV^+]v7IW`Yag()*.,=vhn7nbL>DkZKx>-:R+?-JQ+?-Nm'<.ES:a2bk]a+w2IG=0Bap':+YS7W9*9&wDYc2b51g)[F,9/W@n=7-:3&05IXv.Y:P2(9nS^0?ZCa+Crx1(K?23XO_)w$8GQ%b?]v@b^6AJ1l'BS@#:;VQ6-`.3l&U:%?]d8/A3ed3QrSfLeK/[#RUp+ML(NT/3)ew',mQ[''4p:/O1[s$lD.H).t`e-9Ak632Jke)-`/u(RkRP/+R=g1sO,G4hCXI)X9])4'mOjL'ml]#pni?#M(4@$5v4[9*ZVO'OFUkLPVkD#)^f&47,m]#>t.[#i&`k'PEk]#O$uD#BhoM'CCrZ#inuG*kapi'T,QR&5]G>#dm9[#H4H>#+_Zh,^4H?#1B@&O9T(s$G?B6&9Vu>#lhll(R'FX$P-o@#S9^6&B(2Z#F_W5&^V)w$PNbX$@Md8/J?PD6p_8Q&A-53'#:KhE<,+M2#>GZGm*-r%c^amA-9(h;.YNT%@9p6&?T^=-Qfhe;2PI<$x&dQ:Z@t4':YEj1&IdcM1F&g4*RhX%jI$r:FWR+4;]G>#YA0D5Y<F;$TSRL(let/,ws:k'u([7&9AcY#95b]%NR3p%w7J1(M>TD5II0Q&WJed)sp7F#%#M'#%2PuuDN'^#pj7-#-(;p$7?VG)#0Tv-(O]s$[HSP/J5ZA#>K(%G^1]v5R3*7BI&_W7dv@)GjnBH)Ym=]#jPE>/Bqmk'IXEp%9AalA&>dF+H5P?6L#;Q&jbv@&LBHT0:YtH),r.W-r#weM->DT/R[$##`&/`$k>(u$cS5f*EB0<-_Ewa.nmre3uKH12JQx(<0(3*g>iO6fQ+;mQY3iS0X9EC()Bm0(TmYW->D;eHF3,8f$peYQ8%OvL/2^U-]^0=1%F#q9<M6fXnD>&#Nn2#&]BY_Jdb4V/#05T.WD+G4RMYS.PDRv$D77f4ksBC+b>A%Y?(`V$eZgn/VR82'fdY70C#L/)dxl;-`3B01is/q%54Z?,NL7w#p71lL,vQuu6m6o#@WL7#Uqn%#@dHd)Iq4D)4%mG*i-M*i/<AN%LO5L(eeDX*[#N%Onkn@#>naU=*JVda_$oQ0Y_$##-Z4@&aitwgdTeF49E6C#BbSs-g7+gLlSGA#4(XD#N(p+Mvw'f)Fheq.O;em0@d7l+T^&F.VfWF3w%AA4mP1I$]u)Z6Ti0F.cG+=(8Ze*7rx>)4amdA4xd89%-'>)6Sj5V%9.7s$Mh39%aAxfLZd=9%m@sw$A%Pg1Rp_k'6LdG*TbNT%SN0U%Mhe<$+GcY#IL39%E$^2'6x_v#0i_;$Boh;$*(_p7D;wn9k,@G=Q3Xp%<ol>#:CR<$aOwK>w$Km&;%2v#P5nd)tCkE*qox>,csGn&e)o?9gCDv#P[&Q&p3FL);fP>#6:7w#;XW5&h+'p7'krSAMFfv.fY]+4-ip0/)E6C#H8Hb%0@%lLIE?P.s<RF4HtC_&KB%@'^0_fLpao8%,-Y,2G&e)*vW?;@l$FB,nN%],,Xvq7dL:a4*BshL$mE<%?7%s$spEs7%;CW-=XGN'+XGB$^j1O']+cv,3%7W$7r6s$=nxi'2x_Z#buA*[jjSs$=_j5&[7G?,R?0U%gGF)+?+D?#u0iw,TK>3'a+fL(.c_V$OXe]#O=r;$P?1g(I9uw$=RY-)>u#t0P3]s$94rv#:1wS%;ca#-W.ofLT1fS%=g3H2:h&q%[:1w,TQ6n&Cq8q%Y8%-)e9KQ&mgKY$jha9%A%6_%A1FR0OY+Z,Xf8^+c%Ts&@Qf%F#CNW-1M_'d4XkD#Eflo$fGUv-jUKF*t?(E#qTPjDY'3iMJIr9.*%C(4w><(Z^Ks?#x3vr-1/u58ep.73;G,G4tx8gL4<@^$(Ncd(-McY#<Xap%idTD3*C2`Hq5BW$CoLZ#NLws$=4.W$9+.W$><Cj$;x?s$,Gc>#-DP>#<_Am&Bw3]#V-Wv#D_s5&@t<x#F?#3'D$k9%X1d&6.SEH,47wS%0;@s$WRH5/ZV^r'7&xY/_:]t%CX39%O6vlCRh8m&:I[<$9ruY#G'PJ(8C@[#8fuY#;`u>#q4Jq;q3n0#SK1KEhQN$#U'+&#jWt&#;Y7eE3l=p8Ds'?7Uej=.@]WF3q(m;-,`[F%OmWt(TGc[PXp2*'E_/V8K^,g)d^L)3Q034'S5I-).Pk.)advL2%k_4N:s[.MtaZnAmBMiLe*Yw$xMQ['2[9R3&h`h,x#-q/bYgV-:MYn*a$]m/mQ(L5rk;;$gaf<-d2;P-dT+,%A_Kg1,G>c47L]s$KRPQ',KeeM;:6>>$iCPDeiYa?Aq8q%v@xw$;%@8%urhG*Y83q`m>:6p@<hm&Fh7[#_q)Q/e/Ug)#Qu(3&Rdt.^7^F*.D,G4#/<9/;P*A'rFlSN=0t?#N2@d))Pp;--<Z<-L%EE/7aBv-06o;Qo2I1gT=,qBlpJ%#gRe+OAn_v-Zx/+*w0`.3:>SC4%(/BP0l3@$+$Ev$%K2H2u&D^#H*pm&cFrv#`mIfhJk@q.EQYN'0:v']F.-q7NZ6C#un`v#fLB+*C.R8%X[x@'(p*i(th*onIo,&$`)1'#(AP##B;eS#4aU7#K'+&#<Vs)#8nYL1*W8f3/p^I*jpB:%j]Le$HZc8/HjE.3jiWI)WSvRa-tbS'RK]@#onDP0YnVM0&6RH)QtgfQqm3Z%)B;okojP,2TfBF*B0m]477B&$*K8bQ>V'60=`3j1eHqo-VX#uq3,6uqR-<p7o]i)+/PNY5GT_g1v'7x,%@'E#x.<9/gCSfLh`iB'Kf)tKNtkj1:@i?#'Vv`4*]S)3KnU0(2RUG)V52O'H%I8%K7t$8dMhR'J:i;$S$49%O>%P']#iG)lR*dt5U,m'WXR[#FE7_+F^u3'>bS2'Xh$KWILwJ$dHgm&2(eS%F(2v#5H*XC`JvpgljA%#Vxq*Oj5Js$)%=?1lS[]4h48C#QE^:%M7kj.Xe75/`U@#N._FA+2a*]%%*'Z-84.<$a:e;%dsXOM;=BGPD1cZMcCf$$j%a[$5A%q/8u:Z#3`%q/pvkG22xO]ual@h%QJuuu:g-o#<^U7#EXI%#98E)#sBV,#mJc8/SP,G41tB:%sp@.*IsJ+c1=+D#`xjO'&w]Z7$hn5/RLqhLEmgR/b`]9/.H6C#3i487]Q;wg4(7x,6ESP/e35N'/toc2d&SF4uHNs$M#2O'4jrK(8>d_&T(^P'+O)e-G_bqIuRBW$5/KCOWmdR*9AIs?n;Za3E=gq@Q;RD*41@W$xm.fj%'(Y$g,TFEb:eS%ad1E#q1M/:3v:50L0_ih9[-C#+4Dj9-)9407X`w,=HTK1b`m5&R)VG)hqb:&Owp?BX;h8%h(3=(5+V5BW1[S%+le=$f4P$,xSlT.r8q'#'@./&A,g(mXsI:72+TC4lZ*G4Kk@5/AMko79]5s.7:(^#<DoYQ^SSh#o&Pv#GIv>#nZ3#-6x$s$HlqV$bbE5&gB4w7QolS/]kT;.[d@Z$tI^58lu25(I2<&+Rf:Z#MC.s$g>Yx#Rfb;-J?F]uS<aN&Oa2r)XrDY1bJuuuCG*p#_(Y6#EXI%#JuJ*#3*]-#B0#dt+]S)*1d(T/xg;E4nVe)*5?cc2%Kc8/x<258EKjv6ROr_,3E*I-bCHTK,P7C#$Gd<-s)T4&$2K+*2ncp%UG_]=1IlQ'E(%s$Do$#'_SF;-^APG-J&Do&a]vR&'E@`Ap@>$%le(%,[d`B'MBU]'+Yd&6R`QI8qeKN(1(^P'pZa0Gr^4oLxLfr8+*R'A%Ebw,1)no@*^8b6?SI&,;=J8+B;OK9S03@$8;-`a$*o._ftho.+00_6xqXI)NP5]6OoLs-klOjLX01f)BtX'Gjr)<%)Ck]#A3ev$C]R_#=bWI3:*YA#V?(E#o11Df`5Uw%&wpdOgG-3'^.At%RZ5$:keD^4*>cY#XRQ5/tonL(KnWP&>DcY#6AcY#L,g._?WZUK?#ih1x2hm&GqRw#xaIa+?xc_+Z>e*?$%ZZ5pTC;$P+`r.e]`4'&l&Q&DOw8%?7iZ#Yb>]ObT=)#l$),#:KNgZ:t@.*RY[I*i:AC#pNXA#0IH:7dx+G4n.;*%Lqro..2JAPDrZX-O2R<&gD6N'bH/Z-0Fv29E2_M:PTrA#JfCB+HPJ90eAZj'KK$q&(K=p76xi<%+8nx4m6#5AsB3D<-OH^pTg8V'=w4%7ec%H)*Lj,+9Ln;-(%Xq-fG.lB4K]T&,T39/w0.q7KaLB#[DVO'IKDbTTB4i*X4wW-/CEn<-wOCP_P_O95F4m'HP`20t0`.3vbLs-kAl9Be2L%Qx)o5/`&PA#NP,G4$@I1C^R'/`MO<tnA:@8%=IeA%:Rws$h^N1CWZv;%RGNa*j`EH2Gr2m&krxF4_@@<$4P###)6):3[ahR#=)V$#r>$(#]UG+#Pb9SIN6Bv-1gNm$d2x'(i5^G3[T,X-b<s.-qY>H3bj*.)Mu:I$k5Q)&I>*mS3[i9N>>`YQPAS_U2T/R.EjVS7'pT)N*>Q-()I+U%7mb;-.3tZPFLvxPbF6qQ?2%a$BqhA#B93E&e*O,O8$g>-L@*2'%5lr-9S9vn*S7C#o@7BnmGGA#XLu+DKCYd3l82)31rK_.U$^:/x<j?#A'@v$'cVE4Lk*.)ptC[,0A,s-rCFjL10M-MS)HcgvM39%iim5JJa--5)rB#$4=N2L<BEe-_fl-$^)S.Mjo24'8eqB#?Zw-GC_39%<KNsLTi><-HGP;&viou,BhG-Z5mpD4x%D'S(au58ud<1YrS=I-nZD.3xXmUA_WgJ)=q`ca>RFa+a#AiLvUoYM,)2hLs1N*M]AKu.&^r%,2O)%,.>T7J0tu?^ih3>'Q=4J2j<,LU+2r_&DkDZS8.r)4oUn92oK-bWqVuAJl*_)Ma?G0.4K'%Mu]j$#S6_c)6?i,)?b%?5aKA8%$c<9/%ZP^,[bQP/iq_F*<Nb)+-=q2(M=)rAg`P>#9;#j'OfED(p8cP9E$6/(/qvN(*OLk+(OJs$#Xu6*b%?lY=LG&#>&lY%9DH%b<G?`a^hHP/PW[i9+$?PAWw`uG<Wd`*LgR<-J=@LG<$+r.sJ))3*0=L##BqB#1N?.%PCt+&C)ZA#Mg8#ei(*mh;4dW-8qJ4rH@NfUvbj<%EQl/(pYC(&W7^;)u%O-)8MsILNgSa+9a5_FBoJf$=HY,%Bu:U4t'Tu.qZ;-*Bm:Q&wL/W7h[l<M=.Pu+bkP7_7Ib8R2%PS73jIs.#$4K3KT1E#g4h'#XI5+#CaX.#p:w0#c->>#EQHDe7tH]%DE+<-1s[a*xu#<-sl9ppR$2x5><vL%?e*Q/^idG*e'lB,,]WF3sN^:/wKv;@GT>d35kr(EVTGq;7164(Lkjp%GW@a$hn15Ep_G;-&]O]uHp'PoF@']$N,_8/J8Sf<EXn7RNus.L^t79%fRuc<@<R<&AMs9&uU-HNw_0kN0x*jNoEr5OAQG$0?;L+.+VF&#6BA]$9DH%bhuC`aWuSY,I0`l8um%##fpk8Vx'LF*j-UH69JeA43-Tv-mvdOKLV3j1b@;3=pDPA#qYOj11&))3W[oV%rn'02t^3O66NXm/8gKe$Vnhl.H=_YS$60PfbF]w'4rpf)D(i5/[@.1('B>5M*<jJ#=7SN'Ysu3'jbqJ#1*#<8H?Z51FX(k+T?9-%K:I+5c<Yx>-LFT%[@JU/Qmav6N)TT&$(s5&:Kx-$(*g#GQB9q%C]+d(R5r%4`o$0:NBGd3?29f3E5Ov$?kIq$:sPF%'8Zx6.j5,%M86g:^9L'YG']t-G(7s$p%]L(avSe$LFt#-/8k.)LJUiWk,1h$58oO'eM.-)@L82'OPs&+@RaP&OY8B+Cq]M'B,FxY^xU/).^v&')*6qV5c)t-FaqL;AP)0ZUiY1MA%D8.<f-<-ND&$2[3rZ#<&D^#H-,3'Uas?SL>q&$[uo'+FAl_/%mp;-_OW/'jPbafS7[w07u9j(.Zk584)6@d0No._[[-5/IgSc;/H&##hP`;?JBav6R+h.*AP>s-nhpb*A%sp.FV7C#DMD(==vcG*m:B^#RqvMVY9j?#.`6<-lHem%FRM8.bF+O4tD^@#CDRh(E$[D*Kgcn&WUDv#[okxYZ9F1DQ+;mQ]2Rd)@xkHV(f>C+kSu;.l:x1(=oHN(cB+=$:WR/&p]q6&j,(q%:]G>#_)?7&`K][#t^Zk(btw[#M6ZE*J6:,)CxhV$=H;G#8p*;0wTw31q0D8.@V`0>*)U:[liN**N9tT%<`mX-rPn0#IO3T.VN0q%CA(X'nv?D*?HcLs^OF+3Bhp:/:5Rv$7QCD3Yn^h1@Gp@%4fcYu(+D?#IZXu7o7Z;%$Okm/Q/%>%wVvA45>w#'9e]f1aGUFINNG#>)8FA[8vO%&<6Tv-khp`NaPXD#H.ZkOd$92'G9gp.()ta*t<5Y(]eAQ&uh4gLw=B>,/sg2(/(UkXwZIf=.wIX-KwwQ/d>dn&*UK;IWEd:`w$cWR.0hp*NrMVRL'wB=PZquZe)S2io&^%#`5ct7iKC^#12=a*#j_p7Hfa)>ssW?#M*TQ&e_ns$H3:,).hsq.i;+.)WHHiR#p5Y%iXFgLYdOp%Up>7&WGY$0Gw:lK1mJdt_*w##xUs)#k[P+#?gu(&FL?K)55%&4_R(f)M0$?>n/G)4(En=L#Qic)20/$n;Y[&4Iv'J'wwU<-@o1I$5)J-)mkjp%a*wIQvtblAuVdnA9ScqAeSFHVQ<B(MwRwC)9xvo%ZTXp%d[(%,3(>gL(ru8.O3jxFFZ/t%f;gM#5`</(vIZL22.<;$8;-`a'_A`aG&w%+LV@dFpF/q)g:Ls-/W8f39t_F*tQ=g1Bc``3.0ob4xS_R/U?9r.@5B>,Ghi?#19)noM6gc$7<IfP:oMBO9.r;$j_Tn'99gU+%#sw$B[a5&wCD`agHB/NI9)+7,e3.*hrIa#4(%<$rSo?P#-F,sh=fp/<0nS%6RSm&i.<D#KB_KEt$o#1W?O&#0pm(#(NA.*o?MEPGHBF/:YZ(+;9GxWwTMpLTTOu-,V2s*MgQW-n-jT`QcJD*@=@8%phZx6Ubs#f#`E<%7Wv.q7FlD4C]V9;HYoq&q5)^4Y]>c+jMS6)SZNE*Xw`[&5:Zg)+98I-5Fn>#6kB_G>,V1;S`$K)*1Ne-,Ttw&.Xm_+'>cuu9m6o#=WL7#?@%%#s]Q(#Ckn8%7GU%6=>:r.&ur?#3#,G4O*A.*0Zc8/:ZZ.Ogqg)l]0f(%c,Ur(8,9>&&'k72o(kg(OEp6D+-<2'i2?a3OFIw#&nAW$X*<?#>O#12?Iwo%AGhj0A4r0(A%S,V13C;(IBSn0XPF]$iTk,2iFSX%-m3t.k4rv#b'4p%K&Nd@^HFm')MO-=HErM%$U^A=?<Z&m?*2e&%rIt-V..+O$MbUI`VlS/aA,<-MQvH&83TFO/fXI)J]?@?q.rv-fOk.)8c$G()Bm0(s+D*N)5oH+Z5q7/dDHPJ/ZTj(U</&G]tY8/((**%x3wK#O*V$#v1m(dlv0H%:p2,)UT-`Gt2Z;%)ktQ/OF[p%(2.cV4kZC#S.6>#CeEd;9^e[%Q(mM9d&BI$eK?K1D)vXctflT%)@OH;jX1ebP=$##%)###X$5K1O,>>#fl+G4iT&],)=%%@$JrB#Z&e)*9t]5/CV>c4)loL;gDqB#8o4deHh39%$@_-M-u*R8t1m>#rj.P%GNqG)1NjHMx0SwB%EwS%>;g0PX5)n)rpTm&rB%a+Z]PMMh,0C/:WL7#:2TkLH,hb*09gW-G>d'Zx@rB#Hdx;'2xgHus:^+4:D74'8YN-)O`alA)h%a+-iCKMjQW2MAZSa+'fbA#PPh0,9xU<-waUs/Fm24'rLViLPPqw-kVQlJo-1H2K_R%#n2h'#HVs)#'%(,)PvHj'/h_F*:27C#7qj?#l+]]4dBXA#u3Cx$>R(f)Tk0,&W2))3wT;m$M]WF3>TYp.U-X:.JV%-?iGQj'c;qi'fE)%%i_rZ#@]*7M%E/cVNgSa+D$Xp%+p`/1`$v3;ZDF]1UXQ>#d>f]%BE'_,PxZwJZmgjCF%SC#CODZuGNf-6aBbr.DRJN'&/K;-fY&v.$jSr)QQW>n_0*?#]ZI%#+^*87p*5gL^>LZHFh>w-jUKF*jx+G4rg*bRr1AH<VC0Z$FL9p@D1`BS0L][#qoo]$+)Fs@2cMcBL+B->N;R'4Z2>C+Xh%[#=F$p[_ImP/v4[m^ARtVf^nH>#V#x%#]$(,)1h5N'jZiYPX.it6PTH-&'Eg_S@B+a*'#Z,(8:RH)Jg4',+7>q@>n&6&WB=Y'$-mK5iNj?#FUj^SW+4p@PI'gLL_CJ)3Rg#(LB'Q&(c^58n<g'/S0CwKK,5uuhg(,MW4DhLFwl&#;kP]4CekO:Q9d;%c/v[$mq@8%='J,3CDZK)jX@8%:q'E#`0`v$8;f`*WKd&4]/np%U3dr%:9Ts$9fCZ#fEg+2Z)_6EOB$$c,S1[ESa:,)]3IF.^dK=1KNev$B6^DCS[7v?Ycq@-c.1lLc<`-Mb&mK1O>]iL<n][#a68x&RBuMCAc*mLu9Ss$80eu%:2%AbaE]f1Q3Z*l-2vT%8,PZ6gH7lLmXu]#_HGd2m#:u$'pus.8EtxFC_39%JMYe$@?Q3'^9jv#8D=7'#9tv#1MR',F>D9/<?Kf'9`rq%mbF3'G2VZ#&c5Q8LQGQ&Ce3p%'kG?,3^_Q&6,Z5&a0v^#8GQ%bQxMcV1Q+g29X-T/j=Gd=Z-<iMmVE.3[Z*G4an@8%;7Is$R2u`O#VAs7+8nS%[..<$xG`-%u<5B$c`9DjaI:k1B2M11tQ^0(/]'xTs1qh=S&iG)*.Gd3Mu3=$FwJA=r=;v#a9n,*j9###%&>uu1aaL#CxK'#%sgo.atr?#P94eHJe75/XN><.+Z6K:8CvK))`x_4:N.)*2OOUIi9hB#bo.n&IK'*<Z6g*%wN/7L^Bw&/DL<M26Wrq)p,c+BdD24'6&Z<-X4:12Y<Zp%4>,##>Obr/,2@#>@5W8]NPk.)]IjQ/m8q'#N7p*#h>g;-E6V[%6eYa=hTEj1f?%lLEt>Q<TA+O%t8*8*3cbZQQUPd4r#Yg1=BLe$ukxS^)%jT(si5',JD/]cxq0`$@IgRJ.N=q&Agf._%>-EG8K^9`2@1.)C*Vp.W2-A8f9iRJHZBZduR39/I:8p%7CaW-?6x)?EStW#8Oc##Mqn%#*.FCM?M(u$NIk@$8Oq-M>7V)3?_#V/#@]s$.c0_.-IL+*Zj:9/Z%FF3Ju>t&x)%w8OxcF+wOk.)b,XX$V7U6(&Y'@%A(e;-6^5W%)9Fb.&mtXZG-9U%=ux[>aF04L7c=>,nN*2005r%4]$%##UmFlVdcTg-[2he$(Ov)4')'J3=s(Y$l9Mj(;X^:/ZO@a4'Xwq7@T7U/M)D^#o-24'YTF+5_I:&4wi*.)GD0;*8wJuAjM6',TI?ofQIFF%dN,p<r-qK(0(gn/?`(0MT;ojLmYGwPa7@#M_Pdo/T[i8q3F_'#tJW@tP`%/L:,NV6Y#B,3*56R'XQJw#v;Tv-Xngx$S9V9/kon:/`Ld5/6B1C&&'p]#sOsD#Z/QA#cl4Z,l1pb4*xV]F?C[8%+#6w-gh=?..-:Y$dk93'X=gMB6%#[5KT(g(6>h(,N)34'M-Xk)P.d>#>$^Q&js*39kxmo%U0]8%NA3I)wq1)+<WTJNO.u)svH<Q/KD8^+pbBN(Fr_C,`I,D#jhtM(`GvR&,_IE+M^Bt-t8bmBi*dG*X*bT.s:Rv$ugpv$)2K+*.7UC4AvM%.i>k4<eG?0)d2/'+7bqC.RT<N1HFL2'Ps2/)vYFRUpJ26T$$^N0M`uS.deRv#?+J3'd;###fN,/LNrIG)x)'/125V`3B@0;6h>3KaF'qk$te?x6@f%&4;#fh([hi?#ZVd8/3eit6VHL,3#*$E3R`%>.8$<8.FRoU/YS1I$%',F%=$G&:Q=Ha3dZbG2Xwiu%Qfm[b']3D#C12?#iZrZu,@.D&prB7)wu[T(Og)6S_JFU(YXn*EY/?v$M1`e$NNcA#2Vqn#V/%-)w1058MNPj'k6V)vOl$SVJVj3GdmG<-%(IM0%,Y:vHh8E#irZiLb??>#eVT16T:Ls-[J7&40Pr_,jh^F*'[U&$F.<9/CP,G4.15ZG8o:Z##=Gj'NMl[nuCum'iQ/R/Cual0CjO',xr2^ud<)D+Wa%[%XoPu-Wu,##EEe#6t4L.=1?-v.N6>j'mZ%'5m,CV.o++J,+#H_FV54W6+mg+*os$crU,9v#COqr-ggN^,:7%s$B.i?#QNNjL1uQgD#2YD4hBf;-un7T%[gxFiY3Ev6IcLv#.Qc++8T@H3oi.h(YfiT/%Qrh1L%+0(R3b1'QG+m'eAtD+'N::%9;H%-n.0c3-n8s$/m=F+V@.d+fN=g$I2>>#M]:E3U?O&#(K6(#HVs)#ibY+#omE:.=p0W->vq?[+fj/%mX)<-iLh5%vK'H;HSP8/Jn@C[ULc97O;64'xSO-r(f>C+x_5'5CM5>#Nnbr/8Z%123D3JUm&DAPpWvf;@Z*#H0(LB#<UG<'91+rLZF?C+rRa&l4*S5'agmxuYLN>.Q5RJ(iP^G3n6K7&xfc;-4W%:.%/5##)<$N0C7>##eH?D*Q4qb*%Ya<-u^<b$jlOjL)N&],X,U:%[5MG)82dA#TglHZ+%W9`TrZT8a2?r%25jl0RJ<e)lb7Z7Gwlx4'AuKP/q.'5jbml/Tj:11@48j0QSDP0o#`K(RnU$v7m6o#WWL7#gd0'#C9OA#7)S^.HXX/2c5h-%+*>9/&,JA4X)e]40V_w,UkH>#P52k'i6`G)o[O,Mo=>N'i,K+E;Dq9RI,/t%Bf,cG;?J.*L)d>#n7OQ'BT]**_YRB$BfG;Dpf%d)Pr$IMpH$=$e;?xbFX02+m`V6/v>$(#k`Hh*D+?b*r;_H;(($Z$O<t)E:<hV_]o5988w..*D.Y)4O5+%,mgTq%ZTXp%+_j;-?Lr9.-TD/qgAS/&PV-(,sf+%,;:@&,H>0%,HpK.;JC3=(:Y@U%V0%HDjv'2qkq5`-HsaLjc?W$#RJ2,<fxP,*7bda$17^FEZwL$%>nl_$<*_:/'Gl/Msu?BF^pt1qY6d8/AY@E,Y_$##)&>uu;4PY#En:$#S&up8wMF&#<RU&4Q[tD#9daI)HHeF4,6+G4OCUN('JRgs3RXD#7^e`*;H_T%(9f+4<J6]kdD24'R/gV$'#]v%MP,,;>`HmSLf(2)s^^j'dZYO'6YA$5eB]5L>Z46';AY>#r.Je-79,s$$Re,;dJh^u<?l(5/Kh?'L7MZuS?Uw-sNVxLKX8Z7&>uu#UE)A-eX>GDA#hx=*9&##4t`a4%&AA4PBoo8LU`H*X:Ls-GMrB#DM#<-VlXk%V_9U)Ba4R**IwlLPGYk-mP1I$O]<+3d)pG3C#qVKoD)-a-<eW&2mrg2d*qU%oLqB%sL]i+)i=:&17v?,xlHC#:mjp%E_=;/D[eh#C[0ji3'%0)eP.L(tu2bP+,2t.pF'32M3b*OLhR9(9.=8&0Tc8/Th[@#1?2c#bD<E*mP;s%ZTXp%L]/GMqxDO'#NB.$bla-6p?(*#%&>uu29wK#M_Q(#w=3dX.e+qYtXhv-xa)*4AU4E,cVOZ6K.rv-%NCD3M$nv$3=Y)4aD#d$fi)3Ld&V0(ig+MM>B?C+7b=`&pW^6&32t#q,0-3'ok5'5q.Ca>n7J-)YGmvARbd&4$*9q%.$###u]x9vhcaL#XaR%#HPUV$O7%s$[E/<7%5ZA#N)b.3qM%d)BCPd33>h8.:?N4B^&<1`=t+K1F'h41;)I(W%Qd*3vs4@&t=4'..S9,7olsb3(-s</njSn/^^'LD.cQ<-teV='ZE]h=FN4u-Tl4Z,[PTG.h_<9/.($j1$qk_$677<$T8[<%1*^A==Z=I>7^I*7gOeW$J-fw#hPh'#$,Guu0dqR#e:I8#[ulW-Ah'[Ko*TM'BO=j1-Wgf1%OG,MEYd8/=G,o$<-+mLZ_YA#2P,G4/[/I$B'PA#kYKq.]0#3'H?#7&A:VZ#&]:%,cmT#$[0J[#v2Op@&:cm'JSl>-i@j2'Y=Y?,2f370.%clAS]ZT82V0T&G[<9%5[[h(($:3'AkhA5jN7-3i[#Y%.X,B$A$'U%_r98.joH(#'&>uujD3L#F[u##R'+&#h$(,)eDK-Qpqi?#+=tD#,7Ap.+o@8%ZbwZTP*.0)lH8j9A)Wm/XB4J*T+DW$wIcw9#ggx,2je6'933`+maCa#fAMh+Ss>;%:YG>u?n.T%gr$C6J8j%$WGg%6*Z(a63kHE$L*C8hxQ;[%]TVs@wstOS,E3/MKVY8.`D#6#mlXg&a);D3@4ku5eIeu>83LG).39c5QXj=.jfq8.K/B+4C?TW-=4$o1jxId)/##jL;+b'4TmwiL1XkD#h4.'&f761M+GA+4dA8_#PvP3'be#nA38U[M@']6/#^sIL<xSfLAHxY-C,$+%rJ[;S4GeA-JPj+MhmX>-7kl1N(V?j9cWA]$Ve##,G:$##2rh8.oaVa4[Otu5`w6eQE#QA#1W$E38scG*fvCT%Wc?S%cxa1BS9&K:)c=<6NSTE+V`f;6B:VZ#&=+.)lJ3&+:?#A#r,V0(l0IlL.2&L(Wc/B+_2,<-9^<.-rVY&#9pse-q9S8%hJLb(QOCK)tER5]J5r:q+u/m*bt,k0fh,i<#mS=ujp:GM*=r/2@4ku5'c>m0-Q8c$t&pM9;Fl)4#T0<7pM.a*>?ks--h7e*<53H2L.OF3`9km&3R7D%;ccYumYL&481Cn&rueU&Wt))%4&ru$].TQ&xbB].h#A:l78I=-g;,<K'7Z@-b6F6)lEbQ&.+CJ)l8>'&.?i,M@/`4JC####r$a..+`B%Mg_Y&#x<x:H/9d;%JjVm$F8-+%vpVa4U>#s-?3rhLJft/MkF,=65<MG);AEPA,<qU%ctdT.^Ig-)q(J-)o0+X.K5.F3<3jd*N_Z(+I1gP'mMik'>BL,)7>8N00`u>#V$X#-E+8n9JWYT%JQMM2ERU02q0&<$TjuN'kC+6'=bSM'ENi-MxU]-)Seno%&gP%b'kL-Z;j8>,%E#,2Fq(58obIY>,?&##lq[s$Dd(T/t:tvLN#_C4e),J*6So_4i4NT/7Z11.I<3jLmM7u6&UP,M@Y1)3=$[v$qZR1Mp<]s$fQtG*0c94.?>XjLG8Uv-4gY,*U^p6CJ:3JUB@lx>?1Y#?uKS+O(E8`EVqDv#&WC11/YC;$Q?x8%QJ>K-jc[h(Fi-+%Zs=v#JTfA,M%72LO>5U&WVMW%g%Yv,)>P>#O0@XR(f>C+xaw-4dRVc>7QU1;A;<%ZXSNI)EbS8Sdm>3'Qd+(/=C[s$Rl(+%^Ht;.nrEe)J_1p/Ga&t%>>m.U6%YgL5rv2&DP&q^[19-#Bsgo.:#gsT*ei8.rWdd3D-9Z-a[n8%.2Q+%$ABf3b1TV6m('J36TID*7d_D3e^6^$v]DD3Dn1^45>$9%A):_,qTfs$<es5&sA+q$:xh;$x<`W%WY721GKEI-3lgf)L;?p/DtEp%5Yl>#+dqV%#,N/(j-Qg)</Y',QeEX$;`1Z#;UW5&M#RD*<PeV%DEIaN4SbE*T#Cs.=FR<$0qMI-d>vM0;:G>#@Oc##>j&kLM`(u$+dfF4:oU@,f9*Q/b5i1.M2FjLMZ.:.=@[s$Vt+9.G1clArbm(5p#i2'MFe^&.qZaNw1@N'mIamJ(Pws$LpM`NM4Tj0Y])T%-:.<$]noi'*IK0(;U*9%x5=i&].Us-4(.<$OtM20%)###&e_S7w9_s.oZ%##-uVs-e8apJ9qqa4g<7f3?W8f3]o:p.?Hwh204pTV#&'f)SZb;.';:8.eBf8.ae_F*jSB,3]Dq58_Aic)%m]nfVM(_,oTx8%r.iB#/YjW%(x?5/h+Ls-1xt+*r.iY$oBDH*VsAE+dk;Z#'sRD*p5UB##/g[u#'UKM/'#9%F(Ai1wOp'+cRw8%>_m_+,hAC&L=$R0+DFj+IKB7/#S=gL;>AL(h3n0#xZj-$2jPxk%+ei0KNw.:@h#&+&4pP0L[0v56W8x,jIb&+dM-R/#F/[#.enX-3]1gLBl1#$mNJi^Yhja,I46>#lZP,2mV[H)$'+>-fwlA5r]=(jOsf%)-:Tm&CR7@#N^[h(bYR1(>k/Q&*pFQ%KZfe*6lJ-)-3Z>-*9CW-_GnI2&Y^#,<AXi(PqB,3Y^M7'K*#Q#2uq;$aB+T%N6;b78v%1(M7@s$)/,##S3n0#O2>>#rLb&#alZh*dNx<-;<FW:o#cg$$tFA#;u)t-u+6f*ujm30PJ))3rtC.3q]X*R^O%NML`49%jJf/L#Skxuc(0n$QoQS%;41hL)]5W-O;oqT*V/^$uwI:R1o&K2Fs=gL?H+[6XtVV$3ptF`n=%Ab_<QfC&cF`NiI(##)-wD*>qhk`#P7C#e6fW-)6:@ee^s?#H0^M'6=[s$iSC_&-[X,2M]mT/a@i?#KmLT/jmCI$@P,G4@_/I$:g*gL[:L+*r2u]#UQ%u.aCI8%`SID*/`8a#g.]Z$*gXkLo8Uv-66lH*mNo8%bdK>$E$r0,<O+&'R)?Z$A@7[#/NXv#$^59%g:[s$-2@8%`9/j0E@vlLpTf]&VPrS&Jw+SnEL[<$<(M;$q:J5'5&'asR,V4'ZxP>#6llY#AnjT%fshg(ZnJm&PEYj'&fsQJfJ`O'=r_v#@]cYuj7T6&3YL;$Fb&m&BUw8%Dgv`*@:v>#lqSRJP><E*cchrEnkd>#<e/m&fLx+M&lD;$Xhf-)C1;MPE]6>%g8c9%%_MO(kmp`3Dk<X$S/V4'Ui[6Wm#gs$$6?a3P8@L(*@S<$oXj<%@@%<$-AG>#VE=p%vwPC+?j%h(IpoY#ChWp%B`Y>#$,SBfvtoM'MI#>%fU(W-dNSj0lqPa*A4Rs$.P(v#I/([-_3n0#A@Rc;0F#W.nN@q$C]]`*@HDZ>I^WZ6#@n=7QBMP8+o^>$]f-9.8<SP/oUw5/Pp.'5edQ_>MQ`M2dITf)9VT/),DZV%4%+$0Jg4',^`(HW%.su]1=LB#)<hd<]9_^>o4Jt%(.7u-wrw**p*th>`^%pAl1Vs-lO>29kLbm'2p3GDw>#H(+Rs8.Yg'u$x+hS+jHuD#h)BkL_YfF4jAcR(@(<Y$DjdA4WG[]4OtYw-OgZ)*m1[s$+2pb4S',f%_ccYuRmjp%Lph0(l0;)+gDQS/R+mYu:5rIV:_@T.-_T6&r%3s%Q^GN''Zk-$1R`S$xW$s&SAwp8@:%@#-gXJ*.Ld;%MI7'&^@;mLuT.E+D:?d-04xf1-P0F*f_lg+IT-caOY/5'I$YJ(,4<N0nTXp%W+:<6rBHE3O9*EE2ZI`$2DYY#8;-`a<G?`aY[HP/&<FdXp]a.3Skc12nkp>,AG+jLjavKFMnp_4.@sp%2;v7&j/^,2U[c>>XZ+>'gDvV%iBo+iiL*I-OJZs$(s$W$u)qa<TP'H4/A>##qm6d&Y>nx4Vpw.:w0+;?2:'XLQIcI)@f)T/2Bq-%13w)4HjE.3IG1I$'o2M2xraI)#os[$URoU/j1e8/u3YD#[I,gL*C7q$_TFs->d7Z?h^'^#wr^58s9_B#_Nds.HlpNg3J,W-Ki`C&=?5A#,x;Q/iGg+(#1JB#LHrB#1Paj'I;Bq%6qgSM_L@%b1_Ds%J%mW-Jns$'Wc4E4FXwmL^6Tu.MD4m'/LYj'$7+;.2M,NB$6-)OiYr=:#ET)EhjBn'$sQ]4TW%29a0Vd*G<GQ/atr?#q=1<7oG[>%QqlS/2B:d;QBdK)RJ))3`+KL(r7Qd$5fffLXU?uuZGfZ5PB^Q&NV=jLT%E?>3brS&<U:B#`q)6/0XP#BTZ]36igNh#Q*f*7tYNE*##^w'7[@RT^.#C+Doo1(S>nd)`KjxF5'c;L_bZuu8Zqn#<^U7#^hTO.g$(,)i`:W-PLhWhkx'KMTiPr$R]<+3`j'xPsM-n&*oIm&E*o*%]12$#0r/gL1RZiVKnt)Ww($snu(@['OE*=M100/1aZI)EkI*7MZ9/W$^g^Y$mUNh#25tA+k:iJ:222.MI.m<-0f`:%cG?`a*Gju5Q;Xt0q9+o9uu:_?w@rB#P6vL%='A.*LUp;.e]OjL7CF4:h(>)4L8#>%SXkD#qJ))3#1<:.Lk*.)+V0T7jGPb%nD1q%cmXp%#[)%,RV=V-dFBJ)`9T1;eILFGJ]wd%bfLT%OAj#lZQt9%LNl/(Z@I2L>oat(tYq.;52pDGin+A-^s%gLWNvu#Nn5@-]felA6M7A4e<%##H8jhL%Ds?#0AmX$UwIs-X3+f*Q%tvG*i,g)@3nZ$DElX$#L(E#*(qx-qkmG$`*V0&*/QK'Alwj'FIrv#wfo(5?lLJV0vVm/]S*O'E]p[2:<Y7&A,1V._EbA#Abnw#p<5-)nasZ#Sx^^%U&*&+mxV(Z>kB=%pV<Z%ISij0CDuJ**4?c*,JVT.#sgo.r_P_HXh@+%R9%gLWX]+4Hk48):1&(k4#/u.IoN/2jt;m/-N8^+5u([,=s((kfmkb+]ZN)+E:br/.*Sa+Fj'_,xD[#%fj6o#@WL7#IXI%#Rk5s.Y08b*U)u8._]d8/%d?m/AA5##F06C'7]Y8.#/97;+C-C#=-1.)g+66/S$(-)i:SY-a5AL,8dR2(XxNh#m.$###&P:vJjS(Mo%wLMNHs?#0$UXml`%:/ZI:E4d]jj1Mnpr6lgUHklPl]#Unu_$.hGj'Ytu3%L^B#$sfC(&%aYp%AskgL]*8s$*sg7*Suq;$M`7f2VVwW$hfCv#v$^p%vatT<fi?['P$=)<67]:.3oUv#==Y&#0PsC7jdW$#l&U'#N%T*#1$S-#_k/t:a>gG3u2)9&*G<#G`%dG*:uh^#1>l(5dF`2MDp`v%%aYp%[2JiL1Xnm/j=9a<-P3j1McAGMCXv<-1-r[-`0Nq;*7Wq;p%@k=VvruL<k0W.Y[3VR`;^;-I39k02IYp%-Z=J*MW?J?7slG*J3G9Rc1L)RVrJfL9bhp7Ze-$?Qe`uG4bZuPS)r=%?@*<-L.4/%=W<#YdFa_=(1^G3]p*b*[_eW-49`B'DT1p/E0p[uFNi&5&=@^?qn5]%S.72Lp?G_/]F`2Mniw#8>BS#IR:Yp7pbkA#4A;A.NgSa+X+4W[:[r%,KUVv@MZ3r7wZ((&uv>)O$cdERt4M?-8vYOMdq7Y-htOk4BwwX-BDD(&M6eL,q3n0#Xn)vu4N_n#hXL7#Qj9'#L+^*#)Oi,#pkP]4^bm5/2a=Z,ih^F*xaRq$1#>c4B7.1M.HUV%F:;8.;eML)tliO'W_d5/gG^.*wG1r.S7r?#dPQ_#MPsD#H'^s$Fq_F*0Mcj1IHOA#:;?_/[+vLMYsdX/]@[s$VFCRf_N8@#Xu4E$b%_B+T$-Z?Bq^>$$?=bH@io1(;@6,*7fx.C]JM8%kLY$,evt01)&i+VG4;Z#TEg:BFB%>%$Ggf):gpn*2l6=-I83V9VMk*._2b>#*P7Q8-7H<e(N71(HQJe*N9t>-^,D</sTA9&(tdD*Ba6d),]ii0Qq.[#OEFX$IEPj'eiId)*Q;E0.lqp7v@iv)a5kXZQ5B]$iD`,)Vh.U/S%8q/3c&Q&Io(v#:bh0,h;###'&>uug5wK#h:q'#BDW)#k,>>#OIR8%ir^'/d@i?#lwkj1m+B+4[#,d3eNsb$S`6g)qW*7%Iplv'4bS*%^,ZR&QiB/)kE1W9ZJBW7>dXh#/uWaa>ps5(fCR&03BTkPH8e^4HDsa*Yt[<$I6Sa+sX:D5U8Q@-N,-%-E49?-dD24'GIPn*%3$`Mik^KO6:9g%v<<h253)DN>iLxkgdgr?Q;aZ8I[Fj1SBo8%,lVK'LDl;-g'pZ$%(pU/Bdp_,W5MG)n.f`*RJDW-d3O<8DxMT/XX3W-AYL=:PQ1P:V<cD4`-a^%;(6[/[Es?#FssbN<lA,3edslf-QIi$#><O'fSq7/*g(0*be30*Mkjp%Jt39%fUG?GSD?^=7c%[uBp>+=^Q8s$:L39%5$^,2[2vR&G$TQ&Z8Z;%EO@<$4L6Z$@_g-64[+nKV5do/E-^p%$#miTYBuB-1#K$00bRt-N)Lv-[#`E39)TmA[a^6&ADhT7NxR=l3oUv#0=<AKv,=$^i?md3?w9w^t7p>$pssr$r)'gMIB@^$^Z-/LQMV]4L3DP8$Oc&H4>Nq)cc``3N6f;-_^^s$lCu;J?+OF3aNwA%;'Sp7Y3#-3[ko>8H:`e$s,Bg:2FHJVkD$N06ZJ-)$2Mt;k4JiL^X8;6oIHJVbU_<%kW4g10.P[$A:pGM`Vx8',KM-),xS:)<%.+B1_ue8[a3X]VU$##QYr.L/.35&q>:D30Tq;7(r_7BY?u`4wYF$5#Te12)9ki0U<j?#OgZ)*&9G=7/eL+*/.O(&bGUv-1]WF3,3s0,:#Xw(A/[O'1-naN.+CJ)a6We$+ahp%lP_M'R6Fp%B,e#5QdYn&'*%[%Oi/.&J$Xp%.#VP02Nd3'04M9.N@f4(i(-Q'quEe6:]Oe6o[>;-3`Q=l0xeH%<..<$4DpQ&i5;0(2mjp%'$kM0@RSs$Wtld0:aqR#%XL7#b5ct7@hDmhBT7j%*W8f37`wi)1Qpv-iL0+*Zu.&45sI9&TC^mAf]V8&ua4C&C(Sj:DSw59Duti(j6taa#8poSx7poSw<B%68:ZL<0aHY[`hc@57#;p/Q($##Er-W-@oa9MBsMY5nX=qMTj+k)2w-pI%x]G3f5g;-mB8)?NOt'4+d%H).7A`aIdm`*Pw=6/Xf:9%_<9a<2pUC&qGU:mdGDO'.:472L9(sL?w3D%W^J#GaZ;^u[Pn$,:PUV$Z&1#'R);D3>L1@7a[8%>F>ZK)d`eU/M4G)4n#gs-#0,59&Q.:/cTIg)jiWI)NVd8/mGpkLi=,f*=-g<6s.s^uomQb<]#/=)l8=@,AlfQNp(U@ksRB.&mawQO2/`O--1<M2.+1/)`S[e2p'[>-_%vO0`Yu<Qdou##'R7p&nt2P1L?%29'b^o@W-AVH2O$>Pcq]%XcXQ9pd-KS)^XQjB1cB$/n:7@D.2?Z-IJE@c,Ow_#bBR-)QrbF'wHjm/J-t9%L4ie$FKx;QR#e%+6h1t-;'dgLK;*qMLd/sQg^BO0<'^6&;dQ-)r=SfLdaf@%7<9a<rN$3:SQ^6&(47I??-Bf$DBmY(9viY(f><ZOC7CP8ikh&lr%.GV6Wgx=7p4r$qf)T/N9Q)4$R:a#?W8f39ESP/-K?C#l[E$6/bL+*kon:/91FK;8>hR'[&PA#oi&f)04vr-+Os?#_7$r[Vx0H2Z5OKS:/;J3fKOZ#Z5$v$72pF*^gm`*v/Pp%Nr-W$Fk*=$H&7h(J-t9%`MDo&;w%>-c62Y6APsGZA/#Y%@EL,)D[^l:UI*p.kp9Y$BC<T%DH7_8iU3p%G*Xp%FX7@#KiqTRg_vu#YfY=l+Ik^oW$4D<5Z&##LDQEn9M<5V)%=%$%vCp.w<7f3w1T9rlOtu5cTl$+rWP>-);/CNBDNT/*)TF4'gc^,%tUhL`dt]>Ab:k1Q,iO',=sxCU&Vg(U$^m&dQsv#Oj5;%?e8m&Ff?t1$5*D#OC=x#0xWn0;^$NDj-)kB3a&5:IY*CAaeiv#0AD50L%C)vCQu/(X&LU%G7VZ#@.%w#qEC1L1O+(Ph0X5&cBh41EZ[=&mUL13QLN`<*e'B#(2/u*0FJW-xOO@R.x=D'cEW@,=4D<'be#nA;Bw8'A+ZW-OEPX(o1#1,v[c1,/84'#-&>uujtRfLfs<,#9$S-#Qmk.#ll?0#0`W1#b-dT%JY*w$a&PA#[(Ls-5<(C&`u$T.2fNT/7R%:.iE(E#I6Y)m?8gI*.>Ip%d^(4)toL:%iG+G46N.)*^s-)*H.J['BX+L>+O'>.MqeD4f7v<-0k#D-ggC=%nYSv$$5T$9+`kGMvI;-*%%&6&M<BU%Zrl>#PQpM'Hvj$6Rx=Z,pYru5q6#N'FU%W$nY;K(d5x<(1&M(co#,k03uQ^,,w&bE,(g&$>@Bd)NY^P8mi#-3(f>C+noxL,jkV2MM4le^*nkJ-d5u(.I1cGMP6$s.1I_J;gFNGNU]B;IWjb/)tdV1,ja6,M%X=g$Q2>>#I*V$#p2h'#;1dh%hJ(T.hGv;%gpfc$Nxko7]sY,*U_lIFA'lD#=tV@,,M2]-tY8f3=RF,%muiD39geD*%b2O+^rsS=LImV[Zeh9Nx_(h38e^BQ3nYT#]A8dugD(1(Z]$+<H;&#,X6FT%<9IiLb$aO)?mX2&G@Sn3pprc<3T$9.E,hQSE^r%,?SF#qDwDN9<Ub<&aKT6&+h=A#GK,r%W8[d)Cie&,o?3$#R9@x%#,PV-Pd_T&dvV-M+oul9<S8r0bce`*7h;9.n%/$&paR^%NPd),6ZpS%aS>rN]xZxOv,J7T$v,]%_k(K)>.G2:`bK2:6XhC&:rw.-ZI`/:/>uu#0m9c`huC`aS]sx+<d/eQ&hhc)^qi?#b3NZ6Rg;E4k&B.*50,RCJB7u6]?jv&=><^'7?c5/oi&f)7u529TI_s-'Y0f)PJ))3J7wJ71C&9.KB+k^Y3S@#9SVk'3=(?A$@Ks*Thlk0N*F9%$Y]t%/]1Z#i&RE3avR-DVV55(*q6s&XEE)(a)XBOljX8A]uqRA=i?4(K99U%Wgcj'PF@w#8lh;$+AM6&486<-uIco.Mmk.#_Q(a%R5%&4A5^V-D,5L#Esu_&9vsI3ka@IMNp^Xs,h2^%=RNHDOBb][BMG)%p]B.*(%mg)X9v8/x)Qv$0[FQ/%u`p%N<cC-r,Jd<%O(?%AF#-Mu;Uq%)PG8..h_v%76b2(caNh#Ev]kL-9Yp%65u;-G(-$&fw[p%ZOqvAYCU$.=L>HMLkFrLRXXp%'NRL_%6O2(4i^GM;kFrL*`49%ObML2CZil^*S_9M[5>##;j6o#:WL7#>Ja)#:sgo.RK/49R_l8/uCq=@3r;q0aM<2%aJ))3GW__&feX@$wK(E#&-Qv$R9OA#Y,*E3..<p%WOn55HDnS%[Ag=-dj>7&qtoW7[:@b2qhnW$Gi-+%u$m.)F5#@PF-9q%#'NGFFU[s$/'Ib*1,MC&g1;F%_s>6&VdYs-mVriLPMbU._iQ>6fCr/)?5YY#2m_s-rU`mLT:c7%82JD*Ylqo%lN->%[]d8/[j:9/0h5I$I#[]4iJ:I$;G3l'UE>V/:dD<%*d*E*J:=^4SpZ.qNFPNB=_Y3'QfaT%e6ts8D$BQ&B2pY#7ne,;N1^2'*wrG)_0t>$mNV8AsNsM006s*4/Gj0(tHZ12ILdV-=NJX#xd-c=aVw`*YiE9%=j;Q&ur<f)g>Vx$c3nHD/Jo;6jbNEE/ku3'Jr;*+X6CG3XFpX%QxNB4X=f(#&+hB#9JQ%b]R@`a8GkWhMqj?#eRFj1P-pU/1p+c4@&>c4*^B.*YiWI)2%p+MnPPA#)*^s$4h*d32co$-HZM.3d;+G4a&ID**E9I$%qB:%q1JD*X&g7.olOjLEH8f3[DGH3Di^F*K/jhL()nC#)x9,N$l3d;%4+$6X*+,2h;JD$==%w#oTw>#D(/M1cNKY$p#PO0p?mK)To+Z,jX(w,=bqB#JD/^+2q5Y%.9.iL.%[lLQI(Z%CUEM*,:aV$(5_D$fl$j)'$p30,khM'P8Gl9he3X$&O_c3Ja]m(W71W-<.i?#]QOp%^4>;-ixP=lGU`X-te8U)XYL;$@B1g(qrIu.qVshLO18n9ms>N'Gaw<0iX(D+3gGt-:T7s;[$0x$<@le)^q[s$CY@C#U<RF4fE]q$L7[=7=Ddc26O]s$qhEY$0DXI)2UaJ1oHMH*+2pb4lS[]4jJ1I$J,9f3]Ah;.R[Ex-7&;9/Pq@8%pD9I$EtUhLWe'E#Jx?9%4-p8%RYEv-?Cw++vtXl$Uf1Z#Dgm`*J/h_6I=2v#.P1v#fw3x#6x-W$xlV8&x@b.)4YG>#0w+)3D1;v#B]lY#8R*X$>7rZ#aOX,MoE3?#)5G>#](#(+vt:<-Wk.W$<Njxl50rI2E]G>#QrUv#<X^g2<'p[#>7YG-VtA`6O.mY#jHw=-twL[,r:bI)sSVs%*JuY#<i$s$5ue34^:E5&a4j]F4YCv#v@s9).u'hLH/R>#ob>v,rxn-)tM%L(jwRs$cFI7nH?1T%XYqr$8;-`a(bA`aRr4;-9+KV6s*FV?:E-)*7^(9/CH7f3%&AA4T&wA4ifWI)D`ld$b1TV6O)8f3Q7V9.lf/+*s7v`4`9$`,pF,G4-I%x,X(6]63:AC#Xih&P[j0^#Zsn_sHvn_s4MZg'6+1R'RgCO'AW2**9kbN'Sxs`<3b&g1t^&mA3]1Z#@=_/%VJF,M4%<,%;vAgLW5UB#4**f2'79a<snew#?+<&Fd5f_m#QQA4a4a%$G3;5.=Vl>#Q9(K(%f0^#OP5W-$M%@'YMc>#avq0(Bb[@#Cwat$D3@Z$6i+gL]P<$5DGP##p8A9vFwL?#Rhb.#nrH0#C9OA#).sB3rv)E*(WB.*[hi?#C]R_#<SEC=I9G)4??040<)'J3tk=V/OuaWq2h;E4inL+*YiWI)9g$&4[q'E#g<7f3ZPCs-7X(hLofXI);IEs-0-+mL[1<9/OJ,G4uV[*7:`ZA#V7LF*l@AC#X;s359Suv,gQ^a<)*c5&IbE9%:4%<$4]>C+qS_B#QNPN'p^O,2NJdT%>,''+Mm(q%s&g7/@X2kLfRWI+*KUu$P`,&6L/N&+-g?V%OCsK;2HYx#K3^f+K$=t$8-cY$blA^+4frxG@E=Z6r<mK)^*^6&>.Vv#QSJ#,jv(4'iM.h(pxmr%dwums@?rJ)Iigp7p?36L^t/6&Wwfq/ua/M)i^CK(M2p],$:'q%FBq=%$mmE3M<7o'iX6T.uo^O9YJk@$<OEp%2BSL(95A-)1jmn&?]4I)LFoN0[d0'#[,>>#nH7DErTx>I>)0i)k]:.$k&/L,9Ce;-8PMi'GMHO&n8$Q/*uIm&?pOsA7g^3(s(Oo7DL%@#j#CdMva49%BxvP&VewQ/]5.s?1K<[V+[rs%<kB=%^xSKFHak%=j>sV7b&6[$pLKV6p^%##wZ*G4vf-t$FS/)*#,f9MjCI8%;<Tv-R]jj1aY8f3s.J@[_p?l1)Lp+M?>I&4@UZg)>;8^$]>E<.VM6]0kKBmCdo;Q/Q+ZF'+QL11$HMs%P-J@#As_:%EV5##dD24'$?i)+O``?#dwR=lmtfW7>:4Y+Zf[I2*?')4;7DIV]Htt$5X6,*Z`A>,m^Y/(B#>_/Pu.-N5iS5'7l;Z76?4?/u:B?/62@S@C(/t%Sc8>,'^u(3HIl3:*q#5AV$&;H+=)##e=.BMov9`$p5#H3$^OjLG$Y?%g1$Z$Hg,'F39&`=7uG,*>=xm/#lWG%'Z59%MHg;-lj[Q/3w.1(rb*#HR@$_#S4u;->Obr/Y/P[$glZp%O'$satZ-7*&uWaa=+vcarOSfLq,kuLvR49%WR^?-lF(<-&UZk(]fa-&MP<F@'1IlLwVPo$+nJ&5]_iX-fZ0XU_T+%#b'uG2fXL7#D_R%#b[P+#'A*F3+n3r$i]Z8/OJ,G4;#K+*$DXI)@vSp@v3T;.Vms/2Q`J>,T09Z1u_t_$E4qY,6U`X-`SA,ZDhUP82n5>?NtFT%pR35MYjL/)ScLg*PKY/(aO*C&OF':)1VrS%.1>0LusbA#PB'%MR=j8,>p`o0L^v&4>$('-U150L[w;mL^6iT7V&*<%_k26/kQ#x'E6.C#&=:g(6k.=-DI>:&2HU]4&,Y:v<4>>#L$M$#f@*1#ri:9/#&AA44CEs-OmaR8ui>w-Zu*V//,-J*&C[V')=Gm'VAqB#jOPv$iH`.M>$&],Low+3TMrB#Je75/sJ))3,87<.*J+gL$>,c4;0l]#5^$E3x+JA4l5MG)E:b05Bv:9/>'@$$/h54*FET:%fk.T%9G*9%g3-v.-g67&U=L8.2,te),4r@,k#l-;=qGZ.Dfc>#c$7X-`#q7/85Es%Dh<p%'O)%,r;v3'Wj^u$I`#/*q6Fp%'gh6&rKYg(OJ<e)84Vw,3IlgLL#a,)g0W6/Ykp+Mue9dMR[U&4a'G80B@`7'Vkn8%VlU;$vel/C>7nHH_7mY-HtYJ2we7W$CKhG)6-X6/1:]S%w=P$,$OF9%QT5j']B&w#Ep^R/ZIfOTakQT.?wSm&G*^m&U0Ot$JKBU%Cn3X$roao7PA)mL5<_%X1>g1^faE^,YU65/v;Tv-Lp:9/vo=Z,eWkKX(fR_#Dd(T/Xvfm%5_[1MrB/[#;hT,2G.<9/#,]]4-Ck]#iG=c45@8_8Aj:9/RR/EFxvY,*-Tb*.W[*LDY=)h)6V]C4ubx:/dn$a$1((hL=3E.3wQv(Nx96N'BG+jLI5_F*=?v`-tIUEmIoT,N[8h^#Wx*9%(O7x,lcR1(8`:v#m:Es%omPN'%65o/]6^2'S<#N'Ts7.M$@Z0)4XI&,3%@s$_T#n&+]F.)>]L;$Km--)R$FT%Zt3T%F<:,)q]Vo&ptX,MgH>H2/HJ*+@;Qs.G,8-)Qwu.)/Y5<-QF`t-C+5gL=iTB+g`tgM5I>i(;_WT%Z)qU%-QJ?PQHGN'RJRbM4:SqLgF,9%_mGN']W>3'o<@9.6EVO'O6%0)^<jq.PJ`$'W$0>.XWg2'bp9Y$SQk9%Cba5&7cC;$44IW$Xf&B+V1Mv#`sY3'p6ZE4dVwd)VZ]t-)t;`+F7u.)iaFT%Dhh-MA2Lr.7rEb3u/mN'b>+0Mk,gw#n<DD+CF.W$V=QP/lq+i#]QZ`*W]H6/C:r$#'(,8JjiS]$e?ng)W%]&47pSi)LZhM'fUKF*L*;mQ1hdC#CC,QL=w_>/4bm5T(aXH*8(bZMwHC[8N(S=D7@mu9*c)&&8@:Z%Um`02_Z&##?PY)%q#uo%g^x+2^Jw1%*BqB#%H>x6$Pjc)I<09%t4)9.xE(E#@b%?5:N.)*[bv%FFe39%BQ_V$ed@.GZHHlfDc4E4>X'I29Y`Q&xBV($S.qB%?i+%%jH4,2C70&tU8J@Y@BbB,N+o,;:^nw%sA]K3,07V#Iu+5Vf][`*v>1kBn&@#6$%L8'CFLB#U]r%,Z4u<MV^r::YT7k;8+ZW-h#c_kU#(^ue#]p%g#BI$Y5<gLY?]D<_o?['2%VG[%[Bb,;qjLDVh5g)mZN7%D4vr-[5MG)STZ$([Y_nYAhRl$$6CUj<MT)#%&>uuiA3L#@Oc##K####+dfF41tB:%)5K+*%f^wL]l>&6%c7C#&_<c4[#[]4)f%s$`Ld5/E_Su.XV9TA5&i7)4HXa(je0U@AJoh(`Sip/Sd%s&j?K2'TnkA#Hb[v6lXAT,mH_e2AQX:.QVoV@kVxY,8_&w#[T/0:a4FcMS5'/Lf5020vp%##Cw+[$BB6/4v66a$=o6x6WfSn$)6MG)4(7]6R&0g:?@^v--E6C#AtM)N:Y@C#Kn=g._Qvh2>#IW%j#WA+??0T]Kvh0(NC`8(e3a&+FUn8%@XGN'ix%6*K:`;$?`*1)7J[w'rF)e;F-K6&eaFVHG'(,)mv<<7suic)TqOK(^mpF,QQkW$U8;S&$k?f;C_39%m>MG%fEqd)G'297@KM-)m#>4M#hOI+7/OB+@bj5&ZNs(=MYl;-%SDx$r#p(<lg$l;,09[#lNXA#@-D.3,oF+3d4AC#/>7<.q4kw-1d%H)+2pb4;:b=.b^=HX0FOD#aLit-E=9H<b^g<RJ.Q>#;%d>#?H-)*nmf*%$P7@#J#2S&=<;22Evbh)Ex_v#g:l(5OAY>#Ed$H)9Fh]*0xj5*>*YJ(X9,n&S<J[#Cqw[#M:YZ87(Is$8k>D#p0)YP]:;m8;-UB#SI'&+Q@=PAv5(-*M7%s$X#`1.AJbGML@B.*1W$E3MEC)3nOCj1NH*qiQ2QA#Ynn8%#mqB#J51>GPulG*dJOb$VWgf1w-@x6l(9f3L4+B,hbK+*>>xS/SG*X%9jWI)<DhR%bV.H)#wY#5bWuAJ10l3(38G:vYc79814O(Zo=Fi(Ts:K(L'Tm&:Cn8%TXWp%''dn&<eur)eTR$9?:5gLQW20(vE)[%a&38:kgc#>E0;</:]#_$wR5C+DwET%D@eW$<xCv#>_a5&wwo6*s5;4'>(G&#*N'<-uP#9%XZB2b?Qjs-eka5/Cx;9/^)B1CMpGg)If2JU=9l(7GHpS%i[,=&bDVO'Fhu,e4mP$-G?=v#@+6)4XS>Q'E[*t$.VET.4;Q%b<G?`aNGW]+(sq%4iB?S'Ht[s$a%NT/kK(E#+r0(4C?N'%D)3^4iA>W-IlOn*L7$Q8.YX$0[lH1i7S'f)Of@i1r$D[,$$4=)d=2s$bbO-)$$V<-5erwGd#fM1+8A+O/&kN(2$xX-t&)Z[:W`>-S<^M'<dpf$@Ykm[Zl<p'Lb%/M;?6##<)n<%@Nm2;ZBs?#-E/$nhc0<7%5ZA#s(QwnlM(u$abfM'CXX/2`>F;/wHeF4[m5%-w0tD#JO-s&B0dq&]ggQ&c3ZgLDWgK1LjuN'YKI'%/]'j(7,j$'e:87&r(xf(a8Hv1)&ht:L1f6&k:MZuG/)%,&?rp.8sNP8J5hI;WfQ_#Ve##,]$%##0R(f)3bC?%[/E.32&)C&Rf>QB1;cD4tW>ND>qYF#3GZp%G$b-E>`&r1aluY#;Wuu>vevc#-Uev#mva?#3V1v#[kwY#<_82'i+R8%K_0m&dGhq%HBP/(5k3?(BFV?#w'XK#1@R<$Mi_'/Es1B#[:?I4?[WP&euY29&>*9.&js[tgUGfhWn>>,j0.5/#-'/1/vu(3Xn$##&$:u$]1[s$kv,T%nHSP/g3YD#7c7%-J]B.*nt(H*&Vw;%xdS8%V`x_4F#OH*=Q/J3m9q54pVBFEFPxT&GW<+*T?P]'c,is/RdC(G6cj.55e%[)FB[K)1Ak?Q$bnk?vjfp(vos/)<@^g1*Dt@?8^VM'oi(Z-Lu$tL(Rdx%s)uo%^hHP/DJ(]MjFx9.:7F]-%i:8.?L.U.9@L+*FX.:.`@i?#m+vd3[<+J*3hp:/c#DP-u5-F9-5)-*7#K+*=L6$g%<eB$/En2LPnDD%VW)C&'LT$';1RG*.j.0LPq,.)RIdP/DSu>#jq;v#tj+U%Xf6W$wsfslGq&6&BdFk0RGh$Dm_kCNx>eZ$np6r@cHk6&L:Z8-r[;m/TGmZ$-uPW-n=Zqpk<7##94i$#NXI%#/uJ*#v$),#/[%-#MKHH3WjYW.#07d2]p*P(d#5J*T,)Y$hK/@#okCP2=p1P-qPn./O29f31kSe$*;f;.Ov@vOSlx=%nEs?#kE`a4vF)?#@f])=;DM+VV5do/B-).)oorZu,'[gu`FS>,Xq/q%9bKm&9X6>6*%B>(=1BSMr1[()Cifh(*<xiLs]$G,_N+>d-5Oo7dD24'FZJZuK>o0#=G3GVDk0)*8.7W$;bJs$twF:&LJ0?P6/_SOqEiK,>uV`F(JZf:G_6(#rXW]4He,87VB')3eRYI)odtq%t,><-wT:L(.vUv-PF_Y,tOJd)-.C(4*QCSIj^m.)2:B=%YrgC%=VG+>D#2I2(S>C+OiKmAqI1GV[XD<'l1Po$;Zct1jHoe$#5u;-MkrMMVc[^7%rB'#&8Yuu:m6o#PxT%1Ri8*#;sgo.U9Gj'Vm]a*&v>W-I^L(&l4NT/jr%&4)%[LMj[m=7*Eg8.$MbI)$67s.0d/[$GG2^#QKG>#[T+IH1JucMXqZ1Mg'qY?9Tq8IN1R8%G>fv#p>T&&#:A%b:1G>#RST@2>@.<$tN,tOtYG=$lp0d28'iG)Txt5(>vlY>[wf*%9UikLS<@U7t_Ph#]5YY#uY8xt^FOcMbBAJ1m(8C4t(4I)xH2>&j9+0NCPZA##XIh&o:SW?ZkuN':1[`<*aWE*@OTk1];;o&Kn+A'.eF^&D37o[NYRW?+VRD&IW4d.m`sJsth]S##*Y6#9(V$#(1Vd*fCw9.;,Bf33(?a*O2vs-BA$vLZ&DZ+wOk.)Abm(5'Y_.Gi4wn]c6*;nT%[0)3=Pf<21k3G>ldZM_Smi49JQ%b)qx@bsJU`3_J9G;F]tr-;`tw5#F_i(6^d;%Jtr?#Owkj1EHuD#NRI6/qpvD*RRT@>s-H,*v#Ks-.41o*xIuT%/u>V#$Jj=Gf7A9&6F,b#@62S&vPjA+'KFb+'woW$k'ar.8D.cV.0Sa+v8t//hg#0(K.D.$WWZ^7(7a9%L:nS%Bi:x%N^g:%'3X?#mCO_$doVl*3kl<--hq`$:u)T.H-4&#-x^4.vS'Q;w$dG*UP.r.gl@d)FC%bmhf]+4.vOv,w@pV-pJCCkVqUE43>km'#i<<%B3J6%)aM#RioID*QHGN'2fbHuS)cG8-O49%>;1<-80Dj9L8ffL$RaWB+YPs-?lmgN@[;+;j)B;IbgmA#G7K$.5mi`DMfZ`,A4L/)Ikjp%k37=-uImv#k-oS%h'&j0`=G)NWkoQ0_vqm7?K[*Nr=,h%>`Wucgk18.=.=#(B23,)MH_5:6IB$-Jtr?#@5%E3+0n9Dg1u<M[Upkp2pA'+7VI6021.Q/P`OsutM]2&'NQe%7-Mn:UWpq%%t*MMAHqau4]5RFp4h^#p@)4#;mk:A9k0B#T$D.3$KGp.TekD#h%6l9/b(*4[.rv-8[nLMG'U&$7ZWI)=]Q)FrNc#@$;%?$GTjH*GEUwKATnH-S'49%'Z-0)qD24'ub=F3_n[f7$UFY7R*kp%nVUPMPI-##4l]l'E*hEeSqA6)P$Xp%ex,##PLf34`s`^>$hf<$sx)%0B%%-N]kb_ZZ[Quu7dqR#TYL7#CtNu*9CFN0%i:8.tjng)w.5jLPev>#.(T&v)`J,&:T0<7Y$x[-cj9S2o%d,4LXUK2WYVB#D6.1(KXfjV7L,I)RA3E*X6'V%foM<L$Us-4j7<I*Px+TcEFf.(=Gc?^>qje$<Fi<-a>uVffTNmLR@#&#/sgo.vNkG%=;gF47>PjL?DG++ux:K1X5V:%()MT/>U^:/H8Hb%W(3H*W$5N'/TQ/*pabP07DC00HHGA#vxr11w6)D+,au8%mWES(9[FU%9X':%EH8P<N:;Z#7_/*F'Xg$-)ncr/)RE?#3h-'58-'7/wJLB#$=P^$cO7W$<6#9%>gga<OS82'T#R90Lw`E[L,###fN,/LBtK^,dxl%=VVMt->n4(P'aIp.fjGj'@0vD'gk)VA3VbA#lx89/AJ]_4MS@*nUt[Nk'rdY#1O`&5?<H-dUtAu.b3fw-4QIh(d@-YuSW%l'9`.3'IcF]%I=*#$foJ;0i?W20nbOU%;Zv3'cTmV@+2E=.UFpv5bFY?,U6cd20>l(5ULb%$,JY>#+)H^,o;,A#Ud9U%@;>%PwhN(6CX$H)EUDZ@lSlb+QNQB$`M$(#,>5uuqg8Yl.9o]$Hs?D*k9IP/8lNY5_Dt+;sg%##f2$w-DM;-m$d``3+r@8%uugI*$:*Q/RTZd3Z3f.*AVgGN%r)E,n,Y,26ktD#n`aI)vv@.*[(Ls-;JjD#8$:u$RFGH3)EnkES[(Z#4oq;$bYr&$Q:#N%Bw>c#vZJp%1tt[Aq;`m/[#Q;$1,57()vH8%m_qY#-S1v#E_Cv#]lxe#kM1<+:?$$oYg.<$4rU:7wBP>#Av5s$/0'W$[O-m27]JMB#p>2T/^G#YFM1v#K%t20KDPxP2VlY#7Kc>#U5BZ#,WL;$9ZSFUaa1@c2T%v#6)L(a]Dr7e@/rup.$pN-.u0[%.bc,6ZDOZ6v8&ktt,HT.Y@u)4(Ue;$dcf;$jMjo]=[ooS4D1n%Yr?U%/r9A=S,18I]0<v5CW_tQLO]YcjfOa$0d[=FO^=;HsW[W$eB('#2BQQ/0H.%#%2<)#JYis-n$I1Mn6E.3`h%s$7oQs-g1dL:npC(&UO4T%pB]@#Ikdp.H='U).U5Y%wJ;^4QHGN'rxrsY`W0T7XX1XMJcLV.w:+.)?f69%RDHW.PtfT%XNXT%c7v?0ccnW?4E3N`2N&L&>&J-)ST8kXRp=:viD3L#I0`$#Z1g*#1Ef5/M#)T.1'X:.M=%q.Nn@8%R1cMtl_Zx6(X[R]+fuS/B$Fr$xt'f)U*TM's3vr-6cGg)F7#`4mbK+*,I0q%2h8O0Gud^k*#Rj9uFdH->r:/:he&U%-P^E>Eh+I3NgR;6nr$W$w8x,;>LRw#jueP'C5t5(M3gM']Ce`ab](WHA/%w>aNeK)mh16(GAHX7Oqbp.aFg'+/NBK4a+F5&ukW@$QFH$&Xc]#,UG<E*tjTu$Ed.@#@*aQjU&###=98v#i]cf1:E-)*.R,gL1`Cu$?ArB#uWqhL5mMs-Xngx$/W8f3stC.3;@'E#G#vgl+AF.3=*AZ3QtwH+(7IA,E6PY>hU7<$LL:F*v[+i(lDQn&&*Bn/s:'k1E*hE#?g6R(g?:>?0ckQ'jo8'+;h3u-nbp'+Pge?$eK_^>,]lE*_:1hPQ:4a<f38N0tD-(#_[P+#Ist.#44B2#bQD4#]lP]4MFn8%x3vr-kZ*G4[`JD**^e`*k&HT.N)b.31dXhWeD&J3Ungg%%BOZ6m('J3r_E^-m'2F7]d8x,ZW;M/[q'E#_3rhLrEi8.>x+gL1v;Y$:tJ,*;u(#(-Na.37hUhL3/,V/t4eb%1]^F*+bFU%1oiW$8RA2'@5@W$=eww#I*PJ(X@-p.hOxT&U08s$:;vY[C_39%JqC&4?s&q%=pY^=OY+Z,dI@w#)cP>#juZw'mg7_8]L<9%[%7s$C-h8/]mK2'*VeEP]K@:09;K6&.r9T7vGKe$;6$o&#YXAuRmlN'snAo31Cs;$j?F2'RXaQ&KA%[#jgn1&+=U@%W;mC&,<io&Bbap%pSqM'i;Px#jm<e'#1lgLhKAs$83u5&4Ze<$>]FgL'cxs?Jsv`*o_5-4k15Yub_P>u&].rmO5a]+GCRo%w,sbNA)_N(Jv4D<R[)>G7[J6)]B7f3?pCD&s;c;-KO$&%w)SF4h:AC#v+6f*6JET.rH%x,q_^n$$6MG)MT.I6>;2H*.D,G4u`&@'RRu)4bfZ%*fiHT%.+CJ)3_AG2C_39%r<Hk(c9x[#JkET%>_em/N:9U%`_*X$H`Ys-*]Sm*_YNR/@.g#,2O)%,R>^t%ZTXp%fZi0(EucY#GBeBO-jBa%Ie=V/6e_a4P)R^4@']x,DWws$ZgUV$9DH%bguC`asU^l8=8h8.j,Tv-'qLg1#GXI)Njhc)r[<9/OChhLS0<iM6QrhL+wjV$D%I=7F1f]4H^8R.>;gF4Y.e,*ggqZHBi5g)+&?X$x`(<-nq.U.]7]X%wunh%EtTn&cp`]+#8(<-dD7h(fH#n&u;hu$7=.[#2x6s$.IH,*p'-K)k^J#G?FlM(b*#44R3-K%P7u58+nW>-.+(B#^DJ;MNe-3qkYxp&8[Jd+$a<($[VsA+pF/t%/`Cv#:=<p%m?8@#`+g#,mhdp.]%b7M&rlM?u)72L9o9a30==I%/5>##361R#ikh7#h^''#$I19&+Os?#*e75/Sr/gLRTv)4>NCl:QRYF%9_iCHd;Mo&oJ_Q&e_*X$8boj0Ysp:%p)*B+wOk.)Hp.T%^j-o#+<]IqPdUg(t'uq&hN/W$DBUH2QHKU%?=[S%K]3(M^-pc2%2Puu:g-o#,XL7#fd0'#sh^r0[V0<7`qqHQVdlD#'c7%-X`*E*W))Y$o/_:%PEZd3B*#]#&jws?]82o&&9TV.1Xct?3fFO1oPVS&2^3%tNnYMpMT@K)'>YYuMgXZ-3@p6*AFGgLD+l.))#?_/OVso&s/Ld2@?Uc)(AkNp*####]uh)dWkd##IXI%#<93G7k`X.#u:w0#OwP3#*^+6#V7I8#c&(,)QsGA#(:b=.cl?#6@*`ENx$1f)PK`$'`s3.-id<r7'x]G3jgtW-Hj,:p1N/c$x5MG);G`9.wHeF4r%`W-wO]E-@Jhv-+Kwa-Z9j?#PPdG*<9+Q'AbJ%'M=xD&?dkVn>L:&53.5F%kL.F%&O#W%i.oFM`#?/(>f4Q0b40J)ILRs$rZNvMW3]S%j_F,M35kmfW0;p/HK4v-R6SjMkR#sM`aX_P1f>;-$UEa%:LMs%h2Xjawm3D%;_.u-2/:@MvgR@)A-'O0ew*t$$4NQ/*t)bNw7[;%(ufU)$8C/-anN9%<(N+7I#[$0W>uu#9DH%b<G?`aV@LS.Hjo(<iq7J3w-;a4MV&E#YiWI)P3j;7d>qi',bZv,`,b/2DpCEMdQ>V->cxX[:_.D%Fer65T@Nuf)3(B-$aoH-;L1hL&j,t$9?6X7qUZt-Kh9G&ga_sd`WOv-t`U[MIwr<-'>cuu9^hR#F[pD337p*#7I?D*1h5N';f)T/CI?S'#34k1Nnpr6Z&PA#`,:Y$tCBv-DcVe.IIV@,^Kxf$t^v)4.#jQ0S)ZA#K;gF4PNwV@t$7,=AsYx#G+`;$MTuJ(x[0T71PY>#Ko`]-qnn7n`:%97tv9H2e%bI)$%,.)[f0#&e_c;-:&i-2^S*T@V5do/m6Y44LG`?#e;*qeA$5/(64.<$$B3W%bBAj0HS?%bS=<2ql8#oLU@9`=dD24'9/83'UjgR)T`KkLbI<mLvGdo/.HarT>hX)#k,>>#M%p+M,(w*&3CQv$X_A0sC>%m-5I8X'aD&J3kewG*.kDU0Gw629r%]-)a4u;-H)uve5IGH36459%9e]#GWvAS'UdPN'%[<:.l(Yv,*LFq%D7;?#s`bM(xULhL3VJr/Bmjp%JTiF*8Pu@2tG&h2SQ^6&b.5_+O-Kq%9`I)<kofs70dx+;`uP9`3ZVO':7%s$:&sc).qB:%4(;sg*c@C#G7[=7W2P)4L,d%J4UkD#SkEg)i=>#/lYU:%^7^F*_=KG0xF[W$mW0Y$.4L=S1,^,Na$+p%'N9w#],aA+^3^q%J$Xp%ooil0h/uXI1]C;$KXNp%H[e^2KHMm&AOwW$ei;<%.b>[-[]Nv3%M>jDRn10CI<gQ&Z/%_#I&I-)&?V.2`(oC#vis$%M<bT%]P;s%QaD-mH^x9v.6pE#QZI%#6CHP.7QCD3*x>U/Jd_:%P]d8/u<RF438LP%T#(T.=Ha.3-BGOMbM$C##00v#:KnS[/OvJ6MV/H%2Gc>#FJnd)+gti&*%S6&Q@V?#Yi%p&.W0T7J@mi;Li4J_Ux:Y7XM0Q:DQCn#.V%n&sWUsd1YZ]M<>>M&?dA1M;@P1#$&>uu16wK#tCV,#hBT)=_QJ=%iL0+*&9G=7:d8x,OgGj'Qau[$upVa4_CDd3vg.AOif]+4TMrB#i8-9/Je75/r*UfLW,B.*(irn<sRk:Cm+DhGN%F;%@5kx%P#r,)GFDZ#$Epr.q6xA,3&mO0/p7*/L$iR'iVdofXfc;-hPqw-lXFgLa5.V%`Jaa*.jCh1.5u;-=/g/-Rj<+N9rJfLX$[uum7YY#:,[0#[?O&#O,>>#O1WM-Q.`W$``I-dF5Qb4xE_x$?q5V/#@]s$%aC(&&HM2i/ks`+3qE;7AqaQ/YAKW7S6EF*83H=AxILW-xUkA#t;@B4]9T'?$s8$5<ks6/?[4uA4V-L0BrCEO]`l@09JQ%bixC`aI4-eQc^Q)*ZY4kOIYCv-w^v)4qc@A4'xr?#Qe+`#[G<p%RD/i%@u$W$qHrs-*4$@/%s2U%LT1K(iO4gLih@`a-ei3VG.4sBn+N7#iUG+##1;,#ls``H0`sJ%Y@%gD./7m0V'iq7ewfG3+9v]'/BqB#L&B.*qPA+4LSi=.ZA)m0o)P'&-%18'LRFHVZML&54HY%'n.[p%Lmd`*(ir=-H8G)36Lg:%,XT<LE2UH#Y2qK%*=_b*#l.<-Y=)t-&?]?Pu^49%[itILbZUg15m6o#fXL7#RuJ*#4RZ`*@@JW-5%-b>x@rB#i/=0&.d%H)px'F.FBG3bc%NT/Xj$M;6e_a4tP2)3Y1lJCj`FJ*;O'>.%rN`#1do$5K0Bg4idpq%[sQwRdP#<-X^d&%x:34'8#b[$6ex&GTE.$(dPEA+5wQS'L9Bq%aj9Y$]%)hC:D74'+^s.34DlgL@moo<O`d--;Pk.)X2(_,u8c`<wK@gLMEKO0NR%p(kpQ`4SoIfLQ_6##Z_RP&Wo8>,)$4L:5-Bv-*Rlf%[>Rv$D(^C4-9]+4O&<+36@O;RR>]>hV]ROVlJ]Ni/nfI_ofY`5>hhN=RIhc=RV8'7=C^5'<kY6'nvtM*EFZi9P:hB#0YL7#?L7%#W'cH50-8x,?15jBVZPs.X*r-M+V@C#[SMp.ikkj1niF0=L@<9/h?=g1EK(E#QuSfL_eVS.V5do/4qZB+cUU<-Nj*.)<OC>,2&Wm/C,fH)FJ@n&g.Fa*E<,n&W6fl)qRbm'o=J9&[tjP&8u@n9'[+A#pRCp0(#O=,keL@,9kl0L(<_s-/gi[.ks.hCVjv`*rxN7'oJo`$V>dV%_MHV%(#od)dt-lLAYOn%jm95&dt-5/1+`58j_HC#J@[s$oUFb3_&B.*,CmG*<&HK)JnK,3,uV0G`;Zp%YRPG**k&@#(>x_uR$TfL[iC:8)_Y)09UF7,B569%K/W.Lk0&W$.wjxF_wbr/L8;s%(7r)5OG:;$65qCaS<F`a7[Erpvt,Z,B*TM',OTfLkvW*G#@o79`ZlS/G2-<-=14J%Iej:8<OP8/3L$C#=kCv#FRwW$WCd2'*4$?$,@.JQs[qJ-kBX/>re;Z#h&#b%3<*Q+wOk.)It&T.>[<t$lfH=.4kX;$30o5'AU=BQ_p-Z(UqT1;UH/^5h5mj'v*AW;(lX&#E_P7AONUV&)Jl>#k%AA4a2.l'*0^]=?26q%OFrZ##Ge2032GJ&_^0q%:uq*%H>uu#38i20NB%%#m@*1#mjk<8viYA#R4r?#PCr?#m)t<:CI;8.s59m8#e:%G]Z[gsq_Z=7TB]s$x6RE.Wj:9/Q[K$-#:[x6#,m]#dYL:8o;`BS5$CD3#j8^HR=uRKN]Og1)^1T/#sbm+C*F]#KwWt$WosI)0r-W$rv03'x5:H2HKGp%J$Xp%N[$G=+=xNMbMZZ$t$$u%T?9q%lj^*<YKZ&4TjY3'kp#Z.E0Pj'9lfl'ZUQT.,@hq)IHu5&'&&7&bY.s$E_wS%F$+A#3T7iLX]Q>#+0#9%SKfnL=;#gLMTJt/LDtXZKkap%79s^%55Zp%I%c?I_daZ6_Ld?,wIgw'R8QT%]9ngLt`_E<V*=p%RY4O1i%Kx$iJDk'/N6a3%,BL,^7Gx%O)A<Z*;rZ#0c$s$*Z0W$q$Yu%IYY##*P(vu:m6o#%XL7#dQk&#.^Q(#XOrp$8MxP'W5MG)v]WH=mbZx6bM#)<(9l0jmMa.3vbLs-rjdR*UT*#,hm0U%R8*E*rk.6&617<$1PuY#lPUM'L9Bq%#v,W-[`74gHc=fa9Yx904.PF+iQtT%glI-)WmcN'CX>+GUD6>RDY]9GEn$SV4)Tu.$EP`<qc0^#-].+19(V$#[;L/#mjKS.3/d/)*B6*n)Y65/eQAg:H8Qv$kXvgb=R_58TsUN=MpIj%FB_,;00b^,xSCD3i,*J<i<Zv$B0GY>]a`#5-;@<.oA/H:^I;h3L3vN'f68='6TF++D6_)=E@@W$;7Rs$b0kt$Rsc3'oS-3'KLIs$b)6v$<wRu-tZdaNKf<k'7))(&*a;#5ft5j'O9OT%6lx@8H>'3270QHE@hi&._TolL$^oH)VA24'JN6E3T@I2TTd$249t(W)]'tT%wMEX.Psc7&'E,o/Z<1_A6M`8gR($&+q+XT%]:35&PAw%+lBel/`-%##7<Nv6Kf^I*D/;u$*W8f3dU(f)Tj<c4]fXjL3<+u-_7/v$,Tj.3gb%f$#53T%N?K.*M8jc)ud&U7*D]5DutS.Ep,Pu#16_0(1<pO2T(-##.+CJ)X=Wi4HpZb<uFmP9ofvJ;@wo)9KOM1313x-4C_@w#/&dv#D1uZ6nxco89TWoAT0<S0.=ZC+90B9(%PYi9D3I2L$_d>n;>qeXIL=j1-xWj$+.ji0-<Y0.wH7lLE[Af30d%H)^5xj%=+[HX&uoL(6%pZ5tq(<-lbJX(`>Vu.OY;B#gWT4LXf?%b^,DK(Q;BA,D,=.))tv8'v3Me-db.RN4Vpq#(YM4#/Vs)#akP]4CcK+*13<d*u7ap.s9uD#3`GkOZ$UfL(TNx-RFRm/9G>c4pGUv-#(L`$jQ:a#T@0L5T^A.*@=@8%w3@mL447m0ec7NU6tAs$6XZ)4=XWT%ZI[8%[90U%Fdun&vljp%7'#d2=b^H)I#ik'Qh8m&T1.<$g)*XC1(4w$o>.L2])Z9%:fR3:F[WT%b-pM'6[r%,)vJ?,dpo21e`n;%XvP7&Yd(k'h^YT%pmcN'`$]W$q&,S/-*oa+c^6&>Wujw$2.bW%mtL%,RHAE+g@Tn$#GSuc^7pu,:E-)*aU)Q/rh_V_UTZd3MPsD#G'xa57bLa4Ns/]t^82o&EIOk'&Sx'4bQ-.)O7M@.GWNE*5)K=utsBK#L))t-dQgnLZ3S>-tTX;.E2bX&_SKp&#u,I-OJ-<-uP^s$widu>eNNdX-)Z9%F(cI)Mq[s$:QU0.r`Wa40e#;/.t`.3h3UC4jAqB#ef6<.?=Vs-ZFq8.d7N,Y,%uZ%4JND#C/VHmw['B#Q4JiLd3sK*ajcn&M$^m&oR[s$ZQKU%Pb#W.K*0k07Gk350qOp%RqC=6<jOu%`;/'5T1:58`B.S'[XO/2O@ml/.%0OM26V-MFvv3'WdFx#^jVb7_aEmTmpL6&Ah]c2D[br/4ZUQ&jgT^-WlQ[-C,-f;BRJ886DR*+K<%29*w>PAFk@a??[bD#G)'J34heG3Sna,*:b%njnkkj1D4NT/Q]4R*vn@8%[YWI)apd)*'4h0,*d0<7`m(AXwesD#HYt/2fPXV-v0d%5TL52(_fiakZq%j0w+Is$XO:@,urQ$$wAR3'I2jA+Z_p,3fp?T.9%`;$b5q#$=1K('@v<o$h@O/2ho.21R@ml/[q[p.K%.<$n-1,)<tJj0nr3c#?*#j'jfIi1k`ah%&'OZ#'4Qv$(F0F&I;G##G_Oj0l&U'#S7p*#mp@.*F$Ts-$o2VANvD<%D-dA4@-joAk)>)4XvI@'@S058V-*M,7CI>#]?l(5LK>.8WSU^uA0rZ#:Gdo/7tiXMsLF**,Gr_&CmFQ']M^)5s])v7D^/-swx2+3.n@A,;E/i)8<+Q'2GI%'Dao5'4rJfLK[vuuH%Z)%%?W]+.;R]4wsUiBxx>`,LcXo$bC587D#J]OX$p:/VRpV.f=[l+2'L^-'>k)'o0G^$:(@s$&rK#$J;Z<-<EvW-LCJ]'06-A'OkIa5ccS%%YwM`%ZjJe$QnhrZ-/S38lVw(#*>P:v&e_S7UUBA+drP`<@Pk(Eu4/GMEc3P0^aQ)*jiWI)'FCmA5&$L2Jon;%]@[s$&-p8%'FEs-3]pP8*$H]uCB=W-[hIWAD)pt-hHj-$mPru5Q23&+k:Dj9Q_aT%P6Q/(n>KnLsWWZ##m:M:,g)h+53AE+aN+A#5IV$/Br_Q85;hN()[/s$N=iV$e*(lNXfLf)ut_%,bS9'+=mp7/4r9l8JM6QUW^X&##d+:vocaL#pL6(#&$S-#04B2#nI/l'*ljj12BfX-l:u$Iaf0<7cj#;/@^0>G'TV-*^tn8%a]B.*;nK(Gf+hn'mqPv,Ux/+*;#K+*&Op&GUN0V*KG2]-TL9U%Cn4'&bj9q%84@s$3u$W$Q&ER4*S:w,V60U%*9bV$=:7w#d6Jj0]%`Z#>gG'=9@mj)9$W>#Ib`Z#K/3**:q=/(jX@K)Coh;$5LpU.LBhlAQSg$&#Z?q%Pbe<$A.rv#[-M$$`9Zs%tu%1(h+P'A-;o5'`V:X1dg4O0sh)?-=iUv#kNNh#i'>/(CV(Z#=rL;$MvrZY4I6TQxljp%M:%oLQ$SS%t5rD3KtC$#tJ6(#+Ur,#KaX.#Yrbf(7an&4IDnC#+2pb4b^5N'Y?&s$IBuD#[*PX(&V65/^k@U.F4:+*_vK40[a<c48tFA#2E=_/5r>a*k0l<-g45Z%62>C+g4u;-a'//1MGq[6N;v@7p83o0H,c/M4lu8.M7$81Xvsj1DFe8%MXb4:u:dh2N@#r/i$&=-obs50W5Hq%)5.H;X0O2(#t&R'9%@s$ZO84'7=&@'-CHlf#dGG('WhU%`8IL(dQjmL<f<8(?Giq%EnWT%7sS2)VnZG$IIdY#u;GKNmi89*Wjc3'^2DK(tfV0(Yb;m/fB*02M696&Ho_e$3[mv$3`(Z#r+TV-g9WN3$KKu*tG_s-[v2`>7:H`,<RIw#Nghc)PEZd3'b<c4EPkI)_tuo715f$Rj'AT%DWt2&rQ<>-C7[s$tA5S/i%dY#UlEJ5SAi#R@:.s$3M?7;xmNe=(f>C+5u)F2IAQ2'C?7a$;ha9%:bW#7^8JC#UQNO5`g:N;6rCZ#](+PAE/S/;cZm63k]?f;:b9qKJH1E#B[u##@>N)#$=M,#KI?D*jm199Y13C=<f,g)x;_20BS7C#doJK2xSFe-2Fh^#u3YD#$WMV?tXCa4[.5I)?Q'*4-<Tv-M):I$WHSP/Vl6g)HXaIfB`d8/AYstE9(H@-dD24'>p3e)tv14'b:GZ,&cl8.%e@E+PY^N12Cs%,.h$sa.B(<-c;.h(RP7P'1q-2LNNjV7O?L-)Z8Z;%ihrf[=(;?#[,q8/*t+`6P=HlL#<Cq%3`H>#<A.6/e;s7/F1apL)Ndo/_oS+MRBIU0s[lZ,p.[mkF8QI8o[q2q%5YY#9DH%b$iUP/2wRc;%ro,30ZKs-c3q+MJf4c4)O`t(6>%T.hZ*G48x7Edb2Hj'vuQ/:nf5r@SBeC#j1%<$68[s$(r9x5?*G/(Kt`mLMNLnJi@R[-dTP3'`ZXt$H^&o8`gG/($(cn0KCLx5jTSj0>w,mSD%T2BT5_SI(YBp77Xg$-BxO**(fBf)9YwTI?;G#-u#.L(_1R[-*tSS%-DJfLt-gfLdfRr#``V4#(8E)#)->>#'TMV?:hc8/H#_VKIR^C4+P-AP.D;&PCttl&bmfx%ZTXp%:;DwSo41mTC;#UMm+^j2=1]b%h(sb,3Q/n$W6_)3Jrn-%/mWCQC_39%=Yb_&KorQMO-=IHWA=<H/M@6/3eWC$3^+MM)r6u:`u#E*VYr$'M&N-)&du'&.LvA5f:,Z$M:hEkGS2GVNrkr-^xhx=pLF9r+bQ;@vSmZ$[o[_#'L8[#Q_6G'$>6R%#G/I*4tFA#n_QP/;JjD#lb&<(PbZV-cu(s$eP&J3$fH=l<3wL8jNG/$QG%5':b82'GV1v#Co$s$[vk=$)fj`W$5>q]uAY40MDU?-EfKB%w[de$tnG;-L*kp%liES7cu%?AY](?#FF;v#Hu?8%X&1>$CBP3'H;&^+)JR11KW0T7x#g[#NR/m0;Y)^%+_nYMBK)?%_-f+%<vC`aQiou,D3[i9[+nXH(VH:RqS762kt[AeAS$w-47*N&6[MWJr3Ms-RCK>%t`_*Ie;Spqm_G;-fY$n;Av^C6E_o]64*;s/V+mC+Yobm1^ok#/8<H+<Sb%pAI$M(&#q<]IQ75R0ElCZ@=EK88>qccaW']F%#06s7GaA(Qq1Fa*a`EE3+gB.*n4^+4=Z8f39`p>,SiWI))OF)<oY3<UnuCSI*%WW-gc3eHW=rKGPg*32Ng4',o<:h(:ppj(Q9Bq%KZj1M&Sd3)(f>C+'$;-3&4@g2F.:$g[2v92EKhba.+CJ)E4hZ-IQIl'=dtm'rkcN%:W5^=rVJ2`5VIeMor0h$nS2GVnZai0/h7E5CbXD#EaoA,7iv[-kna5/<DtM(p-_fL/4(f)NNXA#>)P]F(;h^#bj*.)sGB@MBjSW7N1D?#:G***sTAe$?uu>#-c%[uOW@g:g5>b%T<FT%fe+9%HVLHMTVY8..:9U%wpLY7U4c#%P^U,)u3/9%S>AjKTs>V%f)vW%i+O$%8vaS7'7*/1/Fx3DmOVE/&Ql8/KNE/MV<j?#ck6q$DV>c4Bl$],+.`5/dbL+*]**>P;IK>cXv1)3=Ce8%KFs50?tOh#Lb)h)BRes$,DKB+k>ZG,0x_5/jYg^+I(2&Pe=f21Fr8e*t=ns$S..<$/E7iLmo?3'U4u;-7iC;$IF*p%ZN#V%-I2W%wxG`/r+`c`ArJfLY*euu8dqR#iXL7#@R@%#0>N)#_JwL%0)K+*YCh8.Fe75/YcJD*FMbI)'1/9.G,;u$<`o/1BkY)4RWgf1-R$v,VxG=7)j)M8H>'32*;]W$]GeH)q5cp%2>2s1qttq&ZxSw5i'))+2P#N'#w?JV;4lQ'jFoP'RIqZ/&v=;-<C712eFUh/daXT%Dqh^+#&bI3xM/W604'6&CWB?-a@W8&%](w,%Sc$,oYUY$*hM`+:o74r>`:%MG3A(#J]&*#ogwX-PP,G4E&Q,%3jic)<8`_Z5bgx$IIh[%n+]]4*kH)4mYo_>*#b>-u)bb$U%6+v5$Hq&`.?C%mp'H2t,+jLc)vV-g7pfL(F?_+Get.LhGi7@PS?T.]MAC+eW+A#o5IrA]PwS@Z8Z;%ENo*5<#PY-Y:Bp&O?,3';bEN0q/Y=$Vt/H+^2SVM-gq@-.2=i%TDluu001n#*kh7#BL7%#U;x-#>->>#D)MT/S&Du$,H#g1`V&J3Di^F*g&fTi@)CR'3eUa4m#:u$i.<9/i2c'&2MbI)0uY<-'Dg;-$-UW.<E6C#/rY<-LfG<-Fb0)M1,V:%iL0+*s9uD#/Y<9/FV'f)Y[rW'-qYF#7xBJ)&VXY/GLNrR-tkP&O'Ft$b<Sv3OQgQ&,&2X.@b2M)D3pM'EW4336`xH)O;bG4(f,(+N9Ts$7?oE+E&Fn'C4rZ#PpJx,6MHb%mM+N9#J*A-<@R<$G`u4gV5do/Eda=&oo7L(U4)ZuxWP42CBQT0nulT8UqOe<W<dS-s7@W$r$D`+V:^r%7.i?#xkT'+x(8p&52Wm/WN%PBdZ?V%F=[s$?eFt$wVAj2Ij-H)'E6_-NV=I)fZkG2LZ$v$'VBh4hF$##&&>uu1:G>#Y;F&#K1g*#$2QA#3(*W-^#*C7gYSF4g48C#]X':)Y@NH*jAqB##o-lL0P7C#HPvG*5if:)TbTU)&Ftr8IqK80@ia6&C.ugL4w?N')p-I2]UTp%ZTXp%qC>'%;Z5^=5S+U%;+&G5<UW5&Xu-b6J8IN'm$^O&BM0as.+CJ)PtIw#xB1r&ttP8[crsp%qgJf$aO+gLR.2'%SNv5&j&@G=8+%<$.u0HM=h'`$pvv%+Zt$##&ctM(>Mh;-*iFf%w=PjL/TIp.Y-&OV^>Wi%^CE(&SY1E%CZ59%no'HMKvX`<=cOo7^+6LM^4eTM^N&@#Pd1*M*`D<FRmNYdnYtJ25W<pD:%co7m*UaS)IL,3wc``3Z2Cv-0cgA#%/Hs-[I`/Uffi/W@Mkg6(vF:vH'V?#[GX&#$3h'#4dZ(#Lc/*#@69u$MxIjih%>c4YESP/K?-<gV3Bv$#^B.*js>V/J3Fx#sRl87(uL5/j7#`4`grhL>>D:%$w:fqF4f_u?fUg(Z9]s$H12w&Kg_g(W&HV%YZM]-Xx+$,G3-I<GhEe)V&]wYG1q%YIImxY;=d&4dq=K1e`)<%gHeY#s/lH5:8CQ$:OUB+s^-B+SZlJ(#UCV&li&F*?U*?#S)4W6l%HR/)Ek-$WBBR/A^CN'V>d2T]aB:%;ru##Rr[fL?orn#_,]f0kvK'#C9OA#m'(hL$E]s$-Y9v/MVt1)e/ob4s=pr6R+h.*xIo+MKH&g4nRMM0Gc4i(JiXV&ja0d2sx3=$4VrQ3E*Bm&*[B`=xGrg*o<,W%7q<B,nkc,*B@.0)Q/.n&kv'd2#PNp%>1@8%k_&Q&D9M/)pbu?,xD2W%)mxc*N&mD/-,Y:vjtRfLs/W'#T=#+#3b.-#hxQ0#JwP3#Itgo.l5MG))HG'ZaB3mLXaP0&/VFksoP_:%m2Gt-hmI)EYJn,=3Hjd*uI:dM[EHH3.:^OTD2-K)P9QcM?PrB#x.TF*lf-F%.rUq)@wY=?4O]b.OQ3D#2CEp%uuNo7`Va]+BMD?>Gljp%Yre+MN)DmreB:SeD,1<-2D^3%1q'H2=4;9.]Y>+0WIX>-)rXJigTCgL<A9(Od'j*OQ)w^$@o;Q&Qp14')NRGV'ee,XJAXp'1Emb@FNU738iZW-M;uX?7HjV7$]r2LSQu/(i6_I6,[F(&[G:;$2Z4f_<G?`ad<ai0eCIY>8$M8_%V@C#PQ<^%vg;E4duI*PjJYA#K&d5/_&ID*lZ`8Ap&_w0]RHB?Se)?#9Z9<-s<s5%U)ZA#xQ([,aX1b$SK9Y$c#)T&[]jRQ/E<kBQ,2S&hmlS&u)g#GI.2Zu(l5<-e9;iL//VQVY,=x'1UkV7p?gcN==Dp&<GAF-KN]b-q@6hGitVUM_####'&P:vInAE#wTl##?.`$#*c/*#oY1T/hGo;3$(Zg)sxgI*MkDs-k%AA4Y1`/:d+IQ2`sCt%Mwip11P.U/(LOG2d4Ew&Inwo%>AjN+NgIgul';?#YLljBZ;WL%Xf]#,h4u;-HY?%b8^pJ)WZ,11=;5##tm62LN7am&LNPS.N@)w&2Eco$1S&T^(Jg;-It6]-SpcNb%MkGMCoxK#uBP##Hww%#2Ja)#RHLpLsMo8%'4X=.<p<Z$SJX?gcD;d2%((028Fn8%uR'k.jiWI)_+M&&d2<s.^?GT%x.q.*q,8u6C4NT/0UYQ'dL0+*-.,DWPhE5CAG/A#keljBKnn@#7scg)bJNE*iw]$p<%Ci2K<4S67uP:A)]ng3*[][#YbIw#>B?^$XFS:/^qA/+4go3/k$Is&R-Kt:)[tt$uF/p&ni.0Ld2m4:rsdU65/jd,ae^#8`#QX.GW9')64x8%wg*W-bXgg2#)3+MNRZY#O*[0#nG$P&_TIg)<(6,DQ65d3RDhh=a2E.3pZn%Fg)/d<_`GL#S;Zp%=Y5LM6&0P%m/Yp%4C39%5wA*[:_q$'vojE,GdF?-AI&V%J2%AbCOgr6#07JCbdXoIiB?S'X5MG)@lr5M6[XD#[q'E#Vsg*%3gOO<k[Zx6G.7X$&V<Q/P&Du$N`0i)eLeG*8j,K)6?V-MAAZ)4N8o^fn^q]@Wb6lL46YI)QnS:/.m@d)F4p_4BW;T%I2YOqT<X9%KrN-))_[],Kqjp%`3sZ#DwWt$YVNI)gJGb%vU&m&ZR[<$8r-s$&E$r%m8O[V:n.xadDI-)JbG>#q*ST%?73m/hf(Z-QDR?$-tqb*GCrv#fJ,n&4rs@$@W:0(5&?c(S_`?#e/'+*SdP3':geiL*A,gLqmxF46u-s$L8I#-H%HT1FO[<$hW+]urLd9)gM:X1'>K/)?@K9Mh=xp&n'X0;m`NS&#aLq%<i:v#NWcj'XDuu#4)U(anC@]bDLKV6ibEV?;5V9/lHSP/?]d8/0MrhbuR+E*O1[s$[RUa4-@XA#Hcco$#-f9Cn=+E*RT^@#a>-F%bgG<%YIV8%,07s$'6gR/BQA<7b;ZR&Betl&'6d3',lN)WQ`4Z,@Jvs.US4&%*QOfGMJDv>DJDT/gW4]uU6X^.5W2TA)S^P8^XLw,FfFI#eYs3;7b;GDax*m';wh8IIZPn&^;2L+C+5E&:XGL2%pp5S#c?iC?1V?#'(VW7<<;W/%2PuuZ-Zr#r@)4#IL7%#mp@.*==.[#cI=j1uWI5/^[)W-=xQxk*d)#5c4fl'>Vb$,r:W`#7&QiTx5^A#j^*:*1[c?(r.K'+R[7X':lN7#&`c9'w_`uG`.(##`@;*%Oo[:/gA6j96-3Z6g?rkLoBs?#$8gV-(?0I$Nsg5/*-T%6BvVhL1XkD#1F8-;29?v$+%/W-Ath0,*N.)*N1[s$`uQ#6XIuJMlhb02&Cs?#W+]]4CY@C#GbRP/Xxs,&*Jq,3Yk1DfAWiS%'%hkH'KuY#[Bu/(TKO=$J6O]#ZTo8%LR39%Q_W5&57nS%K#0x$^e39%ZCw8%OhMv#;%%<$;Fe20b@1<-MjYR&&*L=(v4rv#GEI%?VRIW$_8I-)6%%=-&eV-*p%+I)Hx:?#OpZ]/jRP5*EE^U%,h>Q/QAaA+51%[#O&7H)Ndp:%L0XX$C(.s$>ksP&?[<9%<=Is$=UN5&2nD[$IqNT%N`QYQ?C3p%2N9b%o2E&+#19#5qH#7&uY&B+#uT+*WHB6&)####%####13>>#R(V$#)w>=(DXoXf:Bjb$Fh/W-dtExoYubo$$Kfa*0+gp.YWU7#'a-A.?38G;R?kM(nK/W-^ssEc57m<-$cO%Q>Gq0Mai4oM=p?e/w`8xt7qV>#cE[70Tb$##^frk'tc(T/Mtn8%?@i?#,R)w$l^*G4t96GMHn#`4iE(E#Gf[F<DG_s-.@sp%?0Zr%5N*&+g`R-)eTj:.iKB9.3ltE*UlJ'+Ii6lL6fT^+nIqB<<v+)O+HIr88cVx-FROt$usa6/jrv#>%@Yx#OQvE7$<.)*29v7&<LY]uGB<U2x#*C#W`GxkxOE`W;l###l[i;-Wk5l$S^uD#bv)E*4HEE4,#Y(jAu-2hhA//hp#h#$@7@B,O^gqADi4'.)sKgD1Z5W$ag$%/m_^#,w%5>LC@0;%K/x>/(,Y:v&S0%M$4$o$ENj(Ei[EQ/Gva.3vbLs-N([s-3b2r7#xlG*NQYd2dV8f3ZktD#WC[x6C4NT/a(e'&5v'-3[p?d)&5<X(gP[]4Bhp:/u^DE47Jh@6o:gF4%tP^,8Fn8%fhNB-P2US-'N[l$Qx`_&#(Ox#`4K+*B1rV$=@w8%SG&-)EuH8%2aNFN$,^f3&BJP%X`E.)nH@lLimSW$>=M?#X,@H)S#bC5dIFGMovf@#jki3=xk9AergNdXR^q2'0o_v#p:0f)<(`V$Z$B6&Gw+T%7x$<$o4tI)]1Pv,uU*A'K#aV&UaTY$M2Id)^9F=$#Wck0[AY>#ZxFv,:O_#$.HCV?N8q^#Cjh7#4pm(#M)jA4KGW/2p;Tv-Jc7C#PpvD*oo/f).x+gL/C;A/)<>x6F%AA4vI>Z,uPU)3+/rv-=`,Yup_ft%(#r6&GRi@,iIwo%9%Dv#`_a50=v2no#bNq.k'eJ&#-jh);G[5JhVnH)t,vk'L%hT7n>u=$9LnW$nr_^#O5=[,)nb@7(,)m(^T;B4%4nX-sbVw0mq.%#wfS=uE7Wh$AD`$'u.Ls-Z7[s$-ncI$QXI5/5IL,3<<u:?vR058b.rZ#CG#W-TGd'&m[TD$^x?`a6)6MTZZSs$CX=/%%;x1%i%$e$Jp_k'Ti###+;###Fp`S7v<wr$=wfi'Tf8>,%K>G2KbZ3F<^fX-stC.3Ab>d3W=_F*qvrI34d?a3QFYI)iV2,)5V7C#vFq8.o9rI3kh:8.>_Fo9-(g2BBMj`uZ1(t:+=pd,ls(D7_E[a,*fR=)X+F,3D0xa565wmWsJM-)f27fa'e>-6xj*_8t?.SApvrV89uPnAe.>;-]6q;.lS9>#Yi,nAD?hr/b7='#r2[CsSTB]bo'5kXYl@W]SMG^,U+YV-ZktD#;#[]4'`2D%1NgF%7GPw/+X^aunMrT7(_xZ,avso;l259%Vl%Zl;Opw>Y*Fh+7eZ3+oCppTj4/o#:WL7#]Xba=ElI@YXdu`4kucd3I>WD#[9..M$9Bj0a0P=??G8(O>[8]$;X^:/9xbkKccZv$FZ1K(M^H)*Fc5<-JVrt-j<d]OSE-/VYobm1T1OdaN`34'p@,%,et%@#Kt3:.uNYN'NY@21<n-@'W:IW$RO0?-,2ks/5,E:/Uu#4,Lf@QMt&R:v4c&Jqj<ol&`Olr-R[$##0Haa48aFo1#Sw;%^tn8%^qeX$&P%r8.1s20qNv)4%[*G4`h%s$R0h</6cEt$=0>p%=f]($58FrJgc:v#d5e$$Q,b9D7k+onn>ZA4gOIw#2VPC1p:Zv#5m,-5Nb)6LWloY,W[<t$RLniLgido/+gV#5UcDv#CpY11q#8w$A7xUd$*o._:679/2A7A44]7:V:cK+*]8v;%+*9fNIA>V/.v+G41(4.*+dfF4,Ff[#vu/+*q6Lx$@-RC#QAI$$tXf=%54@W$ojt2(Oho/.2c,jLF%>T8<1@8%pURw#7aOFfQ+;mQAM%lEC_TS+wOk.)^`ER8YhiM0U9Ac4[1HQ8JHP/(J_<t$Emg58Yr-s$@Ijcs7YxYQ?&eiL^PafLO:?C+=a.'#H<bxu-WVrT^EW$#0&*)#K]n'&eO.CSvm9u$4tJnLEcd8/&_<c4eKX,*s&Mp&>)'J3h:K>,IONY1cc``3Ab;QT-RZd3)E_PMMa_&$.h?S'voQN'x_7[#2J5c*<3Lu$a>omE=o)$'[K^6&>^Ta<M-'6&ve^b*u@;mLwQ1&49T-h(]kuN'_6gn&[`G/(KT7@YX_'-k:]_M#0$[aNkpNh#;XHaN=;m0)P4`$#&2P:v;'W>#;&J@%c:Vm9Is/02GH9u$hIo+MxnXI)I]OjLbF^I*3h;E4s0q+MVU$lLd)QI<^R5s.>G<Q/FIF<%.@sp%]3dr%=unw#O_3X$_Xlf(rD24'TsAbEWX)Q/Vaq&=,cQL2-^(-2g]-_u>ui99F6]Q:rim.3=Rg&=,r'Z/Gnv`EJbA2'<B@iLL=%c$$[,%.l8C1NJX>:&tK^&,oNRlLKwhOfU?H&#xng#$*BxI_^Q,*+=U(58(6h,F$YR_#2.=j0>;gF40k'u$=;.$$97G?>JHNh`Q,I8%ZeS6)]h<X$u0;,)WAiP-g;[J,2J?)%j@B/)MVB>%f=+j+V<5E+x`nr6;TN,3'&>uug5wK#FtC$#IL7%#TQZ`*PR/q.u:j=.JV:.$V>-H+46,xu92o2LwP.tLab@`a8JsIL5C1B#:&c'BRR8q'8.2M3Z3=&#qvK'#1dZ(#I#fF42KnL(p6/W-lNl-?(+gm0wSLD3u?lD#PggK)Uf%&4a_G)4k-e&/6[@E+aKn*IdGtMV.-X>-iw1XM<t0E#diNS7*obA#wXM2LDOGnNt5^2MoE[5LNxU<-4o.pAi.r5/w]###OG.+MsOu$M>td##dj9'#WI*x@gaKj(qT849kXY6WK,Bf3RnL+*g:Ls-ZI:E46p;+3;*YA#T0)9/eqvr-l)Us.l4ur-Tc#$0,=n=7u&x#0Jg4',*,p#,RlZp%em/I$QcSCsC:.W$UT3n8@hmm8#FG#%XO_#&4E:H2dD24'3I=.)`TRV6rOk.)G*rc)'Et$M9Aeo/9]69%k,HN'OT>n&ERe<$9KeW&9[PB$p^=gL[@?C+^a9U22oN_=jLrJ)vN*R1g-%%5FV###%&P:vuodMjocl&#gnu.9MD0j(iSw;.AQ[v?Y;Ib4rOe%-Rapi'34p_4?W$@'S%Wc4G4#`4;3u]#Q.i?#S`&02[]?C#l6XxbnO)<6ec&B+mkiZu_`Np%44h%2KO[DEfbN5&``+J)3ZjQ+/S1v#OI$u6u1B=%(Z1q%9ofZ5c+u;-FS_b*O[%f$U&3`Ngu&B+dLS,)QC(gC?TBx,ZwI9.xb#X&KV&2BDY(Z#JmcR&1Y8p&N/cF+dPHr%c]%-)?&cf*@G###'&>uu'b/E#@Oc##>]&*#Q.L4.n9<782Pld3S23,)*.g:/aS-<-r^BS/CtC.3w1=^4>?V,2`7%s$BQwb4aq@8%(&Vv-S0BW-LTG'okM[O'5G>V-SQ^6&9qfS%$_pvHSgv5/.sEI)F]RN'>0fl)qRbm'ji)w$_,Au6-d(l0KG+^,LHnY6w3q`NE]w_'.OuQ'U0pi'P8_sHs/?0)V5X5]d_J)=KQ?N0$Z/xt&c53'l[TuH7]mJ;>2i^oXv),Mqn*`Z26w,*:^PY>5:7F45HSF4h:AC#k%AA4,(a:8RuE^,^/l]#`JxfLR>(u$7?t-$csZ)4_kY)4eoFJCqn7/1CP6S%>%DZ#L?Bq%M396&R4jXcdD24'>vpv-s)dj'pZ.g)G%&6MJ3@'57Yrh7Q5`N*Ac&t%J$Xp%O$bT%MQ5n&2@O;Lm5qq%%ibM(T5U7/ck&@'c11'5=Wae3K6LfLM[duuZ-Zr#0ZLh.nid(#$N8#%-h_w-@<Tv-*Zkv6c8w)40fUWJ`$qk$ReI@@HskD<7EDH*V?(E#fii^ok8NZ%Enu/aS^DMO['N;$>B1K(Tip4L##<BQN@7&M8KA<$UwW5&ikhW%V9=]#vW-iLc#_wQj=/GV3D(3+eVK<-])LTTnS?R&NcVqLWE&HD`[-9.`_39%5)Qm8FB;#5.2wA0YM%`=&@q^#DZ=8%e%m%=xOhd'b7%s$94p_4V#-F%G<Tv-h.NT/IV/)*q)YA#`]1E4x<7f3SttY$PCF#-5e7u-w=4gLHq3Q/,.cGM3_Va4:9:T%iW$>87WId)JR`8(UNTU%WPn-))*xRR`U[8%S_[8%aw;Z#63xg:?`o-)XEOp%u(tA+U/Z_FDe&6&jSJK6Fd`c#0U7Z#iAHj0_N[S/um]t'W<f8%$BJa3ml$%'iQgq%Gq3X$K*p2'7PS(4xa0u$+q_V&]6^m&/$v/(N9)8&Ip3L)n4K#,mE_;&-Oks5*,Y:v>@P>#9vu+#9*]-#Y5C/#*SE1#hBhhL3*1+*hpB:%lP(T.CT(T/F8_H1;3wL2]lR_#MPsD#K:Mt-p;OVJ'oAg2^F6lLxYfF4$Y]n36mae3'3PT.iq_F*o:D*%?T&q'mjZR*ED^+4PDRv$$`^F*J=1H2+`qV$a:H;$#Y-9.&RikB4jY8/1P0DN.AG>#>U3t$L%@s$F$Xp%2TE**O.%/*1Y5<-<6Bk0T@%[#pqIq%mK&3077Gb%4-X2(7rus-&33JM8R,F#aC7w#eih;$e3Rt->$Y.+:nVR8r&j3(vON`#D'pM'<U&m&N%.W$d^Fg1K87l'>P;p/3G.w-prsE*Z%/=%Yox>,<(Is$Rp`a-?3++%`7@f$`CAr%G3%?$EcGLMbt78%aBLdk]`a,#dk3+H)>YD4q1M/:`h@%>31$Z$p9'9.Ut;8.d`Up.w?uD#K]ESCsYYA#5NCD3eO#1%&LIxIg]ic)RT70)nKs52&41+*<hYO'][K6A8B_s-T>HZ$PN^2'Le+n0IX8$vNx06(.fBJ)I](=QNQ%`$4mFjL5guX$cjJ[uM-b#9T[r%,frn+Mi#0nL)dK;-9Ef_5]kCF*D<,<8Xgk^,cV+%,6f7A,'fZE3x?RHNPRS=-S$U]=dO+kuYh4',s@F&#2e5d2FS2GVUuou,VB')3+$lk0j8k-$QXkD#CG5s-3>c/MF/:Z-/4CB#<.s#PBMl-$nO:GD(NT1T]o=;-h3I>mM?g(MLv-tL_`75A3_*3L`ano.8f3>5IYA<.xCXI)BAvb<vW8<73>%&4s.(]?Lp]G3?=3W-MNV4`x@rB#5`l428S);([j<-*a0taaa;I)*UXP2(C_39%b-Ne$(4ik%5_Nh#ZiQM==%-G#uaj-)a@Il9v@Sl'a1r13BXX*&hcv5/[wET%X'H^;Xbv?$8A6`aF.s=chax+2StFs7(rxQ_AL8C#wx2T/HcTF*XQpR/D&;9/[`JD*R4r?#R`>lLuG:u$rO8U)j,wD*W/2a<rnp58ei)'4x:MWH^E<EE-N^5L9rQO(n#HB=^.2M:WxqV$^023;@R*p%)u#(+F=&H%IAw'4jjPgHhVnH)9hdZ,FHZgLpR,L2dX,b78tt[&vba%$N)6b+Pt]M'mXgW&'/R8%jHZi(^RJD=Fl39)*Ik3T5:wx-dp]uG,tK^#AQ=8%7r)<-vDu%&?v:u$:n;gZ<nVs-ax;9/A<3E4<TIg)qv@+4m^=?-0YDu$Hw*F+wOk.)G<n8%.4O-)nxrIL<VfX[fN&m&54[s$`;bYuCM/##pNqvAV0([-V`q921pr4'u(cY@R3^CMV@nM0oT5t$^<<h#YbEQMfX>;-C::tU.Tqp.P3=&#8$VS_i$ct?]f'^#De0T%raP4:Dt@_A@m,b+$lbe)q(PY@tkbi((/sB#C2]x0FFd_At+6-4D4T:drm(t%DM(a%Q9@0);.7REV,Y:v(h8E#f._'#^kP]4A7[s$'S1P/M2^b42k4pBoRK$-?35N'?I.[#<x+gL^>+jLYTf<$)@dv$CY@C#KK@?$'2f]4pSMq2AJPI'm5Z3'Scas%4bCa45l;>$i0r<-^gj`+PB53'H=oi1BDms.UUw8%:t@G;K<`B#6(su$^l>T8s>q8/cfeL(0LChL5PAx$/TtY-K(j=.j$dn&d'[X-t,HV%o8ID*Of?T.HZox,H_ws$*4ci(t,Tr..#fh(cd,[N5;Ah(j<in'H6@?$Q27-)>^&+.3^6r%L/pS8JrYca5su,*:rNY5V@k$+ufWI)7rIf$bYDD3dQwPAA7^;.Epw2j0?I1gFY2H2575+%VLqOBM0`]PZ20X%&YFl7d9s$#pwq+;j')d*`G#-3m]WI)Fqv'?sEHO(UD.&4YC?;-D:Lt/2,&l'$/Ae)dsTq%PrB4-q^ec*OF82'W_`?#OMwH)ZQpqLuc&c$@/IcVY+JfLNG3]-QO-W6#:OA#`N2E43l6##-5Oo7qE//1L?0>#OZ^m&-7k$9t_bJL_3k##i4B58@BV)b`6&/10d'_S''PA#N3i90u<RF4rH7f3+Xs-$1BGA#c`+p7jX1a41)6[J%Y@C#^:Xf%?D,c4so^I*1-9S%[PTB%2Gc>#<gA8'kEo;$KFw8%tbIm&?2wfL%mY=$5=jl&F[[c;Li4J_C_39%$Cgl86aC30u>[s$IXi;$wSNh#.Rmv$r5=M&Xlb4%G`8q^&Y.(#ET[hah+=a*`s;NTOxo_%YlL;$:Jj>5hD<iY=($0&>gme2i?7b>JE^)8K_>GabR?daWIho.?ZrxR9P`h$*c7%-$>`:%@=.s$lqAm/FK(E#:`x_4YeRU.=n+D#D?P[$g<4W$PRe<$MgpEF09@sCog1d2jKi,)Xn%8',d#t$<;Fx%$$a*.h_.W$G8J>-BDUw-1:=nMf/1_Id/u?-sT6X.<D_[#r+TV-J58r0Y'3$#VC%r8i%t$Q0a*(GhX_C#%KCm4OCNl<J>Vt1x4+gLQHtV$#9W]+$B#,2DX,87%ro,345wI%>O,6DSV=k%$De8/wS))3m#:u$s/tR8kD?v$6FLB#@^r%,p]-6Mnr8S[td@E+XSu7/iq1D+=*MPKg9/m'Lg*T'L9Bq%6YfD<xpT(,oOl/(NgAE+9lwGV9DD:89x0c3c3Cw-=DKKM9dRIMTR$##D<bxur#6V#R?;mL1HYI)_2qB#Ff@C#gc``3YPjc)IiHb%kiVD3Z/QA#(d6@'7jE.3GRoT%?A^Y,[PID*$mPxkldf.i<n;w,_rS^+C=*T%Y5mV%jIY$,h=c_+'hjQ/:+`v#<LU-MN5]N1oliS&DCBH)5d[[%Z'q3+Z68W$<bJm&ZQFT%si=A##S^i%fMvj'1cC;$hmB)3DU7%#RlIfLLO6##cQ,,)xk0eZ(H8f3*BshL/,$X$F2QA#3*g;-/HS_%3ipquYHd70EfKB%x3a:8&9:D&Z']&6^JK+GM,]&G3*gsT@9llr#rJfLbBeuu8a$o#>d_7#&Vs)#o$),#EK0#$Ynn8%jj'V%<PsD#S#wA4QMn;%?@i?#4_Dw$Zu/+*OV>c4Ct8i#F6C]$dC587:d8x,Tapi'*o&02is.T$DwoM'+CBF&NiN/2GValA6ZOY-f0,3'lH[=-m&*a*9TgJ)H[U^uku[[#Iw0F3j'@qNUH$>YU8`0(do`8&-(@Q'Ne@t-27it%XIhb$KwAm&uAB?-4s#f$Q$Z;)s==-)Ln,D-.dY1N[[$##EJ4;-/k4GVP(fc)b1HQ<A=XJ%[R(f)iUdP/Z@i?#2<kxFH#XFN6Z6C#E=?G#4V/##V'r0(rD4`m&MRV%fve+>oflYu%Y<N%$Ddqp4##L#Tsn%#rpB'#FkP]4cc``3mS,lLClUC,#a'RL2XCN(=D/sV1HFW'H;NG)RJ))3,5?m%6tpg1C+->#Jc.GV=Ik`uXS9$+Fow<-QF8c&:q+Y[$j^`<=^.^uV+>uulNCK<p7od)w@gE[P5YY#O*[0#Ke[%#DZl,%L=Hu&H73lCXWcH3?U^:/BsMF3n.n'&DD(jC)OYH3X_+D#J[29/Fn6a$Vhh@%cm)mfl_tJ18QDZumk*.))tv8'L=w1*;jAE+emo7/egTwAo1j0(m[xt%n=oY-v/9I$'u#gLJrYcajsXc2&%5H3oFL8.+dfF4w^6^$roH`,TpB:%u-,V/IfMH*1_v)4q3q+MN-,c,w6%,;hWu-;+pML*Dn`@,Xndc*:8*'44I$v$x:O[.E:_f)SaZD*/`Cv#L>GJ_I$#[7hrH[-cTQ-3M+1b*gF<E,'*v.<>6#k0HV:v#U>p5'F&CYG90LB#LYMJ(DD);?nU-(#nYRD*W0pi'&q[P/L*K8%/C-Z$x0s..h#e.<LYDa.S^Q/V0S%[&=kaT%B,A(QFcE5&D7/2NK2O(N8Rj5&oon.)QBER8HMYSJA^sD#;;s;TIO,R&w35dPal=>%R=CJ#^s`lD6x:Z#wZ8X1MW3fMHMYSJdS_p.&&>uuiA3L#PYu##.@J6a,PlV-+,?X$Dr=a*#O%n/CTe12tLn;%@]nXfF*%b4sJ))38$Ai)f-W@#]*>F)>g>T%xD59%7s.?5B>Is?kx9DjC_39%a6We$3Y79%fkn9%>QT]=R9DC+t_Xd)w@Dp.NJXa$N%S^Qpu24'J]ltTmEJqEV@(>V<fs.L*Ah;-=.T'0.XPbuv]r%,@*%L-/_Gl$cR@`aU[^]+DX,87rd%##-Ov)4QV>c4$)]]4%VKF*Wg]O9`<Zv$C-Ll:b5*<%?S<+3i_wG*8GP'?%G9f37bv[5SYfY,:wK<LYdk]#0<^A=MW$31SjY/(575+%U6:02/JkB4RkS[u^6R/;cYw*&n`I;6l3$h23O>70PkB&$7..<$r&)XO3HQZ$-(wY-nDc>-J?QI4B0<d*_wPPA$),##[*Zr#EB)4#UPUV$`D.m-?Z,)69K<b$a>Ps-nXeR98^gJ)ERT,2S.+$(hK(l'tljp%j&)l'_wp?-OAIS@Bx,r%ZTXp%:vGg)a6WROXhrr$rE+0:4'(m9ml0b*^69q.3Y7%-XZi2<,qZ,*Xv4b*)Lj<-o&pf$X?Y70TMS-)[u5V'_njm&_uK-4dD24'eIS.Ep,97;`S39/^'IxOite%%[CHg-6KMK('-j609HNK(Nug^%-cPw9qtf34qRZbH#?e8/2D<`&^Zv%+U&>6/MXI%#bX^Y?`fcd3`n`8.k@YjL/2%E3kZrhL>4/GVM^gp.0%O<L=j%1#xXkA#3C,D%K6vTMq^Uq)[X@2LuFPS.8&>uul86PNRx`G<G.H]F2[ZuPs2n7[^`*PfH7=ip3_xi't/,,2_]>D<^TB;%JS)q%aho3'(LQ5Ag.tY-E]6r@wX8;2k5^G3'A'[%x^O;Q=^&ZPbg:@-IWS>-c59wP&x8h:+0Xwp=.'/Q%0xx'$+x1qW-+<-a>QW-uKuV)u*Y>-f&N(&4$`;)$DsU<hdrJ6c9a:)D@q%lC/*KUUAS_UKIt/O5UtsR,b-]O:js.LDP[)8qmJr)w8I&#T6xP8kpNJMdh7X--p*EG)Y(6(JYc58[xU,bnXwA-s&sI3dVfF4MC)#&*T9<-SxQ+).M:JMFE&VQ+6g/)<c'E>v&e:&.cbA#4%77*W)8;MlX&;QqIJfLShQuu:g-o#<^U7#t,_'#e*%q$R)/)*[hi?#@T/<7p;Tv-xg;E4I@u)4PP,G4*??A48QMd2$D2^%^x)QJi&DW/Desl&^bO=(V,PMM4T66:q8jV7[N7Q0n0G[$puO=(EqIJV3(c&4'&P:v>@P>#M<r$#2jd(#/N=.#^``<L`o@#-T2m8.[(Ls-;+.W-6vF3)p_Zx6KGL6a4EJ1C'R>s.P:si-<))kbuvg;7P88L,iW1,)aX/g:)&vG*Kg],lB9El%`7+n)2u/(4^).-)2[4]#V4sM'$vw<$%O05oYm5R&m',j'5`[j'`Cc81TA:_,vZ/9%?rV2'.@?u6C0PJ(,E%%%kdfR/K$v)4;)IV%)3TF%_U4WmD<#N)X^PR&Xs:g(D8tkBN_8R&pcWT%-:Im/TE'U%ME>N'x1#A7$i_Y&l-/T%2vBW$OGIW$e&od#?kcV)Jg4',)GCbE>'dGEC&f@%e'7##^N78._tu,*]nr?##0Tv-v-@x6iM/R.S)ZA#F(5K1;Mx_4+g^I*&`$@#MUs5&.5aIqI__GD>nWt$E)+<6[F#i2?1i;$=][w#)Po3+pOsaagX4gLPP?$G?haT%[SIO*kJ5##v>GKamw[n9/v6C#EQR12:GUv-cD6C#Jmu2*;>Uv-v9Ed$,14D#OU*K)`]H0cp9X`<#$=v#nZ3#-HaZZ$PEX5&tpds&UH;w#U*pUI55Jue44@<$nFZ5/[f5#-5f:v#/`Rw#_Q$)'*;ZX$EO,/LJM2/(h6el/BXGS7w0+;?QFwwT5EQJ(_kY)4-vgI*B-fa*ivZv-kLre;<%H,*N_Y&46CF<%itn[#bj*.)h)S[V?NRw%$bNh#+sZmM0]g;-?sOs%6l>9'YOXlAZf0E#sO%^$r@7Z7t];/D#Tpxc>HIAGXQaJ2v<m%liGsB#NUHU7w:+.)Dt+6M$3oiLNtvu#8;-`aixC`arriu5j38W-;nq?%9XXD#(l@W$^mM2%eW]c;e*b#-o:gF4&%3Q8bsc<.Vw&>.;He@%-7)N9o6Fb+P$$&4E'bX$2;,>u3')9.Rs(?#9.<T..oBB-E(/?&<LN(,wYQt.JXVv#%Csb%'$v<%w;(pAIIT?-jaNH,'>cuuSJ[#%ABq%4pL2A=Hx6V8&t/02gFU%6A($lL=,B.*d@>itJ.Dg*4-><-e_94.VuH79F8^;.pNTv$EI;8.#9L0cF[sU8XDxI*56=W[9?Ba<49t`<o/LH2Z8Z;%1$50.*?b.Nfd*30SF39%P1rV$.P`_toCo2LS#DO'ARDX:*d1Uo8RWp%SQpQ&8]uY#?pCKC<C(S-D/w3>%ArB#o#Lh$QO1F*TekD#6`8Pa.LsWXoRY<Q1gB(Mg&i@3`;C:%Ca/mAdaH1gC_39%=&G)Y)@$##&&pXuYgCj0Q3=&#<Ja)#6%(,)#@aD4T^x;-=-uu$X>okrlst_P+KT88MFu1qi/RY%a92TTO)I9Mu`-i$;uYca_qAQ(nm3AF61cKN4Xdo$x4u;-.Nap''?GG2j#R]u#%OS-R+BH)$?W]uE0NS-)2l-(q3n0##]@m/)tr4#ncZ(#Y/95+FUp;H/A^;.4V0`$mdj;-u3q`$/`d5/[RUa4k=8C#ZV/)*8C*Q8;(lA#C%8V%5j(C&#Yw<$n/Yp%?9%T0e@%[#KB5n&0Cg9&#(G2(WjPn&t/f$(V*VgLrdEv#]_39%s'l^&eSIE3'J.s$Q<4X$r%oV6,UZV@hlBp&99Dj8='o_o1YK+*ap#E&e:)W-3c@_62qn_Y4t,x8F^aJ2;+.W-:J4co$,qa8@jcQs<cL_?:8+6.0d?S@Gk.I*j6IP/Ys[i9*9&##`VC&&CJke)^KOA#p]`O'.6ng)H,Bf3OtL)Nb4269uk>Wg0/%E3:.G4K^)#d3k>(<-S^%n$G6D,3HWlj'VNhG3rjuN'g9e1MdHG-96#.T%)s5v&Rsp:%t'pa#YYsA+VvDm1br8m$a.wM'Ll1W$hXwW$Y'Y2'N2:9%>BAN0^NhG)p:4Q'tr-m0>koH)o*<I$_uOq#A0gm&+*1q%ZpIfhF0g2'8Js%MVLhm$wgj*%;L/W$S:3W$&,###qk&/L%V&)*h*.5/o6YK1?DXI)<b,l1o:gF4%*=dX)F`i6)^dT6]0H`u&)pG2^&a6&U9;$>v=-:8pHCE#1sCp.=KW)>vJZh#uCs-2-edk(RjvRM*I2XMd_$a.A-2,#1xS,Mb&g%#e@`T.=e[%#_A`T.*AP##/B`T.E3=&#vB`T.Anw@#s7D9.Na9B#MHev$:oGuuDH&9&mStxF9-AT&`^Uoe>Zt2(F9K2'?d9N(X0]J1@mTj(Q$2,D?p,g)=H>AY@#H,*d81Zd'5>>#[>I0YRAl-$.(1B#QAl%=<UL^#x4`+V1:h#$iuJo[2C-?$hYQJ(3LHZ$#eGPA4Udv$xfe1g8$&9&>U9)*9-AT&FF<JU>Zt2(1e8Vm?d9N(Q(lV-@mTj(6DVD3C2Qg)#7KJL@#H,*lDKi`+/G]FcgXoIT1PcDH]4GDcM8;-YqTiB+D-F%'QNk+G&RX(Wrv7IQe`uGBB2)F>NE)#k^T%J$'4RDCKlmBxlndFh:3s78M`iFKU&##1[l>-/q8O=#%?b74bf'&f3/U;Q>qHH]&m639ai?-12kaGbZr`=@'`qLt`b,NfCFE-s3*B/5&*)#ra6RTk*a*4<1`0M/eiK^8kI(#x'Ia.?vv(#E?EU-q8XD+'p8JC_6auG=b9XL-%8X1Y'w^]`ob603qC.3QVu(56m#t7<_T?-:ln+HOn:f5_pf$M[7S;%DX[<->rK&8E<nM1A@EZ'IqNp.w8EVC[hk5CJ/w+#h-k+.=40sLW.K-#.^^,.3M*rLOA;/#&X9K-E;.6/_;L/#tZhpLA4oiL10]QMC4oiLT:oQMu.B-##n-qLd-lrLLe=rLXLoqL^-lrL%Mh'#f6%F-4[sZ/>X&iFF92&G:`vlE+ItfD/-xF-;3XG-xBrE-88?lEEi*s1J?@I-3PTC-9=)&.e,KkL/@xQMK.lrLvR^`&,.UiBJZ2)FtwU?Ha9if5WZ<hFTwH?8^K<j1;^Sn*3j1?-tg7v&hPg;-GZ?U&^-q=RR#:P%[(q&#%/5##vO'#v-gdIM4i#W-#['=(vF1##);P>#,Gc>#0Su>#4`1?#8lC?#<xU?#@.i?#D:%@#HF7@#LRI@#P_[@#Tkn@#Xw*A#]-=A#a9OA#eEbA#iQtA#m^0B#qjBB#uvTB##-hB#'9$C#+E6C#/QHC#3^ZC#7jmC#;v)D#?,<D#C8ND#GDaD#KPsD#O]/E#SiAE#WuSE#[+gE#`7#F#dC5F#hOGF#l[YF#phlF#tt(G#x*;G#1#M$#w'`?#(=VG#,IiG#0U%H#4b7H#8nIH#<$]H#@0oH#D<+I#HH=I#LTOI#PabI#TmtI#X#1J#]/CJ#a;UJ#eGhJ#iS$K#m`6K#qlHK#uxZK##/nK#';*L#+G<L#/SNL#3`aL#7lsL#;x/M#?.BM#C:TM#GFgM#KR#N#O_5N#SkGN#WwYN#[-mN#`9)O#dE;O#hQMO#l^`O#pjrO#tv.P#x,AP#&9SP#*EfP#.QxP#2^4Q#6jFQ#:vXQ#>,lQ#B8(R#FD:R#JPLR#N]_R#RiqR#Vu-S#Z+@S#_7RS#cCeS#gOwS#k[3T#ohET#stWT#oPtA##1tT#'=0U#+IBU#/UTU#3bgU#7n#V#;$6V#?0HV#C<ZV#GHmV#KT)W#Oa;W#SmMW#W#aW#[/sW#`;/X#dGAX#hSSX#l`fX#plxX#tx4Y#x.GY#'>YY#*GlY#.S(Z#2`:Z#6lLZ#:x_Z#>.rZ#B:.[#FF@[#JRR[#N_e[#Rkw[#Vw3]#Z-F]#_9X]#cEk]#gQ'^#k^9^#ojK^#sv^^#w,q^#,k/i#'?6_#+KH_#/WZ_#3dm_#7p)`#;&<`#:kj1#,2N`#C>a`#GJs`#KV/a#OcAa#SoSa#W%ga#[1#b#`=5b#dIGb#hUYb#lblb#pn(c#t$;c#x0Mc#&=`c#*Irc#.U.d#2b@d#6nRd#:$fd#>0xd#B<4e#FHFe#JTXe#Nake#Rm'f#V#:f#Z/Lf#_;_f#a5:/#<xAi#gS-g#k`?g#olQg#sxdg#w.wg#%;3h#)GEh#ZgLZ#/Yah#3fsh#7r/i#;(Bi#?4Ti#C@gi#GL#j#KX5j#OeGj#SqYj#W'mj#[3)k#`?;k#dKMk#hW`k#ldrk#pp.l#t&Al#x2Sl#&?fl#*Kxl#.W4m#2dFm#6pXm#:&lm#>2(n#B>:n#FJLn#JV_n#Ncqn#Ro-o#V%@o#Z1Ro#_=eo#cIwo#gU3p#kbEp#onWp#s$kp#w0'q#%=9q#)IKq#-U^q#1bpq#5n,r#9$?r#=0Qr#A<dr#EHvr#IT2s#MaDs#QmVs#U#js#Y/&t#^;8t#bGJt#fS]t#j`ot#nl+u#rx=u#v.Pu#$;cu#)Juu#,S1v#0`Cv#4lUv#8xhv#<.%w#@:7w#DFIw#HR[w#L_nw#Pk*x#Tw<x#X-Ox#]9bx#aEtx#eQ0#$i^B#$mjT#$qvg#$u,$$$#96$$'EH$$+QZ$$/^m$$3j)%$7v;%$;,N%$?8a%$CDs%$GP/&$K]A&$OiS&$Suf&$Tf&*#%3,'$^=>'$bIP'$fUc'$jbu'$ZZP/$pt:($t*M($x6`($&Cr($*O.)$.[@)$2hR)$6te)$:*x)$>64*$BBF*$FNX*$JZk*$Ng'+$Rs9+$V)L+$Z5_+$_Aq+$cM-,$gY?,$kfQ,$ord,$s(w,$w43-$%AE-$)MW-$-Yj-$1f&.$5r8.$9(K.$=4^.$A@p.$EL,/$IX>/$MeP/$Qqc/$U'v/$Y320$^?D0$bKV0$fWi0$jd%1$np71$r&J1$v2]1$$?o1$(K+2$,W=2$0dO2$4pb2$8&u2$<213$@>C3$DJU3$HVh3$Lc$4$Po64$T%I4$X1[4$]=n4$aI*5$eU<5$ibN5$mna5$q$t5$u006$#=B6$'IT6$+Ug6$/b#7$3n57$7$H7$;0Z7$?<m7$CH)8$GT;8$KaM8$Om`8$S#s8$W//9$[;A9$`GS9$dSf9$h`x9$ll4:$pxF:$t.Y:$x:l:$&G(;$+V:;$.`L;$2l_;$6xq;$:..<$>:@<$BFR<$FRe<$J_w<$Nk3=$RwE=$V-X=$Z9k=$_E'>$cQ9>$g^K>$kj^>$ovp>$s,-?$w8??$%EQ?$)Qd?$-^v?$1j2@$5vD@$9,W@$=8j@$AD&A$EP8A$I]JA$Mi]A$MPW)#H'#B$Scs)#*7>B$^CPB$bOcB$f[uB$jh1C$ntCC$r*VC$v6iC$$C%D$(O7D$,[ID$0h[D$4tnD$8*+E$<6=E$@BOE$DNbE$HZtE$Lg0F$PsBF$T)UF$X5hF$]A$G$aM6G$eYHG$ifZG$mrmG$q(*H$u4<H$#ANH$'MaH$+YsH$/f/I$3rAI$7(TI$;4gI$?@#J$CL5J$GXGJ$KeYJ$OqlJ$S')K$W3;K$[?MK$`K`K$dWrK$hd.L$lp@L$p&SL$t2fL$x>xL$&K4M$*WFM$.dXM$2pkM$_5HkECx[V1.i3GHjmkb$8GhoDf(LVCn)fQDoNj*%KU/vGpsKG$9>2eGdL^kEvOQSD;fcdGg%8;Hw^L_&N0=GHYS@UClIS;H(5M*Hjh/v.M$obH4*i_&1N.oD.83&&5)uVCC:DrCmLdoDr5kjEa:b7Dm*Z1F^Y#kEfNbF$vE;9Cw#kCI3oJb%1:;LFrl-H$$H,hF-<&NF(awqL=dc6B7ESGMEt?kE#0SgLoRE-G$HxUC1LxiF-ToUC.`uS&87=2Cmf=s%TfgZH(=FfGkarTC<JK9i).h#$e0=F$B#b#Hi*;iFtw8I$DicdGw3=fGvc?)%fmnUCbQxfCMpnrLH-H:Ci4A>Bhp,[&?CkGH2v<nDruVA&OYp;I#gTSDGZBS/=Q;eEp+8#'<RXmB&jXVC2*%%'h2_t16&`_&H64,H6fN$JEi3j..NOGHT'1w-/DR7M*S2sHqJ5hFa`V=Bhlm&FP'X0MYO/eGsDL6MFdG;H#^4A$v:7FH(xXVC/jE<BvM]>Bn;ugCJ`glN5$rDN6v0#GpPQd$3r3,HuT9GHq;>gCb3_t1WYdt1/OBX:<*<[$gEDtBpJbQD6%WiFMoY5'R7Y3b:eDlEGeFnB$N'kEl:-oDJGM9.)0oUC%N/R3D;34NB;Z?Gq-.wpZqHO4*L;LFE;uk+=IrdG78LSD)xn+HXxJKFtTRfGNm;eEoxr]&V#*IH1m__&[:b4N:-*hF;'&gLlmDVCxsR/G`j9_%)PD.G7rw+HwRFvBkHV=BM$YOF+SKnDolq`ET*4F$vMFVCkk0WC-lL5/<#N=BIlM_OvFdfGo/X7Dki;#GpswUCaijjEh9Z<B;rhjE=)XrL2XW1F?Idt0.]eFH`Y76DvlVA&Qr:W-'or/32)'h6wKiEH/&iEH&4QhF1)?LF'pN<BwA5gCtWrTC,I,+%W>T.Gd&TjBI%f:.1GcdG^v.+F4^cT17oefGgDXUCtrugFY/U9iWWI#HA(orLN;'=BtRx;H&9sXBsgaNE^q^H3&pm)%:DvhFZA$aE)DvLFq*QhF?Kde$j`>JG'6FVC$C6lEm8v[&ng`9Cdq`3O<l`YGv>PGDVN/NB/NbRD)#<]&(u3GHkQitBour9(%k'H1DuBoDPD4_G&>.FHFk7U.%,rEH@I2X-]o-M,)wsM(V=?p7a7eM1^l1j(Ca@O=XDkYH.TC1MD<?Z$t)/YB#b'gGnseQDr0)*Ho>5gC(dXVCt@idGg<MtBJ6n?86?Z%H=CRFHwwOVC$jq`El#(c$-+4cH`l>kEj+u%$uf_G$5_T%Jo_,-GvM'kEuI/vGgvb'%ZtS/1^FcdGt%$oDX`0[HQk_&4*u+wG4jBOE-SMeG-K4RDuO]:C*K[-?Ze#UMu^qjE]2S=B]94b$8j+vBvk%iFHr<W1si#lEeIcdG9qb3C+m?`%I,kYHQrRU.%,rEHK'2IMbW?jB7];2F'S/vG-5<&&f5=O4-Qu'&<rQ`%(vkVC*T4VCEeh).,9IqLu)JeEfe>lE&PdoDwTV=B).82FuY9kEg];#G'#YVCj1+7D-JiaHoC+WHFGRV1--]gL8KRSD+K^Qs/@SvG/HxuBbZ+F$b;jU/c1FrC]TB_%YYo&G$HkjE(s-rLW*IKF`SH&Fm8tnD7N[6MY+9$.?TnrLOK/eGq[*99jBwq$p3Ap.l.X7D-wX?^ImupLRibo$+@H*nX8Gc.c$vIPO-*hFCaOdM'MwA-BF5HM_h:dM5>5/GwjC[0u%oTC;fiiFh/J=B>T5W-JKM'J9+I&FvA^kE$eBcHD&2U1)#FC&t+P<%4)?LFp;-)%mlGs-6S.rL1C)gCD%Oa%8PkUC[jr<Bsgr=BaSXUC%Xi=BoA(hC0NCU1c?DtBwAFVCj4UVC0v>LFXW&jBfZ^$&-vGlEBrhjE$rrhF.VZa$E;[rLP+$jB+&N]&)VhO1sSKKFkOxVH+s>LFk7;LFHspm8plOU&7g4VC42vdG%/<&&I3rmM#'nJC%<OVC2e9cH?^fUC:,JUCdlm&F3FM].$HxUCaehm8U=vV%2bg,2w-VeG>K(_I,HX7D3pKSDwWv]GE4>k--*/?RNRwB&Ne5;)6D+7DJC/[P>>5/Gv5d2C)Z_(%b[,aF(Dts8CFd6Bo)0NB:]7+HrM$@&vV'oD9`r*HLHlC&:wJZG*1AK3(mt#J9II68?a7p&O1/mB^*1<.repKF8-Sp&8@lpLvOZp/kqY1F1fw+Hc)r]$`deM1j)9m'XGtYHA/bx'h*wt%5xViF?G+7D&(AiFEwhQMna)0CxdM=BJD%q.038/G'x=C&Ib^8Mu?_<./QtjEUYK;I,n<vLqEvfCgjB_%*&%kt9H]iF?1Kb%*W)=B_NW5'TAtYH6B@@'NsX0GA,c;-D[Vt-I2uHM;P(cH'g^oD%83jM,MDX-+3SgjHDYV13(5<H&9sXBhHHT/c=T0FZE+F$70N%$)B(G$3JvLFbxeuB&gkVCf[B8Df9kQ/%,rEHv^nFHi_],2s:AUClmeQDjc)&&x)/>BxQ*6'w?vsBu$>KDCfmlEOQs&HNL@+%3<SMFF6n^GCe#&Jmx.>B0:X5q&=O<Bj5J=B%6J>BYWofCh50NB(wI:ChaXb$rA*eE]>o=BxRnaHtj@,M5)PD%-G3$J[<f*$_sKG$0)?pDtnFVCVZV<Bh[G<B1jg%%6m7qCiL^kEGg,jF394HM/2(_Ihi@u'K/+'G7J2eG0&?LFX(AY-KpM'JCOCO+DjXR*->F;C6FGC&65/:C%'DO=(ve:CvBsQ.9m3_Gv>=p&RX]/1.ZxuBiVo=BCGRV1ffuD1bcTnDB(8fGr>=UCL^[2.9M%rLqPl+HY>'68;u[5BG]-bN?:Jv$at^MBiHF'%+d]YBw@A;H(EBNB#9JuB.gcdGxODlExu)BFMAFSM+?D8Ig,H@&-w?7MN`O_.b(9kEO@Dm$=KbfGlVZ[&?52U1/fV.GQA*_SIjxO16O4,HePtmD,*&:C9wFnB`#$@&hO`8.iKd<Bre2W-CEjU)Ar>LFw?fiFo#fUC7vIqC64;9.e>tmDk=[20*+cV(+oR+Hgh/U;I=qoD.#?LFrRHSD1b:qLRf(7D`WM<Be*=kL+r(v'OsH8BDOkCIF$kCIr=HSD(1PWHFGRV1'^udGuCn&FaW:]M'WmvG*q%UCO*+pDro1HD/-Yd4lcCEHswpKF(s6&FrrQD%w/fuB:fJ^&&eHEF'KpKFo7xu'`a3N1r=8#'jd&k;-hu,M`rG<-N<D.MR'mhL9IwOE<Fs*.WNnM1[.4n/f`tUC:A2eG@ub_.1rw+H2?lK.%W)&&wa1kk0Zu'&B+$1Fb^WMBu^%gLj$=LFubfYB,;f#'%uEGHLC=W1-8$lEC.mW-h(XHmYxCcHbxrMC`FaF.(#kjEChSF.I^S5'F$CNCD$$&J:M@rL(BO_$;Md`%=$paH@%8fGl+=3E8MeV17=4cH49.%'WrnRM6`mvG%*bNER00iFfH/jB(HxUC>_LeEgWiTC3BQ<Bm]hHDsCeo;k#X#H5i3GHMhG-MjU*'O('nKF&?[@'vu%=B@j3_Gl/Z@&EdR&Gx42eG]-f8.,/r*H$g8#HE<Fr.*Zx>BNf`b.UfIrLsaSK:JDbMCZU9o/itusBvg#)INexV%D$obH:N[@'5u>LFT;b>H?ZjKOBtcQD`s#`%*D%bHL$h%JjU,-GC(?LF1(Vp.+^,LF%:c'&UNPnC6rc6B+l&$G(#PVC^H4T.0'jiFEsG<-4$E^%r876DJEB0118iEHhb(*Htp76DG9D2%IlqU1[6iTCrjjMBaRs#0p=F;C8bb3CZJie$87vLF]au[$'3iD3ai.>Bv2fUC1ew+H3GqoDC6;eEFZdOC&HX7D[jX,H3M@+H%mnUCo$Q<B`+d;-_i`:%Q^<LF5Pr.GGTnrL14?/C^&)='%NL.-0erhFR*+pDa.WY0e4KKFpa)=BFjG39Bp[aFtYVx&k`(eGLA9N1%/$PE>F=mBI6*[8g4&Bdn/AdD#jE<B[Q'C%MPq0,AhQSD-P)iF%NXVCI65bHLF/`OGT*G'h,%KDk(x6)>k,Ze;)0_OFmR0F2>n)%;1kCIbaaMBi5CC%vN;tB&o4v',-]:Cdh#*F)8$1FJp3kN+9<LF:<oP's*7`G5(jiFrfd&F'AViFtxu-G(X2iFF0@7M94MGH)2hoDKW#/G#T?`%L)=#H&]wH?GqhjE2XbfG9?r6Mw%QvGHq_QM2mjn16DDEHobxvG:5.V1U848M>q:HM(9<LFi+,^G5<[7M&.gfLi*/dDjH7UCwx0VC5c)UDsSE#$,CZ;%MoMe-7*shFk'Pq8d01O+nbp^fT%B;)*g@qCbpU`/6D+7DJC/[P?A5/GrdFg$7=-#H8T$nBw&8YBv,+;CHirQMCCwKDR;0vH-b?'8kci6N+IAnNkO*#1f2P/)0wb0PE@2eG7mqU1(mpOE)rT4.Oh1jO1I?&%Gv+q&x;fQDkp7UCXl_j(-+4cH^[3F.pE;9C>WO2(#taeF:-k30a@T0F$LI'IK=S_/:38p&M8kYH8HCL0#<bNE@S4VCfTu$e=bi=-^o0L&HUZ8&mQ%dM:IH]%5trS&;ae>5-p(*Htw@iF3K/>B#SsYG4I0%JsRXnDh;V$TS>pq'eks>.pKeQDIJF,M*[noDw7iEHA<EW%9>2eGtg@^QO[Y)1lp]NBkW)XB58rU1/$4m'@6dGE??@x'(.mgF4s>LFQ_08/YS@UCEsFHM4u(RB-5QhF10.%'5ocdGxs__&`mTt1^5*HEv&4RDX+]:.0PiMFn1pAG'EpKFc:L_GvA$`%x8sXBo]#lEv6;iFVqds%xD+rCNn2T&C%cKck@S'Gq&?%&-3/:CtGxuB<WsP_<S5bH'x=<HdjeUCCrpKF(J+v'7&$lEPhCLcX']Nk@S'8DnSm`%ej[:C*K.:Cq&0`I%G5s-]['F<2o,P1og3nDXNkF$1o;MFa7,-G3NfUCMsAm_C1NY$?fEx'JIr*HoP0nDu42iFs&:,$]<xa$O]Ld-3@^e$J9@kEld`TC0N<j$7@e2(rOlNXb,bN1ox;&&.xn+H#CkJ-p&1H%AZ4m'Q>b#H1TpgFoCvAmBKbr.-'oFH1wWeZ>%b7MN5xc$+j#lE7_=fGl5LQ/AXnFH+G0O*=C=[97B=fGk9`9CpgH=.vRXnDP9U,2(o<GH%R)iF#HX7D4a=gG:kTNCcAZWB2x*,H7Si6&,X)pD$*A,M&bT$Hx0ddG+u3cH$YX8Im&4RDBI0W1#mMa%E44W1,gpKFpqY1F.]eFHC_nFH7<7%'E#N=BhQ/jB)3fQDl'vLFc^+F$(#lVCVvb8.w2J:CVjbj(kj[:C^O.q.*-d<BMDH7U:e.:.v^=b$_f4#H<i&gLC^8.Gj=Z6'tg.>B.:OGHhgwTMto#$G*>HlE%pN<B6]/B&wsn6D8jE<Bv=&ZGl2pgF#%SiFPpNW%q?`9Cv%,s/lF+7D'(&2FsC6.33mpOEnk,-G'ebfG?mhU19_16Ml+`dM/^&iFqmmt.s4/:Ch-uWf*XPgLd?/U1wo(*H^ol]84;14+RJk#H=SvLFc+`V:37FmBksaNEC<2dEO3j[8O1=mB2<+HMM%^9C<vFHM,^8eGpv[:C4*r$'%pp;-a0]/MF4TZ.3r*cHJ8VT.)dT4EQ+5[$k_ucMO'crLuVOnM*`>>B9a,<-&>9_-iFkEIqlD<B[Dqp.3g@qCJSgu(8D+7Dj#'NBqT#)/g)9NB$3f,ku/nNBvE;9C%o<GHVTkCI-3&gL<#X1FZ/)=BxMpgFn%Jq(]W*N167lpLc[e]Gk9IbHgEbb$#&?LFv4vgFq?vsB=i1nDb<&jB,p?d$?N.EFXJitBo$9I$CtCnDM/29.-)e`%Lm%aF/lfb%F6O_I;U%:.-KFVCa=$@H$?,0CLfRV1+oR+H%3+HM&+xaFn#_(%&TJ>BqD>gCr]TSDf/#gCu)U_%7A[V1<cD.G`SM=B8GM*H6M[rL@W/eG9d)=B;d[%'3Nn*74G=UCwM#hF5A2eG#k3CI0]umDpYHaEI5FSMbWwaN]+EU/jRT0F=b?T)Z]P68t%4m'@'gp.JU%'I9>tx'BqhjE;j8:)#T@UCR9?:2QPUk+-n.iFT#:[/i:kjE,&YVC6Mo/1.p>LFkx0VCx>pKFqH7UC/hViFvoUEH*92=BwJ00Ff]DtB,uwFHm:/YB?pCp.2)2eG,kWe$LBwgFvS>LF-g0eM.HNhF>.JjFw.ocEwNNxH.DqoDZaK(%'ZPhF(iovG+ieBI;9`qL>]mvG8m1U13/?LF.Y8vGHT%rL+>b_$>iE<B)X9GHt/_$&>vZ<_8Z9GHu#00F5Ce20?LtCIh59kEsoc3=E'0`I$:LSD%#[D%Aw?7M?B,gL6ELgEddN2B:Rg%JbxeuB3rw#Jk*mlE_aN2B(-+;CSjusB)<s=BZjSNB'KJUCF$paHvd+F$vYX7DssNcHiT&NBYZ$IHnSM<Bo0ZWB+ifOM0Z*hFxjeUCblIuB#-omDq:vgFbD#F7@S1U1fwl[$8YtnDg1vgFRK*N1;anrLQ&TiFi[D[%&l0nDu5A>B=+?>BqJb7D%E0SDqp/@J6&Z0C'vqEH:vCU1J.?l$#=%eGA^4-MFjL$H$39kEoD;]&mcJ,MX$sgC6e:qLVDcFH$dUEHehi(v/q:HMA2(_I?=4GH>n#gDflQN9d)ZgD62CoD.s0IMOxP<-7V(p$Au/:):)L<-D-Xn/+^,LF6LofGNh67:oo^>$MavcE/uU5/;c^oD2E@qL3V/eG3/?LFk2'D4m#>gC6>LSD^)YgC@%jMF@S4VCfQ$C@RZ-hc01HkE2E1U1ri^oD'Z9*NOeJZ$Hxk)N9geoDfX@eGj6vsBl*,F%>A],M]:[A-2(DT.e#00F?L.6/K4uVC3p=HM%C>UC4I+,HI#=#H%KD$TECGR*WNnM1fO`iL4o=g.DSA>BUJ5HMm@W:/2ZX7D?m'IM]oG<-05IA-Iq.:.3mpOEj*q'&m)<&GF?,5&R,:[0$0p98W%oP',af,M9QP,M29MVCuoTnDaIxe>HdM<%GreV1uW+b$6O'NCoI`hF0N<?$4(x+H)>^;-GHHaMde#Y94GZZ$#ZB8Du6^e$I^8p&:$'IZsvZt1=KkbHfH76D%pN<B9qj;0P';q:p3=2Cd6Dv$H^mG2`V`9Ch%e&F+:+RBvSpOEs-ST%A@?lE$HX7D?l0WC&f%iF/ToUC+V3'F0QA>BC72VC2KfUC.WlpLR6U0MKW/eGq$)*HRALh,,u0VC1,k<Bvi2E%AKiDFGDRH;pxE^G2)2eG0R1[B@'f6B=xn'I0#(eMrwoTC5#Ni-5t(O=Abom/dP;9CJEg%J3CRm/&QcdG*kIbHbr?a.A`KKFx:jf%(].Q/e#00F(C?lEnS-<-pM9kEl:s=B%IHlE(0fQD-*AfG9wFnBlI8vG,&D.GoMiX%CqhjEt&@G?*vM*e$X@X%D+s.G-TOVC$f]>BpMZQBu8_C%:5$1FW-P[MOMv50JU;iFx_moDJr<EY#5Q;Htg`9C&b;iFg$V<?S<eM1rWpmBuOhVC2(8fGfol;-3dTW$>7'=BnCRw9].@h*pt8S3ntUeG9DFVC(NpKFfvs2B+?fUCA6e?$+PZ1FhwuLFPa9hPVBDVClf1eG_i.>BfpAjB,Tg;-`aX&=cH;s%:OOmB(WKSD5Oem/uNrTCa/)=BV,GG-N`Ul/48vLFn'VeGvTh'&,P50CFZ3sLVh-%Jto;]&Ce&T.2ve:C8#)t-q7&2=6MjuJ8ZmuBpm'C%@/rU1ZZ'G$8]V.Gg`)=B##/#'HKE_GSr:U1pZ.UChu%UC9E4HMM+:kLGEp='&74h3#RT=B->J>''brpC.O(qL@O1RD*w*$%?CvLF8A2eGiZ5T%2pitBw;Yf#N-E2Bk^bb$i,tjEnheaH)6xUCVSk?HdH+F$3e#&Jr7tv%,dM=B9Ne[';_r;oa--jBPmerLRRL10iKeQDo//>B8kMu&SNVVC-glgC;_1qLZ/.oD,'[`@I,4'G0]J>'1VmLFsBTU;&BW,D@@ofG`8cGDr;8>BmBw#JaNkF$lg3nD+$4cH'6kjED`XnDuMqc$__YWB_iTRDd9Z<BuQNe$1tT=Bxxd&F2/rU1(/_OEl[pKF$tRQD$qR+HrNJe#)c8$G#TA>BrY^oD%Pr*Hli0VC^Ar9(2SNe$V9DrCT08fG.#v-Gt9?lEsq8I$9CDF$6cw#J0YY8.:vCU1P?@#HekwWUvx&nAV$=Wo3E@*Nl4rb?DIZZ$*<bNEh:,(-38TiF@Uf6BB,>hLa$PV1MP^N1'DM*H$]eFHgC#gL>)X<BqdT$&5Ba=B,Y@bH0;08M3ZPgL)3`nD8iCEHo_)pDlg.>BNRjY$b`ubH)xKpILrGtIhS2='QlHp.C+QhFUt=O)dGb2CXTp?&q%D.G7=4cH]9siBbv/jBtuUeGmquhFB<V*F$^Z%&R]B$Ht)g/C-H1U1FrB=%dfCE4b=b7D-D[rLd66Y'2o;2F-'jtB2]umDi^]/C)q7UC@N]`Q0h/qB)gcgCL(fV1))r*HYjF,D8C=GHa+00FqMd`%&Y*cHmWRQDlkCEHVT0@JbdX'%uGtnDg&cGD2]DiFsW7fGqJLHDS)frL+xR5BjH7UC)Tg%J(X2=Bjq(*Hte%iF2EA>BwLNBF9=/jFs4V$9Gkh<COHFGHuX/ZGMK7rLj5?vG*A?lE)(EPEI8rU1]RZ%H,#vLFv_AvGrNrTC0FfiF(;iEH=`,-Gth(?H$dUEH%kZ6h#?<LF)Xg6<<mtfG&&%[TC,@rLs4D8Ik/6[&/.XMCRIr;-E=AZ$*<d<BsgjjEsVD^6n/*U-&E0%%3w_DF(8wC=c)b#H*-d<B,8he6G$WMFi:?Y%u()iF$5DEH`PM=BK)2,H^YkUCf'kHQ-/B#HL<U-HG1USD&U;iFR'jiF89S,M-XngF'/CVC-QtjEk&KKFxQ)iFuLUVCfTh[-;SjQaG*VnD8Mv^OFAthF3FxiFNVGtIgFO8I&A2eGMaYWB119I$.E&_GfH7UCh[YhF@vj8M^ZqjEp^*3EjRW<BQ(*#&4)&UC;v2eHOoEsLWquUCaIcdGQsnrLEQISD:,]6D4&9b@[mZ/tI]l@&)ewaHK5u0,5mub%TtCnDim+KC-s1eGq>$d$$8rEHVoqgao?cQD)ln+H[Gm5/5>r*Hafq;:4FHOC@fV.Gmb@eGAW;eE)8M*Hh3*0:`nv5/p'$pDxf%#'pPcdGDXjdG'WpKFsw>lECn+RB<tg%JxW7fGVR<kL+a03Cal*nDw1M*HfIKkEvrH&F0&YVC&CtbH:bNhFu]+>BroCEHx+s='ox5P1nov`%8%=GH7AZ1Fv6DEHvV'oD>#qaNCL`3Cp2CC%67FnBdv9_%GHeRMsoGvG-(i90s:AvG%j>LF#O,+%g/0iFrKitBoFfUC`?++$.;/#'ACkCI];Fh5G?[;%CKM)F)B],M+ZElE<B&gLY55UC2O5l$;0fiFwDUG$.K00Fn-VeG%se^0OjusBp/TNBixvk<PJUV&jKd<B?3blE[<b'%eQ%UCn),kB&Z9oDuHT59'F3x'3=rdG.0fQDZfn6Dd+00F*/(8DCsRhs%3.oDipeUC+xIf$7GRqL5dwKDhSlGD0v,hFxhh?BWC&qL-C,Y'5/R&=O06Z$dPY'8*x0VC152eG$ZQt.-?0@JnH,FR>$,naN4MU1*dp;-Qe5-Ms2pZ$M9ofG)x09IRmJt9)rMw$oGtnDfdANBAq1qLiRhjE+tLC&>FvLF&*i_&a,$&J_WofCbD(dD-rI+H2,VqL8'?D-/^_`&7$sS&Vx^?HJ*+pDji%>'-))iFF7XjC)'W=BiHQvA3r/k$R[g#>_SgJ)&ZF-M.:Uq@2Zat(&4Z,GQ6`eMbJ;&&@b@&H'^#lE,T@UCrtXsHpHiTCs>^kE$,>>#%;cY#Z2c'&*tj-$4<k-$2L$$$<t`Y#dl6@'.SNh#uQj-$*J[-B/rO41E@5MLb%###E@5MLlHLR[;<@<#"
