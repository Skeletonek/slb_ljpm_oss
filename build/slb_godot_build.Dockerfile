# Remember to mount volumes to your local directory for accessing build files
# You can mount docker volumes using -v parameter:
#
# docker run -v local_mount:container_mount image:tag
# F.e.:
# docker run -v godot_src_code:/godot slb_godot_build:focal_fossa-sdk34

# Use Focal Fossa image for insuring compatibility with linux distros using GLIBC 2.31+
FROM ubuntu:20.04

ENV ANDROID_HOME="/android"
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt update && apt install -y mingw-w64 build-essential pkg-config libx11-dev \
  libxcursor-dev libxinerama-dev libgl1-mesa-dev libglu1-mesa-dev libasound2-dev \
  libpulse-dev libudev-dev libxi-dev libxrandr-dev libwayland-dev openjdk-17-jdk git curl \
  python3 python3-pip && pip install SCons==4.0.1

# Configure mingw for Godot building
RUN update-alternatives --set x86_64-w64-mingw32-gcc /usr/bin/x86_64-w64-mingw32-gcc-posix
RUN update-alternatives --set x86_64-w64-mingw32-g++ /usr/bin/x86_64-w64-mingw32-g++-posix

# Install Android SDK
RUN mkdir -p /android/cmdline-tools/latest && cd /android/cmdline-tools/latest && \
  curl -L https://server.skeletonek.com/app/ljpm/cmdline-tools.tar.gz | tar -xzvf - --strip-components=1 && \
  cd bin/ && yes | ./sdkmanager --licenses && \
  ./sdkmanager --install "platform-tools" "build-tools;34.0.0" "platforms;android-34" "ndk;23.2.8568313"


WORKDIR /godot
