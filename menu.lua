-- Settings menu.
function AST.LoadSettings()
    local LAM = LibStub("LibAddonMenu-2.0")

    local panelData = {
        type = "panel",
        name = AST.name,
        displayName = AST.name,
        author = "|cfd6a02AiMPlAyEr[EU]|r",
        version = AST.version,
        slashCommand = "/astmenu",
        website = AST.website,
        registerForRefresh = true,
        registerForDefaults = true,
    }
    LAM:RegisterAddonPanel(AST.menuname, panelData)

    local optionsTable = {}

    --elements
    table.insert(optionsTable, {
        type = "header",
        name = "Tracker Settings",
    })

    table.insert(optionsTable, {
        type = "dropdown",
        name = "Alignment of Synergies",
        tooltip = "Allows the alignment of synergies to be adjusted",
        choices = {"horizontal", "vertical", "compact"},
        getFunc = function() return AST.SV.orientation end,
        setFunc = function(var) 
            AST.SV.orientation = var 
            AST.UI.UpdateElements()
        end,
    })

    table.insert(optionsTable, {
        type = "slider",
        name = "Tracker Transparency",
        tooltip = "Defines the transparency of the tracker's background.",
        min = 0,
        max = 100,
        step = 1,
        getFunc = function() 
            if AST.SV.alpha ~= nil then
                return math.floor(AST.SV.alpha*100) 
            end
        end,
        setFunc = function(var) 
            local newAlpha = var / 100
            AST.SV.alpha =newAlpha
            AST.LoadAlpha(newAlpha);
        end,
    })

    table.insert(optionsTable, {
        type = "checkbox",
        name = "Texture Transparency",
        tooltip = "Makes the textures transparent as well",
        getFunc = function() return AST.SV.textures end,
        setFunc = function(value) 
            AST.SV.textures = value
            AST.LoadAlpha(AST.SV.alpha)
        end,
    })

    table.insert(optionsTable, {
        type = "slider",
        name = "Update Interval",
        tooltip = "Defines the refresh rate in ms",
        min = 50,
        max = 1000,
        step = 50,
        getFunc = function() 
            return AST.SV.interval
        end,
        setFunc = function(var) 
            AST.SV.interval = var
        end,
    })

    table.insert(optionsTable, {
        type = "slider",
        name = "Window Scale",
        tooltip = "Adjusts the scale of the tracker",
        min = 50,
        max = 200,
        step = 1,
        getFunc = function() 
            if AST.SV.windowscale ~= nil then
                return math.floor(AST.SV.windowscale*100) 
            end
        end,
        setFunc = function(var) 
            local newWindowScale = var / 100
            AST.SV.windowscale = newWindowScale
            AST.UI.UpdateElements()
        end,
    })

    table.insert(optionsTable, {
        type = "checkbox",
        name = "Show Tracker outside of Combat",
        tooltip = "Toggles the tracker outside of fights",
        getFunc = function() return AST.SV.windowstate end,
        setFunc = function(value) 
            AST.SV.windowstate = value
            windowstate = value
            AST.windowState()
        end,
    })

    table.insert(optionsTable, {
        type = "checkbox",
        name = "Lock Tracker Window",
        getFunc = function() return AST.SV.lockwindow end,
        setFunc = function(value) 
            AST.LockWindow(value)
            AST.SV.lockwindow = value 
        end,
    })

    table.insert(optionsTable, {
        type = "submenu",
        name = "Synergy Settings",
        controls = {
            [1] = {
                type = "checkbox",
                name = "Conduit",
                tooltip = "Synergy of Liquid Lightning",
                getFunc = function() return AST.SV.liq end,
                setFunc = function(value) 
                    AST.SV.liq = value 
                    AST.UI.UpdateElements()
                end,
            },
            [2] = {
                type = "checkbox",
                name = "Purify",
                tooltip = "Synergy of Cleansing Ritual",
                getFunc = function() return AST.SV.pur end,
                setFunc = function(value) 
                    AST.SV.pur = value 
                    AST.UI.UpdateElements()
                end,
            },
            [3] = {
                type = "checkbox",
                name = "Combustion/Blessed Shard",
                tooltip = "Synergy of Energy Orb/Spear Shard",
                getFunc = function() return AST.SV.orb end,
                setFunc = function(value) 
                    AST.SV.orb = value
                    AST.UI.UpdateElements()
                end,
            },
            [4] = {
                type = "checkbox",
                name = "Bone Wall",
                tooltip = "Synergy of Bone Shield",
                getFunc = function() return AST.SV.bon end,
                setFunc = function(value) 
                    AST.SV.bon = value
                    AST.UI.UpdateElements()
                end,
            },
            [5] = {
                type = "checkbox",
                name = "Harvest",
                tooltip = "Synergy of Healing Seed",
                getFunc = function() return AST.SV.hea end,
                setFunc = function(value) 
                    AST.SV.hea = value 
                    AST.UI.UpdateElements()
                end,
            },
            [6] = {
                type = "checkbox",
                name = "Blood Funnel",
                tooltip = "Synergy of Blood Altar",
                getFunc = function() return AST.SV.blo end,
                setFunc = function(value) 
                    AST.SV.blo = value 
                    AST.UI.UpdateElements()
                end,
            },
            [7] = {
                type = "checkbox",
                name = "Spawn Broodlings",
                tooltip = "Synergy of Trapping Webs",
                getFunc = function() return AST.SV.tra end,
                setFunc = function(value) 
                    AST.SV.tra = value 
                    AST.UI.UpdateElements()
                end,
            },
            [8] = {
                type = "checkbox",
                name = "Charged Lightning",
                tooltip = "Synergy of Summon Storm Atronach",
                getFunc = function() return AST.SV.cha end,
                setFunc = function(value) 
                    AST.SV.cha = value 
                    AST.UI.UpdateElements()
                end,
            },
            [9] = {
                type = "checkbox",
                name = "Radiate",
                tooltip = "Synergy of Inner Fire",
                getFunc = function() return AST.SV.rad end,
                setFunc = function(value) 
                    AST.SV.rad = value 
                    AST.UI.UpdateElements()
                end,
            },
            [10] = {
                type = "checkbox",
                name = "Shackle",
                tooltip = "Synergy of Dragonknight Standard",
                getFunc = function() return AST.SV.sha end,
                setFunc = function(value) 
                    AST.SV.sha = value 
                    AST.UI.UpdateElements()
                end,
            },
            [11] = {
                type = "checkbox",
                name = "Impale",
                tooltip = "Synergy of Dark Talons",
                getFunc = function() return AST.SV.imp end,
                setFunc = function(value) 
                    AST.SV.imp = value 
                    AST.UI.UpdateElements()
                end,
            },
            [12] = {
                type = "checkbox",
                name = "Supernova",
                tooltip = "Synergy of Nova",
                getFunc = function() return AST.SV.gra end,
                setFunc = function(value) 
                    AST.SV.gra = value 
                    AST.UI.UpdateElements()
                end,
            },
            [13] = {
                type = "checkbox",
                name = "Hidden Refresh",
                tooltip = "Synergy of Consuming Darkness",
                getFunc = function() return AST.SV.hir end,
                setFunc = function(value) 
                    AST.SV.hir = value
                    AST.UI.UpdateElements()
                end,
            },
            [14] = {
                type = "checkbox",
                name = "Soul Leech",
                tooltip = "Synergy of Soul Shred",
                getFunc = function() return AST.SV.sol end,
                setFunc = function(value) 
                    AST.SV.sol = value
                    AST.UI.UpdateElements() 
                end,
            },
        },
    })

    LAM:RegisterOptionControls(AST.menuname, optionsTable)
end