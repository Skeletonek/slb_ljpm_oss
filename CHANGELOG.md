#### 2.0-RC+1
 - Added new statistics visible inside statistics panel
 - Added special skins for AI cars when playing on lunar conflict map
 - Added icons for all missing achievements
 - Added player data importing and exporting
 - Added distance counter to the gui in carride
 - Changed playername storing system
 - Separated milks and distance to its own scoreboards in 2_0 scoreboard
 - Improved resilliency to errors when loading config files
 - Fixed issues with showing highest position on the scoreboard
 - Fixed achievement deatils panel showing when dragging screen in achievements viewer
 - Fixed calculating top speed in statistics layer
 - Fixed carride 1.0 being unplayable on Android devices

#### 2.0-Beta+4
 - Added decrease size powerup
 - Added city map
 - Added achievements for Volvo and Emo Panda
 - Added "Unnamed Driver" music track
 - Added car indicators to carride gui
 - Added icon for elapsed time in carride gui
 - Updated credits info
 - Improved description for V-sync setting
 - Changed milkyway behaviour to show ghostly figuers of the cars
 - Improved AI vehicles collsion between each other

#### 2.0-Beta+3
 - Changed method how unlocked skins and maps are handled by profile system.
     This change make previous save files incompatible
 - Replaced main menu theme with its remastered version
 - Added Volvo skin
 - Added Emo Panda skin
 - Added community attribution to shop layer
 - Added Cyber Punk music track
 - Added icons for milk achievements
 - Added icons for Real Panda and Lukaszczyk on Horse achievements
 - Added icon for Globetrotter achievement
 - Added toggle for touchscreen mode
 - Added device name debug info for Android devices
 - Resized and repositioned some touchscreen buttons
 - Changed FPS counter font size
 - Changed layout of the carride HUD
 - Fixed powerup still blinking when picked up another or died
 - Fixed dev console caret jumping to incorrect position when using autocomplete
 - Fixed space ship stopping with camera on Lunar Conflict map
 - Refactored some checks for achievements

#### 2.0-Beta+2
 - Improved parallax background in forest map
 - Slightly improved parallax background in sahara map
 - Improved parallax background in Lunar Conflict map
 - Added dynamic objects to parallax background in Lunar Conflict map
 - Slightly improved carride GUI
 - Fixed error while gtting top score when no scores of current user exists
 - Fixed error coloring in developer console for some issues
 - Fixed "Condition "!is_inside_tree()" is true. Returning: false" on Android devices
 - Fixed player not colliding with out of bounds, milks and powerups second after death
 - Fixed error when starting classic carride
 - Decreased 2D shadow atlas size
 - Refactored powerup code

#### 2.0-Beta+1
 - Added lives mechanic for 2.0 gameplay
 - Added countdown when powerup is about to end
 - Added skins and maps buying
 - Reworked Credits layer
 - Changed "Report bug" tab to "Technical help" in settings layer
 - Moved debug info to Technical help tab in settings layer
 - Added gamepad deadzone setting
 - Added telemetry notification when booting the game for first time
 - Added "Community Made" badge for skins made by community
 - Added community made Real Panda skin
 - Added community made Content Maker skin
 - Added community made Lukaszczyk on a Horse skin
 - Added error popup when display server fails to initialize Wayland client for Linux systems
 - Added achievements for all community made skins and Lunar Rover skin
 - Added cheats for adding more milk
 - Added cheats for instantly unlocking skins and maps
 - Added easter egg for game, protagonist and Pandemonium birthday
 - Implemented Serious Business and Globetrotter achievements
 - Fixed player steering being not influenced by the slow motion power up
 - Fixed V-Sync and UI blur setting not restoring properly after restart
 - Fixed visible joint in Lunar Conflict map
 - Standarized music files for 44.1KHz sample rate and compressed ever so slightly

#### 2.0-Alpha+8
 - Added power up system
 - Added slow motion powerup
 - Added sound effect for milk bundle
 - Added simple UI navigation with keyboard and gamepad
 - Added self-check for recognizing available V-sync options
 - Added scoreboard for 2.0 mode
 - Added information for best score position
 - Added easter egg for international milk day (1st June)
 - Added process delta counter
 - Improved Rick Roll easter egg
 - Improved debug log overlay interface
 - Improved cars and milks spawning algorithms
 - Mitigated known "car wall" bug
 - Updated V-sync option help information
 - Changed button popup UI theme
 - Changed gameplay tab settings layout
 - Adjusted button audio volume
 - Greatly refactored car ride minigame code
 - Fixed easter egg reacting when bootscreen was still visible
 - Fixed button audio playing twice in profile section

#### 2.0-Alpha+7
 - Added basic 2_0 gameplay with milk bundles giving 3 points
 - Added Lunar Rover skin
 - Added shop layer
 - Added real panda skin
 - Added a light shadow to debug layer
 - Added alerts about file corruption for achievements and
 - Added sound effects to buttons
 - Recolored restart notices to orange
 - Improved easter egg button responsiveness
 - Improved profile layer
 - Optimized performance when using disabled UI blur
 - Optimized map loading to reduce memory usage
 - Fixed popup info sometimes being behind UI in pause menu
 - Fixed texture filtering issues
 - Fixed game over animation playing slower on higher FPS
 - Fixed wrong graphics scale sometimes visible on first frame of loaded scene
 - Dropped support for Windows 11 22H2

#### 2.0-Alpha+6
 - Added Lunar Conflict map
 - Added Sahara map
 - Added cr_map command to change maps
 - Currently chosen skins and maps are now displayed as a dynamic background in main menu
 - Added icons for some achievements
 - Added new achievements connected to completing one game with new skin / map
 - Added option to specify which achievement to reset with achievement_reset command
 - Added "all" option to achievement_award command
 - Added custom info popup in option layer in place of Godot default
 - Added command history for dev console that can be cycled with up and down keys
 - Improved achievement popup layout
 - Adjusted default font size
 - Fixed score calculation
 - Dropped support for ARM-v7 Android devices

#### 2.0-Alpha+5
 - Added profile system
 - Added statistics panel
 - Added sahara music to playlist
 - Added basic skin management system
 - Added cr_skin command
 - Implemented milk total count achievements
 - Changed main menu layout
 - Changed milk collision shape to circle
 - Removed test achievements
 - Improved performance by deffering scores loading to after scoreboard button click
 - Improved game start speed
 - Fixed virtual buttons not working
 - Fixed parallax not working properly on forest map load

#### 2.0-Alpha+4
 - Added enhanced version of forest map as the new main menu background
 - Android builds are now built with custom engine build (ARM64 Release for now only)
 - Added banner showing when player completes all achievements
 - Added explosion animation when crashing player's car
 - Improved parallax effect in forest map
 - Added cr_speedometer_value command
 - Added cr_playername command
 - Achievements are now disabled when using cheats
 - Game automaticly minimizes when choosing bug report button in options layer
 - Slightly recolored road texture
 - Disabled Adaptive V-sync option when using Linux Wayland
 - Fixed achievement panel being visible in left-upper corner when using OpenDyslexia font
 - Fixed time still passing after game over
 - Fixed developer console not working on Linux when using Wayland
 - Refactored carride code
 - Fixed motion reduction not working correctly

#### 2.0-Alpha+3
 - Upgraded Godot Engine to 4.3 stable
 - Added trees in the background using parallax effect
 - Added option to change linux window system
 - Added new achievements (some are not obtainable)
 - Added button for viewing achievements to main menu
 - Added memory and locale info to debug
 - Added build_info command which shows version and release type in corners of the screen
 - Blocked linux window system option on non-linux systems
 - Blocked Off and Adaptive options for V-sync when using Android
 - Changed debug_info to show debug information from credits layer
 - Changed FPS input to spinbox and clamped values from 30 to 999
 - Decreased leaderboard max scores showing to 500 entries
 - Fixed graphics info pop-ups showing not centered on screen
 - Fixed game crash when returning to main menu
 - Fixed warning about wrong asset UUID for achievement_container
 - Fixed music play pausing when in pause menu
 - Fixed music files showing double in music_list command

#### 2.0-Alpha+2
 - Upgraded Godot Engine to 4.3-rc1
 - Added DisplayServer debug information to credits and console logs
 - Added interface for changing Linux windowing system
 - Added Pigtank skin
 - Added animation for booting up game
 - Bumped scoreboard limit to 1000
 - Changed to using bootscreen from SLB Frameworks
 - Updated bootscreen to adapt to SLB: LJPM
 - Removed restart notice when changing easier font settings
 - Fixed using wrong font version when disabled easier font setting
 - Fixed achievement glow being not visible

#### 2.0-Alpha+1
 - Updated SLB Frameworks
 - Added Achievements system
 - Fixed misalignment in a container inside CreditsLayer
 - Update panels tint to be more blueish
 - Refactored file structure
 - Updated copyright notice

#### 1.1.1
 - Modified '5', 'Z' and 'T' characters in default font
 - Fixed leaderboards scrolling being diffcult on touch screen devices, again
 - Updated copyright notices
 - Added new music as an easter egg

#### 1.1.0
 - Changed default mobile renderer to OpenGL
 - Added shortcuts to launch OpenGL version of the game to desktop builds
 - Changed maximum player name length to 36 characters
 - Fixed pause menu not saving settings on exit
 - Fixed audio volume loading with slight delay
 - Fixed scrollbar apearing in scores when using OpenDyslexia font
 - Fixed OpenDyslexia font covering speedometer
 - Fixed easter egg button being clickable under pop up's
 - Fixed some UI elements being not navigable using gamepads
 - Fixed Windows builds user IDs containing "{" character
 - Fixed music_list command not working
 - Enabled godmode in release builds (Godmode will disable saving scores until game restart)

#### 1.0.2
 - Fixed exploit connected to display refresh rate

#### 1.0.1
 - Fixed removing newline characters from player names in leaderboard
 - Fixed easter egg button being clickable behind opaque menus

#### 1.0.0
 - Added pop up when player name is not set
 - Added new version info pop up
 - Adjusted debug information for release versions
 - Fixed gamepad joystick sending too much inputs
 - Fixed leaderboards being difficult to scroll on touch screen devices
 - Fixed interaction between some UI elements
 - Fixed AI Cars going through each other

#### RC.7.1
 - Added icons to gamepad controls section in settings
 - Fixed dev console button in settings reporting wrong state on startup
 - Fixed fullscreen button being "off" on Android where fullscreen is always on
 - Fixed touchscreen console dev button not showing on Android right after changing setting

#### RC.7.0
 - Added player naming setting
 - Added disabling or enabling dev console via setting
 - Reworked leaderboards UI
 - Added command to hide debug info watermark
 - Fixed leaderboards UI not scaling

#### B.6.0
 - Added online leaderboards
 - Added graphical speedometer to game HUD
 - Reorganized game HUD
 - Added virtual buttons as a new input method for touchscreen devices
 - Added customizing keyboard keybindings
 - Audio mastering
 - Changed UI theme of sliders, scrollbars and panels
 - Slightly adjusted options panel
 - Enabled MSDF for OpenDyslexia font
 - Changed font in game scene
 - Added button to report bugs

#### B.5.1
 - Improved spawning algorithm curve
 - Changed Android Adaptive Icons files
 - Fixed missing permission to access the internet
 - Fixed missing crash sound effect
 - Fixed engine error appearing in developer console about disabling a CollisionObject node during a physics callback

#### B.5.0
 - Completely refactored AI cars and milk spawning algorithm
 - Added random speed difference for every AI car
 - Added simple game over screen
 - Added update checking
 - Reduced motion is now stoping sprite animations
 - Fixed Graphics API setting not working on Android
 - Fixed "Reduce motion" setting not working while in game

#### B.4.0
 - Changed default font
 - Added option to change default font for OpenDyslexia
 - Added option to reduce motion
 - Added option to swipe instead of taping on screen to steer the car
 - Enabled touch emulation for mouse devices
 - Increased button margins
 - Doubled simultaneous milks on screen
 - Fixed console not working while in pause menu
 - Fixed buttons click causing car to move on touch screen devices

#### B.3.0
 - Entirely changed main menu look n' feel
 - Changed look of buttons and other related UI elements
 - Added shadow to some sprites
 - Moved developers and engine creators section in credits
 - Increased road scrolling smoothness
 - Added new music
 - Changed music player behaviour
 - Fixed visible camera scaling at the start of the level
 - Changed GUI fonts in carride

#### A.2.0
 - Changed road lanes from 3 to 5
 - Added new AI car colors
 - Added milk as a score item
 - Changed driving direction
 - Added acceleration to Lukaszczyk's car (Game is increasing speed with time)
 - Changed viewport stretch aspect setting
 - Added new music
 - Changed music process mode
 - Changed game logo and splash screen
 - Fixed main menu not loading properly on Android devices
 - Some project files cleanup

#### A.1.1
 - Adjusted cars position
 - Added sterring support for touch devices
 - Removed achievements code

#### A.1.0
 - Fork carride to it's own project
