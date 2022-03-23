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
local spawnItem = require("item")

-- Curseur souris
local mouseX = 0
local mouseY = 0

--------------------------------------- FONCTIONS ---------------------------------------------------------

-- Renvoie l'angle entre deux vecteurs ayant la même origine.
function math.angle(x1, y1, x2, y2)
  return math.atan2(y2 - y1, x2 - x1)
end

-- Permet de calculer le point de collision
function Collide(a1, a2)
  local a1L = a1.width * a1.scaleX
  local a1H = a1.height * a1.scaleY
  local a2L = a2.width * a2.scaleX
  local a2H = a2.height * a2.scaleY

  if a1 == a2 then
    return false
  end
  if a2 == spawnItem then
    -- Adapate la collision aux items
    if a1.x < a2.x + a2L and a1.x + a1L > a2.x and a1.y < a2.y + a2H and a1.y + a1H > a2.y then
      return true
    end
  else
    -- Adapate la collision aux tirs
    if
      a1.x - (a1L / 2) < a2.x - (a2L / 2) + a2L and a1.x + a1L > a2.x - (a2L / 2) and a1.y < a2.y + a2H - (a2H / 2) and
        a1.y + a1H > a2.y - (a2H / 2)
     then
      return true
    end
  end
end

-----------------------------------------------------------------------------------------------------------
------------------------------------------- LOAD ----------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
function InitGame() -- Pour la remise à zéro de la partie
  myPlayer.x = LARGEUR_ECRAN / 2
  myPlayer.y = HAUTEUR_ECRAN - 100
  myPlayer.angle = math.pi * 1.5
  myPlayer.angleCannon = math.pi * 1.5
  myPlayer.life = myPlayer.maxLife
  globalParams.sonPlay = true

  theEnemys.Surge.nb = 1
  theEnemys.Surge.timer = 5
  theEnemys.bossPhase1 = true
  theEnemys.totalSpwan = 0

  theEnemys.lstTank = {}
  globalParams.lstSprites = {}
  bullets.liste_tirs = {}
end

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
  --dt = math.min(dt, 1 / 60)

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

  bullets.Update(dt)
  background.Update()

  theEnemys.SurgeEnemy(dt)

  -- Supprime les sprites qui ne sont pas affiché à l'ecran
  for k = #globalParams.lstSprites, 1, -1 do
    local sprite = globalParams.lstSprites[k]
    if sprite.y <= 0 or sprite.y >= HAUTEUR_ECRAN or sprite.x <= 0 or sprite.x >= LARGEUR_ECRAN then
      table.remove(globalParams.lstSprites, k)
    end
  end

  objetsDecor.Update(dt)
  spawnItem.Update()
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
  spawnItem.Draw()
  bullets.Draw()
  theEnemys.Draw()
  myPlayer.Draw()
  objetsDecor.Draw()
  if theEnemys.Surge.timer ~= 0 then
    love.graphics.print(
      {{1, 1, 1}, math.floor(theEnemys.Surge.timer) .. " sec. avant la prochaine vague !"},
      LARGEUR_ECRAN / 2,
      40,
      0,
      1,
      1,
      globalParams.textWidth / 2
    )
  end
  if theEnemys.Surge.timer > 0 and theEnemys.Surge.timer <= theEnemys.Surge.timerPlay then
    love.graphics.setFont(globalParams.FONT_TITRE)
    love.graphics.print(
      {{1, 0, 0}, "Vague " .. theEnemys.Surge.nb},
      LARGEUR_ECRAN / 2,
      HAUTEUR_ECRAN / 2 - 90,
      0,
      1,
      1,
      globalParams.titreWidth / 2
    )
    love.graphics.setFont(globalParams.FONT_TEXTE)
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
    love.graphics.print("Vitesse: " .. myPlayer.speed, myPlayer.x + 30, myPlayer.y - 5, 0, 0.5, 0.5)
    love.graphics.print(
      "X: " .. math.floor(myPlayer.x) .. ", Y: " .. math.floor(myPlayer.y),
      myPlayer.x + 30,
      myPlayer.y + 10,
      0,
      0.5,
      0.5
    )
    love.graphics.print("Angle: " .. myPlayer.angle, myPlayer.x + 30, myPlayer.y - 20, 0, 0.5, 0.5)

    love.graphics.print("Nb de sprites: " .. #globalParams.lstSprites, 10, 50, 0, 0.75, 0.75)
    love.graphics.print("Nb de tanks: " .. #theEnemys.lstTank, 10, 65, 0, 0.75, 0.75)
    love.graphics.print("Nb de balles: " .. #bullets.liste_tirs, 10, 80, 0, 0.75, 0.75)
    love.graphics.print("Vague d'ennemies n°" .. theEnemys.Surge.nb, 10, 95, 0, 0.75, 0.75)
    love.graphics.print("Enemies crée: " .. theEnemys.totalSpwan, 10, 110, 0, 0.75, 0.75)
    love.graphics.print("Timer vague: " .. theEnemys.Surge.timer, 10, 125, 0, 0.75, 0.75)
    love.graphics.print("Timer spawn: " .. theEnemys.timerSpawn, 10, 140, 0, 0.75, 0.75)
  end
  globalParams.Draw()
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
