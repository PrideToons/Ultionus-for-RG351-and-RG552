#!/bin/bash

if [ -d "/opt/system/Tools/PortMaster/" ]; then
  controlfolder="/opt/system/Tools/PortMaster"
elif [ -d "/opt/tools/PortMaster/" ]; then
  controlfolder="/opt/tools/PortMaster"
elif [ -d "/roms/ports" ]; then
  controlfolder="/roms/ports/PortMaster"
 elif [ -d "/roms2/ports" ]; then
  controlfolder="/roms2/ports/PortMaster"
else
  controlfolder="/storage/roms/ports/PortMaster"
fi

source $controlfolder/control.txt

get_controls

if [ -f "/opt/system/Advanced/Switch to main SD for Roms.sh" ]; then
  GAMEDIR="/roms2/ports/Ultionus"
  LIBDIR="/roms2/ports/Ultionus/lib32"
  BINDIR="/roms2/ports/Ultionus/box86"
else
  GAMEDIR="/roms/ports/Ultionus"
  LIBDIR="/roms/ports/Ultionus/lib32"
  BINDIR="/roms/ports/Ultionus/box86"
fi

#BOX86 LOG
export BOX86_LOG=1

# gl4es
export LIBGL_FB=4

# system
export LD_LIBRARY_PATH=$LIBDIR:/usr/lib32:/usr/local/lib/arm-linux-gnueabihf/

# box86
export BOX86_ALLOWMISSINGLIBS=1
export BOX86_LD_LIBRARY_PATH=$LIBDIR
export BOX86_LIBGL=$LIBDIR/libGL.so.1
export BOX86_PATH=$BINDIR

cd $GAMEDIR

$ESUDO rm -rf ~/.config/Ultionus
$ESUDO ln -s /$GAMEDIR/conf/Ultionus ~/.config/
$ESUDO chmod 666 /dev/uinput
$GPTOKEYB "box86" -c "./ultionus.gptk" &
$BINDIR/box86 $GAMEDIR/runner
$ESUDO kill -9 $(pidof gptokeyb)
$ESUDO systemctl restart oga_events &
printf "\033c" >> /dev/tty1
