local globalParams = require("params")

local item = {}
item.imgRepair = love.graphics.newImage("images/Environment/icone_repair.png")
item.width = item.imgRepair:getWidth()
item.height = item.imgRepair:getHeight()
item.scaleX = 1
item.scaleY = 1
item.x = 510
item.y = 500
item.visible = true

function item.Update()
    if item.visible == false then
        item.x = math.random(100, 950)
        item.y = math.random(100, 600)
        item.visible = true
    end
end

function item.Draw()
    if item.visible == true then
        love.graphics.draw(item.imgRepair, item.x, item.y, 0, item.scaleX, item.scaleY, item.width / 2, item.height / 2)
    end
end

return item
