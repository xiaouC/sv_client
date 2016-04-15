-- ./Editor/main.lua
require 'Editor.common'

function main()
    AssetsManager:sharedAssetsManager():addSearchPath( '' )
    AssetsManager:sharedAssetsManager():addSearchPath( 'images/' )
    AssetsManager:sharedAssetsManager():addSearchPath( 'mc/' )

    MCLoader:sharedMCLoader():loadIndexFile( 'mc/anim.index', 'mc/frames.index' )

    protobuf.register( getFileData( 'config/poem.pb' ) )

    local gl_view = CCEGLView:sharedOpenGLView()
	gl_view:setDesignResolutionSize( 1024, 768, kResolutionShowAll );
	CCDirector:sharedDirector():setDisplayStats( true );

	g_main_node = TLRunningScene:create();
    CCDirector:sharedDirector():runWithScene( g_main_node );

    g_main_scale = 1

	g_main_scale_node = CCNode:create();
	g_main_scale_node:setScale( g_main_scale );
	g_main_node:addChild( g_main_scale_node );

    -- 
    register_platform_callback( 'CHILD_VIEW_ON_SIZE', function( args )
        local cv_size = args.split( '|', tonumber )

        gl_view:setFrameSize( cv_size[1], cv_size[2] );
        gl_view:setDesignResolutionSize( cv_size[1], cv_size[2], kResolutionShowAll );

        g_main_node:setPosition( cv_size[1] * 0.5, cv_size[2] * 0.5 );
    end)

    register_platform_callback( 'NEW_SEAMLESS_MAP', function( args )
        local new_args = args.split( '|' )

        local file_name = new_args[1]
        local block_name = new_args[2]
        local block_row = tonumber( new_args[3] )
        local block_col = tonumber( new_args[4] )
        local grid_width = tonumber( new_args[5] )
        local grid_height = tonumber( new_args[6] )
        local material = new_args[7]

        local new_sm_node = TLSeamlessMap:newSeamlessMap( file_name, block_name, block_row, block_col, grid_width, grid_height, material );
        if new_sm_node then
            if g_sm_node then g_sm_node:removeFromParentAndCleanup( true ) end

            g_main_scale_node:addChild( new_sm_node );
            g_sm_node = new_sm_node;
        end
    end)

    register_platform_callback( 'OPEN_SEAMLESS_MAP', function( args )
        local new_sm_node = TLSeamlessMap:create( args, 0.0, 0.0 );
        if new_sm_node then
            if g_sm_node then g_sm_node:removeFromParentAndCleanup( true ) end

            g_main_scale_node:addChild( new_sm_node );
            g_sm_node = new_sm_node;
        end
    end)

    register_platform_callback( 'SAVE_SEAMLESS_MAP', function( args )
        if g_sm_node then g_sm_node:save() end
    end)

    register_platform_callback( 'NEW_MAP_BLOCK', function( args )
        local new_args = args.split( '|' )

        local block_name = new_args[1]
        local block_x = tonumber( new_args[2] )
        local block_y = tonumber( new_args[3] )
        local material = new_args[4]
		g_sm_node:addBlock( block_name, block_x, block_y, material );
    end)

    register_platform_callback( 'MAIN_NODE_SCALE', function( args )
        g_main_scale = g_main_scale * tonumber( args )
        g_main_scale_node:setScale( g_main_scale );
    end)

    register_platform_callback( 'EDIT_NODE_SCALE', function( args )
        if g_edit_mb and g_edit_node then
            g_edit_mb:scaleObject( g_edit_node, tonumber( args ) )
        end
    end)

    local down_flag = false                 -- 鼠标左键按下
    local last_pos_x = nil
    local last_pos_y = nil
    local sm_move_flag = false              -- 平移大地图
    local rotation_flag = false             -- 旋转
    g_edit_node = nil
    local last_edit_node_x = nil
    local last_edit_node_y = nil
    local last_edit_node_rotation = nil
    local down_x, down_y = nil, nil
    register_platform_callback( 'CHILD_VIEW_LBUTTON_DOWN', function( args )
        local down_args = args.split( '|' )

        last_pos_x = down_args[1]
        last_pos_y = down_args[2]
        local ctrl_flag = ( down_args[3] == 'true' )
        local shift_flag = ( down_args[4] == 'true' )

        down_flag = true

        if ctrl_flag then                       -- 旋转
            if g_edit_mb and g_edit_node then
                down_x, down_y = convertPointToEditMB( last_pos_x, last_pos_y )
                if down_x then
                    rotation_flag = true

                    last_edit_node_x, last_edit_node_y = g_edit_node:getPosition()
                    last_edit_node_rotation = g_edit_node:getRotation()
                end
            end
        elseif shift_flag then                  -- 平移大地图
            sm_move_flag = true
        else                                    -- 选择
            local w_x, w_y = convertPointToSM( last_pos_x, last_pos_y )
            if w_x then
                g_edit_mb = g_sm_node:getMapBlock( w_x, w_y )
                if g_edit_mb then
                    local m_x, m_y = convertPointToMB( last_pos_x, last_pos_y )
                    g_edit_node = g_edit_mb:hitSprite( m_x, m_y )
                end
            end
        end
    end)
    register_platform_callback( 'CHILD_VIEW_LBUTTON_UP', function( args )
        local down_args = args.split( '|' )

        last_pos_x = down_args[1]
        last_pos_y = down_args[2]
        local ctrl_flag = ( down_args[3] == 'true' )
        local shift_flag = ( down_args[4] == 'true' )

        down_flag = false
        sm_move_flag = false

        if rotation_flag then
            if g_edit_mb and g_edit_node then
                g_edit_mb:rotateObject( g_edit_node, g_edit_node:getRotation() )
            end

            rotation_flag = false;
        end
    end)

    register_platform_callback( 'CHILD_VIEW_MOUSE_MOVE', function( args )
        local down_args = args.split( '|' )

        local pos_x = down_args[1]
        local pos_y = down_args[2]
        local ctrl_flag = ( down_args[3] == 'true' )
        local shift_flag = ( down_args[4] == 'true' )

        -- 
        local offset_x = ( pos_x - last_pos_x ) / g_main_scale
        local offset_y = ( pos_y - last_pos_y ) / g_main_scale

        last_pos_x = pos_x
        last_pos_y = pos_y

        -- 
        if rotation_flag then
            if ctrl_flag then
                local m_x, m_y = convertPointToEditMB( last_pos_x, last_pos_y )
                if m_x then
                    local v1 = { x = down_x - last_edit_node_x, y = down_y - last_edit_node_y, z = 0 }
                    local v2 = { x = m_x - last_edit_node_x, y = m_y - last_edit_node_y, z = 0 }

                    local dot_value = vector_dot( v1, v2 )
                    local v_cross = vector_cross( v1, v2 )
                    local dis = vector_distance( v1, v2 )

                    local angle = math.acos( dot_value / dis ) * 180.0 / M_PI;

                    if v_cross.z > 0 then
                        g_edit_node:setRotation( last_edit_node_rotation - angle )
                    else
                        g_edit_node:setRotation( last_edit_node_rotation + angle )
                    end
                end
            end
        elseif sm_move_flag then
            if shift_flag and g_sm_node then
                local x = g_sm_node:getPositionX() + offset_x
                local y = g_sm_node:getPositionY() - offset_y
                g_sm_node:setPosition( x, y )
            end
        else
            if down_flag and g_edit_mb and g_edit_node then
                g_edit_mb:moveObject( g_edit_node, offet_x, -offset_y )
            end
        end
    end)

    register_platform_callback( 'CHILD_VIEW_UP', function( args )
        if g_edit_mb and g_edit_node then
            g_edit_mb:moveObject( g_edit_node, 0, 1 )
        end
    end)

    register_platform_callback( 'CHILD_VIEW_DOWN', function( args )
        if g_edit_mb and g_edit_node then
            g_edit_mb:moveObject( g_edit_node, 0, -1 )
        end
    end)

    register_platform_callback( 'CHILD_VIEW_LEFT', function( args )
        if g_edit_mb and g_edit_node then
            g_edit_mb:moveObject( g_edit_node, -1, 0 )
        end
    end)

    register_platform_callback( 'CHILD_VIEW_RIGHT', function( args )
        if g_edit_mb and g_edit_node then
            g_edit_mb:moveObject( g_edit_node, 1, 0 )
        end
    end)

    register_platform_callback( 'CHILD_VIEW_DELETE', function( args )
        if g_edit_mb and g_edit_node then
            g_edit_mb:removeObject( g_edit_node )
        end
    end)

    register_platform_callback( 'ADD_SPRITE_DROP', function( args )
        local down_args = args.split( '|' )

        local x = down_args[1]
        local y = down_args[2]
        local file = down_args[3]

        local w_x, w_y = convertPointToSM( x, y )
        if w_x then
            local map_block = g_sm_node:getMapBlock( w_x, w_y )
            if map_block then
                local mb_x, mb_y = map_block:getPosition()
                local m_x, m_y = w_x - mb_x, w_y - mb_y

                local sprite = map_block:addSprite( file, m_x, m_y );
                if sprite then
                    g_edit_mb = map_block;
                    g_edit_node = sprite;
                end
            end
        end
    end)

    register_platform_callback( 'LOAD_OBSTACLE', function( args )
    end)

    register_platform_callback( 'SAVE_OBSTACLE', function( args )
    end)
end

function __G__TRACKBACK__( msg )
    local tb_text = '----------------------------------------\n'
    tb_text = tb_text .. 'LUA ERROR: ' .. tostring(msg) .. '\n'
    tb_text = tb_text .. debug.traceback() .. '\n'
    tb_text = tb_text .. '----------------------------------------\n'

    CCLuaLog( tb_text )
end

xpcall( main,  __G__TRACKBACK__ )
