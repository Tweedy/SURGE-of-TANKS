local params = {}
-- Sons
params.sonPlay = true
params.sonVague1 = love.audio.newSource("sons/round_1.ogg", "static")
params.sonVague2 = love.audio.newSource("sons/round_2.ogg", "static")
params.sonBoss = love.audio.newSource("sons/final_round.ogg", "static")
params.sonVictoire = love.audio.newSource("sons/you_win.ogg", "static")
params.sonDefaite = love.audio.newSource("sons/game_over.ogg", "static")
params.sonMitrailleuse = love.audio.newSource("sons/mitrailleuse.ogg", "static")
params.sonCannon = love.audio.newSource("sons/cannon.ogg", "static")
params.sonCannonBoss = love.audio.newSource("sons/cannon_boss.ogg", "static")
params.sonExplosion = love.audio.newSource("sons/explosion.ogg", "static")
params.sonImpactPlayer = love.audio.newSource("sons/impact_player.ogg", "static")
params.sonJeu = love.audio.newSource("sons/FreeMe.mp3", "stream")

-- Fonts
params.FONT_TITRE = love.graphics.newFont("fonts/stencil.ttf", 50)
params.FONT_TEXTE = love.graphics.newFont("fonts/narrow.ttf", 18)
params.titreWidth = params.FONT_TITRE:getWidth("VAGUE X")
params.textWidth = params.FONT_TEXTE:getWidth("xx sec. avant la prochaine vague !")

-- Ecran courant
params.ecran_courant = "menu"
params.controlPlayer = false

params.IMG_MENU = love.graphics.newImage("images/Ecrans/menu.jpg")
params.IMG_GAMEOVER = love.graphics.newImage("images/Ecrans/gameover.jpg")
params.img_VICTORY = love.graphics.newImage("images/Ecrans/victory.jpg")
params.img_PAUSE = love.graphics.newImage("images/Ecrans/pause.png")

params.pause = false
params.stats_debug = false

-- Variable
params.lstSprites = {}

---------------------------------------- FONCTIONS --------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
function Ecran()
  love.window.setMode(1024, 768)
  love.window.setTitle("SURGE of TANKS - Projet 1 Gamecodeur")

  LARGEUR_ECRAN = love.graphics.getWidth()
  HAUTEUR_ECRAN = love.graphics.getHeight()
end

-----------------------------------------------------------------------------------------------------------
------------------------------------------ UPDATE ---------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
function params.Update(dt)
  params.sonJeu:play()
  if params.ecran_courant == "menu" or params.ecran_courant == "gameover" or params.ecran_courant == "victoire" then
    params.sonJeu:setVolume(0.1)
  else
    params.sonJeu:setVolume(0.04)
  end
end

-----------------------------------------------------------------------------------------------------------
------------------------------------------- DRAW ----------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
function params.Draw()
  love.graphics.setFont(params.FONT_TEXTE)
end

return params
