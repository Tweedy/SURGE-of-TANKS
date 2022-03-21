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

params.lstSprites = {}

------------------------------------------ FONCTIONS ---------------------------------------------------------

-- Renvoie l'angle entre deux vecteurs ayant la même origine.
function math.angle(x1, y1, x2, y2)
  return math.atan2(y2 - y1, x2 - x1)
end

function Collide(a1, a2) -- Permet de calculer le point de collision
  local a1L = a1.width * a1.scaleX
  local a1H = a1.height * a1.scaleY
  local a2L = a2.width * a2.scaleX
  local a2H = a2.height * a2.scaleY
  if a1 == a2 then
    return false
  end
  if
    a1.x - (a1L / 2) < a2.x - (a2L / 2) + a2L and a1.x + a1L > a2.x - (a2L / 2) and a1.y < a2.y + a2H - (a2H / 2) and
      a1.y + a1H > a2.y - (a2H / 2)
   then
    return true
  end
end

function Ecran()
  love.window.setMode(1024, 768)
  love.window.setTitle("SURGE of TANKS - Projet 1 Gamecodeur")

  LARGEUR_ECRAN = love.graphics.getWidth()
  HAUTEUR_ECRAN = love.graphics.getHeight()
end

function params.Update()
  params.sonJeu:play()
  if params.ecran_courant == "menu" or params.ecran_courant == "gameover" or params.ecran_courant == "victoire" then
    params.sonJeu:setVolume(0.2)
  else
    params.sonJeu:setVolume(0.05)
  end
end

function params.Draw()
  love.graphics.setFont(params.FONT_TEXTE)
end

function math.dist(x1, y1, x2, y2)
  return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2) ^ 0.5
end

return params
