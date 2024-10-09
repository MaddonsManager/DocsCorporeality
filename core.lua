--[[
	Copyright (c) 2009, dr_AllCOM3
    All rights reserved.

    You're allowed to use this addon, free of monetary charge,
    but you are not allowed to modify, alter, or redistribute
    this addon without express, written permission of the author.
]]

local addon = LibStub( "AceAddon-3.0" ):NewAddon( "DocsCorporeality", "AceEvent-3.0" )
local L = LibStub( "AceLocale-3.0" ):GetLocale( "DocsCorporeality" )

local temp

local function p( text ) -- Print
	ChatFrame3:AddMessage( tostring( text ) )
end

local width = 200
local height = 40

local frame = CreateFrame( "Frame" )
frame:SetWidth( width )
frame:SetHeight( height )
frame:SetPoint( "TOP", UIParent, "TOP", 0, 0 )
frame:SetBackdrop( { 
  bgFile = "Interface\\Buttons\\WHITE8X8", 
  edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = false, tileSize = 16, edgeSize = 16, 
  insets = { left = 4, right = 4, top = 4, bottom = 4 }
} )
frame:SetBackdropBorderColor( 0.5, 0.5, 0.5, 1 )
frame:SetBackdropColor( 0, 0, 0, 1 )
frame:Hide()

local text = frame:CreateFontString( nil, "OVERLAY", "GameFontNormal" )
text:SetWidth( width )
text:SetHeight( height )
text:SetPoint( "TOP", frame, "TOP", 0, -5 )
text:SetFont( "Fonts\\FRIZQT__.TTF", 30, "OUTLINE" )
text:SetJustifyH( "CENTER" )
text:SetJustifyV( "TOP" )
text:SetTextColor( 0, 1, 0, 1 )
text:SetText( L["Ok"] )

local textPercent = frame:CreateFontString( nil, "OVERLAY", "GameFontNormal" )
textPercent:SetWidth( width )
textPercent:SetHeight( height )
textPercent:SetPoint( "BOTTOM", frame, "BOTTOM", 0, 5 )
textPercent:SetFont( "Fonts\\FRIZQT__.TTF", 10 )
textPercent:SetJustifyH( "CENTER" )
textPercent:SetJustifyV( "BOTTOM" )
textPercent:SetTextColor( 0, 1, 0, 1 )
textPercent:SetText( "50%" )

local function textSelector( value )
    if value==50 then -- Ok
        text:SetText( L["Ok"] )
        text:SetTextColor( 0, 1, 0, 1 )
        textPercent:SetText( value.."%" )
        textPercent:SetTextColor( 0, 1, 0, 1 )
    elseif value==40 then -- Slower
        text:SetText( L["Slower"] )
        text:SetTextColor( 1, 0.5, 0, 1 )
        textPercent:SetText( value.."%" )
        textPercent:SetTextColor( 0, 1, 0, 1 )
    elseif value<=30 then -- Stop
        text:SetText( L["STOP"] )
        text:SetTextColor( 1, 0, 0, 1 )
        textPercent:SetText( value.."%" )
        textPercent:SetTextColor( 1, 0, 0, 1 )
    elseif value==60 then -- More
        text:SetText( L["More"] )
        text:SetTextColor( 0, 1, 0, 1 )
        textPercent:SetText( value.."%" )
        textPercent:SetTextColor( 0, 1, 0, 1 )
    elseif value>=70 then -- Much more
        text:SetText( L["MUCH MORE"] )
        text:SetTextColor( 0, 1, 0, 1 )
        textPercent:SetText( value.."%" )
        textPercent:SetTextColor( 0, 1, 0, 1 )
    else
        text:SetText( L["Error"] )
        textPercent:SetText( nil )
    end
end

local function checkCorporeality() -- Check the Corporeality status and translate it into an useful value.
    local value = false
    
    for i=1,8 do
        local _, state, text = GetWorldStateUIInfo( i )
        
        --[[if state and state==1 and strfind( text, "%:" ) then
            local s = gsub( text, "(%:)", " " )
            
            local t = { strsplit( " ", s ) }
            
            for i=1,#t do
                if tonumber( t[i] ) then
                    p(text)
                    p(s)
                    p( tonumber( t[i] ) )
                end
            end
        end]]
        
        if state and state==1 and text and type(text)=="string" and strfind( text, "%%" ) then
            text = gsub( text, "(%%)", "" )
            
            local t = { strsplit( " ", text ) }
            
            for i=1,#t do
                if tonumber( t[i] ) then
                    value = tonumber( t[i] )
                    
                    break
                end
            end
        end
    end
    
    if value then
        frame:Show()
        textSelector( value )
        
        if AlwaysUpFrame1 then AlwaysUpFrame1:SetAlpha( 0 ) end
        if AlwaysUpFrame2 then AlwaysUpFrame2:SetAlpha( 0 ) end
    else
        frame:Hide()
    end
end

local function onUpdate( self, elapsed )
    self.lastUpdate = self.lastUpdate+elapsed
    
    if self.lastUpdate>0.5 then
        checkCorporeality()
        
        self.lastUpdate = 0
    end
end

local updateFrame = CreateFrame( "Frame" )
updateFrame:SetScript( "OnUpdate", onUpdate )
updateFrame:Hide()
updateFrame.lastUpdate = 0

function addon:PLAYER_REGEN_ENABLED()
    updateFrame:Hide()
    
    frame:Hide()
end

function addon:PLAYER_REGEN_DISABLED()
    local _, instanceType = IsInInstance()
    
    if instanceType=="raid" then
        for i=1,GetNumRaidMembers() do
            local name = UnitName( "raid"..i.."target" )
            
            if name==L["Halion"] then
                updateFrame:Show()
                
                return
            end
        end
    end
    
    updateFrame:Hide()
end

function addon:PLAYER_ENTERING_WORLD()
    updateFrame:Hide()
    
    frame:Hide()
    
    if AlwaysUpFrame1 then AlwaysUpFrame1:SetAlpha( 1 ) end
    if AlwaysUpFrame2 then AlwaysUpFrame2:SetAlpha( 1 ) end
end

-- OnInitialize
function addon:OnInitialize()
    
end
-- OnEnable
function addon:OnEnable()
    self:RegisterEvent( "PLAYER_REGEN_ENABLED" )
    self:RegisterEvent( "PLAYER_REGEN_DISABLED" )
end
function addon:OnDisable()
	
end
