# Remember to mount volumes to your local directory for accessing build files
# You can mount docker volumes using -v parameter:
#
# docker run -v local_mount:container_mount image:tag
# F.e.:
# docker run -v godot_src_code:/godot slb_godot_build:focal_fossa-sdk35

# Use Focal Fossa image for insuring compatibility with linux distros using GLIBC 2.31+
FROM ubuntu:20.04

ENV ANDROID_HOME="/android"
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt update && apt install -y mingw-w64 build-essential scons pkg-config libx11-dev \
  libxcursor-dev libxinerama-dev libgl1-mesa-dev libglu1-mesa-dev libasound2-dev \
  libpulse-dev libudev-dev libxi-dev libxrandr-dev libwayland-dev openjdk-17-jdk git curl

# Configure mingw for Godot building
RUN update-alternatives --set x86_64-w64-mingw32-g++ /usr/bin/x86_64-w64-mingw32-g++-posix

# Install Android SDK
RUN mkdir -p /android/cmdline-tools/latest && cd /android/cmdline-tools/latest && \
  curl -L https://server.skeletonek.com/app/ljpm/cmdline-tools.tar.gz | tar -xzvf - --strip-components=1 && \
  cd bin/ && yes | ./sdkmanager --licenses && \
  ./sdkmanager --install "platforms;android-35" "build-tools;35.0.0"


WORKDIR /godot
