-- ./win/loginUI.lua
require 'ui.controls'

function openLoginWindow()
    local win, mc = topwindow( 'UI/login/login' )

    local background_sprite = MCLoader:sharedMCLoader():loadSpriteAsync( 'login_background.jpg' )
    mc:getChildByName( 'background' ):addChild( background_sprite )

    local logo_sprite = MCLoader:sharedMCLoader():loadSpriteAsync( 'login_background.jpg' )
    mc:getChildByName( 'logo' ):addChild( logo_sprite )

    local new_mc = createMovieClipWithName( 'UI/button/button_1' )
    init_label( new_mc:getChildByName( 'text' ), 24, CCImage.kAlignCenter ):set_rich_string( 'NEW' )
    mc:getChildByName( 'new_archive' ):addChild( new_mc )
    anim_button( win, 'new_archive', function()
        require 'gamecommon.create_player'
        g_player_obj = createPlayer( 'Flying-over-the-sky' )
        g_player_obj:enterScene( g_player_obj.save_datas.scene_name, g_player_obj.save_datas.position.x, g_player_obj.save_datas.position.y )

        require 'win.mainUI'
        openMainWindow()
    end, new_mc )

    local load_mc = createMovieClipWithName( 'UI/button/button_1' )
    init_label( load_mc:getChildByName( 'text' ), 24, CCImage.kAlignCenter ):set_rich_string( 'LOAD' )
    mc:getChildByName( 'load_archive' ):addChild( load_mc )
    anim_button( win, 'load_archive', function()
        g_player_obj = (require 'gamecommon.user_object' ).new( 'Flying-over-the-sky' )
        g_player_obj:loadArchive()

        require 'win.mainUI'
        openMainWindow()
    end, load_mc )

    local exit_mc = createMovieClipWithName( 'UI/button/button_1' )
    init_label( exit_mc:getChildByName( 'text' ), 24, CCImage.kAlignCenter ):set_rich_string( 'EXIT' )
    mc:getChildByName( 'exit' ):addChild( exit_mc )
    anim_button( win, 'exit', function() quitApplication() end, exit_mc )
end

function closeLoginWindow()
end
