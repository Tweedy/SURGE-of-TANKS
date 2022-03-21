local decor = {}

decor.liste_decors = {}

local globalParams = require("params")

function CreeDecor(pX, pY, pLstSprites, pType)
    local objet = {}
    local image = ""

    if pType == "ArbreMarronGrand" then
        image = "Environment/treeBrown_large_"
    elseif pType == "ArbreMarronPetit" then
        image = "Environment/treeBrown_small_"
    end

    objet = CreateSprite(pLstSprites, pType, image, 4)

    objet.x = pX
    objet.y = pY
    objet.angle = 1
    objet.scaleX = 1
    objet.scaleY = 1

    table.insert(decor.liste_decors, objet)
end

function decor.Load()
    CreeDecor(160, 260, globalParams.lstSprites, "ArbreMarronGrand")
    CreeDecor(50, 220, globalParams.lstSprites, "ArbreMarronPetit")
    CreeDecor(670, 280, globalParams.lstSprites, "ArbreMarronGrand")
    CreeDecor(820, 360, globalParams.lstSprites, "ArbreMarronPetit")
    CreeDecor(990, 30, globalParams.lstSprites, "ArbreMarronPetit")
    CreeDecor(160, 580, globalParams.lstSprites, "ArbreMarronPetit")
    CreeDecor(200, 600, globalParams.lstSprites, "ArbreMarronGrand")
end

function decor.Update(dt)
    local i
    for i, v in ipairs(decor.liste_decors) do
        v.currentFrame = v.currentFrame + 0.08 * 60 * dt
        if v.currentFrame >= #v.images + 1 then
            v.currentFrame = 1
        end
    end
end

function decor.Draw()
    for k, v in ipairs(decor.liste_decors) do
        if v.visible == true then
            local frame = v.images[math.floor(v.currentFrame)]
            love.graphics.draw(frame, v.x - v.width / 2, v.y - v.height / 2)
        end
    end
end
return decor
