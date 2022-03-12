local enemys = {}


enemys.lstGreenTank = {}
enemys.timerSpawnTank = 1
enemys.frequSpawnTank = 2

local params = require("params")


function SpawnGreenTank(pLstSprites)
    print("Spawn un tank")
    local tank = {}
    tank = CreateSprite(pLstSprites, "TankVert", "Tanks/tankGreen_", 1)
    tank.x = 500 --math.random(10, LARGEUR_ECRAN-10)
    tank.y = 100 --math.random(10, HAUTEUR_ECRAN-10)
    tank.etat = "droite"
    tank.dureeEtat = math.random(1, 4)
    tank.vitesse = math.random(60, 120)
    table.insert(enemys.lstGreenTank, tank)
end

function enemys.draw()
    for k,v in pairs(enemys.lstGreenTank) do
        --love.graphics.rectangle("line", v.x, v.y, 75, 70)
        --love.graphics.draw(v.images[1], v.x, v.y, 0, 1, 1)
    end
end
return enemys
