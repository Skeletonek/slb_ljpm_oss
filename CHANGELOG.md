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
