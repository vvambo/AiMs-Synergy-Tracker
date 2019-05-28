----------------------
-- data namespace
----------------------
AST.Data = {}

----------------------
-- variables
----------------------
D = AST.Data

----------------------
-- group variables
----------------------
local COMBUSTION_SYNERGY        = 1     -- orb and shard
local CONDUIT_SYNERGY           = 2     -- liquid lightning
local PURGE_SYNERGY             = 3     -- extended ritual
local HEALING_SYNERGY           = 4     -- healing seed
local BONE_SYNERGY              = 5     -- bone shield
local BLOOD_SYNERGY             = 6     -- blood altar
local TRAPPING_SYNERGY          = 7     -- trapping webs
local RADIATE_SYNERGY           = 8     -- radiate
local ATRONACH_SYNERGY          = 9     -- summon storm atronach
local SHACKLE_SYNERGY           = 10    -- Dragonknight Standard
local IGNITE_SYNERGY            = 11    -- Dark Talons
local NOVA_SYNERGY              = 12    -- Nova and Supernova
local HIDDEN_REFRESH_SYNERGY    = 13    -- Consuming Darkness
local SOUL_LEECH_SYNERGY        = 14    -- Soul Shred
local GRAVE_ROBBER_SYNERGY      = 15    -- Grave Robber
local PURE_AGONY_SYNERGY        = 16    -- Pure Agony

----------------------
-- tables
----------------------

D.SynergyData = {
    [108782]    = { cooldown = 20,   group = BLOOD_SYNERGY },                -- Blood Funnel Synergy     (Blood Altar)
    [108787]    = { cooldown = 20,   group = BLOOD_SYNERGY },                -- Blood Feast Synergy      (Overflowing Altar)
    [108788]    = { cooldown = 20,   group = TRAPPING_SYNERGY },             -- Spawn Broodlings Synergy (Trapping Webs)
    [108791]    = { cooldown = 20,   group = TRAPPING_SYNERGY },             -- Black Widows Synergy     (Shadow Silk)
    [108792]    = { cooldown = 20,   group = TRAPPING_SYNERGY },             -- Arachnophobia Synergy    (Tangling Webs)
    [108793]    = { cooldown = 20,   group = RADIATE_SYNERGY },              -- Radiate Synergy          (Inner Fire)
    [108794]    = { cooldown = 20,   group = BONE_SYNERGY },                 -- Bone Wall Synergy        (Bone Shield)
    [108797]    = { cooldown = 20,   group = BONE_SYNERGY },                 -- Spinal Surge Synergy     (Bone Surge)
    [108799]    = { cooldown = 20,   group = COMBUSTION_SYNERGY },           -- Combustion Synergy       (Necrotic Orb)
    [108802]    = { cooldown = 20,   group = COMBUSTION_SYNERGY },           -- Combustion Synergy       (Energy Orb)
    [108821]    = { cooldown = 20,   group = COMBUSTION_SYNERGY },           -- Holy Shards Synergy      (Luminous Shards)
    [108924]    = { cooldown = 20,   group = COMBUSTION_SYNERGY },           -- Blessed Shards Synergy   (Spear Shards)
    [108607]    = { cooldown = 20,   group = CONDUIT_SYNERGY },              -- Conduit Synergy          (Lightning Splash)
    [108826]    = { cooldown = 20,   group = HEALING_SYNERGY },              -- Harvest Synergy          (Healing Seed)
    [108824]    = { cooldown = 20,   group = PURGE_SYNERGY },                -- Purge Synergy            (Extended Ritual)
    [102321]    = { cooldown = 20,   group = ATRONACH_SYNERGY },             -- Charged Lightning        (Summon Storm Atronach)
    [108805]    = { cooldown = 20,   group = SHACKLE_SYNERGY },              -- Shackle Synergy          (Dragonknight Standard)
    [108807]    = { cooldown = 20,   group = IGNITE_SYNERGY },               -- Ignite Synergy           (Dark Talons)
    [108822]    = { cooldown = 20,   group = NOVA_SYNERGY },                 -- Supernova Synergy        (Nova)
    [108823]    = { cooldown = 20,   group = NOVA_SYNERGY },                 -- Gravity Crush Synergy    (Supernova)
    [108808]    = { cooldown = 20,   group = HIDDEN_REFRESH_SYNERGY },       -- Hidden Refresh Synergy   (Consuming Darkness)
    [108814]    = { cooldown = 20,   group = SOUL_LEECH_SYNERGY },           -- Soul Leech Synergy       (Soul Shred)
    [115567]    = { cooldown = 20,   group = GRAVE_ROBBER_SYNERGY },         -- Boneyard Synergy         (Grave Robber)
    [115571]    = { cooldown = 20,   group = GRAVE_ROBBER_SYNERGY },         -- Avid Boneyard Synergy    (Grave Robber)
    [118610]    = { cooldown = 20,   group = PURE_AGONY_SYNERGY },           -- Agony Totem Synergy      (Pure Agony)

}

D.SynergyTexture = {
    [COMBUSTION_SYNERGY]     = "/esoui/art/icons/ability_undaunted_004b.dds",
    [CONDUIT_SYNERGY]        = "/esoui/art/icons/ability_sorcerer_liquid_lightning.dds",
    [PURGE_SYNERGY]          = "/esoui/art/icons/ability_templar_extended_ritual.dds",
    [HEALING_SYNERGY]        = "/esoui/art/icons/ability_warden_007.dds",
    [BONE_SYNERGY]           = "/esoui/art/icons/ability_undaunted_005b.dds",
    [BLOOD_SYNERGY]          = "/esoui/art/icons/ability_undaunted_001_b.dds",
    [TRAPPING_SYNERGY]       = "/esoui/art/icons/ability_undaunted_003_b.dds",
    [RADIATE_SYNERGY]        = "/esoui/art/icons/ability_undaunted_002_b.dds",
    [ATRONACH_SYNERGY]       = "/esoui/art/icons/ability_sorcerer_storm_atronach.dds",
    [SHACKLE_SYNERGY]        = "/esoui/art/icons/ability_dragonknight_006.dds",
    [IGNITE_SYNERGY]         = "/esoui/art/icons/ability_dragonknight_010.dds",
    [NOVA_SYNERGY]           = "/esoui/art/icons/ability_templar_solar_disturbance.dds",
    [HIDDEN_REFRESH_SYNERGY] = "/esoui/art/icons/ability_nightblade_015.dds",
    [SOUL_LEECH_SYNERGY]     = "/esoui/art/icons/ability_nightblade_018.dds",
    [GRAVE_ROBBER_SYNERGY]   = "/esoui/art/icons/ability_necromancer_004_b.dds",
    [PURE_AGONY_SYNERGY]     = "/esoui/art/icons/ability_necromancer_010_b.dds",
}

D.TrackerTimer = {
    [COMBUSTION_SYNERGY]        = 0,
    [CONDUIT_SYNERGY]           = 0,
    [PURGE_SYNERGY]             = 0,
    [HEALING_SYNERGY]           = 0,
    [BONE_SYNERGY]              = 0,
    [BLOOD_SYNERGY]             = 0,
    [TRAPPING_SYNERGY]          = 0,
    [RADIATE_SYNERGY]           = 0,
    [ATRONACH_SYNERGY]          = 0,
    [SHACKLE_SYNERGY]           = 0,
    [IGNITE_SYNERGY]            = 0,
    [NOVA_SYNERGY]              = 0,
    [HIDDEN_REFRESH_SYNERGY]    = 0,
    [SOUL_LEECH_SYNERGY]        = 0,
    [GRAVE_ROBBER_SYNERGY]      = 0,
    [PURE_AGONY_SYNERGY]        = 0,
}

D.SynergyList = {
    "Blood Funnel", 
    "Spawn Broodlings", 
    "Bone Wall", 
    "Combustion", 
    "Conduit", 
    "Harvest", 
    "Purge", 
    "Supernova",
}

D.SynergyListValues = {
    6, 
    7, 
    5, 
    1, 
    2, 
    4, 
    3, 
    12,
}

D.HealerTimer = {}

D.UnitClasses = {
    ["nightblade"]      = "art/icons/class/class_nightblade.dds",
    ["templar"]         = "art/icons/class/class_templar.dds",
    ["sorcerer"]        = "art/icons/class/class_sorcerer.dds",
    ["dragonknight"]    = "art/icons/class/class_dragonknight.dds",
    ["warden"]          = "art/icons/class/class_warden.dds",
    ["necromancer"]     = "art/icons/class/class_necromancer.dds",
}