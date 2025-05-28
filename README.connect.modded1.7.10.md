# Main instruction to connect to modded 1.7.10

We use pollyMC launcher. (Optionally u can use any other launcher (like TLauncher), that has ability to run easily forge 1.7.1.0)

Game setup.
- Java 1.8.0 64 bit to install and to choose ( https://www.java.com/en/download/ this one should be ok. Ensure to use 64bit version if your PC 64bit friendly (which it should be) )
- pollyMC to turn on https://github.com/fn2006/PollyMC  (pick installer in Releases)
    - Windows-MSVC-Setup version should be good if u are regular windows user
- pick in PollyMC:
    - Minecraft 1.7.10
    - Forge (latest) as loader
- putting stuff from server_modded_1710/mods [in archive](https://github.com/darklab8/infra-game-servers/archive/refs/heads/master.zip) to mods folder 
- adding server address (ask which one)
- If you have unstable internet connection, add to your java arguments `-Dfml.readTimeout=120` in addition, it will help you to stabilize it

# if you are windows user and u have low FPS, while having powerful videocard

That's probably because you have chosen wrong videocard to turn on Minecraft!
How to check it?
Turn on minecraft, Video Settings, Shaders and u will see your current videocard enabled for a game running.

How to fix it? (On Nvidia example)
- Open Ctrl+Alt+Delete, Task Manager while running the game. Right click running Java for game and ask to open its location (and remember the name of file) 
- https://www.ozzu.com/questions/609667/-can-you-choose-a-default-graphics-card-in-windows#:~:text=Right-click%20on%20your%20desktop,set%20a%20default%20graphics%20card.
- Right click your main wallpaper, Go to Display Settings, Graphics settings, and choose as app the java at the found location. In options change graphics preference to videocard.
- go to game and have fast fps. U can validate in Shaders as having minecraft running with Videocard.

But what if u still have low 30FPS already with Nvidia videocard?
Go to Nvidia setttings (near your clock), and in 3d parameters turn on Vertical Vsync as true 🙂
And optionally try running laptop without battery saving mode (should be working if power cable is attached at least)

P.S. potentially with properly turned on Videocard u will have enough video power to turn on shaders if u desire 😉 like:
- https://shadersmods.com/oceano-shaders/
- or https://resourcepack.net/kuda-shaders/#gsc.tab=0
and etc 
