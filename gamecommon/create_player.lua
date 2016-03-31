-- 
require 'config.create_player_config'

function createPlayer( name )
    local ret_player_obj = (require 'gamecommon.user_object' ).new( name )
    for k, v in pairs( YY_CREATE_PLAYER_CONFIG ) do
        ret_player_obj.save_datas[k] = v
    end
    return ret_player_obj
end

