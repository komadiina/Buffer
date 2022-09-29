Buffy = LibStub("AceAddon-3.0"):NewAddon("Buffy", "AceEvent-3.0", "AceConsole-3.0")
local AceGUI = LibStub("AceGUI-3.0")

-- [[ TODO: Implement callbacks for checkbox state toggles ]]--

function Buffy:OnInitialize()
    self:RegisterChatCommand("buffy", "SlashCommand")
end

function Buffy:OnEnable()
    self:RegisterChatCommand("buffy", "SlashCommand")
end

function Buffy:GetRaidMembers()
    local RaidUnits = {}

    for i = 1, MAX_RAID_MEMBERS do
        local RaidUnit = format("%s%i", 'raid', i)
        local RaidUnitName = UnitName(RaidUnit)
        if RaidUnitName ~= "" and RaidUnitName ~= nil then
            table.insert(RaidUnits, #RaidUnits, RaidUnitName)
        end
    end

    return RaidUnits
end

local function DrawBuffTab(container, buffs)
    -- Create a scrollable container inside current tab
    local ScrollableContainer = AceGUI:Create("SimpleGroup")
    ScrollableContainer:SetFullWidth(true)
    ScrollableContainer:SetFullHeight(true)
    ScrollableContainer:SetLayout("Fill")
    container:AddChild(ScrollableContainer)

    -- Create a scroll-frame inside the SCROLLABLE container
    local ScrollList = AceGUI:Create("ScrollFrame")
    ScrollList:SetLayout("Flow")
    ScrollableContainer:AddChild(ScrollList)

    for _, buff in ipairs(buffs) do
        local BuffEntry = AceGUI:Create("CheckBox")
        BuffEntry:SetLabel(buff)
        ScrollList:AddChild(BuffEntry)
    end
end

local function DrawRaidCompTab(container)
    local RaidUnits = Buffy:GetRaidMembers()
    if #RaidUnits then
        for _, RaidUnitName in ipairs(RaidUnits) do
            local UnitLabel = AceGUI:Create("InteractiveLabel")
            UnitLabel:SetText(RaidUnitName)
            container:AddChild(UnitLabel)
        end
    else
        local EmptyRaidLabel = AceGUI:Create("InteractiveLabel")
        EmptyRaidLabel:SetText("No members are in raid.")
        container:AddChild(EmptyRaidLabel)
    end
end

local function SelectGroup(container, event, group)
    container:ReleaseChildren()

    if group == "generalbuffs" then
        DrawBuffTab(container, GeneralBuffs)
    elseif group == "casterbuffs" then
        DrawBuffTab(container, CasterBuffs)
    elseif group == "meleebuffs" then
        DrawBuffTab(container, MeleeBuffs)
    elseif group == "flaskbuffs" then
        DrawBuffTab(container, FlaskBuffs)
    elseif group == "defensiveauras" then
        DrawBuffTab(container, DefensiveAuras)
    elseif group == "offensiveauras" then
        DrawBuffTab(container, OffensiveAuras)
    elseif group == "raidcomp" then
        DrawRaidCompTab(container)
    elseif group == "extras" then
        DrawExtrasTab(container)
    end
end

function Buffy:SlashCommand()
    local BuffyFrame = AceGUI:Create("Frame")
    BuffyFrame:SetWidth(500)
    BuffyFrame:SetTitle("Buffy")
    BuffyFrame:SetStatusText("Oggnjen @ Lordaeron, Warmane")
    BuffyFrame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
    BuffyFrame:SetLayout("Flow")

    local BuffTabGroup = AceGUI:Create("TabGroup")
    BuffTabGroup:SetLayout("Flow")
    BuffTabGroup:SetRelativeWidth(0.5)
    BuffTabGroup:SetTabs({
        {
            text = "General Buffs",
            value = "generalbuffs"
        },
        {
            text = "Caster Buffs",
            value = "casterbuffs"
        },
        {
            text = "Melee Buffs",
            value = "meleebuffs"
        },
        {
            text = "Flask Buffs",
            value = "flaskbuffs"
        },
        {
            text = "Defensive Auras",
            value = "defensiveauras"
        },
        {
            text = "Offensive Auras",
            value = "offensiveauras"
        }
    })
    BuffTabGroup:SetCallback("OnGroupSelected", SelectGroup)
    BuffTabGroup:SelectTab("generalbuffs")

    local PlayerList = AceGUI:Create("TabGroup")
    PlayerList:SetLayout("Flow")
    PlayerList:SetTabs({
        {
            text = "Raid Composition",
            value = "raidcomp"
        },
        {
            text = "Extras",
            value = "extras"
        }
    })
    PlayerList:SetCallback("OnGroupSelected", SelectGroup)
    PlayerList:SelectTab("raidcomp")
    PlayerList:SetRelativeWidth(0.5)

    BuffyFrame:AddChild(BuffTabGroup)
    BuffyFrame:AddChild(PlayerList)
end
