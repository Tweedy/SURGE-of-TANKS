-----------------------------------------------------------------------------------------------------------
-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then
  require("mobdebug").start()
end
-----------------------------------------------------------------------------------------------------------

-- Modules
local myPlayer = require("player")
local bullets = require("bullet")
local theEnemys = require("enemys")
local globalParams = require("params")
local background = require("terrain")
local objetsDecor = require("decor")

local timerMachineGun = 0

-- curseur souri
local mouseX = 0
local mouseY = 0

local Surge = {}
Surge.timer = 10
Surge.nb = 1
Surge.print = false
Surge.pos = "droite"

--------------------------------------- FONCTIONS ---------------------------------------------------------

function InitGame() -- Pour la remise à zéro de la partie
  myPlayer.x = LARGEUR_ECRAN / 2
  myPlayer.y = HAUTEUR_ECRAN - 100
  myPlayer.angle = math.pi * 1.5
  myPlayer.angleCannon = math.pi * 1.5
  myPlayer.life = myPlayer.maxLife

  Surge.nb = 1
  Surge.timer = 10
  theEnemys.bossPhase1 = true
  theEnemys.totalSpwan = 0

  theEnemys.lstTank = {}
  globalParams.lstSprites = {}
  bullets.liste_tirs = {}
end

-----------------------------------------------------------------------------------------------------------
------------------------------------------- LOAD ----------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
function love.load()
  Ecran()
  InitGame()
  background.Load()
  objetsDecor.Load()
end

-----------------------------------------------------------------------------------------------------------
------------------------------------------ UPDATE ---------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
function UpdateJeu(dt)
  dt = math.min(dt, 1 / 60)

  ---------------------------------- CONTROL DU JOUEUR ----------------------------------------------------
  if love.keyboard.isDown("d") then
    myPlayer.rotate(1 * dt)
  elseif love.keyboard.isDown("q") then
    myPlayer.rotate(-1 * dt)
  end
  if love.keyboard.isDown("z") then
    myPlayer.accelerate(300 * dt)
  elseif love.keyboard.isDown("s") then
    myPlayer.accelerate(-300 * dt)
  end

  love.mouse.isVisible()
  function love.mousemoved(pX, pY) -- Donne la position du curseur au canon du tank joueur
    mouseX = pX
    mouseY = pY
  end

  myPlayer.angleCannon = math.angle(myPlayer.x, myPlayer.y, mouseX, mouseY) --Donne l'angle du cannon

  myPlayer.update(dt)
  if timerMachineGun <= 0 then
    if love.mouse.isDown(2) then -- Tire une balle en direction du curseur
      local vx, vy
      vx = 10 * math.cos(myPlayer.angle)
      vy = 10 * math.sin(myPlayer.angle)

      local x1, y1 = 0, 0
      local x2, y2 = 0, 0
      x1 = myPlayer.x + 15 * math.cos(myPlayer.angle - math.pi / 4)
      y1 = myPlayer.y + 15 * math.sin(myPlayer.angle - math.pi / 4)
      x2 = myPlayer.x + 15 * math.cos(myPlayer.angle + math.pi / 4)
      y2 = myPlayer.y + 15 * math.sin(myPlayer.angle + math.pi / 4)

      CreeTir(x1, y1, myPlayer.angle, vx, vy, globalParams.lstSprites, "BallesBleu")
      CreeTir(x2, y2, myPlayer.angle, vx, vy, globalParams.lstSprites, "BallesBleu")
      timerMachineGun = 50
      myPlayer.mGunX = myPlayer.x - 11 * math.cos(myPlayer.angle - math.pi)
      myPlayer.mGunY = myPlayer.y - 11 * math.sin(myPlayer.angle - math.pi)
    end
  elseif timerMachineGun > 0 then
    myPlayer.mGunX = myPlayer.x - 14 * math.cos(myPlayer.angle - math.pi)
    myPlayer.mGunY = myPlayer.y - 14 * math.sin(myPlayer.angle - math.pi)
  end
  timerMachineGun = timerMachineGun - 10 * (60 * dt)

  bullets.Update(dt)
  background.Update()

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
  if myPlayer.nextPosY > HAUTEUR_ECRAN - 20 then
    myPlayer.y = HAUTEUR_ECRAN - 20
    myPlayer.vitesse = 0
  end
  if myPlayer.nextPosY < 20 then
    myPlayer.y = 20
    myPlayer.vitesse = 0
  end

  --Fait aparaitre les ennemies par vague
  Surge.timer = Surge.timer - 1 * dt
  theEnemys.timerSpawn = theEnemys.timerSpawn + dt

  if Surge.nb == 1 and Surge.timer > 0 then
    Surge.print = true
    if globalParams.sonPlay == true then
      globalParams.sonVague1:play()
      globalParams.sonPlay = false
    end
  elseif Surge.nb == 1 then
    globalParams.sonPlay = true
    Surge.print = false
    Surge.timer = 0
    if theEnemys.totalSpwan < 10 and theEnemys.timerSpawn >= theEnemys.frequSpawn then
      theEnemys.totalSpwan = theEnemys.totalSpwan + 1
      theEnemys.timerSpawn = 0
      SpawnTank(LARGEUR_ECRAN / 2, -100, 0.5, 0.5, "bas", 10, globalParams.lstSprites, "TankVert")
    elseif theEnemys.totalSpwan >= 10 then
      Surge.timer = 20
      Surge.nb = 2
      theEnemys.totalSpwan = 0
    end
  end
  if Surge.nb == 2 and Surge.timer >= 0 and Surge.timer < 6 then
    Surge.print = true
    if globalParams.sonPlay == true then
      globalParams.sonVague2:play()
      globalParams.sonPlay = false
    end
  elseif Surge.nb == 2 and Surge.timer < 0 then
    globalParams.sonPlay = true
    Surge.print = false
    Surge.timer = 0
    if theEnemys.totalSpwan < 10 and theEnemys.timerSpawn >= theEnemys.frequSpawn then
      theEnemys.totalSpwan = theEnemys.totalSpwan + 1
      theEnemys.timerSpawn = 0
      if Surge.pos == "droite" then
        SpawnTank(
          LARGEUR_ECRAN + 10,
          (HAUTEUR_ECRAN / 2) + 32,
          0.5,
          0.5,
          "gauche",
          10,
          globalParams.lstSprites,
          "TankBeige"
        )
        Surge.pos = "gauche"
      else
        SpawnTank(-10, (HAUTEUR_ECRAN / 2) + 32, 0.5, 0.5, "droite", 10, globalParams.lstSprites, "TankBeige")
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
    if globalParams.sonPlay == true then
      globalParams.sonBoss:play()
      globalParams.sonPlay = false
    end
  elseif Surge.nb == 3 and Surge.timer < 0 then
    Surge.print = false
    Surge.timer = 0
    if theEnemys.totalSpwan == 0 then
      theEnemys.totalSpwan = theEnemys.totalSpwan + 1
      SpawnTank(LARGEUR_ECRAN / 2, -100, 1, 1, "bas", 100, globalParams.lstSprites, "TankBoss")
    end
  end

  -- Supprime les sprites qui ne sont pas affiché à l'ecran
  for k = #globalParams.lstSprites, 1, -1 do
    local sprite = globalParams.lstSprites[k]
    if sprite.y <= 0 or sprite.y >= HAUTEUR_ECRAN or sprite.x <= 0 or sprite.x >= LARGEUR_ECRAN then
      table.remove(globalParams.lstSprites, k)
    end
  end

  objetsDecor.Update(dt)
end

function love.update(dt)
  if globalParams.pause == false then
    globalParams.Update()
    if globalParams.ecran_courant == "jeu" then
      UpdateJeu(dt)
      theEnemys.Update(dt)
    end
  end
end

-----------------------------------------------------------------------------------------------------------
------------------------------------------- DRAW ----------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
function DrawMenu()
  love.graphics.draw(globalParams.IMG_MENU, 0, 0)
end

function DrawGameover()
  love.graphics.draw(globalParams.IMG_GAMEOVER, 0, 0)
end

function DrawVictory()
  love.graphics.draw(globalParams.img_VICTORY, 0, 0)
end

function DrawPlay()
  background.Draw()
  bullets.Draw()
  myPlayer.Draw()
  theEnemys.Draw()
  objetsDecor.Draw()
  if Surge.print == true then
    love.graphics.print(math.floor(Surge.timer) .. " sec. avant la prochaine vague !", LARGEUR_ECRAN / 2 - 40, 50)
  end
  if Surge.print == true then
    love.graphics.print({{1, 0, 1}, "Vague" .. Surge.nb}, LARGEUR_ECRAN / 2, HAUTEUR_ECRAN / 2)
  end
end

function love.draw()
  -- Affiche l'ecran courant
  if globalParams.ecran_courant == "jeu" then
    DrawPlay()
  elseif globalParams.ecran_courant == "menu" then
    DrawMenu()
  elseif globalParams.ecran_courant == "gameover" then
    DrawGameover()
  elseif globalParams.ecran_courant == "victoire" then
    DrawVictory()
  end
  if globalParams.pause == true then
    love.graphics.draw(globalParams.img_PAUSE, 0, 0)
  end

  -- Affiche les informations de degugage
  if globalParams.stats_debug == true then
    love.graphics.print("Vitesse: " .. myPlayer.speed, myPlayer.x + 30, myPlayer.y - 5)
    love.graphics.print(
      "X: " .. math.floor(myPlayer.x) .. ", Y: " .. math.floor(myPlayer.y),
      myPlayer.x + 30,
      myPlayer.y + 10
    )
    love.graphics.print("Angle: " .. myPlayer.angle, myPlayer.x + 30, myPlayer.y - 20)

    love.graphics.print("Nb de sprites: " .. #globalParams.lstSprites, 10, 10)
    love.graphics.print("Nb de tanks: " .. #theEnemys.lstTank, 10, 25)
    love.graphics.print("Nb de balles: " .. #bullets.liste_tirs, 10, 40)
    love.graphics.print("Vague d'ennemies n°" .. Surge.nb, 10, 55)
    love.graphics.print("Enemies crée: " .. theEnemys.totalSpwan, 10, 70)
    love.graphics.print("Timer vague: " .. Surge.timer, 10, 85)
    love.graphics.print("Timer spawn: " .. theEnemys.timerSpawn, 10, 100)
  end
end

-----------------------------------------------------------------------------------------------------------
----------------------------------------- CONTROL ---------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
function love.keypressed(key)
  if key == "p" then
    globalParams.pause = not globalParams.pause
  end

  if key == "a" then
    globalParams.stats_debug = not globalParams.stats_debug
  end
  print(key)

  -- Changement d'ecran via la touche ESPACE
  if globalParams.ecran_courant == "jeu" then
  elseif globalParams.ecran_courant == "menu" then
    if key == "space" then
      globalParams.ecran_courant = "jeu"
    end
  elseif globalParams.ecran_courant == "gameover" or globalParams.ecran_courant == "victoire" then
    InitGame()
    if key == "space" then
      globalParams.ecran_courant = "menu"
    end
  end
end

function love.mousepressed(x, y, button)
  if globalParams.pause == false then
    if globalParams.ecran_courant == "jeu" then
      if button == 1 then -- Tire une balle en direction du curseur
        local vx, vy
        vx = 4 * math.cos(myPlayer.angleCannon)
        vy = 4 * math.sin(myPlayer.angleCannon)
        CreeTir(
          myPlayer.x + vx * 2,
          myPlayer.y + vy * 2,
          myPlayer.angleCannon,
          vx,
          vy,
          globalParams.lstSprites,
          "ObusBleu"
        )
      end
    end
  end
end
