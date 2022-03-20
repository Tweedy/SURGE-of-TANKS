local terrain = {}

local myPlayer = require("player")
local objetsDecor = require("decor")

terrain.map = {}
terrain.map.grid = {
    {21, 31, 21, 31, 21, 21, 21, 24, 25, 31, 31, 21, 21, 31, 21, 31},
    {21, 34, 23, 23, 23, 23, 23, 26, 26, 23, 23, 23, 23, 23, 35, 21},
    {31, 22, 21, 31, 21, 31, 21, 21, 31, 21, 21, 31, 21, 21, 22, 31},
    {31, 22, 31, 21, 31, 21, 21, 21, 21, 31, 31, 21, 21, 31, 22, 21},
    {21, 22, 31, 21, 21, 31, 31, 21, 31, 21, 21, 31, 21, 21, 22, 21},
    {18, 40, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 40, 18},
    {03, 05, 11, 01, 01, 01, 01, 01, 11, 11, 01, 11, 01, 01, 04, 03},
    {01, 02, 01, 11, 01, 11, 01, 11, 01, 01, 01, 01, 11, 01, 02, 11},
    {11, 02, 11, 01, 11, 01, 11, 01, 11, 01, 01, 11, 01, 11, 02, 01},
    {11, 02, 01, 01, 01, 11, 01, 01, 11, 01, 01, 11, 01, 01, 02, 01},
    {01, 16, 03, 03, 03, 03, 03, 03, 03, 03, 03, 03, 03, 03, 17, 11},
    {11, 01, 11, 01, 11, 01, 01, 01, 11, 01, 11, 01, 11, 11, 01, 01}
}

terrain.map.MAP_WIDTH = 16
terrain.map.MAP_HEIGHT = 12
terrain.map.TILE_WIDTH = 64
terrain.map.TILE_HEIGHT = 64
terrain.tileImage = nil
terrain.tileTextures = {}
terrain.tileType = {}

function terrain.Load()
    print("texture")
    terrain.tileImage = love.graphics.newImage("images/Environment/tiles.png")
    local nbColumns = terrain.tileImage:getWidth() / terrain.map.TILE_WIDTH
    local nbLines = terrain.tileImage:getHeight() / terrain.map.TILE_HEIGHT

    terrain.tileTextures[0] = nil

    local l, c
    local id = 1
    for l = 1, nbLines do
        for c = 1, nbColumns do
            terrain.tileTextures[id] =
                love.graphics.newQuad(
                (c - 1) * terrain.map.TILE_WIDTH,
                (l - 1) * terrain.map.TILE_HEIGHT,
                terrain.map.TILE_WIDTH,
                terrain.map.TILE_HEIGHT,
                terrain.tileImage:getWidth(),
                terrain.tileImage:getHeight()
            )
            id = id + 1
        end
    end

    terrain.tileType[21] = "Sable"
    terrain.tileType[31] = "Sable"

    terrain.tileType[2] = "Route"
    terrain.tileType[3] = "Route"
    terrain.tileType[4] = "Route"
    terrain.tileType[5] = "Route"
    terrain.tileType[6] = "Route"
    terrain.tileType[16] = "Route"
    terrain.tileType[17] = "Route"
    terrain.tileType[22] = "Route"
    terrain.tileType[23] = "Route"
    terrain.tileType[24] = "Route"
    terrain.tileType[25] = "Route"
    terrain.tileType[26] = "Route"
    terrain.tileType[34] = "Route"
    terrain.tileType[35] = "Route"
    terrain.tileType[23] = "Route"
    terrain.tileType[40] = "Route"

    print("texture chargé")
end

function terrain.Update()
    local col = math.floor(myPlayer.x / terrain.map.TILE_WIDTH) + 1
    local lig = math.floor(myPlayer.y / terrain.map.TILE_HEIGHT) + 1
    if col > 0 and col <= terrain.map.MAP_WIDTH and lig > 0 and lig <= terrain.map.MAP_HEIGHT then
        local id = terrain.map.grid[lig][col]
        if terrain.tileType[id] == "Sable" then
            myPlayer.maxSpeed = 50
            if myPlayer.speed >= myPlayer.maxSpeed then
                myPlayer.speed = myPlayer.maxSpeed
            elseif myPlayer.speed <= -myPlayer.maxSpeed then
                myPlayer.speed = -myPlayer.maxSpeed
            end
        elseif terrain.tileType[id] == "Route" then
            myPlayer.maxSpeed = 150
            if myPlayer.speed >= myPlayer.maxSpeed then
                myPlayer.speed = myPlayer.maxSpeed
            elseif myPlayer.speed <= -myPlayer.maxSpeed then
                myPlayer.speed = -myPlayer.maxSpeed
            end
        else
            myPlayer.maxSpeed = 100
        end
    else
        print("Hors de la map !")
    end
end

function terrain.Draw()
    local c, l

    for l = 1, terrain.map.MAP_HEIGHT do -- Liste des lignes
        for c = 1, terrain.map.MAP_WIDTH do -- Liste des colonnes
            local id_tile = terrain.map.grid[l][c]
            local quadTexture = terrain.tileTextures[id_tile]
            if quadTexture ~= nil then
                love.graphics.draw(
                    terrain.tileImage,
                    quadTexture,
                    (c - 1) * terrain.map.TILE_WIDTH,
                    (l - 1) * terrain.map.TILE_HEIGHT
                )
            end
        end
    end
end

return terrain
