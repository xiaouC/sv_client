-- ./win/mainUI.lua
require 'ui.controls'

local winSize = CCDirector:sharedDirector():getWinSize()

local ui_scale = 3

local ctrl_buttons = {
    move_btn = {
        file_name = 'images/mvCtrl.png',
        win_name = 'mv_ctrl_win',
        get_position = function()
            return 40 * ui_scale - winSize.width * 0.5 + 10, 40 * ui_scale - winSize.height * 0.5 + 10
        end,
        width = 80 * ui_scale,
        height = 80 * ui_scale,
        click_func = function() end,
    },
    switch_btn = {
        file_name = 'images/switch.png',
        win_name = 'switch_skill_win',
        get_position = function()
            return winSize.width * 0.5 - 40 * ui_scale, 40 * ui_scale - winSize.height * 0.5
        end,
        width = 80 * ui_scale,
        height = 80 * ui_scale,
        click_func = function() end,
    },
}

local cur_skill_ctroll_index = 1
local skill_buttons = {
    {   -- button 1
        win_name = 'skill_win_1',
        x = winSize.width * 0.5 - 150 - 160,
        y = 20 * ui_scale - winSize.height * 0.5 + 15,
        width = 40 * ui_scale,
        height = 40 * ui_scale,
        skills = {
            {
                file_name = 'images/btn.png',
                skill_func = function()     -- kaiken
                    local action = 1
                    g_player_obj:doAction( action )
                end,
            },
            {
                file_name = 'images/btn.png',
                skill_func = function()
                    local action = 1
                    g_player_obj:doAction( action )
                end,
            },
        },
    },
    {   -- button 2
        win_name = 'skill_win_2',
        x = winSize.width * 0.5 - 120 - 170,
        y = 20 * ui_scale - winSize.height * 0.5 + 65 + 90,
        width = 40 * ui_scale,
        height = 40 * ui_scale,
        skills = {
            {
                file_name = 'images/btn.png',
                skill_func = function()
                    local action = 2
                    g_player_obj:doAction( action )
                end,
            },
            {
                file_name = 'images/btn.png',
                skill_func = function()
                    local action = 2
                    g_player_obj:doAction( action )
                end,
            },
        },
    },
    {   -- button 3
        win_name = 'skill_win_3',
        x = winSize.width * 0.5 - 70 - 120,
        y = 20 * ui_scale - winSize.height * 0.5 + 125 + 120,
        width = 40 * ui_scale,
        height = 40 * ui_scale,
        skills = {
            {
                file_name = 'images/btn.png',
                skill_func = function() end,
            },
            {
                file_name = 'images/btn.png',
                skill_func = function() end,
            },
        },
    },
    {   -- button 4
        win_name = 'skill_win_4',
        x = winSize.width * 0.5 - 30 - 40,
        y = 20 * ui_scale - winSize.height * 0.5 + 185 + 100,
        width = 40 * ui_scale,
        height = 40 * ui_scale,
        skills = {
            {
                file_name = 'images/btn.png',
                skill_func = function() end,
            },
            {
                file_name = 'images/btn.png',
                skill_func = function() end,
            },
        },
    },
}

local main_ui_obj = nil
function openMainWindow()
    if not main_ui_obj or not toTLWindow( main_ui_obj.win ) then
    end
    createMainWindow()
end

function closeMainWindow()
end

function createMainWindow()
    local ret_main_obj = {}

    -- move
    local worldPoint = nil
    local worldRect = nil

    local mv_btn_info = ctrl_buttons.move_btn
    local mv_win_obj = createCtrlButton( mv_btn_info, function()
        local last_pt = TLWindowManager:SharedTLWindowManager():getLastPoint()

        local temp_x, temp_y = last_pt.x - worldPoint.x, last_pt.y - worldPoint.y

        local dt = 0.01

        -- 往右移动
        if temp_x >= 0 and math.abs( temp_y ) <= temp_x then return g_player_obj:move( 'right', dt ) end

        -- 往左移动
        if temp_x <= 0 and math.abs( temp_y ) <= math.abs( temp_x ) then return g_player_obj:move( 'left', dt ) end

        -- 往上移动
        if temp_y >= 0 and temp_y >= math.abs( temp_x ) then return g_player_obj:move( 'up', dt ) end

        -- 往下移动
        return g_player_obj:move( 'down', dt )
    end)

    worldPoint = mv_win_obj.node:convertToWorldSpace( CCPoint( 0, 0 ) )
    worldRect = CCRect( worldPoint.x - mv_btn_info.width * 0.5, worldPoint.y - mv_btn_info.height * 0.5, mv_btn_info.width, mv_btn_info.height )
    TLWindowManager:SharedTLWindowManager():setUpdateHandler( function( x, y, world_time, dt )
        if mv_win_obj.down_point and worldRect:containsPoint( CCPoint( x, y ) ) then
            local temp_x, temp_y = x - worldPoint.x, y - worldPoint.y

            -- 往右移动
            if temp_x >= 0 and math.abs( temp_y ) <= temp_x then return g_player_obj:move( 'right', dt ) end

            -- 往左移动
            if temp_x <= 0 and math.abs( temp_y ) <= math.abs( temp_x ) then return g_player_obj:move( 'left', dt ) end

            -- 往上移动
            if temp_y >= 0 and temp_y >= math.abs( temp_x ) then return g_player_obj:move( 'up', dt ) end

            -- 往下移动
            return g_player_obj:move( 'down', dt )
        end

        --return g_player_obj:moveEnd()
    end)

    -- skill
    local sb_objs = {}
    for _,v in ipairs( skill_buttons ) do
        local sb_obj = createSkillButton( v )
        sb_obj:update()

        table.insert( sb_objs, sb_obj )
    end

    -- switch
    local switch_win, switch_frame = createCtrlButton( ctrl_buttons.switch_btn, function()
        cur_skill_ctroll_index = cur_skill_ctroll_index + 1
        if cur_skill_ctroll_index > #skill_buttons then cur_skill_ctroll_index = 1 end

        for _, sb_obj in ipairs( sb_objs ) do sb_obj:update() end
    end)

    return ret_main_obj
end

function createCtrlButton( cb_info, onclick )
    local frame = MCFrame:createWithBox( CCRect( -cb_info.width * 0.5, -cb_info.height * 0.5, cb_info.width, cb_info.height ) )
    frame:setPosition( cb_info.get_position() )
    local sprite = MCLoader:sharedMCLoader():loadSprite( cb_info.file_name )
    sprite:setScale( ui_scale )
    frame:addChild( sprite )

    local win = TLWindow:createWindow( frame )
    win:SetWindowName( cb_info.win_name )
    TLWindowManager:SharedTLWindowManager():AddModuleWindow( win )

    return init_simple_button( win, onclick )
end

function createSkillButton( sb_info )
    local frame = MCFrame:createWithBox( CCRect( -sb_info.width * 0.5, -sb_info.height * 0.5, sb_info.width, sb_info.height ) )
    frame:setPosition( sb_info.x, sb_info.y )

    local win = TLWindow:createWindow( frame )
    win:SetWindowName( sb_info.win_name )
    TLWindowManager:SharedTLWindowManager():AddModuleWindow( win )

    local ret_obj = {
        frame = frame;
        win = win,
        sb_info = sb_info,
        click_func = nil,
    }

    init_simple_button( win, function() if ret_obj.click_func then ret_obj.click_func() end end )

    function ret_obj:update()
        local skill_info = self.sb_info.skills[cur_skill_ctroll_index]
        if skill_info then
            frame:removeAllChildrenWithCleanup( true )

            self.click_func = skill_info.skill_func

            local sprite = MCLoader:sharedMCLoader():loadSprite( skill_info.file_name )
            sprite:setScale( ui_scale )
            frame:addChild( sprite )
        end
    end

    return ret_obj
end
