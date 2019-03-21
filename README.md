# AiMs-Synergy-Tracker ![release](https://img.shields.io/badge/release-v3.8.6-yellow.svg)

#### Description
The purpose of this Addon is to show if there currently is a synergy cooldown active and how long it takes to run out.
It's possible to adjust the tracker frame without having to reload your ui.
Furthermore as of Version 3.8 the core of this Addon has been pretty much entierly rewritten to ensure flexibility with further features.


#### Synergies
| Synergy        | Status       |
| ------------- |:-------------:|
| **Combustion** (Orbs) | Added |
| **Blessed Shard** (Shards) | Added |
| **Conduit** (Liquid Lightning) | Added |
| **Purify** (Extended Ritual) | Added |
| **Harvest** (Healing Seed) | Added |
| **Bone Wall** (Bone Shield) | Added |
| **Blood Funnel** (Blood Altar) | Added |
| **Spawn Broodlings** (Trapping Webs) | Added |
| **Radiate** (Inner Fire) | Added |
| **Charged Lightning** (Summon Storm Atronach) | Added |
| **Shackle** (Dragonknight Standard) | Added |
| **Impale** (Dark Talon) | Added |
| **Supernova** (Nova) | Added |
| **Hidden Refresh** (Consuming Darkness) | Added |
| **Soul Leech** (Soul Shred) | Added |
| **Icy escape** (Frozen Retreat) | Probably won't be added |


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
