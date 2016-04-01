
test_is_valid = false

function test()
    --new_icon_test()
    --test_shader_glare()
    --test_guide_dialogue()
    --test_update_complete()
    --test_new_pager()
    --test_effect()
    --my_test()
    --test_geometry_extend()
end

function extend_test()
--[[
--]]
    local cc_size = CCSize
    CCSize = function(...)
        local ret = cc_size(...)
        local tbl = setmetatable({}, {
            onValueChange = function(...) end,
            __index = function(t,k)
                if k == 'width' then
                    return ret.width
                elseif k == 'height' then
                    return ret.height
                else
                    return t.__value[k]
                end
            end,
            __newindex = function(t,k,v)
                if k == 'width' then
                    ret.width = v
                elseif k == 'height' then
                    ret.height = v
                else
                    t.__value[k] = v
                end
                t.onValueChange(k,v)
            end,
            })
        return ret
    end

    local cc_rect = CCRect
    CCRect = function(...)
        local ret    = cc_rect(...)
        local size   = ret.size
        local origin = ret.origin
        local tbl = setmetatable({}, {
            __index = function(t,k)
                if k == 'size' then
                    local s = CCSize(size.width,size.height)
                    s.onValueChange = function(k,v)
                        if k == 'width' then
                            size.width = v
                        elseif k == 'height' then
                            size.height = v
                        end
                    end
                    return s
                elseif k == 'origin' then
                    local p = CCPoint(origin.x,origin.y)
                    return p
                end
            end,
            __newindex = function(t,k,v)
                assert(false, string.format('cannot add new prop into CCRect: %s=%s',tostring(k), tostring(v)))
            end,
            })

        tolua.setpeer( ret, tbl )
        return ret
    end
end

function my_test()
    extend_test()
    --local layer_color = CCLayerColor:create( ccc4( 50, 48, 45, 255 ), 50,50 )
    --local box = getBoundingBox(layer_color)
    local box = CCRect(0,0,1,1)
    local size = box.size
    --local size = CCSize(1,1)

    size.height = 12
    pdump("=======================size.height = 12", {sh=size.height,bh=box.size.height})

    box.size.height = 13
    pdump("=======================box.size.height = 13", {sh=size.height,bh=box.size.height})

    schedule_circle(1, function()
        pdump("=============================", {w=size.width, h=size.height})
    end)
end

function test_effect()
    require 'utils.tweenExtend'
    local effectHandler = nil
    local tweenHandler = tweenExtend:tweenFromTo( LINEAR_IN, 0, 0.5, 0.5, 0,0,5, function()
        pdump('test_effect',effectHandler)
        if effectHandler then
            --stop_effect(effectHandler)
        end
        effectHandler = play_effect('music/playerlvup.mp3', false)
    end, function( value )
    end)
end

function new_icon_test()
    local winSize = CCDirector:sharedDirector():getWinSize()
    local layer_color = CCLayerColor:create( ccc4( 50, 48, 45, 255 ), winSize.width, winSize.height )
    g_device_obj.root_scene_node:addChild( layer_color )

    local c_x, c_y = g_device_obj:getCenterPos()

    require 'win.new_icon'

    -- hero icon
    local hero_icon_obj = createHeroIcon( {
        rarity = 4,
        attr = 3,
        step = 3,
        level = 33,
        breaklevel = 5,
        class = 1,
        box_type = 'HERO',
        icon = 'head/204082.png',
    })
    g_device_obj.root_scene_node:addChild( hero_icon_obj.frame )
    hero_icon_obj:setPosition( c_x - 100, c_y + 200 )

    -- hero patch icon
    local hero_patch_icon_obj = createHeroIcon( {
        rarity = 2,
        attr = 4,
        class = 2,
        box_type = 'HERO_PATCH',
        icon = 'head/204082.png',
    })
    g_device_obj.root_scene_node:addChild( hero_patch_icon_obj.frame )
    hero_patch_icon_obj:setPosition( c_x + 100, c_y + 200 )

    -- equ icon
    local equ_icon_obj = createHeroIcon( {
        rarity = 4,
        box_type = 'EQU',
        step = 5,
        icon = 'icon/760004.png',
    })
    g_device_obj.root_scene_node:addChild( equ_icon_obj.frame )
    equ_icon_obj:setPosition( c_x - 100, c_y )

    -- equ patch icon
    local equ_patch_icon_obj = createHeroIcon( {
        box_type = 'EQU_PATCH',
        icon = 'icon/760004.png',
    })
    g_device_obj.root_scene_node:addChild( equ_patch_icon_obj.frame )
    equ_patch_icon_obj:setPosition( c_x + 100, c_y )

    -- item icon
    local item_icon_obj = createHeroIcon( {
        box_type = 'ITEM',
        icon = '5icon_0007.png',
        icon_scale = 2,
        level = 1000,
        rarity = 3,
    })
    g_device_obj.root_scene_node:addChild( item_icon_obj.frame )
    item_icon_obj:setPosition( c_x - 100, c_y - 200 )

    -- head icon
    local head_icon_obj = createHeroIcon( {
        box_type = 'HEAD',
        icon = 'head/204033.png',
    })
    g_device_obj.root_scene_node:addChild( head_icon_obj.frame )
    head_icon_obj:setPosition( c_x + 100, c_y - 200 )

    -- mall icon
    local mall_icon_obj = createMallIcon( {
        box_type = 'MALL_ITEM',
        icon = 'head/204033.png',
        rarity = 3,
    })
    g_device_obj.root_scene_node:addChild( mall_icon_obj.frame )
    mall_icon_obj:setPosition( c_x + 100, c_y - 400 )
end

function test_shader_glare()
    --self.mc = createMovieClipWithName('NUI/ngame_parts/parts1_190')

    --local tex_full_path = get_external_path() .. '10019.png.lh'
    --local frame = MCLoader:sharedMCLoader():loadSpriteFrame( tex_full_path )
    --local sprite = CCSprite:create()
    --sprite:setDisplayFrame(frame)
    local sprite = MCLoader:sharedMCLoader():loadSprite( '10019.png.lh' )
    --sprite:setCustomUniforms( 0, 129 / 255, 166 / 255, 0 )
    sprite:setPosition( g_device_obj:getCenterPos() )
    g_device_obj.root_scene_node:addChild( sprite )

    --local shader_program = CCShaderCache:sharedShaderCache():programForKey( 'position_texture_color_glare' )
    --sprite:setShaderProgram( shader_program )
end

function test_guide_dialogue()
    require 'win.Guide.guideWin'
    require 'win.Guide.guide_process_control'
    require 'config.guide_config'

    guide_manager:playGuideDialogue( dialogue_info_adventure_1_1, false, function()
        CCLuaLog( '天高地迥，觉宇宙之无穷；兴尽悲来，识盈虚之有数。' )
    end)
end

function test_update_complete()
    local function createBackground( height )
        local tex = MCLoader:sharedMCLoader():loadTexture( 'mc/5NgameUI.png' )
        local batch_node = CCSpriteBatchNode:createWithTexture( tex )

        local top_sprite = MCLoader:sharedMCLoader():loadSprite( '5ui_010_7.png' )
        top_sprite:setFlipY( true )
        batch_node:addChild( top_sprite )

        local title_size = top_sprite:getContentSize()
        top_sprite:setPosition( 0, ( height - title_size.height ) * 0.5 )

        local center_height = height - title_size.height
        local offset_y = height * 0.5 - title_size.height

        local __create_center_sprite__ = nil
        __create_center_sprite__ = function( c_height )
            if c_height <= 0 then return end

            local center_sprite = MCLoader:sharedMCLoader():loadSprite( '5ui_010_8.png' )
            local center_size = center_sprite:getContentSize()
            center_sprite:setPosition( 0, offset_y - center_size.height * 0.5 )
            batch_node:addChild( center_sprite )

            offset_y = offset_y - center_size.height
            __create_center_sprite__( c_height - center_size.height )
        end
        __create_center_sprite__( center_height )

        local bottom_sprite = MCLoader:sharedMCLoader():loadSprite( '5ui_010_7.png' )
        local bottom_size = bottom_sprite:getContentSize()
        bottom_sprite:setPosition( 0, offset_y - bottom_size.height * 0.5 )
        batch_node:addChild( bottom_sprite )

        local node = CCNode:create()
        node:addChild( batch_node )

        local winSize = CCDirector:sharedDirector():getWinSize();
        local layer_color = CCLayerColor:create( ccc4( 0, 0, 0, 255 * 0.8 ), winSize.width, winSize.height )
        layer_color:setPosition( -winSize.width * 0.5, -winSize.height * 0.5 )
        node:addChild( layer_color, -1 )

        return node
    end

    -- 给个提示更新完成，但不需要按钮关闭
    local winSize = CCDirector:sharedDirector():getWinSize()

    local text_width = 400
    local text_height = 200

    require 'utils.CCNodeExtend'
    local box = CCRect( -text_width / 2, -text_height / 2, text_width, text_height )
    local frame = CCNodeExtend.extend( MCFrame:createWithBox( box ) )
    frame:setPosition( winSize.width / 2, winSize.height / 2 )
    all_scene_layers[layer_type_mask]:addChild( frame )

    frame:addChild( createBackground( text_height ) , -1 )

    local text_label = TLLabelRichTex:create( '', 24, CCSize( text_width - 40, text_height - 40 ), CCImage.kAlignCenter )
    text_label:setPositionY( -10 )
    text_label:setRichString( _YYTEXT( '正在重新加载资源，请稍后...' ), TL_RICH_STRING_FLAG_ONE_LINE )
    frame:addChild( text_label )
end

local head_sel_mask_name = 'icon/5icon_666_6.png'
local head_lock_mask_name = '5word_666_8.png'
local function getHeadBoxInfos()
    local ret_head_box_infos = {}
    for id,item_info in pairs( C_ITEMS ) do
        if item_info.type == PROP_TYPE.HERO_ICON_BOX then
            table.insert( ret_head_box_infos, {
                id = id,
                box_type = 'HEAD',
                box_icon = string.format( 'icon/%d.png', item_info.iconid ),
                desc = item_info.desc,
                name = item_info.name,
                unlock = false,
            })
        end
    end

    local function __get_head_box_info__( id )
        for _,head_box_info in ipairs( ret_head_box_infos ) do
            if head_box_info.id == id then return head_box_info end
        end
    end

    local head_items = getItemsFromPkgByType( PROP_TYPE.HERO_ICON_BOX )
    for id,_ in pairs( head_items or {} ) do
        local head_box_info = __get_head_box_info__( id )
        if head_box_info then head_box_info.unlock = true end
    end

    return ret_head_box_infos
end

function test_new_pager()
    require 'utils.entity'
    require 'ui.gallery_pager'
    require 'win.home_page'
    local obj_4 = home_page.createCommonWindow( '5_NUI/5game_parts/parts10_8_6', all_scene_layers[layer_type_fight_ui], nil, '5word_0002_19.png' )
    local win_4, mc_4, close_func_4 = obj_4.win, obj_4.mc, function() obj_4:close() end

    -- 更新头像框的数据
    local head_box_infos = getHeadBoxInfos()

    -- 
    local head_name_label = label( win_4, 'biaoti', 35, CCImage.kAlignCenter )
    local head_desc_label = label( win_4, 'neirong2', 20, CCImage.kAlignCenter )

    local head_icon_objs = {}
    local cur_sel_index = 1
    local head_container = nil
    head_container = gallery_pager( win_4, 'neirong1', TL_SCROLL_TYPE_LEFT_RIGHT, 0.4, function()
        cur_sel_index = head_container.currentpage + 1
        for index,icon_obj in ipairs( head_icon_objs ) do
            if index == cur_sel_index then
                icon_obj:setScale( 1.5 )
                icon_obj:setMask( head_sel_mask_name, false, -1 )
                head_name_label:set_rich_string( icon_obj.hero_info.name )
                head_desc_label:set_rich_string( icon_obj.hero_info.unlock and '已解锁' or icon_obj.hero_info.desc )
            else
                icon_obj:setMask( head_sel_mask_name, true, -1 )
                icon_obj:setScale( 1 )
            end

            local x = math.abs( math.abs( icon_obj.frame:getPositionX() ) + head_container:getPosition() )
            if x > head_container.scroll_unit then x = head_container.scroll_unit end
            local temp = ( x / head_container.scroll_unit ) * math.pi * 0.25
            local y = math.cos( temp )
            icon_obj:setScale( y * 1.5 )
        end
    end)

    for index,head_box_info in ipairs( head_box_infos ) do
        local icon_obj = __head_icon.new( nil, nil, head_box_info, function( argv ) end, function( argv ) end, false, nil )
        icon_obj:setHeroInfo( head_box_info )

        head_container:append( icon_obj.frame, false )
        table.insert( head_icon_objs, icon_obj )
    end

    head_container:layout()
    head_container:jumppage( 0 )
end

function test_string()
    CCLuaLog( '111111111111111111111111111111111' )
    local text = '觉'
    local length = string.len( text )
    for i=1,length do
        CCLuaLog( string.byte( text, i ) )
    end
    CCLuaLog( '111111111111111111111111111111111' )
end

function test_geometry_extend()
    -- 需要先把 launch/main.lua 里面的 require 'utils.CCGeometryExtend' 先删掉
    local rr = CCRect( 0, 0, 0, 0 )
    local ss = rr.size
    local oo = rr.origin

    require 'utils.CCGeometryExtend'
    local rect = CCRect( 0, 0, 0, 0 )
    local size = rect.size
    local origin = rect.origin

    schedule_circle( 0.1, function()
        CCLuaLog( string.format( 'oo.x : %f, oo.y : %f, ss.width : %f, ss.height : %f', oo.x, oo.y, ss.width, ss.height ) )
        CCLuaLog( string.format( 'origin.x : %f, origin.y : %f, size.width : %f, size.height : %f', origin.x, origin.y, size.width, size.height ) )
        size.width = size.width + 1
        size.height = size.height + 1
        origin.x = origin.x + 1
        origin.y = origin.y + 1
    end)
end

