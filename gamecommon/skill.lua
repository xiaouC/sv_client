-- ./gamecommon/skill.lua
require 'config.skill_config'

-- 技能类型
local KaiKen = 1
local BoZhong = 2
local QuShui = 3
local JiaoShui = 4
local ShouGe = 5
local MaiChu = 6
local ShiYong = 7
local GrowingUp = 8

skill_ability = {
    [KaiKen] = {
        check_func = function( player_obj, item_obj )
            -- 正前方坐标
            local k_x, k_y = player_obj:getDirPos( 'front' )

            -- 这个格子允许
            --if not player_obj.scene_node:getIsEnablePlant( k_x, k_y ) then return false end

            -- 上面有东西，不能动
            local grid_info = player_obj:getGridInfoByPosition( k_x, k_y, false )
            if grid_info then return false end

            return true
        end,
        effect_func = function( player_obj, item_obj, ns_info )
            local grid_info, grid_key = player_obj:getGridInfo( 'front', true )

            grid_info.ability = KaiKen
            grid_info.can_pass = true           -- 可以通行
            grid_info.can_plant = true          -- 可以种植
            grid_info.can_reap = false
            grid_info.last_change_time = os.time()

            for k,v in pairs( ns_info ) do grid_info[k] = v end

            local grid_obj = player_obj.all_grid_objs[grid_key]
            if not grid_obj then
                local x, y = player_obj:getGridPosition( grid_key )
                grid_obj = ( require 'gamecommon.grid_object' ).new( grid_info, x, y )
                player_obj.all_grid_objs[grid_key] = grid_obj
            end

            grid_obj:recreate()
        end,
        update_func = function( player_obj, item_obj )
        end,
        finish_func = function( player_obj, item_obj )
        end,
    },
    [BoZhong] = {
        check_func = function( player_obj, item_obj )
            -- 正前方坐标
            local k_x, k_y = player_obj:getDirPos( 'front' )

            -- 这个格子已经被开了
            local grid_info = player_obj:getGridInfoByPosition( k_x, k_y, false )
            if not grid_info or not grid_info.can_plant then return false end

            return true
        end,
        effect_func = function( player_obj, item_obj, ns_info )
            local grid_info, grid_key = player_obj:getGridInfo( 'front', true )

            grid_info.ability = GrowingUp
            grid_info.can_pass = false          -- 不能通行
            grid_info.can_plant = false         -- 不能种植
            grid_info.can_reap = false
            grid_info.last_change_time = os.time()

            for k,v in pairs( ns_info ) do grid_info[k] = v end

            player_obj.all_grid_objs[grid_key]:recreate()
        end,
        update_func = function( player_obj, item_obj )
        end,
        finish_func = function( player_obj, item_obj )
        end,
    },
    [QuShui] = {
        check_func = function( player_obj, item_obj )
        end,
        effect_func = function( player_obj, item_obj, ns_info )
        end,
        update_func = function( player_obj, item_obj )
        end,
        finish_func = function( player_obj, item_obj )
        end,
    },
    [JiaoShui] = {
        check_func = function( player_obj, item_obj )
        end,
        effect_func = function( player_obj, item_obj, ns_info )
        end,
        update_func = function( player_obj, item_obj )
        end,
        finish_func = function( player_obj, item_obj )
        end,
    },
    [ShouGe] = {
        check_func = function( player_obj, item_obj )
            -- 正前方坐标
            local k_x, k_y = player_obj:getDirPos( 'front' )

            -- 这个格子已经被开了
            local grid_info = player_obj:getGridInfoByPosition( k_x, k_y, false )
            if not grid_info or not grid_info.can_reap then return false end

            return true
        end,
        effect_func = function( player_obj, item_obj, ns_info )
        end,
        update_func = function( player_obj, item_obj )
        end,
        finish_func = function( player_obj, item_obj )
        end,
    },
    [MaiChu] = {
        check_func = function( player_obj, item_obj )
        end,
        effect_func = function( player_obj, item_obj, ns_info )
        end,
        update_func = function( player_obj, item_obj )
        end,
        finish_func = function( player_obj, item_obj )
        end,
    },
    [ShiYong] = {
        check_func = function( player_obj, item_obj )
        end,
        effect_func = function( player_obj, item_obj, ns_info )
        end,
        update_func = function( player_obj, item_obj )
        end,
        finish_func = function( player_obj, item_obj )
        end,
    },
    [GrowingUp] = {
        check_func = function( player_obj, item_obj )
        end,
        effect_func = function( player_obj, item_obj, ns_info )
        end,
        update_func = function( player_obj, grid_obj )
            -- 没有持续时间，就一直维持在这个状态
            if not grid_obj.grid_info.duration then return end

            -- 转换到下一个状态
            local now_time = os.time()
            if grid_obj.grid_info.last_change_time + grid_obj.grid_info.duration <= now_time then
                grid_obj.grid_info.last_change_time = grid_obj.grid_info.last_change_time + grid_obj.grid_info.duration

                if grid_obj.grid_info.next_skill_id then
                    local next_skill_info = YY_SKILL_CONFIG[grid_obj.grid_info.next_skill_id]
                    if next_skill_info then
                        for k,v in pairs( next_skill_info.new_state ) do grid_obj.grid_info[k] = v end

                        grid_obj:recreate()
                    end
                end
            end
        end,
        finish_func = function( player_obj, item_obj )
        end,
    },
}

local skill_target_type = {
    ['PLAYER'] = function( skill_info, player_obj, item_obj )
        return { player_obj }
    end,
    ['MONSTER'] = function( skill_info, player_obj, item_obj )
    end,
    ['USER'] = function( skill_info, player_obj, item_obj )
    end,
    ['LOT'] = function( skill_info, player_obj, item_obj )
        local ts = skill_info.target_select

        local grids = {}
        for _, grid_info in ipairs( player_obj:getFrontGridInfo() or {} ) do
            if grid_info.state == ts.state then
                table.insert( grids, grid_info )
            end
        end

        return grids
    end,
}

local function getSkillTarget( skill_info, player_obj, item_obj )
    local st_type = skill_info.target_select.type
    return skill_target_type[st_type]( skill_info, player_obj, item_obj )
end

function useSkill( player_obj, item_obj, skill_id, call_back_func )
    local skill_info = YY_SKILL_CONFIG[skill_id]
    if not skill_info then return call_back_func() end

    -- 需要消耗的
    for _,consume_v in ipairs( skill_info.consume or {} ) do
        if not player_obj:checkConsume( consume_v, true ) then
            return call_back_func()
        end
    end

    -- 
    local ability = skill_info.ability
    local sa_info = skill_ability[ability]
    if not sa_info.check_func( player_obj, item_obj ) then
        return call_back_func()
    end

    -- 技能动作
    player_obj:playAction( skill_info.actions, 0, function()
        player_obj:playAction( { 'standby' }, -1 )

        -- 技能效果
        sa_info.effect_func( player_obj, item_obj, skill_info.new_state )

        -- 消耗属性或者物品
        for _,consume_v in ipairs( skill_info.consume or {} ) do
            player_obj:checkConsume( consume_v, false )
        end

        -- 回调
        call_back_func()
    end)

    -- 玩家身上的技能光效
    for _,effect_name in ipairs( skill_info.effects or {} ) do
        player_obj:addEffect( effect_name )
    end
end
