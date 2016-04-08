-- ./gamecommon/model_object.lua
require 'utils.class'

-- actions = { 'standby', 'run', 'attack01', 'attack02', 'hurt', 'die' }
local __model_object = class( 'model_object' )
function __model_object:ctor( user_obj, node, model_id )
    self.user_obj = user_obj
    self.parent_node = node
    self.model_id = model_id
    self.model_mc = nil
    self.action_name = nil
end

function __model_object:playAction( action_name, loop_count, call_back_func )
    if self.action_name == action_name then return end

    if self.model_mc then self.model_mc:removeFromParentAndCleanup( true ) end

    self.action_name = action_name

    local model_name = string.format( '%d/%s', self.model_id, action_name )
    self.model_mc = TLModel:createWithName( model_name )
    if call_back_func then self.model_mc:RegisterPlayEndCallbackHandler( call_back_func ) end
    self.model_mc:setScale( 0.1 )
    self.model_mc:stop()
    self.model_mc:play( 0, -1, loop_count or 0 )
    self.model_mc:setPosition( self.user_obj.cur_x, self.user_obj.cur_y )
    self.parent_node:addChild( self.model_mc, math.floor( -self.user_obj.cur_y ) )
end

return __model_object
