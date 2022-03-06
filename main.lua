-----------------------------------------------------------------------------------------------------------
-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end
-----------------------------------------------------------------------------------------------------------

-- Variables
local mouseX = 0
local mouseY = 0


-- Modules
local thePlayer = require("player")
local bullets = require("bullet")
local params = require("params")

-- Renvoie l'angle entre deux vecteurs ayant la même origine.
function math.angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end


function InitGame() -- Pour la remise à zéro de la partie
  thePlayer.x = LARGEUR_ECRAN /2
  thePlayer.y = HAUTEUR_ECRAN - 100
  thePlayer.angle = math.pi * 1.5
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
    thePlayer.rotate(1*dt)
  elseif love.keyboard.isDown("q") then
    thePlayer.rotate(-1*dt)
  end
  
  if love.keyboard.isDown("z") then
    thePlayer.accelerate(300*dt)
  elseif love.keyboard.isDown("s") then
      thePlayer.accelerate(-300*dt)
  end

  function love.mousemoved(pX, pY) -- Donne la position du curseur au canon du tank joueur
    if PAUSE == false then
      thePlayer.angleCannon = math.angle(thePlayer.x,thePlayer.y,pX,pY)
    else
      thePlayer.old_angleCannon = thePlayer.angleCannon
      thePlayer.angleCannon = thePlayer.old_angleCannon
    end
    mouseX = pX
    mouseY = pY
  end


  thePlayer.update(dt)
  bullets.update(dt)
end

function love.update(dt)
  if PAUSE == false then
    UpdateJeu(dt)
  end
end


-----------------------------------------------------------------------------------------------------------
------------------------------------------- DRAW ----------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
function love.draw()
  bullets.draw()
  thePlayer.draw()
end



-----------------------------------------------------------------------------------------------------------
----------------------------------------- CONTROL ---------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
function love.keypressed(key)
  if key == "p" then
    PAUSE = not PAUSE
  end

  if key == "space" then -- Tire une balle en direction du curseur
    local vx,vy
          local angle
          angle = math.angle(thePlayer.x,thePlayer.y,mouseX,mouseY)
          vx = 10 * math.cos(angle)
          vy = 10 * math.sin(angle)
    CreeTir(thePlayer.x + vx*5,thePlayer.y + vy*5,thePlayer.angleCannon, vx, vy)
  end

  if key == "a" then
    STATS_DEBUG = not STATS_DEBUG
  end
  print(key)
  
end
  