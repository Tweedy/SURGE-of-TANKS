local player = {}
local globalParams = require("params")

local imgPlayerTank = love.graphics.newImage("images/Tanks/tankBlue.png")
local imgPlayerTracks = love.graphics.newImage("images/Tanks/tracksSmall.png")
local imgPlayerCannon = love.graphics.newImage("images/Tanks/barrelBlue.png")
local imgPlayerMachineGun = love.graphics.newImage("images/Tanks/machineGunBlue.png")

player.x = 0
player.y = 0
player.speed = 0
player.maxSpeed = 100
player.angle = 0
player.angleCannon = 0
player.nextPosX = nil
player.nextPosY = nil
player.mGunX = nil
player.mGunY = nil
player.life = 100
player.maxLife = 100
player.scaleX = 0.5
player.scaleY = 0.5

player.width = imgPlayerTank:getWidth()
player.height = imgPlayerTank:getHeight()

function player.update(dt)
    player.x = player.x + (player.speed * dt) * math.cos(player.angle)
    player.y = player.y + (player.speed * dt) * math.sin(player.angle)
    if player.speed > 0 then -- Gère la deceleration du joueur
        player.speed = player.speed - 80 * dt
        if player.speed < 0 then
            player.speed = 0
        end
    elseif player.speed < 0 then
        player.speed = player.speed + 100 * dt
    end

    -- Donne et actualise la position des mitrailleuses
    player.mGunX = player.x - 14 * math.cos(player.angle - math.pi)
    player.mGunY = player.y - 14 * math.sin(player.angle - math.pi)
end

function player.GetNextPos(dt) -- Recupère la prochaine position du joueur
    player.nextPosX = player.x + (player.speed * dt) * math.cos(player.angle)
    player.nextPosY = player.y + (player.speed * dt) * math.sin(player.angle)
    return player.nextPosX, player.nextPosY
end

function player.accelerate(pAccel) -- Gere l'acceleration du joueur
    if player.speed < player.maxSpeed then
        player.speed = player.speed + pAccel
    end
    if player.speed < -player.maxSpeed then
        player.speed = player.speed - pAccel
    end
end

function player.rotate(pRadian)
    player.angle = player.angle + pRadian
end

function player.Draw()
    love.graphics.print("Vie: " .. player.life, player.x - 30, player.y - 50)
    love.graphics.draw(
        imgPlayerTank,
        player.x,
        player.y,
        player.angle - math.pi * 1.5,
        player.scaleX,
        player.scaleY,
        imgPlayerTank:getWidth() / 2,
        imgPlayerTank:getHeight() / 2
    )
    love.graphics.draw(
        imgPlayerTracks,
        player.x,
        player.y,
        player.angle - math.pi * 1.5,
        0.5,
        0.5,
        imgPlayerTracks:getWidth() / 2,
        imgPlayerTracks:getHeight() / 2
    )

    love.graphics.draw(
        imgPlayerMachineGun,
        player.mGunX,
        player.mGunY,
        player.angle - math.pi * 1.5,
        0.5,
        0.5,
        imgPlayerMachineGun:getWidth() / 2,
        imgPlayerMachineGun:getHeight() / 2
    )
    love.graphics.draw(
        imgPlayerCannon,
        player.x,
        player.y,
        player.angleCannon - math.pi * 1.5,
        0.5,
        0.5,
        imgPlayerCannon:getWidth() / 2,
        imgPlayerCannon:getHeight()
    )
end

return player
