local globalParams = require("params")
local myPlayer = require("player")

local enemys = {}
enemys.color = nil
enemys.lstTank = {}

enemys.timerSpawn = 1
enemys.frequSpawn = 2
enemys.totalSpwan = 0
enemys.bossPhase1 = true

-- Vague d'ennemis
enemys.Surge = {}
enemys.Surge.timer = 5
enemys.Surge.timerPlay = 5
enemys.Surge.nb = 1
enemys.Surge.pos = "droite"

---------------------------------------- FONCTIONS --------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
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

    tank.imgFullBar = love.graphics.newImage("images/Interface/red_full_bar.png")
    tank.imgEmptyBar = love.graphics.newImage("images/Interface/red_empty_bar.png")
    tank.FullQuad = nil

    if pType == "TankBoss" then
        tank.EmptyQuad = love.graphics.newQuad(0, 0, pLife * 4, 34, pLife * 4, 34)
    else
        tank.EmptyQuad = love.graphics.newQuad(0, 0, pLife * 4, 10, pLife * 4, 10)
    end

    tank.x = pX
    tank.y = pY
    tank.scaleX = pScaleX
    tank.scaleY = pScaleY
    tank.etat = pEtat
    tank.life = pLife
    tank.dureeEtat = math.random(1, 5)
    tank.vitesse = math.random(50, 100)
    tank.timerTir = 1000
    tank.timerPauseTir = false
    tank.tourelleAngle = 0

    table.insert(enemys.lstTank, tank)
end

function ChangeEtat(pTank, pEtat)
    pTank.etat = pEtat
    pTank.dureeEtat = math.random(1, 2)
end

-----------------------------------------------------------------------------------------------------------
------------------------------------------ UPDATE ---------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
function enemys.Update(dt)
    for k, v in pairs(enemys.lstTank) do
        -- Donne à la tourelle ennemie la position du joueur
        if enemys.bossPhase1 == true then
            v.tourelleAngle = math.angle(v.x, v.y, myPlayer.x, myPlayer.y)
        else
            v.tourelleAngle = math.angle(0, v.y, 0, myPlayer.y)
        end
        -- Donne la taille de la barre de vie du tank
        if v.type == "TankBoss" then
            v.FullQuad = love.graphics.newQuad(0, 0, v.life * 4, 34, v.life * 4, 34)
        else
            v.FullQuad = love.graphics.newQuad(0, 0, v.life * 4, 10, v.life * 4, 10)
        end
    end

    -- Changement etat tank Vert
    function EtatTankVert(tank)
        local dist = math.dist(tank.x, tank.y, myPlayer.x, myPlayer.y)
        local rayDist = 150

        -- Si l'ennemi s'approche trop pret du tank, il change sa direction
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
        else -- Il se deplace vers le milieu de la zone de jeu
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
        -- Les tanks tournent autour de l'écran dans le sens horaire
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
        -- Si la vie du tank baisse, il change sa vitesse et son deplacement
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
        -- Si le boss est suffisament descendu, il se deplace aléatoirement en axe X
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

-------------------------------------- VAGUE D'ENNEMIS ----------------------------------------------------
function enemys.SurgeEnemy(dt)
    --Fait aparaitre les ennemies par vague en fonction du timer
    enemys.Surge.timer = enemys.Surge.timer - 1 * dt
    enemys.timerSpawn = enemys.timerSpawn + dt

    -- Premiere vague
    if enemys.Surge.nb == 1 and enemys.Surge.timer > 0 then
        if globalParams.sonPlay == true then
            globalParams.sonVague1:play()
            globalParams.sonPlay = false
        end
    elseif enemys.Surge.nb == 1 then
        globalParams.sonPlay = true
        enemys.Surge.timer = 0
        if enemys.totalSpwan < 8 and enemys.timerSpawn >= enemys.frequSpawn then
            enemys.totalSpwan = enemys.totalSpwan + 1
            enemys.timerSpawn = 0
            SpawnTank(LARGEUR_ECRAN / 2, -100, 0.5, 0.5, "bas", 10, globalParams.lstSprites, "TankVert")
        elseif enemys.totalSpwan >= 8 then
            enemys.Surge.timer = 20
            enemys.Surge.nb = 2
            enemys.totalSpwan = 0
        end
    end

    -- Seconde vague
    if enemys.Surge.nb == 2 and enemys.Surge.timer >= 0 and enemys.Surge.timer <= enemys.Surge.timerPlay then
        if globalParams.sonPlay == true then
            globalParams.sonVague2:play()
            globalParams.sonPlay = false
        end
    elseif enemys.Surge.nb == 2 and enemys.Surge.timer < 0 then
        globalParams.sonPlay = true
        enemys.Surge.timer = 0
        if enemys.totalSpwan < 10 and enemys.timerSpawn >= enemys.frequSpawn then
            enemys.totalSpwan = enemys.totalSpwan + 1
            enemys.timerSpawn = 0
            if enemys.Surge.pos == "droite" then
                SpawnTank(
                    LARGEUR_ECRAN + 10,
                    (HAUTEUR_ECRAN / 2) + 32,
                    0.5,
                    0.5,
                    "gauche",
                    10,
                    globalParams.lstSprites,
                    "TankBeige"
                )
                enemys.Surge.pos = "gauche"
            else
                SpawnTank(-10, (HAUTEUR_ECRAN / 2) + 32, 0.5, 0.5, "droite", 10, globalParams.lstSprites, "TankBeige")
                enemys.Surge.pos = "droite"
            end
        elseif enemys.totalSpwan >= 10 then
            enemys.Surge.timer = 20
            enemys.Surge.nb = 3
            enemys.totalSpwan = 0
            enemys.timerSpawn = 0
        end
    end

    -- Boss final
    if enemys.Surge.nb == 3 and enemys.Surge.timer >= 0 and enemys.Surge.timer < 6 then
        if globalParams.sonPlay == true then
            globalParams.sonBoss:play()
            globalParams.sonPlay = false
        end
    elseif enemys.Surge.nb == 3 and enemys.Surge.timer < 0 then
        enemys.Surge.timer = 0
        if enemys.totalSpwan == 0 then
            enemys.totalSpwan = enemys.totalSpwan + 1
            SpawnTank(LARGEUR_ECRAN / 2, -100, 1, 1, "bas", 100, globalParams.lstSprites, "TankBoss")
        end
    end
end

-----------------------------------------------------------------------------------------------------------
------------------------------------------- DRAW ----------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
function enemys.SurgeDraw() -- Affiche le decompte avant la prochaine vague
    if enemys.Surge.timer ~= 0 then
        love.graphics.print(
            {{1, 1, 1}, math.floor(enemys.Surge.timer) .. " sec. avant la prochaine vague !"},
            LARGEUR_ECRAN / 2,
            40,
            0,
            1,
            1,
            globalParams.textWidth / 2
        )
    end
    if enemys.Surge.timer > 0 and enemys.Surge.timer <= enemys.Surge.timerPlay then
        love.graphics.setFont(globalParams.FONT_TITRE)
        love.graphics.print(
            {{1, 0, 0}, "Vague " .. enemys.Surge.nb},
            LARGEUR_ECRAN / 2,
            HAUTEUR_ECRAN / 2 - 90,
            0,
            1,
            1,
            globalParams.titreWidth / 2
        )
        love.graphics.setFont(globalParams.FONT_TEXTE)
    end
end

function enemys.Draw()
    for k, v in pairs(enemys.lstTank) do
        -- Change l'angle de l'image en fonction de la direction du tank
        local r = math.pi / 2
        if v.etat == "gauche" then
            r = math.pi * 3.5
        elseif v.etat == "bas" then
            r = math.pi
        elseif v.etat == "haut" then
            r = math.pi * 2
        end

        -- Affichage de l'ennemi
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

        -- Barre de vie des ennemis
        if v.type == "TankBoss" then
            local titre = "BOSS FINAL"
            local titreBossWidth = globalParams.FONT_TEXTE:getWidth(titre)

            love.graphics.draw(v.imgFullBar, v.FullQuad, LARGEUR_ECRAN / 2 - 200, HAUTEUR_ECRAN - 50)
            love.graphics.draw(v.imgEmptyBar, v.EmptyQuad, LARGEUR_ECRAN / 2 - 200, HAUTEUR_ECRAN - 50)
            love.graphics.print(titre, LARGEUR_ECRAN / 2 - titreBossWidth / 2, HAUTEUR_ECRAN - 40)
        else
            love.graphics.draw(v.imgFullBar, v.FullQuad, v.x - 20, v.y - 40)
            love.graphics.draw(v.imgEmptyBar, v.EmptyQuad, v.x - 20, v.y - 40)
        end
    end
end
return enemys
