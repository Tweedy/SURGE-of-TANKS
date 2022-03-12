-----------------------------------------------------------------------------------------------------------
-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')


-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end
-----------------------------------------------------------------------------------------------------------

-- Variables
local lstSprites = {}

local mouseX = 0
local mouseY = 0

local timerMachineGun = 0


-- Modules
local myPlayer = require("player")
local bullets = require("bullet")
local theEnemys = require("enemys")
local params = require("params")


------------------------------------------ FONCTIONS ---------------------------------------------------------

-- Renvoie l'angle entre deux vecteurs ayant la même origine.
function math.angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end


function InitGame() -- Pour la remise à zéro de la partie
  myPlayer.x = LARGEUR_ECRAN /2
  myPlayer.y = HAUTEUR_ECRAN - 100
  myPlayer.angle = math.pi * 1.5
  myPlayer.angleCannon = math.pi * 1.5
end

function Collide(a1, a2)
  if (a1==a2) then return false end
  if(a1.x < a2.x + a2.width*a2.scaleX and 
     a1.x + a1.width *a1.scaleX > a2.x and
     a1.y < a2.y + a2.height*a2.scaleY and
     a1.y + a1.height*a1.scaleY > a2.y) then
      return true
  end 

  return false
end

-----------------------------------------------------------------------------------------------------------
------------------------------------------- LOAD ----------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
function love.load()
  Ecran()
  InitGame()
end


-----------------------------------------------------------------------------------------------------------
------------------------------------------ UPDATE ---------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
function UpdateJeu(dt)
  dt = math.min(dt, 1/60)

  if love.keyboard.isDown("d") then
    myPlayer.rotate(1*dt)
  elseif love.keyboard.isDown("q") then
    myPlayer.rotate(-1*dt)
  end
  
  if love.keyboard.isDown("z") then
      myPlayer.accelerate(300*dt)
  elseif love.keyboard.isDown("s") then
      myPlayer.accelerate(-300*dt)
  end
  love.mouse.isVisible()
  function love.mousemoved(pX, pY) -- Donne la position du curseur au canon du tank joueurqqss
    mouseX = pX
    mouseY = pY
  end
  if params.pause == false then
    myPlayer.angleCannon = math.angle(myPlayer.x,myPlayer.y,mouseX,mouseY)
    for k,v in pairs (theEnemys.lstGreenTank) do
      v.tourelleAngle = math.angle(v.x,v.y,myPlayer.x,myPlayer.y)
    end
  else
    myPlayer.old_angleCannon = myPlayer.angleCannon
    for k,v in pairs (theEnemys.lstGreenTank) do
      v.tourelleAngle = math.angle(v.x,v.y,myPlayer.x,myPlayer.y)
      myPlayer.old_angleCannon = v.tourelleAngle
    end
  end
  myPlayer.update(dt)
  if timerMachineGun <= 0 then
    if love.mouse.isDown(2) then -- Tire une balle en direction du curseur
      local vx,vy
      vx = 10 * math.cos(myPlayer.angle)
      vy = 10 * math.sin(myPlayer.angle)

      local x1, y1 = 0, 0
      local x2, y2 = 0, 0
      x1 = myPlayer.x + 15 * math.cos(myPlayer.angle - math.pi / 4)
      y1 = myPlayer.y + 15 * math.sin(myPlayer.angle - math.pi / 4)
      x2 = myPlayer.x + 15 * math.cos(myPlayer.angle + math.pi / 4)
      y2 = myPlayer.y + 15 * math.sin(myPlayer.angle + math.pi / 4)

      CreeTirBalles(x1, y1, myPlayer.angle, vx, vy, lstSprites)
      CreeTirBalles(x2, y2, myPlayer.angle, vx, vy, lstSprites)
      timerMachineGun = 50
      myPlayer.mGunX = myPlayer.x - 11 * math.cos(myPlayer.angle - math.pi)
      myPlayer.mGunY = myPlayer.y - 11 * math.sin(myPlayer.angle - math.pi)
    end
  elseif timerMachineGun > 0 then

    myPlayer.mGunX = myPlayer.x - 14 * math.cos(myPlayer.angle - math.pi)
    myPlayer.mGunY = myPlayer.y - 14 * math.sin(myPlayer.angle - math.pi)
  end
  timerMachineGun = timerMachineGun - 10 * (60 * dt)
  

  bullets.update(dt)

  -- Determine avec quels elements le joueur peut collisionner
  local next_x, next_y = myPlayer.GetNextPos(dt)
  if myPlayer.nextPosX > LARGEUR_ECRAN - 20 then
    myPlayer.x = LARGEUR_ECRAN - 20
    myPlayer.vitesse = 0
  end
  if myPlayer.nextPosX < 20 then
    myPlayer.x = 20
    myPlayer.vitesse = 0
  end
  if myPlayer.nextPosY > HAUTEUR_ECRAN  - 20 then
      myPlayer.y = HAUTEUR_ECRAN - 20
      myPlayer.vitesse = 0
  end
  if myPlayer.nextPosY < 20 then
    myPlayer.y = 20
    myPlayer.vitesse = 0
  end

  --Fait aparaitre les ennemies
  theEnemys.timerSpawnTank = theEnemys.timerSpawnTank + dt
  if theEnemys.timerSpawnTank >= theEnemys.frequSpawnTank then
    theEnemys.timerSpawnTank = 0
    SpawnGreenTank(lstSprites)
  end
  
  -- Supprime les sprites qui ne sont pas affiché à l'ecran
  --  Verifie si le tank est sorti de l'écran.
  for k=#lstSprites,1,-1 do
    local sprite = lstSprites[k]
    if sprite.y <= 0 or sprite.y >= HAUTEUR_ECRAN or
        sprite.x <= 0 or sprite.x >= LARGEUR_ECRAN then
        table.remove(lstSprites, k)
    end
  end

  -- Supprime les ennemies et les balles si il y a eu collision
  for kTir=#bullets.liste_tirs,1,-1 do
    local tir = bullets.liste_tirs[kTir]
    for kTank=#theEnemys.lstGreenTank,1,-1 do
      local tank = theEnemys.lstGreenTank[kTank]
      if Collide(tir, tank) then
        for kSprite=#lstSprites,1,-1 do
          local sprite = lstSprites[kSprite]
          if sprite == tank or sprite == tir then
            table.remove(lstSprites, kSprite)
          end
        end
        table.remove(theEnemys.lstGreenTank, kTank)
        table.remove(bullets.liste_tirs, kTir)
      end
    end
  end

end



function love.update(dt)
  if params.pause == false then
    UpdateJeu(dt)
    theEnemys.Update(dt)
  end
end


-----------------------------------------------------------------------------------------------------------
------------------------------------------- DRAW ----------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
function love.draw()
  
    bullets.draw()
    myPlayer.draw()
    theEnemys.draw()

  -- Affiche les informations de degugage
  if params.stats_debug == true then
    love.graphics.print("Vitesse: "..myPlayer.speed, myPlayer.x + 30, myPlayer.y -5)
    love.graphics.print("X: "..math.floor(myPlayer.x)..", Y: "..math.floor(myPlayer.y), myPlayer.x + 30, myPlayer.y + 10)
    love.graphics.print("Angle: "..myPlayer.angle, myPlayer.x + 30, myPlayer.y -20)
    love.graphics.print("Nb de sprites : "..#lstSprites, 10,10)
    love.graphics.print("Nb de tanks vert: "..#theEnemys.lstGreenTank, 10,25)
    love.graphics.print("Nb de balles': "..#bullets.liste_tirs, 10,40)
    for k,v in pairs (theEnemys.lstGreenTank) do
      love.graphics.print("Angle: "..v.tourelleAngle, v.x +20, v.y -20)
    end
  end
end



-----------------------------------------------------------------------------------------------------------
----------------------------------------- CONTROL ---------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
function love.keypressed(key)
  if key == "p" then
    params.pause = not params.pause
  end

  if key == "a" then
    params.stats_debug = not params.stats_debug
  end
  print(key)
  
  
end

function love.mousepressed(x, y, button)
  if params.pause == false then
    if button == 1 then -- Tire une balle en direction du curseur
      local vx,vy
            vx = 4 * math.cos(myPlayer.angleCannon)
            vy = 4 * math.sin(myPlayer.angleCannon)
      CreeTirObus(myPlayer.x + vx*2,myPlayer.y + vy*2,myPlayer.angleCannon, vx, vy, lstSprites)
    end
  end
end
