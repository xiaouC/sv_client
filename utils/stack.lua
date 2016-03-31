--./utils.stack.lua
require 'utils.class'

stack = class( 'Stack' )
function stack:ctor(list)
    self.element = list or {}
end

function stack:clear()
    self.element = {}
end

function stack:push( obj )
    self:pop( obj )             -- 确保是唯一的
    table.insert(self.element, obj)
end

function stack:pop( obj )
    for i, v in ipairs( self.element or {} ) do
        if v == obj then
            table.remove(self.element, i)
            break
        end
    end
end

function stack:popEnd()
    if #self.element <= 0 then
        return nil
    end
    return table.remove(self.element, #self.element)
end

function stack:insert( index, obj )
    if index > #self.element or index <= 0 then return self:push( obj ) end
    table.insert(self.element, index, obj)
end

function stack:remove( index)
    return table.remove(self.element, index)
end

function stack:getAt( index )
    return self.element[index]
end

function stack:getElementCount()
    return #self.element
end

function stack:dump()
    CCLuaLog( 'stack dump:' )
    CCLuaLog( '----------------------------------------------------------------------' )
    for i,v in ipairs( self.element or {} ) do
        pdump( 'stack i = ' .. i, v )
    end
    CCLuaLog( '----------------------------------------------------------------------' )
end
