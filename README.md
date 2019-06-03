# AiMs-Synergy-Tracker ![release](https://img.shields.io/badge/release-v4.1.0-blue.svg)

#### Description
The purpose of this Addon is to show if there currently is a synergy cooldown active and how long it takes to run out.
It's possible to adjust the tracker frame without having to reload your ui.
Furthermore as of Version 3.8 the core of this Addon has been pretty much entierly rewritten to ensure flexibility with further features.


#### Synergies
| Synergy        | Status       |
| ------------- |:-------------:|
| **Combustion** (Orbs) | ✔️ |
| **Blessed Shard** (Shards) | ✔️ |
| **Conduit** (Liquid Lightning) | ✔️ |
| **Purify** (Extended Ritual) | ✔️ |
| **Harvest** (Healing Seed) | ✔️ |
| **Bone Wall** (Bone Shield) | ✔️ |
| **Blood Funnel** (Blood Altar) | ✔️ |
| **Spawn Broodlings** (Trapping Webs) | ✔️ |
| **Radiate** (Inner Fire) | ✔️ |
| **Charged Lightning** (Summon Storm Atronach) | ✔️ |
| **Shackle** (Dragonknight Standard) | ✔️ |
| **Impale** (Dark Talon) | ✔️ |
| **Supernova** (Nova) | ✔️ |
| **Hidden Refresh** (Consuming Darkness) | ✔️ |
| **Soul Leech** (Soul Shred) | ✔️ |
| **Icy escape** (Frozen Retreat) | ❌ |
| **Grave Robber** (Boneyard) | ✔️ |
| **Pure Agony** (Agony Totem) | ✔️ |


<br><br>
#### Version 4.1.0
##### Changes:
- Mostly Bug Fixes and Code improvements

##### ToDo-List
- Fixing some more bugs

##### Untested Changes:
- 

##### Bugs known:
- Charged Lightning Synergy doesn't seem to work atm


#### Future Update
- Making trackerui and healerui more modular:
↳ putting them in separate files (trackerui.lua & healerui.lua)
↳ Removing pretty much everything from core.lua except for AST.SynergyCheck, Support functions and Slash Commands and add them directly to their module. This way it will be way easier to fix bugs and add new things