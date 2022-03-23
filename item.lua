local item = {}

item.imgRepair = love.graphics.newImage("images/Environment/icone_repair.png")
item.width = item.imgRepair:getWidth()
item.height = item.imgRepair:getHeight()
item.scaleX = 1
item.scaleY = 1
item.x = 510
item.y = 500
item.visible = true

-----------------------------------------------------------------------------------------------------------
------------------------------------------ UPDATE ---------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
function item.Update() -- change les coordonnés de l'objet à chaque réaparition
    if item.visible == false then
        item.x = math.random(100, 950)
        item.y = math.random(100, 600)
        item.visible = true
    end
end

-----------------------------------------------------------------------------------------------------------
------------------------------------------- DRAW ----------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
function item.Draw() -- affiche l'objet
    if item.visible == true then
        love.graphics.draw(item.imgRepair, item.x, item.y, 0, item.scaleX, item.scaleY, item.width / 2, item.height / 2)
    end
end

return item
