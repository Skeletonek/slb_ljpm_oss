#!/bin/bash

GODOT_VERSION='4.3-stable'

GREEN='\033[32m';
NOCOLOR='\033[0m';

echo -e "${GREEN}Cloning Godot Engine source code${NOCOLOR}";
git clone https://github.com/godotengine/godot;
(cd godot && git checkout $GODOT_VERSION);

echo -e "${GREEN}Copying necessary build files${NOCOLOR}";
cp -v build/custom.py build/ljpm.build build/build_custom_templates.sh godot/;

echo -e "${GREEN}Running docker container${NOCOLOR}";
docker login registry.gitlab.com
docker run -it -v ./godot:/godot registry.gitlab.com/skeletonek/ljpm/slb_godot_build:focal_fossa-sdk34 ./build_custom_templates.sh;

echo -e "${GREEN}Copying export templates${NOCOLOR}";
cp -v godot/bin/* export_templates/;

echo -e "${GREEN}Deleting Godot Engine source code${NOCOLOR}";
sudo rm -rfv godot/;
