-- ./win/loginUI.lua
require 'ui.controls'

local login_window_obj = nil
function openLoginWindow()
    if not login_window_obj or not toTLWindow( login_window_obj.win ) then
        login_window_obj = createLoginWindow()
    end
end

function closeLoginWindow()
    if login_window_obj and toTLWindow( login_window_obj.win ) then
        login_window_obj.mc:removeFromParentAndCleanup( true )
        TLWindowManager:SharedTLWindowManager():RemoveModuleWindow( login_window_obj.win )
    end
end

function createLoginWindow()
    local win, mc = topwindow( 'UI/login/login' )

    local background_sprite = MCLoader:sharedMCLoader():loadSpriteAsync( 'images/login_background.jpg' )
    mc:getChildByName( 'background' ):addChild( background_sprite )

    local logo_sprite = MCLoader:sharedMCLoader():loadSpriteAsync( 'images/logo.png' )
    logo_sprite:setScaleX( 1.2 )
    logo_sprite:setScaleY( 0.6 )
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

        closeLoginWindow()
    end, new_mc )

    local load_mc = createMovieClipWithName( 'UI/button/button_1' )
    init_label( load_mc:getChildByName( 'text' ), 24, CCImage.kAlignCenter ):set_rich_string( 'LOAD' )
    mc:getChildByName( 'load_archive' ):addChild( load_mc )
    anim_button( win, 'load_archive', function()
        g_player_obj = (require 'gamecommon.user_object' ).new( 'Flying-over-the-sky' )
        g_player_obj:loadArchive()

        require 'win.mainUI'
        openMainWindow()

        closeLoginWindow()
    end, load_mc )

    local exit_mc = createMovieClipWithName( 'UI/button/button_1' )
    init_label( exit_mc:getChildByName( 'text' ), 24, CCImage.kAlignCenter ):set_rich_string( 'EXIT' )
    mc:getChildByName( 'exit' ):addChild( exit_mc )
    anim_button( win, 'exit', function() quitApplication() end, exit_mc )

    return {
        win = win,
        mc = mc,
    }
end
