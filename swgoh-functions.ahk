#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

global game

WinGet game, ID, BlueStacks

sleep 1000

doChallenges() {
	doChallenge("y")
	doChallenge("k")
}

creditPurchase()
{
	dailyShipment("v")
	dailyShipment("q")
	dailyShipment("f")
	dailyShipment("b")
}

goHome() {
	push("h", 500)
	push("h", 500)
	push("c")
	push("h", 3000)
}

autoBattle(repeat) {
	loop %repeat% {
		notify("Auto battle #" . A_Index . " of " . repeat)
		push(".", 1500)
		push("m", 1500)
		battle()
	}
}

doChallenge(key) {
	notify("Attempting challenge on key '" . key . "'")
	goHome()
	push("left", 2000)
	push("n")
	push(key)
	push("u")
	push("k")
	push("t")
	battle(300000)
	notify("Challenge assumed to be complete. Moving on.")
}

battle(delay := 120000) {
	push("]", 8000)
	push("z", 500)
	push("z", 500)
	sleep %delay%
	push("k", 5000)
}

dailyShipment(key) {
	notify("Attempting to buy shipment on key '" . key . "'")
	openShipments()

	loop 15 {
	    push("down", 300)
	}

	sleep 500
	
	push(key)
	
	hitBuyButton()
}

openShipments() {
	goHome()
	push("o")
}

findShards(charName) {
	goHome()
	push("c")
	push("i")
	push("i")
	send %charName%
	sleep 100
	push("Enter")
	push("j")
	push("]")
}

buyShards(charName) {
	notify("Attempting to buy " . charName . " shards.")
	findShards(charName)
	push("y")
	hitBuyButton()
	push("h")
	push("h")
}

battleShards(charName, repeat := 1, key := "y") {
	notify("Attempting battle for " . repeat . " shard(s) of " . charName . ".")
	findShards(charName)
	push(key)
	autoBattle(repeat)
}

hitBuyButton() {
	push("d", 50)
	push("e", 50)
	push("f", 50)
	push("g", 50)
	
	push("h")
	push("h")
}

spendAllyPoints() {
	notify("Attempting to spend ally points.")
	goHome()
	push("p")
	push("t")
	loop 120 {
		push("]", 250)
	}
}

push(key, delay := 1000) {
	WinActivate ahk_id %game%
	controlSend,, {%key%}, ahk_id %game%
	sleep %delay%
}

notify(message) {
	TrayTip, SWGoH Auto, %message%
	sleep 3000
}