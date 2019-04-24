# Star Wars Galaxy of Heroes Automation
AutoHotKey scripts for automating the tediously mindless tasks required to play Star Wars Galaxy of Heroes.

## Setup
1. After you download or clone this repository, install [AutoHotKey](https://www.autohotkey.com/) and [BlueStacks](https://www.bluestacks.com/) or another Android emulator, but if it's not BlueStacks then you will have a little extra configuring to do. 
  - You will also need to install SWGoH within the BlueStacks emulator (duh)

2. Copy [this BlueStacks config](https://raw.githubusercontent.com/charc0al/swgoh-automation/master/bluestacks-config/com.ea.game.starwarscapital_row.cfg) file into your BlueStacks install directory under configs and replace the exiting file of the same name. This will set up the keyboard controls for BlueStacks so the script can hit the correct places on the screen to push buttons.

3. Modify the [GAME_CMD](https://github.com/charc0al/swgoh-automation/blob/master/swgoh-functions.ahk#L7) variable in swgoh-functions.ahk to match the path to your HD-RunApp.exe, or replace it with another command that will launch the game if you're using a different emulator or version. (You will most likely only need to change the path to HD-RunApp.exe, if even that)

4. You can now simply run any of the example .ahk files included (like [swgoh-daily.ahk](https://raw.githubusercontent.com/charc0al/swgoh-automation/master/swgoh-daily.ahk) ), which will check if BlueStacks is active, launch it if it is not, and run whatever tasks you've included. Example tasks are included in these files. You can also look in [swgoh-functions](https://raw.githubusercontent.com/charc0al/swgoh-automation/master/swgoh-functions.ahk) for more info on what functions you can call, or to modify them to fit your needs better.

5. (Optional) - Set up [scheduled tasks](http://lmgtfy.com/?q=create+windows+scheduled+tasks) in Windows to run [swgoh-daily.ahk](https://raw.githubusercontent.com/charc0al/swgoh-automation/master/swgoh-daily.ahk) or other custom scripts when you want them to run, for example claiming bonus energy and buying from the store on 6 hour intervals.
