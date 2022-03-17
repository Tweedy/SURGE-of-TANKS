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
local timerEnemyMG = 0
local timerVague = 10

local Surge = {}
Surge.timer = 2
Surge.nb = 1
Surge.print = false
Surge.pos = "droite"


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

function Collide(a1, a2) -- Permet de calculer le point de collision
  local a1L = a1.width*a1.scaleX
  local a1H = a1.height*a1.scaleY
  local a2L = a2.width*a2.scaleX
  local a2H = a2.height*a2.scaleY
  if a1 == a2 then
    return false
  end
  if a1.x-(a1L/2) < a2.x-(a2L/2) + a2L and 
     a1.x + a1L > a2.x-(a2L/2) and
     a1.y < a2.y + a2H-(a2H/2) and
     a1.y + a1H > a2.y-(a2H/2) then
    return true
  end 
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

  ------------------------------------- CONTROL JOUEUR ----------------------------------------------------
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
  function love.mousemoved(pX, pY) -- Donne la position du curseur au canon du tank joueur
    mouseX = pX
    mouseY = pY
  end
  myPlayer.angleCannon = math.angle(myPlayer.x,myPlayer.y,mouseX,mouseY) --Donne l'angle du cannon 
  for k,v in pairs (theEnemys.lstGreenTank) do -- Donne à la tourelle ennemie la position du joueur
    v.tourelleAngle = math.angle(v.x,v.y,myPlayer.x,myPlayer.y)
  end
  for k,v in pairs (theEnemys.lstBeigeTank) do
    v.tourelleAngle = math.angle(v.x,v.y,myPlayer.x,myPlayer.y)
  end
  for k,v in pairs (theEnemys.lstBoss) do
    v.tourelleAngle = math.angle(v.x,v.y,myPlayer.x,myPlayer.y)
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

  --Fait aparaitre les ennemies par vague
  Surge.timer = Surge.timer - 1 *dt
  theEnemys.timerSpawn = theEnemys.timerSpawn + dt
  
  if Surge.nb == 1 and Surge.timer > 0 then
    Surge.print = true
  elseif Surge.nb == 1 then
    Surge.print = false
    Surge.timer = 0
    if theEnemys.totalSpwan < 10 and theEnemys.timerSpawn >= theEnemys.frequSpawn then
      theEnemys.totalSpwan = theEnemys.totalSpwan + 1
      theEnemys.timerSpawn = 0
      SpawnGreenTank(lstSprites)
    elseif theEnemys.totalSpwan >= 10 then
      Surge.timer = 20
      Surge.nb = 2
      theEnemys.totalSpwan = 0
    end
  end
  if Surge.nb == 2 and Surge.timer >= 0 and Surge.timer < 6 then
    Surge.print = true
  elseif Surge.nb == 2 and Surge.timer < 0 then
    Surge.print = false
    Surge.timer = 0
    if theEnemys.totalSpwan < 10 and theEnemys.timerSpawn >= theEnemys.frequSpawn then
      theEnemys.totalSpwan = theEnemys.totalSpwan + 1
      theEnemys.timerSpawn = 0
      if Surge.pos == "droite" then
        SpawnBeigeTank(LARGEUR_ECRAN + 10, HAUTEUR_ECRAN/2, "gauche", lstSprites)
        Surge.pos = "gauche"
      else
        SpawnBeigeTank(-10, HAUTEUR_ECRAN/2, "droite", lstSprites)
        Surge.pos = "droite"
      end
    elseif theEnemys.totalSpwan >= 10 then
      Surge.timer = 20
      Surge.nb = 3
      theEnemys.totalSpwan = 0
      theEnemys.timerSpawn = 0
    end
  end
  if Surge.nb == 3 and Surge.timer >= 0 and Surge.timer < 6 then
    Surge.print = true
  elseif Surge.nb == 3 and Surge.timer < 0 then
    Surge.print = false
    Surge.timer = 0
    if theEnemys.totalSpwan == 0 then
      theEnemys.totalSpwan = theEnemys.totalSpwan + 1
      SpawnBoss(lstSprites)
    end
  end
  
  -- Supprime les sprites qui ne sont pas affiché à l'ecran
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
            if tir.type == "balles" then
              tank.life = tank.life - 1
            else
              tank.life = tank.life - 10
            end
          end
        end
        if tank.life <= 0 then
          table.remove(theEnemys.lstGreenTank, kTank)
        end
        table.remove(bullets.liste_tirs, kTir)
      end
    end
  end

  for kTir=#bullets.liste_tirs,1,-1 do
    local tir = bullets.liste_tirs[kTir]
    for kTank=#theEnemys.lstBeigeTank,1,-1 do
      local tank = theEnemys.lstBeigeTank[kTank]
      if Collide(tir, tank) then
        for kSprite=#lstSprites,1,-1 do
          local sprite = lstSprites[kSprite]
          if sprite == tank or sprite == tir then
            table.remove(lstSprites, kSprite)
            if tir.type == "balles" then
              tank.life = tank.life - 1
            else
              tank.life = tank.life - 10
            end
          end
        end
        if tank.life <= 0 then
          table.remove(theEnemys.lstBeigeTank, kTank)
        end
        table.remove(bullets.liste_tirs, kTir)
      end
    end
  end

  for kTir=#bullets.liste_tirs,1,-1 do
    local tir = bullets.liste_tirs[kTir]
      for kTank=#theEnemys.lstBoss,1,-1 do
        local tank = theEnemys.lstBoss[kTank]
        if Collide(tir, tank) then
          for kSprite=#lstSprites,1,-1 do
            local sprite = lstSprites[kSprite]
            if sprite == tank or sprite == tir then
              table.remove(lstSprites, kSprite)
              if tir.type == "balles" then
                tank.life = tank.life - 1
              else
                tank.life = tank.life - 10
              end
            end
          end
          if tank.life <= 0 then
            table.remove(theEnemys.lstBoss, kTank)
            print("gagné !")
          end
          table.remove(bullets.liste_tirs, kTir)
        end
    end
  end

  
  if timerEnemyMG <= 0 then
    for k, v in pairs(theEnemys.lstGreenTank) do
      local vx,vy
                vx = 4 * math.cos(v.tourelleAngle)
                vy = 4 * math.sin(v.tourelleAngle)
          CreeGreenObus(v.x,v.y,v.tourelleAngle, vx, vy, lstSprites)
    end
    timerEnemyMG = math.random(400, 700)
  end
  timerEnemyMG = timerEnemyMG - 10 * (60 * dt)
  
  if timerEnemyMG <= 0 then
    for k, v in pairs(theEnemys.lstBeigeTank) do
      local vx,vy
                vx = 4 * math.cos(v.tourelleAngle)
                vy = 4 * math.sin(v.tourelleAngle)
          CreeBeigeObus(v.x,v.y,v.tourelleAngle, vx, vy, lstSprites)
    end
    timerEnemyMG = math.random(400, 700)
  end
  timerEnemyMG = timerEnemyMG - 10 * (60 * dt)

  if timerEnemyMG <= 0 then
    for k, v in pairs(theEnemys.lstBoss) do
      local vx,vy
                vx = 4 * math.cos(v.tourelleAngle)
                vy = 4 * math.sin(v.tourelleAngle)
          CreeRedObus(v.x,v.y,v.tourelleAngle, vx, vy, lstSprites)
    end
    timerEnemyMG = math.random(400, 700)
  end
  timerEnemyMG = timerEnemyMG - 10 * (60 * dt)
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
    if Surge.print == true then
      love.graphics.print(math.floor(Surge.timer).." sec. avant la prochaine vague !",LARGEUR_ECRAN/2-40,50)
    end
    if Surge.print == true then
      love.graphics.print("Vague "..Surge.nb,LARGEUR_ECRAN/2,HAUTEUR_ECRAN/2)
    end

  -- Affiche les informations de degugage
  if params.stats_debug == true then
    love.graphics.print("Vitesse: "..myPlayer.speed, myPlayer.x + 30, myPlayer.y -5)
    love.graphics.print("X: "..math.floor(myPlayer.x)..", Y: "..math.floor(myPlayer.y), myPlayer.x + 30, myPlayer.y + 10)
    love.graphics.print("Angle: "..myPlayer.angle, myPlayer.x + 30, myPlayer.y -20)
    love.graphics.print("Nb de sprites: "..#lstSprites, 10,10)
    love.graphics.print("Nb de tanks vert: "..#theEnemys.lstGreenTank, 10,25)
    love.graphics.print("Nb de balles: "..#bullets.liste_tirs, 10,40)
    love.graphics.print("Vague d'ennemies n°"..Surge.nb, 10,55)
    love.graphics.print("Enemies crée: "..theEnemys.totalSpwan, 10,70)
    love.graphics.print("Timer vague: "..Surge.timer, 10,85)
    love.graphics.print("Timer spawn: "..theEnemys.timerSpawn, 10,100)
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
