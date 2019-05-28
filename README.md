# AiMs-Synergy-Tracker ![release](https://img.shields.io/badge/release-v4.0.0_alpha-green.svg)

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
#### Version 4.0 Alpha5
##### Changes:
- Updated APIVersion to 100027 (Elsweyr)
- Added Grave Robber and Pure Agony Synergies
- Added a UI for healers
- Adjusted a lot of tooltips
- Added an option to control time interval of update events
- Added an option to let the slider "Tracker Transparency" affect Textures aswell
- Added Checkboxes for Grave Robber and Pure Agony
- Separated Tracker Settings and Healer Settings to ensure a better overview
- Added Checkboxes to deactivate/hide Tracker and Healer UI

##### ToDo-List
- Rounding the remaining time of cooldowns correctly. e.g. 1000ms should display 18 seconds and not 11.9 or 9.0 seconds
- Creating a Healer UI where your healers won't get eye cancer after a few minutes
- Probably some additional adjustments to the menu

##### Untested Changes:
- Everything apart from the menu settings

##### Bugs known:
- fortunately none yet


#### Future Update
- The possibility to move each element independently from each other (not sure wether I'm going to implement this one or not)
