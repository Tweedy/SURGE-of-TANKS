local bullet= {}
bullet.liste_tirs = {}
bullet.liste_enemyTirs = {}

local params = require("params")
local moduleCreateSprites = require("createSprites")




function CreeTirObus(pX, pY, pAngle, pVitesseX, pVitesseY, pLstSprites)
    local tir = {}
    tir = CreateSprite(pLstSprites, "obus", "Bullets/bulletBlueSilver_outline_", 1)
    tir.x = pX
    tir.y = pY
    tir.scaleX = 0.25
    tir.scaleY = 0.25
    tir.angle = pAngle
    tir.vx = pVitesseX
    tir.vy = pVitesseY
  
    table.insert(bullet.liste_tirs, tir)
end

function CreeGreenObus(pX, pY, pAngle, pVitesseX, pVitesseY, pLstSprites)
    local tir = {}
    tir = CreateSprite(pLstSprites, "ObusVert", "Bullets/bulletGreen_outline_", 1)
    tir.x = pX
    tir.y = pY
    tir.scaleX = 0.25
    tir.scaleY = 0.25
    tir.angle = pAngle
    tir.vx = pVitesseX
    tir.vy = pVitesseY
  
    table.insert(bullet.liste_enemyTirs, tir)
end

function CreeBeigeObus(pX, pY, pAngle, pVitesseX, pVitesseY, pLstSprites)
    local tir = {}
    tir = CreateSprite(pLstSprites, "ObusBeige", "Bullets/bulletBeige_outline_", 1)
    tir.x = pX
    tir.y = pY
    tir.scaleX = 0.25
    tir.scaleY = 0.25
    tir.angle = pAngle
    tir.vx = pVitesseX
    tir.vy = pVitesseY
  
    table.insert(bullet.liste_enemyTirs, tir)
end

function CreeRedObus(pX, pY, pAngle, pVitesseX, pVitesseY, pLstSprites)
    local tir = {}
    tir = CreateSprite(pLstSprites, "ObusRouge", "Bullets/bulletRed_outline_", 1)
    tir.x = pX
    tir.y = pY
    tir.scaleX = 0.5
    tir.scaleY = 0.5
    tir.angle = pAngle
    tir.vx = pVitesseX
    tir.vy = pVitesseY
  
    table.insert(bullet.liste_enemyTirs, tir)
end

function CreeTirBalles(pX, pY, pAngle, pVitesseX, pVitesseY, pLstSprites)
    local tir = {}
    tir = CreateSprite(pLstSprites, "balles", "Bullets/bulletBlue_", 1)
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
    for kTir=#bullet.liste_tirs,1,-1 do
        local tir = bullet.liste_tirs[kTir]
        tir.y = tir.y + tir.vy
        tir.x = tir.x + tir.vx
        if  tir.y <= 0 - 20 or tir.y >= HAUTEUR_ECRAN + 20 or
            tir.x <= 0 - 20 or tir.x >= LARGEUR_ECRAN + 20 then
            table.remove(bullet.liste_tirs, kTir)
        end
    end
    for kTir=#bullet.liste_enemyTirs,1,-1 do
        local tir = bullet.liste_enemyTirs[kTir]
        tir.y = tir.y + tir.vy
        tir.x = tir.x + tir.vx
        if  tir.y <= 0 - 20 or tir.y >= HAUTEUR_ECRAN + 20 or
            tir.x <= 0 - 20 or tir.x >= LARGEUR_ECRAN + 20 then
            table.remove(bullet.liste_enemyTirs, kTir)
        end
    end

    
end

function bullet.draw()
    
    local y = 1
    for k,v in pairs(bullet.liste_tirs) do
        love.graphics.draw(v.images[1], v.x, v.y, v.angle - math.pi * 1.5, v.scaleX, v.scaleY, v.width, v.height)
        
        -- Affiche les informations de degugage
        if params.stats_debug == true then
            love.graphics.print("Balles direction: X: "..math.floor(v.x)..", Y: "..math.floor(v.y)..",  Vx: "..math.floor(v.vx)..", Vy: "..math.floor(v.vy), 600, y + 15 * k)
        end
    end

    for k,v in pairs(bullet.liste_enemyTirs) do
        love.graphics.draw(v.images[1], v.x, v.y, v.angle - math.pi * 1.5, v.scaleX, v.scaleY, v.width, v.height)
        
        -- Affiche les informations de degugage
        if params.stats_debug == true then
            love.graphics.print("Balles direction: X: "..math.floor(v.x)..", Y: "..math.floor(v.y)..",  Vx: "..math.floor(v.vx)..", Vy: "..math.floor(v.vy), 600, y + 15 * k)
        end
    end
    
end


return bullet