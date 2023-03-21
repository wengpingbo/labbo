#!/bin/sh

# -kernel /path/to/Image
# -no-window
./emulator/emulator -avd testavd -no-audio -camera-back none -camera-front none -netdelay none -netfast -gpu guest
