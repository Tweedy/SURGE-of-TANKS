local globalParams = require("params")
local spawnItem = require("item")

local player = {}

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

player.imgFullBar = love.graphics.newImage("images/Interface/blue_full_bar.png")
player.imgEmptyBar = love.graphics.newImage("images/Interface/blue_empty_bar.png")
player.fullQuad = nil
player.emptyQuad = love.graphics.newQuad(0, 0, player.maxLife * 2, 30, player.maxLife * 2, 30)

player.imgTank = love.graphics.newImage("images/Tanks/tankBlue.png")
player.imgCannon = love.graphics.newImage("images/Tanks/barrelBlue.png")
player.imgMachineGun = love.graphics.newImage("images/Tanks/machineGunBlue.png")
player.timerMachineGun = 0

player.width = player.imgTank:getWidth()
player.height = player.imgTank:getHeight()

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

    -- Redonne de la vie au joueur
    if Collide(player, spawnItem) then
        if spawnItem.visible == true then
            print("touche")
            player.life = player.life + 10
        end
        spawnItem.visible = false
    end
    -- Limite le nombre de point du joueur
    if player.life > player.maxLife then
        player.life = player.maxLife
    end

    -- Donne et actualise la position des mitrailleuses
    player.mGunX = player.x - 14 * math.cos(player.angle - math.pi)
    player.mGunY = player.y - 14 * math.sin(player.angle - math.pi)

    -- Donne la taille de la barre de vie
    player.fullQuad = love.graphics.newQuad(0, 0, player.life * 2, 30, player.maxLife * 2, 30)

    -- Permet le tir à la mitrailleuse
    if player.timerMachineGun <= 0 then
        if love.mouse.isDown(2) then -- Tire une balle dans la meme direction que le joueur
            local vx, vy
            vx = 10 * math.cos(player.angle)
            vy = 10 * math.sin(player.angle)

            local x1, y1 = 0, 0
            local x2, y2 = 0, 0
            x1 = player.x + 15 * math.cos(player.angle - math.pi / 4)
            y1 = player.y + 15 * math.sin(player.angle - math.pi / 4)
            x2 = player.x + 15 * math.cos(player.angle + math.pi / 4)
            y2 = player.y + 15 * math.sin(player.angle + math.pi / 4)

            CreeTir(x1, y1, player.angle, vx, vy, globalParams.lstSprites, "BallesBleu")
            CreeTir(x2, y2, player.angle, vx, vy, globalParams.lstSprites, "BallesBleu")
            player.timerMachineGun = 50
            player.mGunX = player.x - 11 * math.cos(player.angle - math.pi)
            player.mGunY = player.y - 11 * math.sin(player.angle - math.pi)
        end
    elseif player.timerMachineGun > 0 then
        -- Change la position des mitrailleuses pour créer un effet de recul
        player.mGunX = player.x - 14 * math.cos(player.angle - math.pi)
        player.mGunY = player.y - 14 * math.sin(player.angle - math.pi)
    end
    player.timerMachineGun = player.timerMachineGun - 10 * (60 * dt)

    -- Determine avec quels elements le joueur peut collisionner
    local next_x, next_y = player.GetNextPos(dt)
    if player.nextPosX > LARGEUR_ECRAN - 20 then
        player.x = LARGEUR_ECRAN - 20
        player.vitesse = 0
    end
    if player.nextPosX < 20 then
        player.x = 20
        player.vitesse = 0
    end
    if player.nextPosY > HAUTEUR_ECRAN - 20 then
        player.y = HAUTEUR_ECRAN - 20
        player.vitesse = 0
    end
    if player.nextPosY < 20 then
        player.y = 20
        player.vitesse = 0
    end
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
    love.graphics.draw(player.imgFullBar, player.fullQuad, 10, 10)
    love.graphics.draw(player.imgEmptyBar, player.emptyQuad, 10, 10)
    love.graphics.print("Vie du joueur: " .. player.life, 20, 16, 0, 0.75, 0.75)
    love.graphics.draw(
        player.imgTank,
        player.x,
        player.y,
        player.angle - math.pi * 1.5,
        player.scaleX,
        player.scaleY,
        player.imgTank:getWidth() / 2,
        player.imgTank:getHeight() / 2
    )

    love.graphics.draw(
        player.imgMachineGun,
        player.mGunX,
        player.mGunY,
        player.angle - math.pi * 1.5,
        0.5,
        0.5,
        player.imgMachineGun:getWidth() / 2,
        player.imgMachineGun:getHeight() / 2
    )
    love.graphics.draw(
        player.imgCannon,
        player.x,
        player.y,
        player.angleCannon - math.pi * 1.5,
        0.5,
        0.5,
        player.imgCannon:getWidth() / 2,
        player.imgCannon:getHeight()
    )
end

return player
