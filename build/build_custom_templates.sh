#!/bin/bash

(cd platform/android/java && ./gradlew clean)
scons platform=android target=template_debug arch=arm64 disable_3d=yes lto=full build_profile="./ljpm.build"
scons platform=android target=template_debug arch=arm32 disable_3d=yes lto=full build_profile="./ljpm.build"
scons platform=android target=template_debug arch=x86_64 generate_apk=yes disable_3d=yes lto=full build_profile="./ljpm.build"
scons platform=linuxbsd target=template_debug arch=x86_64 disable_3d=yes lto=full build_profile="./ljpm.build"
scons platform=windows target=template_debug arch=x86_64 use_mingw=yes disable_3d=yes build_profile="./ljpm.build"
scons platform=android target=template_release arch=arm64 disable_3d=yes lto=full build_profile="./ljpm.build"
scons platform=android target=template_release arch=arm32 disable_3d=yes lto=full build_profile="./ljpm.build"
scons platform=android target=template_release arch=x86_64 generate_apk=yes disable_3d=yes lto=full build_profile="./ljpm.build"
scons platform=linuxbsd target=template_release arch=x86_64 disable_3d=yes lto=full build_profile="./ljpm.build"
scons platform=windows target=template_release arch=x86_64 use_mingw=yes disable_3d=yes build_profile="./ljpm.build"
