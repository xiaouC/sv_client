-- ./gamecommon/scene_manager.lua

scene_manager = {
    cur_scene_name = nil,
    cur_sm_node = nil,
    cur_x = nil,
    cur_y = nil,
}

function scene_manager:enterScene( scene_name, x, y )
    if self.cur_scene_name ~= scene_name then
        if self.cur_sm_node then self.cur_sm_node:removeFromParentAndCleanup( true ) end

        self.cur_sm_node = TLSeamlessMap:create( scene_name, x, y )
        all_scene_layers[layer_type_scene]:addChild( self.cur_sm_node )
    end
end
