-- ./gamecommon/user_object.lua
require 'config.game_const'
require 'utils.class'

local __user_object = class( 'user_object' )
function __user_object:ctor( name )
    self.save_datas = { name = name }

    self.model_offset_x = 0
    self.model_offset_y = 30

    self.schedule_handle = schedule_circle( 1, function()
        self:updateGridObjectState()
    end)
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
    if not checkOnly and item.rm_flag then self.save_datas[attr] = self.save_datas[attr] - value end

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

    if not checkOnly and item.rm_flag then self.save_datas.items[item_id] = self.save_datas.items[item_id] - count end

    return true
end

function __user_object:getDirPos( dir )
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

    return grid_dir[dir][self.save_datas.cur_dir]()
end

function __user_object:getGridInfo( dir, create_flag )
    local x, y = self:getDirPos( dir )
    return self:getGridInfoByPosition( x, y, create_flag )
end

--local grid_info = {
--    ability = 0
--    last_change_time = 0,           -- 上一次改变的时间
--    skill_id = 0,                   -- 技能 ID，可以由很多不同的情况触发，比如时间到了、踩上去、或者在一定范围内等等
--    can_pass = true,                -- 能否通行
--    can_plant = false,              -- 能否种植
--    can_reap = false,               -- 能否收割
--    model = 0,                      -- 当前模型
--}
function __user_object:getGridInfoByPosition( x, y, create_flag )
    local grid_states = self.save_datas.grids[self.scene_name]
    if not grid_states then return nil end

    local grid_key = self:getGridKey( x, y )
    if not grid_states[grid_key] and create_flag then
        grid_states[grid_key] = {
            ability = 0,
            last_change_time = 0,
            skill_id = 0,
            can_pass = true,
            can_plant = false,
            can_reap = false,
            model = 0,
        }
    end

    return grid_states[grid_key], grid_key
end

function __user_object:getGridKey( x, y )
    if not self.scene_node then return '' end

    local col = math.floor( math.floor( x ) / self.grid_width )
    local k_x = col * self.grid_width + self.grid_width * 0.5

    local row = math.floor( math.floor( y ) / self.grid_height )
    local k_y = row * self.grid_height + self.grid_height * 0.5

    return string.format( '%d|%d', k_x, k_y )
end

function __user_object:getGridPosition( grid_key )
    local position = grid_key:split( '|', tonumber )

    return position[1], position[2]
end

function __user_object:clearGrid( grid_key )
    local grid_states = self.save_datas.grids[self.scene_name]
    if not grid_states then return end

    grid_states[grid_key] = nil

    local grid_obj = player_obj.all_grid_objs[grid_key]
    if grid_obj then grid_obj:clear() end
    player_obj.all_grid_objs[grid_key] = nil
end

function __user_object:enterScene( scene_name, x, y )
    if self.scene_name ~= scene_name then
        if self.scene_node then self.scene_node:removeFromParentAndCleanup( true ) end
        self.all_grid_objs = {}

        self.scene_name = scene_name
        self.scene_node = TLSeamlessMap:create( scene_name, x, y )
        all_scene_layers[layer_type_scene]:addChild( self.scene_node )

        local camera = self.scene_node:getCamera()
        camera:setEyeXYZ( 0, -10, 20 )

        self:setTo( x, y )

        if not self.model_obj then
            self.model_obj = ( require 'gamecommon.model_object' ).new( self, self.scene_node, self.save_datas.model_id )
            self.model_obj:playAction( 'standby', -1 )
        end

        -- 玩家在该场景的地图格子状态
        if not self.save_datas.grids[scene_name] then self.save_datas.grids[scene_name] = {} end

        self.block_row = self.scene_node:getBlockRow()
        self.block_col = self.scene_node:getBlockCol()
        self.grid_width = self.scene_node:getGridWidth()
        self.grid_height = self.scene_node:getGridHeight()

        -- 生成新的
        self:updateGridObjects()
    else
        self:setTo( x, y )
    end
end

function __user_object:move( dir, dt )
    local mv_dir = {
        ['left'] = function() return -self.save_datas.mv_speed * dt, 0 end,
        ['right'] = function() return self.save_datas.mv_speed * dt, 0 end,
        ['up'] = function() return 0, self.save_datas.mv_speed * dt end,
        ['down'] = function() return 0, -self.save_datas.mv_speed * dt end,
    }

    self.save_datas.cur_dir = dir
    self.model_obj:playAction( 'run', -1 )

    local mv_x, mv_y = mv_dir[dir]()
    if self:canMove() then
        self:setTo( self.cur_x + mv_x, self.cur_y + mv_y )
    end
end

function __user_object:canMove()
    -- 当前因为其他动作而不能移动
    if not self.enable_move then return false end

    --if not self.scene_node:getIsEnablePass( self.cur_x + mv_x, self.cur_y + mv_y ) then return false end

    return true
end

function __user_object:moveEnd()
    self.model_obj:playAction( 'standby', -1 )
end

function __user_object:setTo( x, y )
    self.cur_x = x
    self.cur_y = y

    self.save_datas.position.x = x
    self.save_datas.position.y = y

    if self.model_obj then
        self.model_obj.model_mc:setPosition( x, y )
        self.model_obj.model_mc:setPosition( x + self.model_offset_x, y + self.model_offset_y )
        self.scene_node:reorderChild( self.model_obj.model_mc, math.floor( -self.cur_y ) )
    end

    self.scene_node:setCurXY( x, y )
    self.scene_node:setPosition( -x, -y )
end

function __user_object:doAction( action, call_back_func )
    self.cur_action = action

    self.enable_move = false

    require 'gamecommon.skill'
    useSkill( self, nil, self.cur_action, function()
        self.enable_move = true

        if call_back_func then call_back_func() end
    end)
end

-- 移动一段距离后去生成附近的，销毁远离的
function __user_object:updateGridObjects()
    if not self.scene_node then return end

    -- 记录下更新的坐标
    self.last_update_grid_obj_x, self.last_update_grid_obj_y = self.cur_x, self.cur_y

    -- 
    local start_y = self.cur_y + grid_obj_visible_height * 0.5
    local end_y = self.cur_y - grid_obj_visible_height * 0.5

    while( start_y > end_y ) do
        local start_x = self.cur_x - grid_obj_visible_width * 0.5
        local end_x = self.cur_x + grid_obj_visible_width * 0.5

        while( start_x < end_x ) do
            local grid_info, grid_key = self:getGridInfoByPosition( start_x, start_y, false )
            if grid_info and not self.all_grid_objs[grid_key] then
                local x, y = self:getGridPosition( grid_key )
                local grid_obj = ( require 'gamecommon.grid_object' ).new( grid_info, x, y )
                self.all_grid_objs[grid_key] = grid_obj
            end

            start_x = start_x + self.grid_width
        end

        start_y = start_y - self.grid_height
    end
end

-- 每秒执行一次的更新状态
function __user_object:updateGridObjectState()
    for _,grid_obj in pairs( self.all_grid_objs ) do
        grid_obj:update()
    end
end

return __user_object
