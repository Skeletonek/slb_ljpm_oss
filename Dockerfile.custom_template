FROM ubuntu:22.04
RUN apt update
RUN apt install -y mingw-w64 build-essential scons pkg-config libx11-dev libxcursor-dev libxinerama-dev libgl1-mesa-dev libglu1-mesa-dev libasound2-dev libpulse-dev libudev-dev libxi-dev libxrandr-dev libwayland-dev openjdk-17-jdk sdkmanager git
RUN sdkmanager --install tools
RUN git clone https://github.com/godotengine/godot
WORKDIR godot
RUN git checkout 4.3
