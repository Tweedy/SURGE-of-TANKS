local globalParams = require("params")

local moduleCreateSprites = {}

---------------------------------------- FONCTIONS --------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
function CreateSprite(pList, pType, psImageFile, pnFrames)
  local mySprite = {}
  mySprite.type = pType
  mySprite.visible = true

  mySprite.images = {}
  mySprite.currentFrame = 1
  local i
  for i = 1, pnFrames do
    local fileName = "images/" .. psImageFile .. tostring(i) .. ".png"
    print("Loading frame " .. fileName)
    mySprite.images[i] = love.graphics.newImage(fileName)
  end

  mySprite.width = mySprite.images[1]:getWidth()
  mySprite.height = mySprite.images[1]:getHeight()

  table.insert(pList, mySprite)

  return mySprite
end

-- Supprime les sprites qui ne sont pas affiché à l'ecran
function moduleCreateSprites.SupprSprite(dt)
  for k = #globalParams.lstSprites, 1, -1 do
    local sprite = globalParams.lstSprites[k]
    if sprite.y <= 0 or sprite.y >= HAUTEUR_ECRAN or sprite.x <= 0 or sprite.x >= LARGEUR_ECRAN then
      table.remove(globalParams.lstSprites, k)
    end
  end
end

return moduleCreateSprites
