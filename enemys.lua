local enemys = {}
enemys.color = nil
enemys.lstGreenTank = {}
enemys.lstRedTank = {}


enemys.timerSpawnTank = 1
enemys.frequSpawnTank = 2
enemys.totalSpwan = 0
enemys.surgeEnemy = 1

local params = require("params")
local myPlayer = require("player")


function SpawnGreenTank(pLstSprites)
    print("Spawn un tank")
    local tank = {}
    tank = CreateSprite(pLstSprites, "TankVert", "Tanks/tankGreen_", 1)
    tank.x = LARGEUR_ECRAN/2
    tank.y = -100
    tank.scaleX = 0.5
    tank.scaleY = 0.5
    tank.etat = "bas"
    tank.dureeEtat = math.random(1, 5)
    tank.vitesse = math.random(60, 120)
    table.insert(enemys.lstGreenTank, tank)

    tank.imageTourelle = love.graphics.newImage("images/Tanks/barrelGreen.png")
    tank.tourelleAngle = 0
end

function SpawnRedTank(pLstSprites)
    local tank = {}
    tank = CreateSprite(pLstSprites, "TankRouge", "Tanks/tankRed_", 1)
    tank.x = LARGEUR_ECRAN/2
    tank.y = -100
    tank.scaleX = 0.5
    tank.scaleY = 0.5
    tank.etat = "bas"
    tank.dureeEtat = math.random(1, 5)
    tank.vitesse = math.random(60, 120)
    table.insert(enemys.lstRedTank, tank)

    tank.imageTourelle = love.graphics.newImage("images/Tanks/barrelRed.png")
    tank.tourelleAngle = 0
end

function ChangeEtat(pTank, pEtat)
    pTank.etat = pEtat
    pTank.dureeEtat = math.random(1, 2)
end

function enemys.Update(dt)
    for n = #enemys.lstGreenTank, 1, -1 do
        local tank = enemys.lstGreenTank[n]
        local dist = math.dist(tank.x, tank.y, myPlayer.x, myPlayer.y)
        local rayDist = 100
        tank.dureeEtat = tank.dureeEtat - dt 
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





        -- Oblige les tanks à faire demi tour si ils sortent de l'écran.
        if tank.x <= 20 then
            ChangeEtat(tank, "droite")
        elseif tank.x >= LARGEUR_ECRAN-20 then
            ChangeEtat(tank, "gauche")
        elseif tank.y <= 20 then
            ChangeEtat(tank, "bas")
        elseif tank.y >= HAUTEUR_ECRAN then
            ChangeEtat(tank, "haut")
        end
    end
    for n = #enemys.lstRedTank, 1, -1 do
        local tank = enemys.lstRedTank[n]
        local dist = math.dist(tank.x, tank.y, myPlayer.x, myPlayer.y)
        local rayDist = 100
        tank.dureeEtat = tank.dureeEtat - dt 
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





        -- Oblige les tanks à faire demi tour si ils sortent de l'écran.
        if tank.x <= 20 then
            ChangeEtat(tank, "droite")
        elseif tank.x >= LARGEUR_ECRAN-20 then
            ChangeEtat(tank, "gauche")
        elseif tank.y <= 20 then
            ChangeEtat(tank, "bas")
        elseif tank.y >= HAUTEUR_ECRAN then
            ChangeEtat(tank, "haut")
        end
    end
end


function enemys.draw()
    for k,v in pairs(enemys.lstGreenTank) do
        local r = math.pi /2
        if v.etat == "gauche" then
            r = math.pi * 3.5
        elseif v.etat == "bas" then
            r = math.pi
        end
        love.graphics.draw(v.images[1], v.x, v.y, r, v.scaleX, v.scaleY, v.images[1]:getWidth()/2, v.images[1]:getHeight()/2)
        love.graphics.draw(v.imageTourelle, v.x , v.y, v.tourelleAngle - math.pi * 1.5, v.scaleX, v.scaleY, v.imageTourelle:getWidth()/2, v.imageTourelle:getHeight())
    end
    for k,v in pairs(enemys.lstRedTank) do
        local r = math.pi /2
        if v.etat == "gauche" then
            r = math.pi * 3.5
        elseif v.etat == "bas" then
            r = math.pi
        end
        love.graphics.draw(v.images[1], v.x, v.y, r, v.scaleX, v.scaleY, v.images[1]:getWidth()/2, v.images[1]:getHeight()/2)
        love.graphics.draw(v.imageTourelle, v.x , v.y, v.tourelleAngle - math.pi * 1.5, v.scaleX, v.scaleY, v.imageTourelle:getWidth()/2, v.imageTourelle:getHeight())
    end
end
return enemys
