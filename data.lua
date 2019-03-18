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
local COMBUSTION_SYNERGY     = 1     -- orb and shard
local CONDUIT_SYNERGY        = 2     -- liquid lightning
local PURGE_SYNERGY          = 3     -- extended ritual
local HEALING_SYNERGY        = 4     -- healing seed
local BONE_SYNERGY           = 5     -- bone shield
local BLOOD_SYNERGY          = 6     -- blood altar
local TRAPPING_SYNERGY       = 7     -- trapping webs
local RADIATE_SYNERGY        = 8     -- radiate
local ATRONACH_SYNERGY       = 9     -- summon storm atronach
local SHACKLE_SYNERGY        = 10    -- Dragonknight Standard
local IGNITE_SYNERGY         = 11    -- Dark Talons
local NOVA_SYNERGY           = 12    -- Nova and Supernova
local HIDDEN_REFRESH_SYNERGY = 13    -- Consuming Darkness
local SOUL_LEECH_SYNERGY     = 14    -- Soul Shred

----------------------
-- tables
----------------------

--cooldown and visible are also going to be removed as they never had a real use
D.SynergyData = {
    [108782]    = { cooldown = 20,  visible = true, group = BLOOD_SYNERGY },                -- Blood Funnel Synergy     (Blood Altar)
    [108787]    = { cooldown = 20,  visible = true, group = BLOOD_SYNERGY },                -- Blood Feast Synergy      (Overflowing Altar)
    [108788]    = { cooldown = 20,  visible = true, group = TRAPPING_SYNERGY },             -- Spawn Broodlings Synergy (Trapping Webs)
    [108791]    = { cooldown = 20,  visible = true, group = TRAPPING_SYNERGY },             -- Black Widows Synergy     (Shadow Silk)
    [108792]    = { cooldown = 20,  visible = true, group = TRAPPING_SYNERGY },             -- Arachnophobia Synergy    (Tangling Webs)
    [108793]    = { cooldown = 20,  visible = true, group = RADIATE_SYNERGY },              -- Radiate Synergy          (Inner Fire)
    [108794]    = { cooldown = 20,  visible = true, group = BONE_SYNERGY },                 -- Bone Wall Synergy        (Bone Shield)
    [108797]    = { cooldown = 20,  visible = true, group = BONE_SYNERGY },                 -- Spinal Surge Synergy     (Bone Surge)
    [108799]    = { cooldown = 20,  visible = true, group = COMBUSTION_SYNERGY },           -- Combustion Synergy       (Necrotic Orb)
    [108802]    = { cooldown = 20,  visible = true, group = COMBUSTION_SYNERGY },           -- Combustion Synergy       (Energy Orb)
    [108821]    = { cooldown = 20,  visible = true, group = COMBUSTION_SYNERGY },           -- Holy Shards Synergy      (Luminous Shards)
    [108924]    = { cooldown = 20,  visible = true, group = COMBUSTION_SYNERGY },           -- Blessed Shards Synergy   (Spear Shards)
    [108607]    = { cooldown = 20,  visible = true, group = CONDUIT_SYNERGY },              -- Conduit Synergy          (Lightning Splash)
    [108826]    = { cooldown = 20,  visible = true, group = HEALING_SYNERGY },              -- Harvest Synergy          (Healing Seed)
    [108824]    = { cooldown = 20,  visible = true, group = PURGE_SYNERGY },                -- Purge Synergy            (Extended Ritual)
    [102321]    = { cooldown = 20,  visible = true, group = ATRONACH_SYNERGY },             -- Charged Lightning        (Summon Storm Atronach)
    [108805]    = { cooldown = 20,  visible = true, group = SHACKLE_SYNERGY },              -- Shackle Synergy          (Dragonknight Standard)
    [108807]    = { cooldown = 20,  visible = true, group = IGNITE_SYNERGY },               -- Ignite Synergy           (Dark Talons)
    [108822]    = { cooldown = 20,  visible = true, group = NOVA_SYNERGY },                 -- Supernova Synergy        (Nova)
    [108823]    = { cooldown = 20,  visible = true, group = NOVA_SYNERGY },                 -- Gravity Crush Synergy    (Supernova)
    [108808]    = { cooldown = 20,  visible = true, group = HIDDEN_REFRESH_SYNERGY },       -- Hidden Refresh Synergy   (Consuming Darkness)
    [108814]    = { cooldown = 20,  visible = true, group = SOUL_LEECH_SYNERGY }            -- Soul Leech Synergy       (Soul Shred)
    --[61927]     = { cooldown = 20,  visible = true }    -- for testing purposes
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
    [SOUL_LEECH_SYNERGY]     = "/esoui/art/icons/ability_nightblade_018.dds"
}


--this table holds all the timers
D.TrackerTimer = {
    [1] = 0,
    [2] = 0,
    [3] = 0,
    [4] = 0,
    [5] = 0,
    [6] = 0,
    [7] = 0,
    [8] = 0,
    [9] = 0,
    [10] = 0,
    [11] = 0,
    [12] = 0,
    [13] = 0,
    [14] = 0
}