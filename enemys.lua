local enemys = {}


enemys.lstGreenTank = {}
enemys.timerSpawnTank = 1
enemys.frequSpawnTank = 2

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
    tank.dureeEtat = math.random(1, 4)
    tank.vitesse = math.random(60, 120)
    table.insert(enemys.lstGreenTank, tank)

    tank.imageTourelle = love.graphics.newImage("images/Tanks/barrelGreen.png")
    tank.tourelleAngle = 0
    tank.old_tourelleAngle = 0
end

function ChangeEtat(pTank, pEtat)
    pTank.etat = pEtat
    pTank.dureeEtat = math.random(1, 2)
end

function enemys.Update(dt)
    for n = #enemys.lstGreenTank, 1, -1 do
        local tank = enemys.lstGreenTank[n]
        tank.dureeEtat = tank.dureeEtat - dt
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
                else
                    ChangeEtat(tank, "gauche")
                end
            end
        end


        -- Le tank est il sorti de l'écran ?
        if tank.x > love.graphics.getWidth() or tank.y > love.graphics.getHeight() then
            table.remove(enemys.lstGreenTank, n)
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
end
return enemys
