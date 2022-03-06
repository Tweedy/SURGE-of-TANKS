local bullet= {}

local params = require("params")
local thePlayer = require("player")

local liste_tirs = {}


local imgBullet = love.graphics.newImage("images/Bullets/bulletBlueSilver_outline.png")

function CreeTir(pX, pY, pAngle, pVitesseX, pVitesseY)
    local tir = {}
    tir.x = pX
    tir.y = pY
    tir.angle = pAngle
    tir.vx = pVitesseX
    tir.vy = pVitesseY
  
    tir.width = imgBullet:getWidth()
    tir.height = imgBullet:getHeight()
  
    table.insert(liste_tirs, tir)
end

function bullet.update(dt)
    for kTir=#liste_tirs,1,-1 do
        local tir = liste_tirs[kTir]
        if  tir.y <= 0 - 20 or tir.y >= HAUTEUR_ECRAN + 20 or
            tir.x <= 0 - 20 or tir.x >= LARGEUR_ECRAN + 20 then
            table.remove(liste_tirs, kTir)
        end
    end

    
end

function bullet.draw()
    local y = 0
    for k,v in pairs(liste_tirs) do
        love.graphics.draw(imgBullet, v.x, v.y, v.angle - math.pi * 1.5, 0.5, 0.5, v.width/2, v.height/2)
        if PAUSE == false then
            v.y = v.y + v.vy
            v.x = v.x + v.vx
        end
        if STATS_DEBUG == true then
            love.graphics.print("Balles direction: "..v.x.."  "..v.y.."  "..v.vx.."  "..v.vy, 200, y + 15 * k)
        end
    end
end


return bullet