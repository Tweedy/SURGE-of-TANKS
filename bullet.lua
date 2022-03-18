local bullet = {}
bullet.liste_tirs = {}
bullet.liste_enemyTirs = {}

local globalParams = require("params")
local theEnemys = require("enemys")
local moduleCreateSprites = require("createSprites")

function CreeTir(pX, pY, pAngle, pVitesseX, pVitesseY, pLstSprites, pType)
    local tir = {}
    local image = ""

    if pType == "ObusBleu" then
        image = "Bullets/bulletBlueSilver_outline_"
    elseif pType == "ObusVert" then
        image = "Bullets/bulletGreen_outline_"
    elseif pType == "ObusBeige" then
        image = "Bullets/bulletBeige_outline_"
    elseif pType == "ObusRouge" then
        image = "Bullets/bulletRed_outline_"
    elseif pType == "BallesBleu" then
        image = "Bullets/bulletBlue_"
    end

    tir = CreateSprite(pLstSprites, pType, image, 1)

    tir.x = pX
    tir.y = pY
    tir.scaleX = 0.25
    tir.scaleY = 0.25
    tir.angle = pAngle
    tir.vx = pVitesseX
    tir.vy = pVitesseY

    table.insert(bullet.liste_tirs, tir)
end

function bullet.update(dt)
    -- Supprime les tirs qui depasse de la zone de jeu
    for kTir = #bullet.liste_tirs, 1, -1 do
        local tir = bullet.liste_tirs[kTir]
        tir.y = tir.y + tir.vy
        tir.x = tir.x + tir.vx
        if tir.y <= 0 - 20 or tir.y >= HAUTEUR_ECRAN + 20 or tir.x <= 0 - 20 or tir.x >= LARGEUR_ECRAN + 20 then
            table.remove(bullet.liste_tirs, kTir)
        end
    end

    -- Supprime les ennemies et les balles si il y a eu collision
    for kTir = #bullet.liste_tirs, 1, -1 do
        local tir = bullet.liste_tirs[kTir]
        for kTank = #theEnemys.lstTank, 1, -1 do
            local tank = theEnemys.lstTank[kTank]
            if tir.type == "ObusBleu" or tir.type == "BallesBleu" then
                if Collide(tir, tank) then
                    for kSprite = #globalParams.lstSprites, 1, -1 do
                        local sprite = globalParams.lstSprites[kSprite]
                        if sprite == tank or sprite == tir then
                            table.remove(globalParams.lstSprites, kSprite)
                            if tir.type == "BallesBleu" then
                                tank.life = tank.life - 1
                            else
                                tank.life = tank.life - 10
                            end
                        end
                    end
                    if tank.life <= 0 then
                        table.remove(theEnemys.lstTank, kTank)
                    end
                    table.remove(bullet.liste_tirs, kTir)
                end
            end
        end
    end

    for k, v in pairs(theEnemys.lstTank) do
        if v.timerTir <= 0 then
            v.timerTir = math.random(400, 700)
            local vx, vy
            vx = 4 * math.cos(v.tourelleAngle)
            vy = 4 * math.sin(v.tourelleAngle)
            if v.type == "TankVert" then
                CreeTir(v.x + vx * 2, v.y + vy * 2, v.tourelleAngle, vx, vy, globalParams.lstSprites, "ObusVert")
            elseif v.type == "TankBeige" then
                CreeTir(v.x + vx * 2, v.y + vy * 2, v.tourelleAngle, vx, vy, globalParams.lstSprites, "ObusBeige")
            else
                if v.life <= 40 and v.timerPauseTir == false then
                    theEnemys.bossPhase1 = false
                    v.timerTir = 80
                    v.timerPauseTir = true
                elseif v.life <= 40 and v.timerPauseTir == true then
                    theEnemys.bossPhase1 = false
                    v.timerTir = 400
                    v.timerPauseTir = false
                else
                    v.timerTir = math.random(400, 700)
                end
                CreeTir(v.x + vx * 12, v.y + vy * 12, v.tourelleAngle, vx, vy, globalParams.lstSprites, "ObusRouge")
            end
        end
        v.timerTir = v.timerTir - 10 * (60 * dt)
    end
end

function bullet.draw()
    local y = 1
    for k, v in pairs(bullet.liste_tirs) do
        love.graphics.draw(v.images[1], v.x, v.y, v.angle - math.pi * 1.5, v.scaleX, v.scaleY, v.width, v.height)

        -- Affiche les informations de degugage
        if globalParams.stats_debug == true then
            love.graphics.print(
                "Balles direction: X: " ..
                    math.floor(v.x) ..
                        ", Y: " .. math.floor(v.y) .. ",  Vx: " .. math.floor(v.vx) .. ", Vy: " .. math.floor(v.vy),
                600,
                y + 15 * k
            )
        end
    end

    for k, v in pairs(bullet.liste_enemyTirs) do
        love.graphics.draw(v.images[1], v.x, v.y, v.angle - math.pi * 1.5, v.scaleX, v.scaleY, v.width, v.height)

        -- Affiche les informations de degugage
        if globalParams.stats_debug == true then
            love.graphics.print(
                "Balles direction: X: " ..
                    math.floor(v.x) ..
                        ", Y: " .. math.floor(v.y) .. ",  Vx: " .. math.floor(v.vx) .. ", Vy: " .. math.floor(v.vy),
                600,
                y + 15 * k
            )
        end
    end
end

return bullet
