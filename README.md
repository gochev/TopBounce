# TopBounce
MacOS small app that doesnt let you go to the top, stopping the menu bar from ever appearing.

The idea is to listen if mouse goes to the top, and move it slightly down so it wont trigger the mac menubar appearing.

If you hold SHIFT it will trigger it.

# Building 

swiftc TopBounce.swift -o TopBounce

# Running 

./TopBounce 

You can make launch agent if you want, just give proper Accessibility permission