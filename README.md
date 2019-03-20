# AiMs-Synergy-Tracker

#### Description:
The purpose of this Addon is to show if there currently is a synergy cooldown active and how long it takes to run out.
It's possible to adjust the tracker frame without having to reload your ui.
Furthermore as of Version 3.8 the core of this Addon has been pretty much entierly rewritten to ensure flexibility with further features.

<br><br>
#### Version 3.8 (current version)
##### Changes:
- Synergies can now be toggled without having to reload UI
- Reworked the way the cooldowns, etc. are applied to their respective xml elements
- Removed a few tables as they were not needed anymore
- Removed a lot of unnecessary code (Version 3.9 will continue in doing so)
- Added AddFilterForEvent Event for further performance improvements
- Changed some texts as I'm still not entirely happy with them (If there are better alternatives, please let me know :) )

##### Bugs known:
- fortunately none yet

<br><br>
#### Version 3.9 (estimated: cw 13-14)
##### Changes:
- Removed some more unnecessary code
- Added an option to control the time intervals of update events

##### Bugs known:
- fortunately none yet

<br><br>
#### Version 4.0
##### Changes:
- Added a frame for healers showing them the synergy cooldowns of their tanks.

##### Notes for the healer frame:
- Frame should be treated like a module which will be activated from a single function (like the one below)
```lua
--initizialize healer ui
AST.HealerUI(AST.SV.healerui)
```