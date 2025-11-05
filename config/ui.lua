-- config/ui.lua
local uiDir = "assets/sprites/ui/"
return {
	bar_1 = 			{path = uiDir .. "bar_1.png", 								frameW = 96, frameH = 16},
	bar_2 = 			{path = uiDir .. "bar_2.png", 								frameW = 77, frameH = 13},
	bar_3 = 			{path = uiDir .. "bar_3.png", 								frameW = 77, frameH = 16},
	filler = 			{path = uiDir .. "filler.png", 								frameW = 16, frameH = 16, frames = { "1-2", 1 }},

	patternBG =			{path = uiDir .. "bottomPatternBG_128x112.png", 			frameW = 128, frameH = 112, frames = { "1-3", 1 }},
	patternPanel = 		{path = uiDir .. "bottomPattternPanel_119x17.png", 			frameW = 119, frameH = 17},

	button_1 = 			{path = uiDir .. "button_1.png", 							frameW = 100, frameH = 35, frames = { "1-4", 1}},
	button_2 = 			{path = uiDir .. "button_2.png", 							frameW = 104, frameH = 35, frames = { "1-4", 1}},
	buttonExit = 		{path = uiDir .. "buttonExit.png", 							frameW = 24, frameH = 24, frames = { "1-4", 1 }},
	buttonHelp = 		{path = uiDir .. "buttonHelp.png", 							frameW = 24, frameH = 24, frames = { "1-4", 1 }},
	buttonLess = 		{path = uiDir .. "buttonLess.png", 							frameW = 16, frameH = 16, frames = { "1-4", 1 }},
	buttonMore = 		{path = uiDir .. "buttonMore.png", 							frameW = 16, frameH = 16, frames = { "1-4", 1 }},
	buttonOptions = 	{path = uiDir .. "buttonOptions.png", 						frameW = 24, frameH = 24, frames = { "1-4", 1 }},

	cursorH_1 = 		{path = uiDir .. "cursorHorizontal_1.png", 					frameW = 26, frameH = 26, frames = { "1-5", 1 }},
	cursorH_2 = 		{path = uiDir .. "cursorHorizontal_2.png", 					frameW = 26, frameH = 26, frames = { "1-5", 1 }},
	cursorV_1 = 		{path = uiDir .. "cursorVertical_1.png", 					frameW = 26, frameH = 26, frames = { "1-5", 1 }},
	cursorV_2 = 		{path = uiDir .. "cursorVertical_2.png", 					frameW = 26, frameH = 26, frames = { "1-5", 1 }},
	cursorM_1 = 		{path = uiDir .. "cursorMouse_1.png", 						frameW = 18, frameH = 17, frames = { "1-4", 1 }},
	cursorM_2 = 		{path = uiDir .. "cursorMouse_2.png", 						frameW = 23, frameH = 23, frames = { "1-4", 1 }},

	frameEmpty = 		{path = uiDir .. "frameEmpty.png", 							frameW = 32, frameH = 32}, 
	frameFilled = 		{path = uiDir .. "frameFilled.png", 						frameW = 32, frameH = 32, frames = { "1-4", 1 }},

	header_1 =	 		{path = uiDir .. "header_1.png", 							frameW = 96, frameH = 32},
	header_2 =	 		{path = uiDir .. "header_2.png", 							frameW = 96, frameH = 32},

	panel_1 = 			{path = uiDir .. "panel_1.png", 							frameW = 144, frameH = 144},
	panel_2 = 			{path = uiDir .. "panel_2.png", 							frameW = 144, frameH = 144},
	panel_3 = 			{path = uiDir .. "panel_3.png", 							frameW = 72, frameH = 72},
	panel_4 = 			{path = uiDir .. "panel_4.png", 							frameW = 48, frameH = 48},
	panel_5 = 			{path = uiDir .. "panel_5.png", 							frameW = 48, frameH = 48},
	panel_6 = 			{path = uiDir .. "panel_6.png", 							frameW = 48, frameH = 48},
}

