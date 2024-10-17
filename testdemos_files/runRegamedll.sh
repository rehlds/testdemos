#!/bin/bash

echo " - Testing ReGameDLL - "
rsync -a deps/regamedll/* .

demo=cstrike-basic-1  desc="CS: Testing jumping, scenarios, shooting etc" ./runTest.sh

