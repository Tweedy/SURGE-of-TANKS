local bullet= {}

local params = require("params")
local moduleCreateSprites = require("createSprites")
local thePlayer = require("player")

local liste_tirs = {}



function CreeTirObus(pX, pY, pAngle, pVitesseX, pVitesseY, pLstSprites)
    local tir = {}
    tir = CreateSprite(pLstSprites, "obus", "Bullets/bulletBlueSilver_outline_", 1)
    tir.x = pX
    tir.y = pY
    tir.angle = pAngle
    tir.vx = pVitesseX
    tir.vy = pVitesseY
  
    table.insert(liste_tirs, tir)
end

function CreeTirBalles(pX, pY, pAngle, pVitesseX, pVitesseY, pLstSprites)
    local tir = {}
    tir = CreateSprite(pLstSprites, "balles", "Bullets/bulletBlue_", 1)
    tir.x = pX
    tir.y = pY
    tir.angle = pAngle
    tir.vx = pVitesseX
    tir.vy = pVitesseY
  
    table.insert(liste_tirs, tir)
end

function bullet.update(dt)
    for kTir=#liste_tirs,1,-1 do
        local tir = liste_tirs[kTir]
        tir.y = tir.y + tir.vy
        tir.x = tir.x + tir.vx
        if  tir.y <= 0 - 20 or tir.y >= HAUTEUR_ECRAN + 20 or
            tir.x <= 0 - 20 or tir.x >= LARGEUR_ECRAN + 20 then
            table.remove(liste_tirs, kTir)
        end
    end

    
end

function bullet.draw()
    local y = 0
    for k,v in pairs(liste_tirs) do
        love.graphics.draw(v.images[1], v.x, v.y, v.angle - math.pi * 1.5, 0.25, 0.25, v.width/2, v.height/2)
        if params.stats_debug == true then
            love.graphics.print("Balles direction: X: "..math.floor(v.x)..", Y: "..math.floor(v.y)..",  Vx: "..math.floor(v.vx)..", Vy: "..math.floor(v.vy), 600, y + 15 * k)
        end
    end
    
end


return bullet