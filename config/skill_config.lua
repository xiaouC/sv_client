-- ./config/skill_config.lua

YY_SKILL_CONFIG = {
    [1] = {
        desc = 'KaiKen',                -- 描述
        consume = {                     -- 需要消耗的属性或者物品
            {
                type = 'ATTR',          -- 消耗体力 5
                arg = 'health',
                count = 5,
                rm_flag = true,         -- rm_flag 为 true 的时候，才会在施放成功后，扣除，false 的话，只是需要判断是否满足但不扣除，物品亦然
            },
            {
                type = 'ITEM',          -- 需要一个物品 1
                arg = '1',
                count = 1,
            },
        },
        gather = {                      -- 收获到的属性或者物品
            {
                type = 'ATTR',
                attr = 'health',
                count = 15,
            },
            {
                type = 'ITEM',
                item_id = 110,
                count = 3,
            },
        },
        actions = {                     -- 使用这个技能时候的动作
            'attack01',
        },
        effects = {                     -- 使用这个技能时候，玩家身上的光效
        },
        range_effects = {               -- 技能影响的范围或者作用的范围
        },
        target_select = {               -- 技能目标的选取
            type = 'LOT',               -- 目标的类型：MONSTER,PLAYER,USER,LOT
            state = 1,                  -- 目标的状态
            new_state = 2,              -- 目标新的状态
        },
    },
}
