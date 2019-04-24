; =========================================================
; ====== Script of actual tasks to run in SWGoH ===========
; =========================================================

; Examples of each automation function are included below. 
; You can check the swgoh-functions.ahk script to find out more
; about how they work or customize them.

#include swgoh-functions.ahk

; ======== DAILY ACTIVITIES ========
;creditPurchase()
;doChallenges()
spendAllyPoints()
;doChallenge(BTN_TAB2) ; just do the challenge on tab 2

; ======= SHARD FARMING ========
;buyShards("jawa engineer") ;attempt to buy JE shards
;buyShards("dathcha")
;buyShards("nebit")
battleShards("jawa", 3) ; auto jawa's first shard battle 3 times
;battleShards("dathcha", 5, BTN_TAB2) ; auto dathcha's 2nd tab hard battle 5 times, third parameter is optional and defaults to BTN_TAB1

; ======= CHALLENGES ==========
;doChallenge(BTN_TAB2) ; just do the challenge on tab 2
;doChallenges() ;do all challenges configured in doChallenges function