-- ./gamecommon/grid_object.lua
require 'utils.class'

local __grid_object = class( 'grid_object' )
function __grid_object:ctor( grid_info, x, y )
    self.grid_info = grid_info
    self.grid_key = grid_key
    self.x = x
    self.y = y

    -- 
    self:recreate()
end

function __grid_object:recreate()
    if self.grid_model then self.grid_model:removeFromParentAndCleanup( true ) end

    -- 
    self.grid_model = self:createModel()

    local x, y = self.x + ( self.grid_info.offset_x or 0 ), self.y + ( self.grid_info.offset_y or 0 )
    self.grid_model:setPosition( x, y )

    local z_order = self.grid_info.z_order or math.floor( -self.y )
    g_player_obj.scene_node:addChild( self.grid_model, z_order )
end

function __grid_object:createModel()
    local ret_model_node = nil

    local file_extension_name = get_extension( self.grid_info.model )
    if file_extension_name == 'png' then
        ret_model_node = MCLoader:sharedMCLoader():loadSprite( self.grid_info.model )
    else
        ret_model_node = createMovieClipWithName( self.grid_info.model )
        ret_model_node:play( 0, -1, -1 )
    end

    if self.grid_info.scale then ret_model_node:setScale( self.grid_info.scale ) end

    return ret_model_node
end

function __grid_object:update()
    local sa_info = skill_ability[self.grid_info.ability]
    if sa_info then sa_info.update_func( g_player_obj, self ) end
end

function __grid_object:clear()
end

return __grid_object
