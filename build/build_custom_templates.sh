#!/bin/bash

# Support for Android ARMv7 has been dropped in 2.0-Alpha+6

# Support for Web builds based on Emscripten SDK is currently not ready

export BUILD_NAME="slb_godot_build"
(cd platform/android/java && ./gradlew clean)
scons platform=android target=template_debug arch=arm64 disable_3d=yes lto=full build_profile="./ljpm.build"
# scons platform=android target=template_debug arch=arm32 disable_3d=yes lto=full build_profile="./ljpm.build"
scons platform=android target=template_debug arch=x86_64 generate_apk=yes disable_3d=yes lto=full build_profile="./ljpm.build"
# scons platform=linuxbsd target=template_debug arch=x86_64 disable_3d=yes lto=full build_profile="./ljpm.build"
# scons platform=windows target=template_debug arch=x86_64 use_mingw=yes disable_3d=yes build_profile="./ljpm.build"
# scons platform=web target=template_debug threads=no disable_3d=yes build_profile="./ljpm.build"
if [[ -n $SLB_NO_RELEASE ]]; then
    exit 0;
fi
scons platform=android target=template_release arch=arm64 disable_3d=yes lto=full build_profile="./ljpm.build"
# scons platform=android target=template_release arch=arm32 disable_3d=yes lto=full build_profile="./ljpm.build"
scons platform=android target=template_release arch=x86_64 generate_apk=yes disable_3d=yes lto=full build_profile="./ljpm.build"
# scons platform=linuxbsd target=template_release arch=x86_64 disable_3d=yes lto=full build_profile="./ljpm.build"
# scons platform=windows target=template_release arch=x86_64 use_mingw=yes disable_3d=yes build_profile="./ljpm.build"
# scons platform=web target=template_release threads=no disable_3d=yes build_profile="./ljpm.build"
