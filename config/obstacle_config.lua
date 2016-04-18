-- ./config/obstacle_config.lua

--local grid_info = {
--    ability = 0
--    last_change_time = 0,           -- 上一次改变的时间
--    skill_id = 0,                   -- 技能 ID，可以由很多不同的情况触发，比如时间到了、踩上去、或者在一定范围内等等
--    can_pass = true,                -- 能否通行
--    can_plant = false,              -- 能否种植
--    can_reap = false,               -- 能否收割
--    model = 0,                      -- 当前模型
--    scale = 1,                      -- 缩放
--    item_type = 1,                  -- 用什么物品才可以清理掉
--    counter = 1,                    -- 需要清理几次才能完全清理掉
--}
YY_OBSTACLE_CONFIG = {
    [1] = {
        ability = 0,
        last_change_time = 0,
        skill_id = 0,
        can_pass = false,
        can_plant = false,
        can_reap = false,
        model = 'images/730002.png',
        item_type = 1,
        counter = 1,
    },
}
