require 'utils.class'

local __user_object = class( 'user_object' )
function __user_object:ctor( name )
    self.save_datas = { name = name }
end

function __user_object:loadArchive()
    require 'utils.table'
    self.save_datas = table.load( self.save_datas.name )
end

function __user_object:saveArchive()
    require 'utils.table'
    table.save( self.save_datas, self.save_datas.name )
end

function __user_object:addEffect( effect_name )
end

function __user_object:playAction( action, call_back_func )
    if call_back_func then call_back_func() end
end

function __user_object:checkConsume( consume_item, checkOnly )
    local consume_item_config = {
        ['ATTR'] = function() self:checkAttr( consume_item, checkOnly ) end,
        ['ITEM'] = function() self:checkItem( consume_item, checkOnly ) end,
    }

    consume_item_config[consume_item.type]()
end

function __user_object:checkAttr( item, checkOnly )
    local attr = item.arg
    local value = item.count

    if not self.save_datas[attr] or self.save_datas[attr] < value then
        return false
    end

    -- 
    if not checkOnly then self.save_datas[attr] = self.save_datas[attr] - value end

    return true
end

function __user_object:checkItem( item, checkOnly )
    local item_id = tonumber( item.arg )
    local count = item.count

    if not self.save_datas.items then self.save_datas.items = {} end

    -- 没有这个物品
    if not self.save_datas.items[item_id] then return false end

    -- 物品数量不足
    if self.save_datas.items[item_id] < count then return false end

    if not checkOnly then self.save_datas.items[item_id] = self.save_datas.items[item_id] - count end

    return true
end

function __user_object:getGridInfo()
    local grid_info = {
        state = 1,
    }

    return { grid_info }
end

function __user_object:getFrontGridInfo()
    local grid_info = {
        state = 1,
    }

    return { grid_info }
end

function __user_object:enterScene( scene_name, x, y )
    if self.scene_name ~= scene_name then
        if self.scene_node then self.scene_node:removeFromParentAndCleanup( true ) end

        self.scene_name = scene_name
        self.scene_node = TLSeamlessMap:create( scene_name, x, y )
        all_scene_layers[layer_type_scene]:addChild( self.scene_node )
    else
        self.scene_node:setCurXY( x, y )
    end

    self:setTo( x, y )
end

function __user_object:move( dir )
    local mv_dir = {
        ['left'] = function() return -self.save_datas.mv_speed, 0 end,
        ['right'] = function() return self.save_datas.mv_speed, 0 end,
        ['up'] = function() return 0, self.save_datas.mv_speed end,
        ['down'] = function() return 0, -self.save_datas.mv_speed end,
    }

    local mv_x, mv_y = mv_dir[dir]()
    if self.scene_node:getIsEnablePass( self.cur_x + mv_x, self.cur_y + mv_y ) then
        self:setTo( self.cur_x + mv_x, self.cur_y + mv_y )
    end
end

function __user_object:setTo( x, y )
    self.cur_x = x
    self.cur_y = y

    self.scene_node:setPosition( -x, -y )
end

function __user_object:doAction()
    self.cur_action = skill_id

    useSkill( self, nil, self.cur_action )
end

return __user_object
