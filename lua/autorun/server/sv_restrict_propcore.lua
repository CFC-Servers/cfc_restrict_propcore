-- Propcore is allowed to everyone, but functions in the restrictedFunctions array will be restricted to devotee+ only

function restrictPropCoreFunctions()
    local disallowedRanks = {}
    disallowedRanks["user"] = true
    disallowedRanks["regular"] = true
    
    local restrictedFunctions = {
        "propSpawn(sn)",
        "propSpawn(en)",
        "propSpawn(svn)",
        "propSpawn(evn)",
        "propSpawn(san)",
        "propSpawn(ean)",
        "propSpawn(svan)",
        "propSpawn(evan)",
        "seatSpawn(sn)",
        "seatSpawn(svan)",
        "setPos(e:v)",
        "reposition(e:v)",
        "propManipulate(e:vannn)"
        --"propBreak(e:)"
    }
    
    local adminOnlyFunctions = {
        "use(e:)"   
    }
    
    for _, signature in pairs( restrictedFunctions ) do
        if wire_expression2_funcs then
            local oldFunc = wire_expression2_funcs[signature][3]

            wire_expression2_funcs[signature][3] = function( self, ... )
                if ( disallowedRanks[self.player:GetUserGroup()] == nil ) then
                    local isInBuildMode = self.player:GetNWBool("CFC_PvP_Mode", false) == false

                    if( isInBuildMode or self.player:IsAdmin() ) then
                        return oldFunc( self, ... )
                    else
                        self.player:ChatPrint( "You can't use PropCore in PvP mode" )
                    end
                else
                    self.player:ChatPrint( "You don't have access to " .. signature )
                end
            end
        end
    end
    
    for _, signature in pairs( adminOnlyFunctions ) do
        if wire_expression2_funcs then
            local oldFunc = wire_expression2_funcs[signature][3]

            wire_expression2_funcs[signature][3] = function( self, ... )
                if ( self.player:IsAdmin() ) then
                    local isInBuildMode = self.player:GetNWBool("CFC_PvP_Mode", false) == false

                    if( isInBuildMode or self.player:IsAdmin() ) then
                        return oldFunc( self, ... )
                    else
                        self.player:ChatPrint( "You can't use PropCore in PvP mode" )
                    end
                else
                    self.player:ChatPrint( "You don't have access to " .. signature )
                end
            end
        end
    end
end

hook.Add( "OnGamemodeLoaded","propCoreRestrict", restrictPropCoreFunctions )
