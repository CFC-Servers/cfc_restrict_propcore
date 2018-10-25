-- Restricts PropCore functions based on rank

local restrictedFunctions, rankRestrictedFunctions = require "sv_restricted_propcore_functions"
local function restrictPropCoreFunctions()
    for _, signature in pairs( RESTRICTED_FUNCTIONS ) do
        local oldFunc = wire_expression2_funcs[signature][3]
        wire_expression2_funcs[signature][3] = function( self, ... )
            local playerGroup       = self.player:GetUserGroup()
            local groupRestrictions = rankRestrictedFunctions[playerGroup] or rankRestrictedFunctions['user']
            local restrictions      = groupRestrictions[signature]

            if ( disallowedRanks[self.player:GetUserGroup()] == nil ) then
                local isInBuildMode = self.player:GetNWBool("CFC_PvP_Mode", false) == false
        
            -- No restriction for this rank
            if not restrictions then return oldFunc( self, ... ) end

            -- No access at all
            if restrictions.pvp and restrictions.build then
                self.player:ChatPrint( "You don't have access to " .. signature )
                return
            end

            -- Some sort of access exists
            local isInBuildMode = self.player:GetNWBool("PVPMode", false) == false
            if isInBuildMode then
                if restrictions.build then
                    self.player:ChatPrint( "You can't use " .. signature .. " in Build mode" )
                else
                    return oldFunc( self, ... )
                end
            else
                if restrictions.pvp then                
                    self.player:ChatPrint( "You can't use " .. signature .. " in PvP mode" )
                else
                    return oldFunc( self, ... )
                end
            end
        end
    end
end

hook.Add( "OnGamemodeLoaded","propCoreRestrict", restrictPropCoreFunctions )
