local CATEGORY_NAME = "User Management"

local function addToWhitelist( callingPlayer, targetPlayers, should_remove )
    local affected_plys = {}
    local message = ""

    for _, ply in pairs( targetPlayers ) do
        local plyWhitelisted = CFCPropcoreRestrict.playerIsWhitelisted( ply )

        if plyWhitelisted and should_remove then
            table.insert( affected_plys, ply )
            message = "#A removed #T from the propcore whitelist"
        elseif plyWhitelisted and not should_remove then
            ULib.tsayError( callingPlayer, ply:Name() .. " is already whitelisted!", true )
        elseif not plyWhitelisted and should_remove then
            ULib.tsayError( callingPlayer, ply:Name() .. " is not whitelisted!", true )
        elseif not plyWhitelisted and not should_remove then
            table.insert( affected_plys, ply )
            message = "#A added #T to the propcore whitelist"
        end
    end

    if should_remove then
        CFCPropcoreRestrict.removePlayersFromPropcoreWhitelist( affected_plys )
    else
        CFCPropcoreRestrict.addPlayersToPropcoreWhitelist( affected_plys )
    end

    ulx.fancyLogAdmin( callingPlayer, true, message, affected_plys )
end

local PCWhitelistAdd = ulx.command( CATEGORY_NAME, "ulx allowpropcore", addToWhitelist, "!allowpropcore" )
PCWhitelistAdd:addParam{ type = ULib.cmds.PlayersArg }
PCWhitelistAdd:addParam{ type = ULib.cmds.BoolArg, invisible = true }
PCWhitelistAdd:defaultAccess( ULib.ACCESS_ADMIN )
PCWhitelistAdd:help( "Adds/Removes specified target(s) to a propcore whitelist" )
PCWhitelistAdd:setOpposite( "ulx denypropcore", {_, _, true}, "!denypropcore" )