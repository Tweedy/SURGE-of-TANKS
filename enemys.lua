local enemys = {}
enemys.color = nil
enemys.lstTank = {}

enemys.timerSpawn = 1
enemys.frequSpawn = 2
enemys.totalSpwan = 0
enemys.bossPhase1 = true

local globalParams = require("params")
local myPlayer = require("player")

function SpawnTank(pX, pY, pScaleX, pScaleY, pEtat, pLife, pLstSprites, pType)
    local tank = {}
    local image = ""

    if pType == "TankVert" then
        image = "Tanks/tankGreen_"
    elseif pType == "TankBeige" then
        image = "Tanks/tankBeige_"
    elseif pType == "TankBoss" then
        image = "Tanks/tankRed_outline_"
    end

    tank = CreateSprite(pLstSprites, pType, image, 1)

    if pType == "TankVert" then
        tank.imageTourelle = love.graphics.newImage("images/Tanks/barrelGreen.png")
    elseif pType == "TankBeige" then
        tank.imageTourelle = love.graphics.newImage("images/Tanks/barrelBeige.png")
    elseif pType == "TankBoss" then
        tank.imageTourelle = love.graphics.newImage("images/Tanks/barrelRed_outline.png")
    end

    tank.x = pX
    tank.y = pY
    tank.scaleX = pScaleX
    tank.scaleY = pScaleY
    tank.etat = pEtat
    tank.life = pLife
    tank.dureeEtat = math.random(1, 5)
    tank.vitesse = math.random(50, 100)
    tank.timerTir = 0
    tank.timerPauseTir = false
    tank.tourelleAngle = 0

    table.insert(enemys.lstTank, tank)
end

function ChangeEtat(pTank, pEtat)
    pTank.etat = pEtat
    pTank.dureeEtat = math.random(1, 2)
end

function enemys.Update(dt)
    -- Donne à la tourelle ennemie la position du joueur
    for k, v in pairs(enemys.lstTank) do
        if enemys.bossPhase1 == true then
            v.tourelleAngle = math.angle(v.x, v.y, myPlayer.x, myPlayer.y)
        else
            v.tourelleAngle = math.angle(0, v.y, 0, myPlayer.y)
        end
    end

    -- Changement etat tank Vert
    function EtatTankVert(tank)
        local dist = math.dist(tank.x, tank.y, myPlayer.x, myPlayer.y)
        local rayDist = 100

        if dist <= rayDist then
            if tank.etat == "bas" then
                tank.y = tank.y + tank.vitesse * dt
                if tank.dureeEtat <= 0 then
                    ChangeEtat(tank, "droite")
                end
            elseif tank.etat == "haut" then
                tank.y = tank.y - tank.vitesse * dt
                if tank.dureeEtat <= 0 then
                    ChangeEtat(tank, "gauche")
                end
            end
            if tank.etat == "droite" then
                tank.x = tank.x + tank.vitesse * dt
                if tank.dureeEtat <= 0 then
                    ChangeEtat(tank, "haut")
                end
            elseif tank.etat == "gauche" then
                tank.x = tank.x - tank.vitesse * dt
                if tank.dureeEtat <= 0 then
                    ChangeEtat(tank, "bas")
                end
            end
        else
            if tank.etat == "droite" then
                tank.x = tank.x + tank.vitesse * dt
                if tank.dureeEtat <= 0 then
                    ChangeEtat(tank, "bas")
                end
            elseif tank.etat == "gauche" then
                tank.x = tank.x - tank.vitesse * dt
                if tank.dureeEtat <= 0 then
                    ChangeEtat(tank, "bas")
                end
            elseif tank.etat == "bas" then
                tank.y = tank.y + tank.vitesse * dt
                if tank.dureeEtat <= 0 then
                    if tank.x < love.graphics.getWidth() / 2 then
                        ChangeEtat(tank, "droite")
                    elseif tank.y > love.graphics.getHeight() / 2 then
                        ChangeEtat(tank, "haut")
                    else
                        ChangeEtat(tank, "gauche")
                    end
                end
            elseif tank.etat == "haut" then
                tank.y = tank.y - tank.vitesse * dt
                if tank.dureeEtat <= 0 then
                    if tank.x < love.graphics.getWidth() / 2 then
                        ChangeEtat(tank, "droite")
                    elseif tank.y > love.graphics.getHeight() / 2 then
                        ChangeEtat(tank, "haut")
                    else
                        ChangeEtat(tank, "gauche")
                    end
                end
            end
        end
    end

    -- Changement etat tank Beige
    function EtatTankBeige(tank)
        if tank.etat == "bas" then
            tank.y = tank.y + tank.vitesse * dt
            if tank.y >= HAUTEUR_ECRAN - 40 then
                ChangeEtat(tank, "gauche")
            end
        elseif tank.etat == "haut" then
            tank.y = tank.y - tank.vitesse * dt
            if tank.y < 40 then
                ChangeEtat(tank, "droite")
            end
        end
        if tank.etat == "droite" then
            tank.x = tank.x + tank.vitesse * dt
            if tank.x > 40 and tank.y > 200 then
                ChangeEtat(tank, "haut")
            end
            if tank.x >= LARGEUR_ECRAN - 40 then
                ChangeEtat(tank, "bas")
            end
        elseif tank.etat == "gauche" then
            tank.x = tank.x - tank.vitesse * dt
            if tank.x >= LARGEUR_ECRAN - 100 and tank.x <= LARGEUR_ECRAN - 40 then
                if tank.y <= HAUTEUR_ECRAN - 200 then
                    ChangeEtat(tank, "bas")
                end
            end
            if tank.x < 40 then
                ChangeEtat(tank, "haut")
            end
        end
    end

    -- Changement etat tank Boss
    function EtatTankBoss(tank)
        local direction = math.random(1, 2)

        if tank.life <= 70 then
            tank.vitesse = 120
            if tank.life <= 40 then
                tank.dureeEtat = 1
                tank.vitesse = 200
                if tank.etat == "gauche" then
                    if tank.x <= 50 then
                        ChangeEtat(tank, "droite")
                    end
                elseif tank.etat == "droite" then
                    if tank.x >= LARGEUR_ECRAN - 50 then
                        ChangeEtat(tank, "gauche")
                    end
                end
            end
        end
        if tank.etat == "bas" then
            tank.y = tank.y + tank.vitesse * dt
            if tank.y >= HAUTEUR_ECRAN / 5 then
                if tank.dureeEtat <= 0 then
                    if direction == 1 then
                        ChangeEtat(tank, "gauche")
                    else
                        ChangeEtat(tank, "droite")
                    end
                end
            end
        elseif tank.etat == "haut" then
            tank.y = tank.y - tank.vitesse * dt
        end
        if tank.etat == "droite" then
            tank.x = tank.x + tank.vitesse * dt
            if tank.dureeEtat <= 0 then
                if direction == 1 then
                    ChangeEtat(tank, "gauche")
                else
                    ChangeEtat(tank, "droite")
                end
            end
        elseif tank.etat == "gauche" then
            tank.x = tank.x - tank.vitesse * dt
            if tank.dureeEtat <= 0 then
                if direction == 1 then
                    ChangeEtat(tank, "gauche")
                else
                    ChangeEtat(tank, "droite")
                end
            end
        end
    end

    -- Changement global etat tank
    for n = #enemys.lstTank, 1, -1 do
        local tank = enemys.lstTank[n]
        tank.dureeEtat = tank.dureeEtat - dt
        if tank.type == "TankVert" then
            EtatTankVert(tank)
        elseif tank.type == "TankBeige" then
            EtatTankBeige(tank)
        elseif tank.type == "TankBoss" then
            EtatTankBoss(tank)
        end

        -- Oblige les tanks à faire demi tour si ils sortent de l'écran.
        if tank.x <= 30 then
            ChangeEtat(tank, "droite")
        elseif tank.x >= LARGEUR_ECRAN - 20 then
            ChangeEtat(tank, "gauche")
        elseif tank.y <= 30 then
            ChangeEtat(tank, "bas")
        elseif tank.y >= HAUTEUR_ECRAN then
            ChangeEtat(tank, "haut")
        end
    end
end

function enemys.Draw()
    for k, v in pairs(enemys.lstTank) do
        local r = math.pi / 2
        if v.etat == "gauche" then
            r = math.pi * 3.5
        elseif v.etat == "bas" then
            r = math.pi
        elseif v.etat == "haut" then
            r = math.pi * 2
        end
        love.graphics.draw(
            v.images[1],
            v.x,
            v.y,
            r,
            v.scaleX,
            v.scaleY,
            v.images[1]:getWidth() / 2,
            v.images[1]:getHeight() / 2
        )
        love.graphics.draw(
            v.imageTourelle,
            v.x,
            v.y,
            v.tourelleAngle - math.pi * 1.5,
            v.scaleX,
            v.scaleY,
            v.imageTourelle:getWidth() / 2,
            v.imageTourelle:getHeight()
        )
        love.graphics.print("Vie: " .. v.life, v.x - 20, v.y - 40)
    end
end
return enemys
