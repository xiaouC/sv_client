-- ./config/GameSettings.lua
require 'utils.common'
require 'gamecommon.enums'
require 'utils.table'

GameSettings = {
    upgrade_url = 'http://pokemonassets.winnergame.com/assets/package_inc/',           -- 增量更新的 URL
    config_inc_url = 'http://pokemonassets.winnergame.com/assets/config_inc/',         -- 增量配置的 URL
    error_report_url = 'http://pokemon.admin.dnastdio.com:8888/ttxm/recv_client_log',            -- 错误上报的 URL

    is_check_upgrade = false,                   -- 是否检查增量更新
    useReYunLogReport = false,                  -- 是否使用热云统计

    nickname = 'pkm',                       -- 昵称

    timeoutInterval = 15,                       -- 网络超时
    reconnection = true,                        -- 是否重连

    -- 富文本
    font_name = 'FZCuYuan-M03S',                -- 在 win32,linux,ios 下，仅仅指定 ttf 文件，并不能找到，需要指定到 ttf 里面的字库名
    font_name_android = 'fonts/YunYueFont.ttf', -- 而在 android 下，直接指定 ttf 文件
    font_size = 22,
    edge_size = 3,
    color_tex_file = 'Ncolor.png',
    color_tex_row = 8,
    color_tex_col = 8,
    color_shader = 'position_texture_color_rich_string_color',

    effect_level = 1,

    --devicesID = '',           -- 如果需要特殊指定设备ID，这个也许可以帮到你
    --GameVersion = 100000,     -- 如果需要特殊指定版本号，这个也许可以帮到你
    --sdkType = 0,              -- 如果需要使用特殊SDK登陆，这也许可以帮到你

    --schedule_log = true,      -- 默认关闭，可以通过 fix_version.lua 来打开

    skip_cg_fight = false,
}
__http_url__ = {
    [1] = {
        url = 'http://192.168.0.85:20000',                            -- session 服务器的 url
        name = '开发服',                                                -- 服务器名
    },
    [2] = {
        url = 'http://192.168.0.112:20000',
        name = '小邱开发服',
    },
    [3] = {
        url = 'http://123.58.55.10:22000',
        name = '宠物小精灵外网服务器-商务版',
        is_release_server = false,
    },
    [4] = {
        url = 'http://123.58.55.10:20000',
        name = '宠物小精灵外网测试服务器',
        is_release_server = true,
    },
    [5] = {
        url = 'http://pokemonpro.dnastdio.com:8888/beta/pokemonpro',
        name = '宠物小精灵正式服务器 - android ios 同服',
        is_release_server = true,
    },
    [6] = {
        url = 'http://192.168.1.133:20000', -- session 服务器的 url
        name = 'xiaou开发服',               -- 服务器名
    },
    [7] = {
        url = 'http://192.168.254.237:21000',                            -- session 服务器的 url
        name = '惊松开发服',                                                -- 服务器名
    },
}

-- PC 默认使用 << 外网服务器 >>
local server_index = 4

local platform = getPlatform()
if platform == 'android' or platform == 'ios' then
    server_index = 5
end

if GetSdkType() == SDKType.SDK_APP_IOS then
    server_index = 5
end

if platform == 'win32' then
    server_index = 4
end

-- 临时修改，可以在这里
-- server_index = 2

local http_url = __http_url__[server_index]
GameSettings.HTTP_URL = http_url.url

-- 如果需要特殊指定 增量更新的URL / 增量配置的 URL / 报错上传的 URL 的话，看这里
if http_url.upgrade_url then GameSettings.upgrade_url = http_url.upgrade_url end
if http_url.config_inc_url then GameSettings.config_inc_url = http_url.config_inc_url end
if http_url.error_report_url then GameSettings.error_report_url = http_url.error_report_url end

-- win32 不增量
if platform == 'win32' or platform == 'linux' then
    http_url.is_release_server = false
end

-- 如果是发布的服务器的话，就开启这些功能
if http_url.is_release_server then
    GameSettings.is_check_upgrade = true            -- 增量更新
    GameSettings.useReYunLogReport = true           -- 热云统计
end

pcall( function()
    local root = CCFileUtils:sharedFileUtils():getWritablePath()
    CCLuaLog( 'getWriteablePath root = ' .. tostring( root ) )

    local m = root .. 'GameSettings'
    print( m )
    require( m )
end)

require 'utils.debugger'
pdump( "GameSettings", GameSettings )

