local filePath = ({...})[1]
local file = io.open(filePath,"r")
local code = ""
if file then
    code = file:read("*all")
else
    print("Unable to open "..filePath)
end

local function split(str, del) --String, Delimiter
    local t = {}
    for value in str:gmatch(del) do
        table.insert(t, value)
    end
    return t
end
local lines = split(code, "[^\n]+")
local map = {}
for y=1, #lines do
    map[y] = {}
    for x=1, #lines[y] do
        map[y][x] = string.sub(lines[y], x,x)
    end
end
-- for y=1, #map do
-- for x=1, #map[y] do
--     print(y,x,map[y][x])
-- end
-- end

local mole = {x=1,y=1, value=0, currentDir = 0, thirdDimCount = 0,
        direction = {{x=0,y=-1},{x=1,y=0},{x=0,y=1},{x=-1,y=0}},
        move = function(self)
            self.x = self.x + self.direction[self.currentDir].x
            self.y = self.y + self.direction[self.currentDir].y
            self.thirdDimCount = self.thirdDimCount - 1
            --print(self.x, self.y)
            end}

local function getBesideValues(x, y)
    local up, right, down, left
    if map[y-1] then
        if map[y-1][x] then
            up = tonumber(map[y-1][x])
        end
    end
    if map[y] then
        if map[y][x+1] then
            right = tonumber(map[y][x+1])
        end
        if map[y][x-1] then
            left = tonumber(map[y][x-1])
        end
    end
    if map[y+1] then
        if map[y+1][x] then
            down = tonumber(map[y+1][x])
        end
    end
    --print(up, right, down,left)
    return up, right, down, left
end

while true do
    if map[mole.y] then
        if map[mole.y][mole.x] then
            local ins = map[mole.y][mole.x]
            if mole.thirdDimCount > 0 then
                --mole.thirdDimCount = mole.thirdDimCount - 1
                if ins == "%" then
                    local number
                    local up,right,down,left = getBesideValues(mole.x, mole.y)
                    if up ~= nil then
                        number = up
                    elseif right ~= nil  then
                        number = right
                    elseif down ~= nil  then
                        number = down
                    elseif left ~= nil  then
                        number = left
                    end
                    if number == 0 then
                        mole.value = " "
                    elseif number == 1 then
                        mole.value = "\n"
                    end
                elseif ins == "=" then
                    --mole:move()
                    mole.value = io.read(1)
                    --mole.value = map[mole.y][mole.x]
                elseif ins == "~" then
                    --mole:move()
                    mole.value = tonumber(io.read(1))
                    --mole.value = tonumber(map[mole.y][mole.x])
                elseif ins == ":" then
                    io.write(mole.value)
                    mole.value = 0
                elseif ins == "+" then
                    local number
                    local up,right,down,left = getBesideValues(mole.x, mole.y)
                    if up ~= nil then
                        number = up
                    elseif right ~= nil  then
                        number = right
                    elseif down ~= nil  then
                        number = down
                    elseif left ~= nil  then
                        number = left
                    end
                    mole.value = tonumber(mole.value) + number
                elseif ins == "-" then
                    local number
                    local up,right,down,left = getBesideValues(mole.x, mole.y)
                    if up ~= nil then
                        number = up
                    elseif right ~= nil  then
                        number = right
                    elseif down ~= nil  then
                        number = down
                    elseif left ~= nil  then
                        number = left
                    end
                    mole.value = tonumber(mole.value) - number
                elseif ins == "*" then
                    local number
                    local up,right,down,left = getBesideValues(mole.x, mole.y)
                    if up ~= nil then
                        number = up
                    elseif right ~= nil  then
                        number = right
                    elseif down ~= nil  then
                        number = down
                    elseif left ~= nil  then
                        number = left
                    end
                    mole.value = tonumber(mole.value) * number
                elseif ins == "/" then
                    local number
                    local up,right,down,left = getBesideValues(mole.x, mole.y)
                    if up ~= nil then
                        number = up
                    elseif right ~= nil  then
                        number = right
                    elseif down ~= nil  then
                        number = down
                    elseif left ~= nil  then
                        number = left
                    end
                    mole.value = tonumber(mole.value) / number
                elseif ins == ";" then
                    map[mole.y][mole.x] = tostring(mole.value)
                else
                    mole.value = ins
                end
            end
            if ins == ">" then -- right
                mole.currentDir = 2
            elseif ins == "<" then --left
                mole.currentDir = 4
            elseif ins == "^" then -- up
                mole.currentDir = 1
            elseif ins == "'" then -- down
                mole.currentDir = 3
            elseif ins == "#" then
                local number
                local up,right,down,left = getBesideValues(mole.x, mole.y)
                if up ~= nil then
                    number = up
                elseif right ~= nil  then
                    number = right
                elseif down ~= nil  then
                    number = down
                elseif left ~= nil  then
                    number = left
                end
                if tonumber(number) == 0 then
                    mole.currentDir = mole.currentDir - 1
                elseif tonumber(number) == 1 then
                    mole.currentDir = mole.currentDir + 1
                end
                if mole.currentDir < 1 then mole.currentDir = 4
                elseif mole.currentDir > 4 then mole.currentDir = 1 end
            elseif ins == "$" then
                local up,right,down,left = getBesideValues(mole.x, mole.y)
                if up ~= nil then
                    mole.thirdDimCount = up+1
                elseif right ~= nil  then
                    mole.thirdDimCount = right+1
                elseif down ~= nil  then
                    mole.thirdDimCount = down+1
                elseif left ~= nil  then
                    mole.thirdDimCount = left+1
                end
            elseif ins == "@" then
                break
            end
            mole:move()
        end
    end
end
