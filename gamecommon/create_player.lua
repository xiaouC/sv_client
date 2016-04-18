-- ./gamecommon/create_player.lua
require 'config.create_player_config'
require 'utils.class'

function createPlayer( name )
    local ret_player_obj = (require 'gamecommon.user_object' ).new( name )
    for k, v in pairs( YY_CREATE_PLAYER_CONFIG ) do
        if k == 'items' then
            require 'config.item_config'
            ret_player_obj.save_datas[k] = { }
            local next_item_id = 1
            for id, count in pairs( v ) do
                local item_info = YY_ITEM_CONFIG[item_id]
                if item_info then
                    for i=1,count do
                        -- 暂时仅仅只有一个唯一 id，以及对应的 config id，以后有新的东西，再说
                        table.insert( ret_player_obj.save_datas[k], {
                            id = next_item_id,
                            config_id = id,
                        })
                        next_item_id = next_item_id + 1
                    end
                end
            end
        else
            ret_player_obj.save_datas[k] = v
        end
    end

    local obstacle_file_name = 'config/obstacle.lua'
    ret_player_obj.save_datas['obstacle'] = table.load( obstacle_file_name )

    ret_player_obj:saveArchive()

    return ret_player_obj
end

