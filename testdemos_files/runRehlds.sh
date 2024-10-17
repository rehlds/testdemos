#!/bin/bash

echo " - Testing ReHLDS - "
rsync -a deps/rehlds/* .

demo=cstrike-muliplayer-1       desc="CS: Multiplayer"                          ./runTest.sh
demo=rehlds-phys-single1        desc="Half-Life: Physics singleplayer"          ./runTest.sh
demo=crossfire-1-multiplayer-1  desc="Half-Life: Multiplayer on crossfire map"  ./runTest.sh
demo=shooting-hl-1              desc="Half-Life: Shooting with several weapons" ./runTest.sh

