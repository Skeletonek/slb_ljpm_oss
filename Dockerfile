FROM alpine:3.20.3

# ENGINE BUILD
RUN apk add scons pkgconf gcc g++ libx11-dev libxcursor-dev libxinerama-dev libxi-dev libxrandr-dev mesa-dev eudev-dev alsa-lib-dev pulseaudio-dev git
RUN git clone https://github.com/godotengine/godot
WORKDIR godot
RUN git checkout 4.3-stable
RUN scons platform=linuxbsd target=editor arch=x86_64
RUN mv bin/godot.linuxbsd.editor.x86_64 /usr/bin/godot
WORKDIR /
RUN rm -rf /godot

# COPY EXPORT TEMPLATES
COPY export_templates/ /godot/
RUN apk add fontconfig udev

# CLEANUP
RUN apk del scons pkgconf gcc g++ libx11-dev libxcursor-dev libxinerama-dev libxi-dev libxrandr-dev mesa-dev eudev-dev alsa-lib-dev pulseaudio-dev git
RUN apk -v cache clean

# SQUASH TO REDUCE SIZE
FROM scratch
COPY --from=0 / /
