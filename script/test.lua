
test_is_valid = false

function test()
    require 'gamecommon.create_player'
    require 'gamecommon.scene_manager'

    g_player_obj = createPlayer( 'Flying-over-the-sky' )
    scene_manager:enterScene( g_player_obj.scene_name, g_player_obj.position.x, g_player_obj.position.y )
end

