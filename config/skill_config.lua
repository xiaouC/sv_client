-- ./config/skill_config.lua

TEST_KAIKEN_SKILL_ID = 1
TEST_BOZHONG_SKILL_ID = 2
TEST_GROWINGUP_SKILL_ID_1 = 3
TEST_GROWINGUP_SKILL_ID_2 = 4
TEST_FILL_WATER_SKILL_ID = 101
TEST_WATERING_SKILL_ID = 102
TEST_REAP_SKILL_ID = 201

YY_SKILL_CONFIG = {
    [TEST_KAIKEN_SKILL_ID] = {
        desc = 'KaiKen',                -- 描述
        ability = 1,
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
        new_state = {                   -- 受到技能影响后的状态属性
            model = 'images/gengdi.png',
            z_order = -900,
            scale = 1,
        },
    },
    [TEST_BOZHONG_SKILL_ID] = {
        desc = 'BoZhong',                -- 描述
        ability = 2,
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
        },
        actions = {                     -- 使用这个技能时候的动作
            'attack01',
        },
        effects = {                     -- 使用这个技能时候，玩家身上的光效
        },
        range_effects = {               -- 技能影响的范围或者作用的范围
        },
        new_state = {                   -- 受到技能影响后的状态属性
            model = '60647/60647_1_2',
            duration = 10,
            next_skill_id = TEST_GROWINGUP_SKILL_ID_1,
            offset_x = 12,
            offset_y = 10,
            scale = 0.5,
        },
        rm_state = { 'z_order' },
    },
    [TEST_GROWINGUP_SKILL_ID_1] = {
        desc = 'GrowingUp',             -- 描述
        new_state = {                   -- 受到技能影响后的状态属性
            model = '60647/60647_1_3',
            duration = 10,
            next_skill_id = TEST_GROWINGUP_SKILL_ID_2,
            offset_x = 12,
            offset_y = 10,
            scale = 0.5,
        },
    },
    [TEST_GROWINGUP_SKILL_ID_2] = {
        desc = 'GrowingUp',             -- 描述
        new_state = {                   -- 受到技能影响后的状态属性
            model = '60647/60647_1_4',
            can_reap = true,
            offset_x = 12,
            offset_y = 10,
            scale = 0.5,
        },
    },
    [TEST_FILL_WATER_SKILL_ID] = {
        desc = 'QuShui',                -- 描述
        ability = 3,
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
        },
        actions = {                     -- 使用这个技能时候的动作
            'attack01',
        },
        effects = {                     -- 使用这个技能时候，玩家身上的光效
        },
        range_effects = {               -- 技能影响的范围或者作用的范围
        },
        new_state = {                   -- 受到技能影响后的状态属性
            counter = 3,
        },
    },
    [TEST_WATERING_SKILL_ID] = {
        desc = 'JiaoShui',              -- 描述
        ability = 4,
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
        },
        actions = {                     -- 使用这个技能时候的动作
            'attack01',
        },
        effects = {                     -- 使用这个技能时候，玩家身上的光效
        },
        range_effects = {               -- 技能影响的范围或者作用的范围
        },
        new_state = {                   -- 受到技能影响后的状态属性
            reduce_time = 10,
        },
    },
    [TEST_REAP_SKILL_ID] = {
        desc = 'shouge',              -- 描述
        ability = 5,
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
                type = 'ITEM',          -- 需要一个物品 1
                arg = '2',
                count = 1,
            },
        },
        actions = {                     -- 使用这个技能时候的动作
            'attack01',
        },
        effects = {                     -- 使用这个技能时候，玩家身上的光效
        },
        range_effects = {               -- 技能影响的范围或者作用的范围
        },
        new_state = {                   -- 受到技能影响后的状态属性
        },
    },
}
