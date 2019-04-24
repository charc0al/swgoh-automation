#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; =========================================================
; ====== Script of actual tasks to run in SWGoH ===========
; =========================================================

; Examples of each automation function are included below. 
; You can check the swgoh-functions.ahk script to find out more
; about how they work or customize them.

#include swgoh-functions.ahk

claimBonusEnergy()

; ======== DAILY ACTIVITIES ========
creditPurchase()
;doChallenges()
spendAllyPoints()
;doChallenge(BTN_TAB2) ; just do the challenge on tab 2

; ======= SHARD FARMING ========
buyShards("jawa engineer") ;attempt to buy JE shards
;buyShards("dathcha")
;buyShards("nebit")
;battleShards("jawa", 4) ; auto jawa's first shard battle 3 times
;battleShards("jawa", 4) ; auto jawa's first shard battle 3 times
;battleShards("dathcha", 3, BTN_TAB2) ; auto dathcha's 2nd tab hard battle 4 times, third parameter is optional and defaults to BTN_TAB1

; ======= CHALLENGES ==========
;doChallenge(BTN_TAB2) ; just do the challenge on tab 2
;doChallenges() ;do all challenges configured in doChallenges function

notify("EXITING...")
killEmulator()
sleep 5000