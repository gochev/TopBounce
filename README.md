# TopBounce
MacOS small app that doesnt let you go to the top stoping the menu bar to ever appearing.

The idea is to listen for if mouse goes to the top and moves it slightly down so this way it wont trigger the mac menubar appearing.

If you hold SHIFT it will trigger it 

# Building 

swiftc TopBounce.swift -o TopBounce.swift

# Running 

./TopBounce 

you can make launch agent if you want just dont forget to give proper Accessibility permission
