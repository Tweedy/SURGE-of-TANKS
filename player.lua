local player = {}
local params = require("params")

local imgPlayerTank = love.graphics.newImage("images/Tanks/tankBlue.png")
local imgPlayerTracks = love.graphics.newImage("images/Tanks/tracksSmall.png")
local imgPlayerCannon = love.graphics.newImage("images/Tanks/barrelBlue.png")

player.x = 0
player.y = 0
player.speed = 0
player.angle = 0
player.angleCannon = 0
player.old_angleCannon = 0

function player.update(dt)
    player.x = player.x + (player.speed * dt) * math.cos(player.angle)
    player.y = player.y + (player.speed * dt) * math.sin(player.angle)
    if player.speed > 0 then
        player.speed = player.speed - 80 * dt
        if player.speed < 0 then
            player.speed = 0
        end
    elseif player.speed < 0 then
        player.speed = player.speed + 100 * dt
    end
end

function player.accelerate(pAccel)
    if player.speed < 100 then
        player.speed = player.speed + pAccel
    end
    if player.speed < -80 then
        player.speed = player.speed - pAccel
    end
end

function player.rotate(pRadian)
    player.angle = player.angle + pRadian
end

function player.draw()
    love.graphics.draw(imgPlayerTank, player.x, player.y, player.angle - math.pi * 1.5, 1, 1, imgPlayerTank:getWidth()/2, imgPlayerTank:getHeight()/2)
    love.graphics.draw(imgPlayerTracks, player.x, player.y, player.angle - math.pi * 1.5, 1, 1, imgPlayerTracks:getWidth()/2, imgPlayerTracks:getHeight()/2)
    love.graphics.draw(imgPlayerCannon, player.x, player.y, player.angleCannon - math.pi * 1.5, 1, 1, imgPlayerCannon:getWidth()/2, imgPlayerCannon:getHeight())
    if STATS_DEBUG == true then
        love.graphics.print(player.speed, player.x + 30, player.y)
    end
end

return player