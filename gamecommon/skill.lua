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

local skill_ability = {
    [KaiKen] = function( player_obj, item_obj )
    end,
    [BoZhong] = function( player_obj, item_obj )
    end,
    [QuShui] = function( player_obj, item_obj )
    end,
    [JiaoShui] = function( player_obj, item_obj )
    end,
    [ShouGe] = function( player_obj, item_obj )
    end,
    [MaiChu] = function( player_obj, item_obj )
    end,
    [ShiYong] = function( player_obj, item_obj )
    end,
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

function useSkill( player_obj, item_obj, skill_id )
    local skill_info = YY_SKILL_CONFIG[skill_id]
    if not skill_info then return end

    -- 需要消耗的
    for _,consume_v in ipairs( skill_info.consume or {} ) do
        if not player_obj:checkConsume( consume_v, true ) then
            return
        end
    end

    -- 技能动作
    player_obj:playAction( skill_info.actions, 0, function()
        player_obj:playAction( { 'standby' }, -1 )

        -- 对目标起作用
        local targets = getSkillTarget( skill_info, player_obj, item_obj )
        for _, target_obj in ipairs( targets or {} ) do
            target_obj.state = skill_info.target_select.new_state
        end

        -- 消耗属性或者物品
        for _,consume_v in ipairs( skill_info.consume or {} ) do
            player_obj:checkConsume( consume_v, false )
        end
    end)

    -- 玩家身上的技能光效
    for _,effect_name in ipairs( skill_info.effects or {} ) do
        player_obj:addEffect( effect_name )
    end
end
