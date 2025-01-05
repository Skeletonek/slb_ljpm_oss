# Super Łukaszczyk Bros: Łukaszczyk Jedzie Po Mleko
Spin-off game to Super Łukaszczyk Bros series, where Michał rides in his car to collect as many milks as he can.


## Godot Engine version
As of now, it is recommended to run the project in **Godot Engine 4.3**


## Supported platforms

### {- WARNING! -}
{- As of 2.0-Alpha+6, support for ARMv7 devices with Android OS has been dropped -}

- Microsoft Windows x86_64
  - Windows 10 22H2+
  - Windows 11 23H2+
- Linux x86_64 distributions with X11 or Wayland windowing system, OpenGL / Vulkan drivers and active support. (This excludes distros with only security support)
  - Ubuntu 20.04 Focal Fossa
  - Ubuntu 22.04 Jammy Jellyfish
  - Ubuntu 24.04 Noble Numbat
  - Linux Mint 21+ Vanessa, Vera, Victoria
  - Linux Mint 22 Wilma
  - Linux Mint Debian Edition 6
  - Debian 12 Bookworm
  - Fedora 40
  - Fedora 41
  - OpenSUSE Leap 15.6
  - OpenSUSE Tumbleweed
  - Arch Linux
  - SteamOS 3.5+
  - Other distributions based off the ones mentioned here
- Android ARMv8a or x86_64
  - Android 7.0 Nougat
  - Android 8.0 Oreo
  - Android 8.1 Oreo
  - Android 9.0 Pie
  - Android 10
  - Android 11
  - Android 12
  - Android 13
  - Android 14

{- Windows 11 22H2 and Linux distributions such as Fedora 39 are not supported because they will go EOL before LJPM 2.0 version release -}

Technically it is possible to run the game on unsupported platforms such as MacOS or BSD-family systems, but no binaries are provided and developers won't help with developing fixes for these systems.


## Graphics API
The game uses both OpenGL and Vulkan (mobile) based backends. In Godot these are called "Compatibility" and "Mobile" respectively.\
Game can be run with 'Forward+' backend, but it is not official.


## Commit push
It is required for all commits pushed to 2_0 branch (and later master branch) to pass the pipeline.\
Right now pipeline consist only of lint job.\
If you happen to push a commit that fails the pipeline, please fix it in the next commit as soon as possible.


## Building
Download the recommended Godot Editor version (.NET support is not necessary) from here:\
https://godotengine.org/download/linux/
\
\
Clone the git repo to your local machine
```
git clone https://gitlab.com/Skeletonek/ljpm.git
```
You can build the game with standard Godot Engine build, but then You will omit some nifty optimizations done for the SLB Godot Engine build. If you don't want to use the SLB engine build, omit next paragraph.\
\
Build the SLB Godot Engine export templates using the provided script
```
./build_export_templates.sh
```
**Remember that this will take a very long time to complete.**\
If you are a Windows user, You can use WSL to run this script.\
\
Run Godot engine and import the `project.godot` file from this repo\
Run the editor\
From menubar, go to `Project` -> `Export` and press `Export All...`\
If you don't use the SLB Godot builds, you will need to erase the values inside `Debug` and `Release` options in `Custom Template` category.\
\
Executable files will be available from `../build/` path relative to game directory.


## Copyright notice
**Super Łukaszczyk Bros: Łukaszczyk Jedzie Po Mleko**\
**Copyright © 2023-2024 Skeletonek & Halembarus2**\
\
Godot Engine\
Copyright © 2007-2024 Juan Linietsky, Ariel Manzur & contributors.\
https://godotengine.org/
\
\
SilentWolf Plugin\
Copyright © 2019-2023 SilentWolf\
https://silentwolf.com/
\
\
Godot Engine and SilentWolf are not affiliated with the creators of SLB: LJPM.
