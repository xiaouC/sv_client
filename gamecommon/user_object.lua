-- ./gamecommon/user_object.lua
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

function __user_object:playAction( actions, loop_count, call_back_func )
    self.model_obj:playAction( actions[1], loop_count, call_back_func )
end

function __user_object:checkConsume( consume_item, checkOnly )
    local consume_item_config = {
        ['ATTR'] = function() return self:checkAttr( consume_item, checkOnly ) end,
        ['ITEM'] = function() return self:checkItem( consume_item, checkOnly ) end,
    }

    return consume_item_config[consume_item.type]()
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

function __user_object:getGridInfo( dir )
    local grid_dir = {
        ['current'] = {               -- 当前位置
            ['left'] = function() return self.cur_x, self.cur_y end,
            ['right'] = function() return self.cur_x, self.cur_y end,
            ['up'] = function() return self.cur_x, self.cur_y end,
            ['down'] = function() return self.cur_x, self.cur_y end,
        },
        ['front'] = {
            ['left'] = function() return self.cur_x - self.grid_width, self.cur_y end,
            ['right'] = function() return self.cur_x + self.grid_width, self.cur_y end,
            ['up'] = function() return self.cur_x, self.cur_y + self.grid_height end,
            ['down'] = function() return self.cur_x, self.cur_y - self.grid_height end,
        },
        ['back'] = {
            ['left'] = function() return self.cur_x + self.grid_width, self.cur_y end,
            ['right'] = function() return self.cur_x - self.grid_width, self.cur_y end,
            ['up'] = function() return self.cur_x, self.cur_y - self.grid_height end,
            ['down'] = function() return self.cur_x, self.cur_y + self.grid_height end,
        },
        ['left'] = {
            ['left'] = function() return self.cur_x, self.cur_y - self.grid_height end,
            ['right'] = function() return self.cur_x, self.cur_y + self.grid_height end,
            ['up'] = function() return self.cur_x - self.grid_width, self.cur_y end,
            ['down'] = function() return self.cur_x + self.grid_width, self.cur_y end,
        },
        ['right'] = {
            ['left'] = function() return self.cur_x, self.cur_y + self.grid_height end,
            ['right'] = function() return self.cur_x, self.cur_y - self.grid_height end,
            ['up'] = function() return self.cur_x + self.grid_width, self.cur_y end,
            ['down'] = function() return self.cur_x - self.grid_width, self.cur_y end,
        },
        ['left_front'] = {
            ['left'] = function() return self.cur_x - self.grid_width, self.cur_y - self.grid_height end,
            ['right'] = function() return self.cur_x + self.grid_width, self.cur_y + self.grid_height end,
            ['up'] = function() return self.cur_x - self.grid_width, self.cur_y + self.grid_height end,
            ['down'] = function() return self.cur_x + self.grid_width, self.cur_y - self.grid_height end,
        },
        ['right_front'] = {
            ['left'] = function() return self.cur_x - self.grid_width, self.cur_y + self.grid_height end,
            ['right'] = function() return self.cur_x + self.grid_width, self.cur_y - self.grid_height end,
            ['up'] = function() return self.cur_x + self.grid_width, self.cur_y + self.grid_height end,
            ['down'] = function() return self.cur_x - self.grid_width, self.cur_y - self.grid_height end,
        },
        ['left_back'] = {
            ['left'] = function() return self.cur_x + self.grid_width, self.cur_y - self.grid_height end,
            ['right'] = function() return self.cur_x - self.grid_width, self.cur_y + self.grid_height end,
            ['up'] = function() return self.cur_x - self.grid_width, self.cur_y - self.grid_height end,
            ['down'] = function() return self.cur_x + self.grid_width, self.cur_y + self.grid_height end,
        },
        ['right_back'] = {
            ['left'] = function() return self.cur_x + self.grid_width, self.cur_y + self.grid_height end,
            ['right'] = function() return self.cur_x - self.grid_width, self.cur_y - self.grid_height end,
            ['up'] = function() return self.cur_x + self.grid_width, self.cur_y - self.grid_height end,
            ['down'] = function() return self.cur_x - self.grid_width, self.cur_y + self.grid_height end,
        },
    }

    local x, y = grid_dir[dir][self.cur_dir]()
    return self:getGridInfoByPosition( x, y )
end

--local grid_info = {
--    state = 0,                      -- 当前状态
--    last_change_time = 0,           -- 上一次改变的时间
--    skill_id = 0,                   -- 技能 ID，可以由很多不同的情况触发，比如时间到了、踩上去、或者在一定范围内等等
--    can_pass = true,                -- 能否通行
--    can_plant = false,              -- 能否种植
--    model = 0,                      -- 当前模型
--}
function __user_object:getGridInfoByPosition( x, y )
    local grid_states = self.save_datas.grids[self.scene_name]
    if not grid_states then return nil end

    local grid_key = self:getGridKey( x, y )
    if not grid_states[grid_key] then
        grid_states[grid_key] = {
            state = 0,
            last_change_time = 0,
            skill_id = 0,
            can_pass = true,
            can_plant = true,
            model = 0,
        }
    end

    return grid_states[grid_key]
end

function __user_object:getGridKey( x, y )
    if not self.scene_node then return '' end

    local x_flag = ( x > 0 and '+' or '-' )
    local y_flag = ( y > 0 and '+' or '-' )

    local row = math.floor( ( math.abs( x ) + self.grid_width * 0.5 ) / self.grid_width )
    local col = math.floor( ( math.abs( y ) + self.grid_height * 0.5 ) / self.grid_height )

    return string.format( '%s%d%s%d', x_flag, col, y_flag, row )
end

function __user_object:enterScene( scene_name, x, y )
    if self.scene_name ~= scene_name then
        if self.scene_node then self.scene_node:removeFromParentAndCleanup( true ) end

        self.scene_name = scene_name
        self.scene_node = TLSeamlessMap:create( scene_name, x, y )
        all_scene_layers[layer_type_scene]:addChild( self.scene_node )

        local camera = self.scene_node:getCamera()
        camera:setEyeXYZ( 0, -10, 20 )

        if not self.model_obj then
            self.model_obj = ( require 'gamecommon.model_object' ).new( self.scene_node, self.save_datas.model_id )
            self.model_obj:playAction( 'standby', -1 )
        end

        -- 玩家在该场景的地图格子状态
        if not self.save_datas.grids[scene_name] then self.save_datas.grids[scene_name] = {} end

        self.block_row = self.scene_node:getBlockRow()
        self.block_col = self.scene_node:getBlockCol()
        self.grid_width = self.scene_node:getGridWidth()
        self.grid_height = self.scene_node:getGridHeight()
    end

    self:setTo( x, y )
end

function __user_object:move( dir, dt )
    CCLuaLog( 'dir : ' .. tostring( dir ) )
    local mv_dir = {
        ['left'] = function() return -self.save_datas.mv_speed * dt, 0 end,
        ['right'] = function() return self.save_datas.mv_speed * dt, 0 end,
        ['up'] = function() return 0, self.save_datas.mv_speed * dt end,
        ['down'] = function() return 0, -self.save_datas.mv_speed * dt end,
    }

    self.cur_dir = dir
    self.model_obj:playAction( 'run', -1 )

    local mv_x, mv_y = mv_dir[dir]()
    --if self.scene_node:getIsEnablePass( self.cur_x + mv_x, self.cur_y + mv_y ) then
        self:setTo( self.cur_x + mv_x, self.cur_y + mv_y )
    --end
end

function __user_object:moveEnd()
    self.model_obj:playAction( 'standby', -1 )
end

function __user_object:setTo( x, y )
    self.cur_x = x
    self.cur_y = y

    CCLuaLog( 'x : ' .. tostring( x ) )
    CCLuaLog( 'y : ' .. tostring( y ) )

    self.model_obj.model_mc:setPosition( x, y )
    self.scene_node:setCurXY( x, y )
    self.scene_node:setPosition( -x, -y )
end

function __user_object:doAction( action )
    self.cur_action = action

    require 'gamecommon.skill'
    useSkill( self, nil, self.cur_action )
end

return __user_object
