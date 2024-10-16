#!/bin/bash

echo " - Testing rehlds -"
rsync -a deps/rehlds/* .

demo=cstrike-muliplayer-1       desc="CS: Multiplayer"                          ./test.sh
demo=rehlds-phys-single1        desc="Half-Life: Physics singleplayer"          ./test.sh
demo=crossfire-1-multiplayer-1  desc="Half-Life: Multiplayer on crossfire map"  ./test.sh
demo=shooting-hl-1              desc="Half-Life: Shooting with several weapons" ./test.sh

