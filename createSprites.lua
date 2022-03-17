local moduleCreateSprites = {}


function CreateSprite(pList, pType, psImageFile, pnFrames)
    local mySprite = {}
    mySprite.type = pType
    mySprite.visible = true
    
    mySprite.images = {}
    mySprite.currentFrame = 1
    local i
    for i=1,pnFrames do
      local fileName = "images/"..psImageFile..tostring(i)..".png"
      print("Loading frame "..fileName)
      mySprite.images[i] = love.graphics.newImage(fileName)
    end
    
    mySprite.width = mySprite.images[1]:getWidth()
    mySprite.height = mySprite.images[1]:getHeight()
    
    table.insert(pList, mySprite)
    
    return mySprite
end

return moduleCreateSprites