-- ./Editor/SMEditHelper.lua
require 'utils.table'

local obstacle_file_name = 'config/obstacle.lua'
local all_obstacle = nil
local all_obstacle_nodes = {}
function loadObstacle( SMNode )
    if not all_obstacle then all_obstacle = table.load( obstacle_file_name ) end

    if SMNode then showObstacle( SMNode ) end
end

function saveObstacle()
    if all_obstacle then table.save( all_obstacle, obstacle_file_name ) end
end

local function __correct__( SMNode, x, y )
    local grid_width = SMNode:getGridWidth()
    local grid_height = SMNode:getGridHeight()

    local t_x = math.floor( x / grid_width )
    t_x = t_x * grid_width + grid_width * 0.5

    local t_y = math.floor( y / grid_height )
    t_y = t_y * grid_height + grid_height * 0.5

    return t_x, t_y
end

function addObstacle( SMNode, ob_id, x, y )
    if not all_obstacle then loadObstacle( SMNode ) end

    if not all_obstacle then all_obstacle = {} end

    local sm_file = SMNode:getSeamlessMapFile()
    if not all_obstacle[sm_file] then all_obstacle[sm_file] = {} end

    local ob_key = string.format( "%d|%d", __correct__( SMNode, x, y ) )
    all_obstacle[sm_file][ob_key] = ob_id

    createObstacle( SMNode, ob_key, ob_id )
end

function removeObstacle( SMNode, x, y )
    if not all_obstacle or not SMNode then return end

    local sm_file = SMNode:getSeamlessMapFile()
    if not all_obstacle[sm_file] then return end

    local ob_key = string.format( "%d|%d", __correct__( SMNode, x, y ) )
    all_obstacle[sm_file][ob_key] = nil

    if all_obstacle_nodes[ob_key] then
        all_obstacle_nodes[ob_key]:removeFromParentAndCleanup( true )
        all_obstacle_nodes[ob_key] = nil
    end
end

function showObstacle( SMNode )
    if not all_obstacle or not SMNode then return end

    clearObstacle()

    local sm_file = SMNode:getSeamlessMapFile()
    for ob_key, ob_id in pairs( all_obstacle[sm_file] or {} ) do
        createObstacle( SMNode, ob_key, ob_id )
    end
end

function createObstacle( SMNode, ob_key, ob_id )
    require 'config.obstacle_config'

    local ob_info = YY_OBSTACLE_CONFIG[ob_id]
    if not ob_info then return end

    -- 如果已经有，就重新创建
    if all_obstacle_nodes[ob_key] then all_obstacle_nodes[ob_key]:removeFromParentAndCleanup( true ) end

    -- 
    local model_node = nil

    local file_extension_name = get_extension( ob_info.model )
    if file_extension_name == 'png' then
        model_node = MCLoader:sharedMCLoader():loadSprite( ob_info.model )
    else
        model_node = createMovieClipWithName( ob_info.model )
        model_node:play( 0, -1, -1 )
    end

    if ob_info.scale then model_node:setScale( ob_info.scale ) end

    local pos = ob_key.split( '|', tonumber )
    sprite:setPosition( pos[1], pos[2] )

    SMNode:addChild( model_node )

    all_obstacle_nodes[ob_key] = model_node
end

function clearObstacle()
    for _, node in pairs( all_obstacle_nodes ) do
        node:removeFromParentAndCleanup( true )
    end
    all_obstacle_nodes = {}
end
