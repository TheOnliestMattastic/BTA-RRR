-- config/ui.lua
local uiDir = "assets/sprites/ui/"
return {
	-- Bars: UI bar elements
	bar_1 					= {path = uiDir .. "bar_1.png", 						frameW = 96, 	frameH = 16},
	bar_2 					= {path = uiDir .. "bar_2.png", 						frameW = 77, 	frameH = 13},
	bar_3 					= {path = uiDir .. "bar_3.png", 						frameW = 77, 	frameH = 16},
	filler 					= {path = uiDir .. "filler.png", 						frameW = 16, 	frameH = 16, 	frames = { "1-2", 1 }},

	-- Patterns: Background patterns
	patternBGbottom 		= {path = uiDir .. "BottomPatternBG_128x112.png", 		frameW = 128, 	frameH = 112, 	frames = { "1-3", 1 }},
	patternBGmid 			= {path = uiDir .. "PatternMiddleBottomBG_199x48",		frameW = 199, 	frameH = 48},
	patternBGtop 			= {path = uiDir .. "TopPatternBG_116x67.png", 			frameW = 112, 	frameH = 67, 	frames = { "1-2", 1 }},
	patternPanelBottom 		= {path = uiDir .. "BottomPatternPanel_119x17.png", 	frameW = 119, 	frameH = 17},
	patternPanelMid 		= {path = uiDir .. "TopPatternPanel_02_33x15.png", 		frameW = 83, 	frameH = 8},
	patternPanelTop 		= {path = uiDir .. "TopPatternPanel_01_33x15.png", 		frameW = 67, 	frameH = 15},

	-- Buttons: Interactive buttons
	button_1 				= {path = uiDir .. "buttonDragon_1.png", 				frameW = 100, 	frameH = 35, 	frames = { "1-4", 1}},
	button_2 				= {path = uiDir .. "buttonDragon_2.png", 				frameW = 104, 	frameH = 35, 	frames = { "1-4", 1}},
	buttonClose 			= {path = uiDir .. "buttonClose.png", 					frameW = 24, 	frameH = 24, 	frames = { "1-4", 1 }},
	buttonExit 				= {path = uiDir .. "buttonExit.png", 					frameW = 24, 	frameH = 24, 	frames = { "1-4", 1 }},
	buttonHelp 				= {path = uiDir .. "buttonHelp.png", 					frameW = 24, 	frameH = 24, 	frames = { "1-4", 1 }},
	buttonLess 				= {path = uiDir .. "buttonLess.png", 					frameW = 16, 	frameH = 16, 	frames = { "1-4", 1 }},
	buttonMore 				= {path = uiDir .. "buttonMore.png", 					frameW = 16, 	frameH = 16, 	frames = { "1-4", 1 }},
	buttonOptions 			= {path = uiDir .. "buttonOptions.png", 				frameW = 24, 	frameH = 24, 	frames = { "1-4", 1 }},

	-- Cursors: Mouse and selection cursors
	cursorH_1 				= {path = uiDir .. "cursorHorizontal_1.png", 			frameW = 26, 	frameH = 26, 	frames = { "1-5", 1 }},
	cursorH_2 				= {path = uiDir .. "cursorHorizontal_2.png", 			frameW = 26, 	frameH = 26, 	frames = { "1-5", 1 }},
	cursorV_1 				= {path = uiDir .. "cursorVertical_1.png", 				frameW = 26, 	frameH = 26, 	frames = { "1-5", 1 }},
	cursorV_2 				= {path = uiDir .. "cursorVertical_2.png", 				frameW = 26, 	frameH = 26, 	frames = { "1-5", 1 }},
	cursorM_1 				= {path = uiDir .. "cursorMouse_1.png", 				frameW = 18, 	frameH = 17, 	frames = { "1-4", 1 }},
	cursorM_2 				= {path = uiDir .. "cursorMouse_2.png", 				frameW = 23, 	frameH = 23, 	frames = { "1-4", 1 }},

	-- Frames: UI frames
	frameEmpty 				= {path = uiDir .. "frameEmpty.png", 					frameW = 32, 	frameH = 32},
	frameFilled 			= {path = uiDir .. "frameFilled.png", 					frameW = 32, 	frameH = 32, 	frames = { "1-4", 1 }},

	-- Headers: Header elements
	header_1 				= {path = uiDir .. "header_1.png", 						frameW = 96, 	frameH = 32},
	header_2 				= {path = uiDir .. "header_2.png", 						frameW = 96, 	frameH = 32},

	-- Panels: Panel backgrounds
	panel_1 				= {path = uiDir .. "panel_1.png", 						frameW = 144,	frameH = 144},
	panel_2 				= {path = uiDir .. "panel_2.png", 						frameW = 144,	frameH = 144},
	panel_3 				= {path = uiDir .. "panel_3.png", 						frameW = 72, 	frameH = 72},
	panel_4 				= {path = uiDir .. "panel_4.png", 						frameW = 48, 	frameH = 48},
	panel_5 				= {path = uiDir .. "panel_5.png", 						frameW = 48, 	frameH = 48},
	panel_6 				= {path = uiDir .. "panel_6.png", 						frameW = 48, 	frameH = 48},

	-- Arrows: Directional arrows
	arrowDown 				= {path = uiDir .. "arrowDown.png", 					frameW = 16, 	frameH = 16, 	frames = { "1-4", 1 }},
	arrowLeft 				= {path = uiDir .. "arrowLeft.png", 					frameW = 16, 	frameH = 16, 	frames = { "1-4", 1 }},
	arrowRight 				= {path = uiDir .. "arrowRight.png", 					frameW = 16, 	frameH = 16, 	frames = { "1-4", 1 }},
	arrowUp 				= {path = uiDir .. "arrowUp.png", 						frameW = 16, 	frameH = 16, 	frames = { "1-4", 1 }},

	-- Tabs: Tab elements
	tab_1 					= {path = uiDir .. "tab_1.png", 						frameW = 39, 	frameH = 22, 	frames = { "1-4", 1 }},
	tab_2 					= {path = uiDir .. "tab_2.png", 						frameW = 34, 	frameH = 39, 	frames = { "1-4", 1 }},
	tab_3 					= {path = uiDir .. "tab_3.png", 						frameW = 42, 	frameH = 22, 	frames = { "1-4", 1 }},
	tab_4 					= {path = uiDir .. "tab_4.png", 						frameW = 42, 	frameH = 22, 	frames = { "1-4", 1 }},
	tab_5 					= {path = uiDir .. "tab_5.png", 						frameW = 42, 	frameH = 22, 	frames = { "1-4", 1 }},

	-- Fonts: Text rendering
	fontLarge 				= {path = "assets/fonts/alagard.ttf", 							size = 96},
	fontMed 				= {path = "assets/fonts/alagard.ttf", 							size = 48},
	fontSmall 				= {path = "assets/fonts/alagard.ttf", 							size = 36},
	fontSmaller 			= {path = "assets/fonts/alagard.ttf", 							size = 24},
	fontXSmall 				= {path = "assets/fonts/alagard.ttf", 							size = 16},
	fontTiny 				= {path = "assets/fonts/alagard.ttf", 							size = 12},
}
