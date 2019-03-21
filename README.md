# AiMs-Synergy-Tracker ![release](https://img.shields.io/badge/release-v3.8.6-yellow.svg)

#### Description
The purpose of this Addon is to show if there currently is a synergy cooldown active and how long it takes to run out.
It's possible to adjust the tracker frame without having to reload your ui.
Furthermore as of Version 3.8 the core of this Addon has been pretty much entierly rewritten to ensure flexibility with further features.


#### Synergies
| Synergy        | Status       |
| ------------- |:-------------:|
| Combustion (Orbs) | <span style="color: #4CAF50;">Added</span> |
| Blessed Shard (Shards) | <span style="color: #4CAF50;">Added</span> |
| Conduit (Liquid Lightning) | <span style="color: #4CAF50;">Added</span> |
| Purify (Extended Ritual) | <span style="color: #4CAF50;">Added</span> |
| Harvest (Healing Seed) | <span style="color: #4CAF50;">Added</span> |
| Bone Wall (Bone Shield) | <span style="color: #4CAF50;">Added</span> |
| Blood Funnel (Blood Altar) | <span style="color: #4CAF50;">Added</span> |
| Spawn Broodlings (Trapping Webs) | <span style="color: #4CAF50;">Added</span> |
| Radiate (Inner Fire) | <span style="color: #4CAF50;">Added</span> |
| Charged Lightning (Summon Storm Atronach) | <span style="color: #4CAF50;">Added</span> |
| Shackle (Dragonknight Standard) | <span style="color: #4CAF50;">Added</span> |
| Impale (Dark Talon) | <span style="color: #4CAF50;">Added</span> |
| Supernova (Nova) | <span style="color: #4CAF50;">Added</span> |
| Hidden Refresh (Consuming Darkness) | <span style="color: #4CAF50;">Added</span> |
| Soul Leech (Soul Shred) | <span style="color: #4CAF50;">Added</span> |
| Icy escape (Frozen Retreat) | <span style="color: #F44336;">Probably won't be added</span> |


<br><br>
#### Version 3.8 (current version)
##### Changes:
- Synergies can now be toggled without having to reload UI
- Reworked the way the cooldowns, etc. are applied to their respective xml elements
- Removed a few tables as they were not needed anymore
- Removed a lot of unnecessary code (Version 3.9 will continue in doing so)
- Added AddFilterForEvent for further performance improvements
- Changed some texts as I'm still not entirely happy with them (If there are better alternatives, please let me know :) )

##### Bugs known:
- fortunately none yet

<br><br>
#### Version 3.9 (estimated: cw 13-14)
##### Changes:
- Added an option to control the time intervals of update events

##### Bugs known:
- fortunately none yet

<br><br>
#### Version 4.0
##### Changes:
- Adding a frame for healers showing them the synergy cooldowns of their tanks.
- The possibility to move each element independently from each other (not sure wether I'm going to implement this one or not)