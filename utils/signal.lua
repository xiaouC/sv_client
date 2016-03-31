--./utils/signal.lua
-- 实现通用监听模式

local _listeners = {}

signal = {}

function signal.listen( key, callback )
    if _listeners[key] == nil then _listeners[key] = {} end

    table.insert( _listeners[key], callback )

    return callback
end

function signal.unlisten( key, callback )
    if not _listeners[key] then return end

    return table.remove( _listeners[key], callback )
end

function signal.fire(key, ...)
    for _, cb in ipairs( _listeners[key] or {} ) do
        cb(...)
    end
end

