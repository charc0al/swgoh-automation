﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

ANDROID_TITLE = BlueStacks
GAME_CMD = "C:\Program Files\BlueStacks\HD-RunApp.exe" -json "{\"app_icon_url\": \"\"`, \"app_name\": \"Heroes\"`, \"app_url\": \"\"`, \"app_pkg\": \"com.ea.game.starwarscapital_row\"}"
ANDROID_WIDTH := 900 ;fixed width of android emulator. If you change this, the image recognition files may not work properly
global IMAGE_SEARCH_ENABLE := true

global ANDROID_ID
global EMULATOR_LAUNCH_WAIT := 180000 ;time (in ms) to wait for emulator to finish starting up
global CHALLENGE_WAIT := 300000 ;time (in ms) to wait after starting an auto-battle on a challenge - i.e. 300000ms = 5 minutes
global BATTLE_WAIT := 120000 ; time (in ms) to wait after starting an auto-battle

global BTN_HOME := "h"         ;home button in upper right
global BTN_BATTLE1 := "."       ;battle button on battle select screen
global BTN_TAB1 := "y"	       ;on 3-pane screen (challenges, find shards) the leftmost panel's button
global BTN_TAB2 := "k"         ;on 3-pane screen (challenges, find shards) the middle panel's button
global BTN_TAB3 := "u"         ;on 3-pane screen (challenges, find shards) the rightmost panel's button
global BTN_COMPLETE := "k"     ;"Complete" button at end of battle
global BTN_BATTLE2 := "]"       ;"BATTLE" button on squad select screen
global BTN_AUTO := "z"         ;"Auto" button when battle is active
global BTN_CHAR := "c"         ;"Characters" menu button on home screen
global BTN_BACK := "x"         ; < Back Button on upper left of screen
global BTN_FIRSTCHAR := "j"    ; location of the upper left character on characters screen
global BTN_SHIPMENT := "o"     ; location of shipments on home screen
global BTN_STORE := "p"        ; location of store on home screen
global BTN_CHAR_SEARCH := "i"  ;location of search bar on character screen
global BTN_CHALLENGE := "n"    ;location of challenges button after panning left (may need to be adjusted)

; bindings for swiping up, down, left, and right (reversed, so PAN_RIGHT swipes to the left, panning right)
global BTN_PAN_UP := "up"
global BTN_PAN_DOWN := "down"
global BTN_PAN_LEFT := "left"
global BTN_PAN_RIGHT := "right"

; Locations of the 4 shipments that can be purchased with credits (for daily activities) after
; opening shipments and scrolling all the way to the bottom
global BTN_SHIPMENT1 := "v"
global BTN_SHIPMENT2 := "q"
global BTN_SHIPMENT3 := "f"
global BTN_SHIPMENT4 := "b"

; possible locations of "BUY" button on shipments purchases, not always
; in the same spot due to variable height descriptions in confirmation dialogs
; BTN_BUY1 should be the top-most position and 4 the bottom-most
global BTN_BUY1 := "d"
global BTN_BUY2 := "e"
global BTN_BUY3 := "f"
global BTN_BUY4 := "g"

global GAME_EXE := GAME_CMD
global GAME_TITLE := ANDROID_TITLE

activateEmulator()

sleep 1000

;ANDOIR_EXE := """" "C:\Program Files\BlueStacks\HD-RunApp.exe" -json "{\"app_icon_url\": \"\", \"app_name\": \"Heroes\", \"app_url\": \"\", \"app_pkg\": \"com.ea.game.starwarscapital_row\"}" """"

activateEmulator() {
	ANDROID_ID := WinExist(GAME_TITLE)
	if (!ANDROID_ID)
	{
		Run %ComSpec% /c "%GAME_EXE%
		notify("Launching Android emulator...")
		WinWait %GAME_TITLE%
		sleep 4000
		WinGet ANDROID_ID, ID, %GAME_TITLE%
		notify("Emulator window found: " . ANDROID_ID)
		resizeWindow()
		imageWait("quests.png")
	}
	resizeWindow()
	WinActivate ahk_id %ANDROID_ID%
}

killEmulator() {
	process, close, BlueStacks.exe
}

resizeWindow() {
	WinMove, ahk_id %ANDROID_ID%,,0,0, 900, 592
}

doChallenges() {
	doChallenge(BTN_TAB1)
	doChallenge(BTN_TAB2)
}

creditPurchase()
{
	dailyShipment(BTN_SHIPMENT1)
	dailyShipment(BTN_SHIPMENT2)
	dailyShipment(BTN_SHIPMENT3)
	dailyShipment(BTN_SHIPMENT4)
}

goHome() {
	activateEmulator()
	push(BTN_HOME, 100)
	push(BTN_COMPLETE, 100)
	push(BTN_COMPLETE, 3000) ;mash that complete button in case something has gone wrong and stuck on completion screen
	push(BTN_HOME, 100)
	push(BTN_HOME, 100)
	push(BTN_CHAR, 200)
	push(BTN_HOME, 3000)
}

autoBattle(repeat) {
	loop %repeat% {
		notify("Auto battle #" . A_Index . " of " . repeat)
		push(BTN_BATTLE1, 1500)
		push(BTN_TAB1, 1500)
		battle()
	}
}

doChallenge(key, wait := 0) {
	if (!wait) {
		wait := CHALLENGE_WAIT
	}
	notify("Attempting challenge on key '" . key . "'")
	goHome()
	push(BTN_PAN_LEFT, 2000)
	push(BTN_CHALLENGE)
	push(key)
	push(BTN_TAB3, 10)
	push(BTN_TAB2, 10)
	push(BTN_TAB1, 10)
	sleep 1000
	battle(wait)
	notify("Challenge assumed to be complete. Moving on.")
}

battle(delay := 0) {
	if (!delay){
		delay := BATTLE_WAIT
	}
	push(BTN_BATTLE2, 8000)
	push(BTN_AUTO, 500)
	push(BTN_AUTO, 500)
	clickImage("continuebtn.png", BTN_COMPLETE)
}

claimBonusEnergy() {
	notify("Attempting to claim bonus energy")
	goHome()
	clickImage("quests.png", BTN_BATTLE2, 30000, "Opened Quests", "Attempting to open quests")
	sleep 1000
	push(BTN_BATTLE2)
	push(BTN_BATTLE2)
	push(BTN_BATTLE2)
	push(BTN_BATTLE2)
}

clickImage(file, button, delay := 300000, msgComplete := "Battle complete!", msgTimeout := "Battle timed out, continuing...") {
	if (IMAGE_SEARCH_ENABLE) {
		_starttime := A_TickCount 
		loop {
			activateEmulator()
			imgX := 0
			imgY := 0
			ImageSearch, imgX, imgY, 0, 0, A_ScreenWidth, A_ScreenHeight, *TransBlack *20 %file%
			elapsedtime := A_TickCount - _starttime
			notify("elapsedtime: " . elapsedtime)
			if (imgX or imgY) {
				mouseClick,, imgX, imgY
				notify(msgComplete)
				break
			} else if (elapsedtime > delay) {
				push(button)
				notify(msgTimeout)
				break
			}
		}
		sleep 5000
	} else {
		sleep %delay%
		push(button)
	}
}

imageWait(file, delay := 300000, msgComplete := "Found image", msgTimeout := "Image find timed out, continuing...") {
	if (IMAGE_SEARCH_ENABLE) {
		_starttime := A_TickCount 
		loop {
			activateEmulator()
			imgX := 0
			imgY := 0
			ImageSearch, imgX, imgY, 0, 0, A_ScreenWidth, A_ScreenHeight, *TransBlack *20 %file%
			elapsedtime := A_TickCount - _starttime
			notify("elapsedtime: " . elapsedtime)
			if (imgX or imgY) {
				notify(msgComplete)
				break
			} else if (elapsedtime > delay) {
				notify(msgTimeout)
				break
			}
		}
		sleep 5000
	} else {
		sleep %delay%
	}
}

dailyShipment(key) {
	notify("Attempting to buy shipment on key '" . key . "'")
	openShipments()

	loop 15 {
	    push(BTN_PAN_DOWN)
	}

	sleep 500
	
	push(key)
	
	hitBuyButton()
}

openShipments() {
	goHome()
	push(BTN_SHIPMENT)
}

findShards(charName) {
	goHome()
	push(BTN_CHAR)
	push(BTN_CHAR_SEARCH)
	push(BTN_CHAR_SEARCH)
	send %charName%
	sleep 100
	push("Enter")
	push(BTN_FIRSTCHAR)
	push(BTN_BATTLE2)
}

buyShards(charName) {
	notify("Attempting to buy " . charName . " shards.")
	findShards(charName)
	push(BTN_TAB1)
	hitBuyButton()
	push(BTN_HOME)
	push(BTN_HOME)
}

battleShards(charName, repeat := 1, key := "") {
	if (key = "") {
		key := BTN_TAB1
	}
	notify("Attempting battle for " . repeat . " shard(s) of " . charName . ".")
	findShards(charName)
	push(key)
	autoBattle(repeat)
}

; Because of variable description height, the "BUY" button is not always
; in the same spot, so tap across different spots where the button may be, 
; starting with the top so we don't prematurely close the confirmation dialog
; by clicking below it
hitBuyButton() {
	push(BTN_BUY1, 50)
	push(BTN_BUY2, 50)
	push(BTN_BUY3, 50)
	push(BTN_BUY4, 50)
	
	push(BTN_HOME)
	push(BTN_HOME)
}

spendAllyPoints() {
	notify("Attempting to spend ally points.")
	goHome()
	push(BTN_STORE)
	push(BTN_TAB1)
	loop 120 {
		push(BTN_BATTLE2, 250)
	}
}

push(key, delay := 1000) {
	WinActivate ahk_id %ANDROID_ID%
	controlSend,, {%key%}, ahk_id %ANDROID_ID%
	sleep %delay%
}

notify(message) {
	TrayTip, SWGoH Auto, %message%, 10
	;sleep 3000
}