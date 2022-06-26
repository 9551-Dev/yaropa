--[[
The MIT License (MIT)
Copyright © 2022 Oliver Caha (9551Dev)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The MIT License (MIT)
Copyright © 2022 Oliver Caha (9551Dev)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

local PATHFINDER = {}

function PATHFINDER.node(x,y,z,passable)
    if passable == nil then passable = true end
    local gCost = 0
    local hCost = 0
    return setmetatable({
        passable = passable,
        gCost = gCost,
        hCost = hCost,
        pos = vector.new(x,y,z),
    },{__index=function(self,index)
            if index == "fCost" then
                return self.gCost+self.hCost
            end
        end
    })
end

PATHFINDER.allowed_neighbour_positions = {
    vector.new(0,1,0),
    vector.new(0,-1,0),
    vector.new(-1,0,0),
    vector.new(1,0,0),
    vector.new(0,0,1),
    vector.new(0,0,-1)
}

function PATHFINDER.createNDarray(n, tbl)
    tbl = tbl or {}
    if n == 0 then return tbl end
    setmetatable(tbl, {__index = function(t, k)
        local new = PATHFINDER.createNDarray(n - 1)
        t[k] = new
        return new
    end})
    return tbl
end

function PATHFINDER.create_field(w,h,d,start_x,start_y,start_z)
    start_x,start_y,start_z = start_x or 1,start_y or 1,start_z or 1
    local grid = {}
    local GRID_LOOKUP = PATHFINDER.createNDarray(3)
    local LAST_NODE = 0
    for x=start_x,start_x+w-1 do
        for y=start_y,start_y+h-1 do
            for z=start_z,start_z+d-1 do
                LAST_NODE = LAST_NODE + 1
                table.insert(grid,PATHFINDER.node(x,y,z,true))
                GRID_LOOKUP[x][y][z] = LAST_NODE
            end
        end
    end
    return {grid={points=grid,NODE_LOOKUP=GRID_LOOKUP},size={w=w,h=h,d=d}}
end

local NODE_LIST_FUNCTIONS = {
    add=function(proxy,LUTBL)
        local LUT = LUTBL.reference
        return function(node)
            LUT.last_node = LUT.last_node + 1
            table.insert(proxy,node)
            LUT[node.pos.x][node.pos.y][node.pos.z] = LUT.last_node
            return LUT.last_node
        end
    end,
    get=function(proxy,LUTBL)
        local LUT = LUTBL.reference
        return function(x,y,z)
            if LUT[x] and LUT[x][y] and LUT[x][y][z] then
                local index = LUT[x][y][z]-LUTBL.offset
                return proxy[index]
            end
        end
    end,
    get_by_index=function(proxy,LUTBL)
        return function(n)
            return proxy[n]
        end
    end,
    contains=function(proxy,LUTBL)
        local LUT = LUTBL.reference
        return function(x,y,z)
            if LUT[x] and LUT[x][y] and LUT[x][y][z] then
                return true
            else return false end
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

local PATHFINDER = {}

function PATHFINDER.node(x,y,z,passable)
    if passable == nil then passable = true end
    local gCost = 0
    local hCost = 0
    return setmetatable({
        passable = passable,
        gCost = gCost,
        hCost = hCost,
        pos = vector.new(x,y,z),
    },{__index=function(self,index)
            if index == "fCost" then
                return self.gCost+self.hCost
            end
        end
    })
end

PATHFINDER.allowed_neighbour_positions = {
    vector.new(0,1,0),
    vector.new(0,-1,0),
    vector.new(-1,0,0),
    vector.new(1,0,0),
    vector.new(0,0,1),
    vector.new(0,0,-1)
}

function PATHFINDER.createNDarray(n, tbl)
    tbl = tbl or {}
    if n == 0 then return tbl end
    setmetatable(tbl, {__index = function(t, k)
        local new = PATHFINDER.createNDarray(n - 1)
        t[k] = new
        return new
    end})
    return tbl
end

function PATHFINDER.create_field(w,h,d,start_x,start_y,start_z)
    start_x,start_y,start_z = start_x or 1,start_y or 1,start_z or 1
    local grid = {}
    local GRID_LOOKUP = PATHFINDER.createNDarray(3)
    local LAST_NODE = 0
    for x=start_x,start_x+w-1 do
        for y=start_y,start_y+h-1 do
            for z=start_z,start_z+d-1 do
                LAST_NODE = LAST_NODE + 1
                table.insert(grid,PATHFINDER.node(x,y,z,true))
                GRID_LOOKUP[x][y][z] = LAST_NODE
            end
        end
    end
    return {grid={points=grid,NODE_LOOKUP=GRID_LOOKUP},size={w=w,h=h,d=d}}
end

local NODE_LIST_FUNCTIONS = {
    add=function(proxy,LUTBL)
        local LUT = LUTBL.reference
        return function(node)
            LUT.last_node = LUT.last_node + 1
            table.insert(proxy,node)
            LUT[node.pos.x][node.pos.y][node.pos.z] = LUT.last_node
            return LUT.last_node
        end
    end,
    get=function(proxy,LUTBL)
        local LUT = LUTBL.reference
        return function(x,y,z)
            if LUT[x] and LUT[x][y] and LUT[x][y][z] then
                local index = LUT[x][y][z]-LUTBL.offset
                return proxy[index]
            end
        end
    end,
    get_by_index=function(proxy,LUTBL)
        return function(n)
            return proxy[n]
        end
    end,
    contains=function(proxy,LUTBL)
        local LUT = LUTBL.reference
        return function(x,y,z)
            if LUT[x] and LUT[x][y] and LUT[x][y][z] then
                return true
            else return false end
        end
    end,
    remove_node=function(proxy,LUTBL)
        local LUT = LUTBL.reference
        return function(x,y,z)
            if LUT[x] and LUT[x][y] and LUT[x][y][z] then
                local index = LUT[x][y][z]
                return table.remove(proxy,index)
            end
        end
    end,
    remove_first_node=function(proxy,LUT)
        return function()
            LUT.offset = LUT.offset + 1
            return table.remove(proxy,1)
        end
    end,
    remove=function(proxy,LUTBL)
        local LUT = LUTBL.reference
        return function(n)
            return table.remove(proxy,n)
        end
    end,
    get_proxy=function(proxy,LUTBL)
        return function() return proxy end
    end,
    rebuild_LUT=function(proxy,LUTBL)
        return function()
            local new = PATHFINDER.createNDarray(2)
            new.last_node = 0
            new.offset = 0
            for index,node in pairs(proxy) do
                new[node.pos.x][node.pos.y][node.pos.z] = index
                new.last_node = index
            end
            LUTBL.reference = new
        end
    end
}

function PATHFINDER.create_node_list()
    local proxy = {}
    local LUT = {reference=PATHFINDER.createNDarray(2)}
    LUT.reference.last_node = 0
    LUT.offset = 0
    local list = setmetatable({},{
        __index = function(self,key)
            if not NODE_LIST_FUNCTIONS[key] then return rawget(proxy,key)
            else
                local UPFUNCTION = NODE_LIST_FUNCTIONS[key](proxy,LUT)
                return UPFUNCTION
            end
        end,
        __newindex=function(self,key,value)
            rawset(proxy,key,value)
            rawset(self,key,nil)
        end
    })
    return list
end

local function reverse_table(tbl)
    local reversed_table = {}
    for k,v in pairs(tbl) do
        reversed_table[(#tbl-k+1)] = v
    end
    return reversed_table
end

local function compare_nodes(a,b)
    return a.pos.x == b.pos.x and a.pos.y == b.pos.y and a.pos.z == b.pos.z
end

local function get_distance(a,b)
    return math.sqrt(
        (a.pos.x - b.pos.x)^2 +
        (a.pos.y - b.pos.y)^2 +
        (a.pos.z - b.pos.z)^2
    )
end

local function get_node_neighbours(grid,node)
    local neighbours = {}
    for side_index,vec in pairs(PATHFINDER.allowed_neighbour_positions) do
        local nei_x = node.pos.x + vec.x
        local nei_y = node.pos.y + vec.y
        local nei_z = node.pos.z + vec.z
        if ((nei_x >= 0) and (nei_x <= grid.size.w)) and
        ((nei_y >= 0) and (nei_y <= grid.size.h)) and
        ((nei_z >= 0) and (nei_z <= grid.size.d)) then
            local neighbor_index = grid.grid.NODE_LOOKUP[nei_x][nei_y][nei_z]
            table.insert(neighbours,grid.grid.points[neighbor_index])
        end
    end
    return neighbours
end

local function retrace_path(start_node,final_node,p)
    local path = {
        {
            x=final_node.pos.x,
            y=final_node.pos.y,
            z=final_node.pos.z
        }
    }
    local current_node = p
    while not compare_nodes(current_node,start_node) do
        table.insert(path,{
            x=current_node.pos.x,
            y=current_node.pos.y,
            z=current_node.pos.z
        })
        current_node = current_node.parent
    end
    table.insert(path,{
        x=start_node.pos.x,
        y=start_node.pos.y,
        z=start_node.pos.z
    })
    return reverse_table(path)
end

function PATHFINDER.pathfind(grid, start, target)
    local starting_node = start
    local target_node = target
    local open_nodes = PATHFINDER.create_node_list()
    local closed_nodes = PATHFINDER.create_node_list()
    local last_parent
    open_nodes.add(starting_node)
    while next(open_nodes.get_proxy()) do
        local current_node = open_nodes.get_by_index(1)
        local best_node_index = 1
        for k,v in pairs(open_nodes.get_proxy()) do
            if (v.fCost < current_node.fCost) or ((v.fCost == current_node.fCost) and (v.hCost < current_node.hCost)) then
                current_node = v
                best_node_index = k
            end
        end
        local final_node = open_nodes.remove(best_node_index)
        closed_nodes.add(final_node)
        open_nodes.rebuild_LUT()
        if compare_nodes(current_node, target_node) then
            return retrace_path(starting_node, target_node, last_parent)
        end
        for index,neighbor in pairs(get_node_neighbours(grid,current_node)) do
            if not (
                ((not neighbor.passable) or
                closed_nodes.contains(neighbor.pos.x,neighbor.pos.y,neighbor.pos.z))
            ) then
                local new_move_cost = current_node.gCost + get_distance(current_node, neighbor)
                if (new_move_cost < neighbor.gCost) or
                (not open_nodes.contains(neighbor.pos.x,neighbor.pos.y,neighbor.pos.z)) then
                    neighbor.gCost = new_move_cost
                    neighbor.hCost = get_distance(neighbor,target_node)
                    neighbor.parent = current_node
                    last_parent = current_node
                    if not open_nodes.contains(neighbor.pos.x,neighbor.pos.y,neighbor.pos.z) then
                        open_nodes.add(neighbor)
                    end
                end
            end
        end
    end
    return {},false
end

return PATHFINDER
