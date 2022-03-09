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
  function love.mousemoved(pX, pY) -- Donne la position du curseur au canon du tank joueur
    mouseX = pX
    mouseY = pY
  end
  if params.pause == false then
    myPlayer.angleCannon = math.angle(myPlayer.x,myPlayer.y,mouseX,mouseY)
  else
    myPlayer.old_angleCannon = myPlayer.angleCannon
    myPlayer.angleCannon = myPlayer.old_angleCannon
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
      myPlayer.mGunX = myPlayer.x - 15 * math.cos(myPlayer.angle - math.pi)
      myPlayer.mGunY = myPlayer.y - 15 * math.sin(myPlayer.angle - math.pi)
    end
  else
     myPlayer.mGunX = myPlayer.x - 12 * math.cos(myPlayer.angle - math.pi)
    myPlayer.mGunY = myPlayer.y - 12 * math.sin(myPlayer.angle - math.pi)
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
end

-- Méthode 1 : L'objet me donne les infos pour que je fasse le taf


function love.update(dt)
  if params.pause == false then
    UpdateJeu(dt)
  end
end


-----------------------------------------------------------------------------------------------------------
------------------------------------------- DRAW ----------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
function love.draw()
    
    bullets.draw()
    myPlayer.draw()
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
