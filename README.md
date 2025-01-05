# Super Łukaszczyk Bros: Łukaszczyk Jedzie Po Mleko
Spin-off game to Super Łukaszczyk Bros series, where Michał rides his car to collect as many milks as he can.

## Godot Engine version
As of now, it is recommended to run the project in **Godot Engine 4.3**

## Supported platforms
- Microsoft Windows x86_64
  - Windows 10 22H2+
  - Windows 11 22H2+
- Linux x86_64 distributions with X11 or Wayland windowing system, OpenGL / Vulkan drivers and active support. (This excludes distros with only security support)
  - Ubuntu 22.04 Jammy Jellyfish
  - Ubuntu 24.04 Noble Numbat
  - Linux Mint 21 'Vanessa'
  - Fedora 40
  - Arch Linux
- Android ARMv7, ARMv8a or x86_64
  - Android 7.0 Nougat
  - Android 8.0 Oreo
  - Android 8.1 Oreo
  - Android 9.0 Pie
  - Android 10 Queen Cake
  - Android 11 Red Velvet Cake
  - Android 12 Snow Cone
  - Android 13 Tiramisu
  - Android 14 Upside Down Cake

Technically it is possible to run the game on unsupported platforms such as MacOS or BSD-family systems, but no binaries are provided and developers won't help with developing fixes for these systems.

## Graphics API
The game uses both OpenGL and Vulkan (mobile) based backends. In Godot these are called "Compatibility" and "Mobile" respectively.\
Game can be run with 'Forward+' backend, but it is not official.

## Commit push
It is required for all commits pushed to 2_0 branch (and later master branch) to pass the pipeline.\
Right now pipeline consist only of lint job.\
If you happen to push a commit that fails the pipeline, please fix it in the next commit as soon as possible.

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
