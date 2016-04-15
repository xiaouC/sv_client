-- ./Editor/common.lua

-- cv_x, cv_y 是 CChildView 里面的 point.x, point.y
function convertPointToSM( cv_x, cv_y )
    if g_sm_node then
        local frame_size = CCEGLView:sharedOpenGLView():getFrameSize()

        local x = ( cv_x - frame_size.width * 0.5 ) / g_main_scale
        local y = ( frame_size.height * 0.5 - cv_y ) / g_main_scale

        local sm_x, sm_y = g_sm_node:getPosition()

        return x - sm_x, y - sm_y
    end
end

function convertPointToEditMB( cv_x, cv_y )
    if g_sm_node and g_edit_mb then
        local w_x, w_y = convertPointToSM( cv_x, cv_y )
        local mb_x, mb_y = g_edit_mb:getPosition()

        return w_x - mb_x, w_y - mb_y
    end
end

function convertPointToMB( cv_x, cv_y )
    local w_x, w_y = convertPointToSM( cv_x, cv_y )
    if w_x then
        local map_block = g_sm_node:getMapBlock( w_x, w_y )
        if map_block then
            local mb_x, mb_y = map_block:getPosition()

            return w_x - mb_x, w_y - mb_y
        end
    end
end

function vector_dot( v1, v2 )
    return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z
end

function vector_cross( v1, v2 )
    return {
        x = v1.y * v2.z - v2.y * v1.z,
        y = v1.z * v2.x - v2.z * v1.x,
        z = v1.x * v2.y - v2.x * v1.y,
    }
end

function vector_distance( v1, v2 )
    return math.sqrt( ( v1.x * v1.x + v1.y * v1.y + v1.z * v1.z ) * ( v2.x * v2.x + v2.y * v2.y + v2.z * v2.z ) )
end
